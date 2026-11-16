#!/usr/bin/env python3
"""Self-playing maze chase, rendered as pixel graphics in Kitty."""
import argparse
import base64
from io import BytesIO
import math
import os
from pathlib import Path
import random
import select
import sys
import termios
import time
import tty

import networkx as nx
from PIL import Image, ImageDraw, ImageFont

WIDTH, HEIGHT, TILE = 960, 540, 16
OX, OY = 248, 88
FONT = ImageFont.load_default(size=16)
BIG = ImageFont.load_default(size=28)
SMALL = ImageFont.load_default(size=12)
GHOSTS = ("#ff647c", "#f5a4d8", "#69d5d0", "#ffb968")


class Maze:
    def __init__(self, seed=1):
        self.rng = random.Random(seed)
        self.score = 0
        self.level = 0
        self.lives = 3
        self.clock = 0.0
        self.round()

    def round(self):
        self.level += 1
        grid = nx.grid_2d_graph(7, 11)
        for a, b in grid.edges:
            grid.edges[a, b]["weight"] = self.rng.random()
        half = nx.minimum_spanning_tree(grid)
        for a, b in grid.edges:
            if self.rng.random() < 0.24:
                half.add_edge(a, b)
        logical = nx.Graph()
        logical.add_edges_from(half.edges)
        logical.add_edges_from(((13-a[0], a[1]), (13-b[0], b[1])) for a, b in half.edges)
        for y in (1, 5, 9):
            logical.add_edge((6, y), (7, y))
        walk = set()
        for a, b in logical.edges:
            aa, bb = (a[0]*2+1, a[1]*2+1), (b[0]*2+1, b[1]*2+1)
            walk.update((aa, bb, ((aa[0]+bb[0])//2, (aa[1]+bb[1])//2)))
        self.graph = nx.Graph()
        self.graph.add_nodes_from(walk)
        for x, y in walk:
            for p in ((x+1, y), (x, y+1)):
                if p in walk:
                    self.graph.add_edge((x, y), p)
        self.dots = set(walk)
        self.powers = {(1, 1), (27, 1), (1, 21), (27, 21)}
        self.power_until = 0.0
        self.round_started = self.clock
        self.spawn()

    def spawn(self):
        self.pac = (1, 11)
        self.pac_old = self.pac
        center = sorted(self.graph, key=lambda p: abs(p[0]-14)+abs(p[1]-11))
        self.ghosts = center[:4]
        self.old_ghosts = self.ghosts[:]
        self.ghost_previous = self.ghosts[:]
        self.ready_until = self.clock + 1.2
        self.invulnerable_until = self.clock + 2.0
        self.direction = (1, 0)

    def tick(self, dt=0.14):
        self.clock += dt
        if self.clock < self.ready_until:
            return
        if not self.dots or self.clock-self.round_started > 120:
            self.score += 500
            self.round()
            return
        distances = nx.single_source_shortest_path_length(self.graph, self.pac)
        powered = self.clock < self.power_until
        targets = self.dots or {self.pac}
        goal = min(targets, key=lambda p: distances.get(p, 9999))
        paths_to_goal = nx.single_source_shortest_path_length(self.graph, goal)
        ghost_dist = [nx.single_source_shortest_path_length(self.graph, p) for p in self.ghosts]
        def value(p):
            danger = sum(max(0, 6-d.get(p, 999))**2 for d in ghost_dist)
            backtrack = 0.4 if p == self.pac_old else 0
            return paths_to_goal.get(p, 999) + backtrack + (0 if powered else danger*3)
        next_pac = min(self.graph[self.pac], key=value)
        self.pac_old, self.pac = self.pac, next_pac
        self.direction = (self.pac[0]-self.pac_old[0], self.pac[1]-self.pac_old[1])
        if self.pac in self.dots:
            self.dots.remove(self.pac)
            self.score += 10
        if self.pac in self.powers:
            self.powers.remove(self.pac)
            self.power_until = self.clock + 7
            self.score += 50
        self.old_ghosts = self.ghosts[:]
        to_pac = nx.single_source_shortest_path_length(self.graph, self.pac)
        for i, ghost in enumerate(self.ghosts):
            options = list(self.graph[ghost])
            forward = [p for p in options if p != self.ghost_previous[i]]
            if forward:
                options = forward
            if self.clock < self.power_until:
                dest = max(options, key=lambda p: to_pac.get(p, 0))
            elif i == 0 or self.rng.random() < 0.65:
                dest = min(options, key=lambda p: to_pac.get(p, 999))
            else:
                dest = self.rng.choice(options)
            self.ghosts[i] = dest
            self.ghost_previous[i] = ghost
            crossed = dest == self.pac_old and ghost == self.pac
            if dest == self.pac or ghost == self.pac or crossed:
                if self.clock < self.power_until:
                    self.score += 200
                    self.ghosts[i] = (27, 11)
                    self.old_ghosts[i] = self.ghosts[i]
                elif self.clock > self.invulnerable_until:
                    self.lives -= 1
                    if self.lives <= 0:
                        self.lives = 3
                        self.round()
                    else:
                        self.spawn()
                    break


def center(draw, xy, text, font, fill):
    box = draw.textbbox((0, 0), text, font=font)
    draw.text((xy[0]-(box[2]-box[0])/2, xy[1]), text, font=font, fill=fill)


def ghost(draw, x, y, color, frightened=False):
    draw.ellipse((x-7, y-7, x+7, y+7), fill=color)
    draw.rectangle((x-7, y, x+7, y+7), fill=color)
    for dx in (-5, 0, 5):
        draw.polygon(((x+dx-2, y+8), (x+dx, y+5), (x+dx+2, y+8)), fill="#080d17")
    for dx in (-3, 3):
        draw.ellipse((x+dx-2, y-3, x+dx+1, y), fill="#edf5ff")
        if not frightened:
            draw.point((x+dx, y-1), fill="#14264a")


def frame(game, fraction=1.0):
    image = Image.new("RGB", (WIDTH, HEIGHT), "#080d17")
    draw = ImageDraw.Draw(image)
    draw.line((50, 63, 910, 63), fill="#29364d", width=1)
    center(draw, (480, 22), "MIDNIGHT MAZE", BIG, "#e7b99b")
    draw.text((55, 97), "SCORE", font=FONT, fill="#7b8da6")
    draw.text((55, 123), f"{game.score:07d}", font=BIG, fill="#fff0c6")
    draw.text((55, 190), "ROUND", font=FONT, fill="#7b8da6")
    draw.text((55, 215), f"{game.level:02d}", font=BIG, fill="#69d5d0")
    draw.text((55, 285), "LIVES", font=FONT, fill="#7b8da6")
    for i in range(game.lives):
        draw.pieslice((57+i*26, 316, 74+i*26, 333), 35, 325, fill="#ffdc65")
    draw.text((770, 97), "THE CHASE", font=FONT, fill="#7b8da6")
    for i, name in enumerate(("HUNTER", "DRIFTER", "GLIDER", "ROVER")):
        ghost(draw, 779, 150+i*58, GHOSTS[i])
        draw.text((800, 144+i*58), name, font=SMALL, fill=GHOSTS[i])
    for y in range(23):
        for x in range(29):
            px, py = OX+x*TILE, OY+y*TILE
            if (x, y) not in game.graph:
                draw.rectangle((px, py, px+15, py+15), fill="#112641")
                if (x-1, y) in game.graph:
                    draw.line((px, py, px, py+15), fill="#397ca2")
                if (x+1, y) in game.graph:
                    draw.line((px+15, py, px+15, py+15), fill="#397ca2")
                if (x, y-1) in game.graph:
                    draw.line((px, py, px+15, py), fill="#397ca2")
                if (x, y+1) in game.graph:
                    draw.line((px, py+15, px+15, py+15), fill="#397ca2")
            elif (x, y) in game.dots:
                radius = 3 if (x, y) in game.powers else 1
                draw.ellipse((px+8-radius, py+8-radius, px+8+radius, py+8+radius), fill="#e7b99b")
    def position(old, new):
        return (OX+(old[0]+(new[0]-old[0])*fraction)*TILE+8,
                OY+(old[1]+(new[1]-old[1])*fraction)*TILE+8)
    px, py = position(game.pac_old, game.pac)
    angle = {(1,0):0, (-1,0):180, (0,1):90, (0,-1):270}.get(game.direction, 0)
    mouth = 8 + 28*abs(math.sin(game.clock*15 + fraction))
    draw.pieslice((px-7, py-7, px+7, py+7), angle+mouth, angle+360-mouth, fill="#ffdc65")
    for i, pos in enumerate(game.ghosts):
        x, y = position(game.old_ghosts[i], pos)
        frightened = game.clock < game.power_until
        ghost(draw, x, y, "#466be5" if frightened else GHOSTS[i], frightened)
    if game.clock < game.ready_until:
        center(draw, (480, 257), "READY!", BIG, "#ffdc65")
    draw.line((50, 483, 910, 483), fill="#29364d")
    center(draw, (480, 500), "ATTRACT MODE   /   " + str(len(game.dots)) + " DOTS REMAINING",
           SMALL, "#7b8da6")
    return image


def display(image):
    output = BytesIO()
    image.save(output, format="PNG", compress_level=1)
    data = base64.b64encode(output.getvalue())
    size = os.get_terminal_size()
    sys.stdout.write("\x1b[H")
    for start in range(0, len(data), 4096):
        part = data[start:start+4096].decode("ascii")
        more = int(start+4096 < len(data))
        params = f"a=T,f=100,i=1,p=1,q=2,c={size.columns},r={size.lines},m={more}" if start == 0 else f"m={more},q=2"
        sys.stdout.write("\x1b_G" + params + ";" + part + "\x1b\\")
    sys.stdout.flush()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--render", type=Path)
    parser.add_argument("--seconds", type=float, default=12)
    parser.add_argument("--seed", type=int, default=None)
    args = parser.parse_args()
    game = Maze(args.seed if args.seed is not None else random.randrange(100000))
    if args.render:
        for _ in range(int(args.seconds / 0.14)):
            game.tick()
        frame(game).resize((1920, 1080), Image.Resampling.NEAREST).save(args.render)
        return
    fd = sys.stdin.fileno()
    original = termios.tcgetattr(fd)
    tty.setcbreak(fd)
    sys.stdout.write("\x1b[?1049h\x1b[?25l")
    last = time.monotonic()
    accumulator = 0.0
    try:
        while True:
            if select.select([sys.stdin], [], [], 0)[0]:
                os.read(fd, 1024)
                break
            now = time.monotonic()
            accumulator += min(now-last, 0.25)
            last = now
            while accumulator >= 0.14:
                game.tick()
                accumulator -= 0.14
            display(frame(game, accumulator/0.14))
            time.sleep(1/20)
    finally:
        sys.stdout.write("\x1b_Ga=d,d=I,i=1,q=2;\x1b\\\x1b[?25h\x1b[?1049l")
        sys.stdout.flush()
        termios.tcsetattr(fd, termios.TCSADRAIN, original)


if __name__ == "__main__":
    main()
