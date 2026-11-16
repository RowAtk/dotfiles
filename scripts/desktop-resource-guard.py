#!/usr/bin/env python3
"""Automatically use Boring mode under sustained system-wide load."""
import argparse
from dataclasses import dataclass
import json
import os
from pathlib import Path
import subprocess
import sys
import time

import psutil

ROOT = Path(__file__).resolve().parent.parent
STATE = Path.home() / ".local/state/charcoal-copper"
CONFIG = ROOT / "experiments/charcoal-copper/resource-guard.json"


@dataclass
class Policy:
    cpu_high: float = 95
    memory_high: float = 90
    trigger_seconds: float = 15
    cpu_low: float = 75
    memory_low: float = 80
    recovery_seconds: float = 60
    minimum_hold_seconds: float = 90
    hot: float = 0
    cool: float = 0
    held: float = 0

    def observe(self, cpu, memory, elapsed, owner):
        if owner == "manual":
            self.hot = self.cool = self.held = 0
            return None
        if owner == "resource-guard":
            self.hot = 0
            self.held += elapsed
            self.cool = self.cool + elapsed if cpu < self.cpu_low and memory < self.memory_low else 0
            if self.cool >= self.recovery_seconds and self.held >= self.minimum_hold_seconds:
                self.cool = self.held = 0
                return "restore"
        else:
            self.cool = self.held = 0
            self.hot = self.hot + elapsed if cpu >= self.cpu_high or memory >= self.memory_high else 0
            if self.hot >= self.trigger_seconds:
                self.hot = 0
                return "boring"
        return None


def owner():
    if not (STATE / "boring").exists():
        return "normal"
    path = STATE / "mode-owner"
    return path.read_text().strip() if path.exists() else "manual"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--once", action="store_true", help="Report usage without changing modes")
    args = parser.parse_args()
    settings = json.loads(CONFIG.read_text())
    interval = settings.pop("sample_seconds")
    if interval <= 0:
        raise SystemExit("sample_seconds must be positive")
    policy = Policy(**settings)
    if not 0 <= policy.cpu_low < policy.cpu_high <= 100 or not 0 <= policy.memory_low < policy.memory_high <= 100:
        raise SystemExit("Thresholds must satisfy 0 <= low < high <= 100")
    STATE.mkdir(parents=True, exist_ok=True)
    psutil.cpu_percent()
    while True:
        time.sleep(1 if args.once else interval)
        cpu = psutil.cpu_percent()
        memory = psutil.virtual_memory()
        pressure = (memory.total-memory.available) / memory.total * 100
        mode_owner = owner()
        action = None if args.once else policy.observe(cpu, pressure, interval, mode_owner)
        status = {"cpu": round(cpu, 1), "memory": round(pressure, 1),
                  "owner": mode_owner, "action": action, "timestamp": time.time()}
        temporary = STATE / f"resource-guard.{os.getpid()}.tmp"
        temporary.write_text(json.dumps(status) + "\n")
        temporary.replace(STATE / "resource-guard.json")
        if args.once:
            print(json.dumps(status))
            return
        if not action:
            continue
        # Recheck ownership before recovery: manual Boring must never be undone.
        if action == "restore" and owner() != "resource-guard":
            continue
        if action == "boring":
            if owner() != "normal":
                continue
            command = [sys.executable, str(ROOT / "scripts/desktop-mode.py"), "--boring", "--automatic"]
        else:
            saved = json.loads((STATE / "mode-restore.json").read_text())
            design = saved.get("design", "copper")
            if design == "boring":
                design = "copper"
            command = [sys.executable, str(ROOT / "scripts/desktop-design.py"), design]
        result = subprocess.run(command, timeout=120, check=False)
        print(json.dumps({**status, "returncode": result.returncode}), flush=True)
        if result.returncode:
            time.sleep(30)


if __name__ == "__main__":
    main()
