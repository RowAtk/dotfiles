"""Focused checks for pressure transitions and maze simulation."""
from pathlib import Path
import runpy
import unittest

HERE = Path(__file__).resolve().parent
Policy = runpy.run_path(str(HERE / "desktop-resource-guard.py"))["Policy"]
Maze = runpy.run_path(str(HERE / "arcade-maze.py"))["Maze"]


class PressureTests(unittest.TestCase):
    def test_sustained_cpu_and_memory(self):
        for cpu, memory in ((95, 30), (30, 90)):
            policy = Policy()
            self.assertIsNone(policy.observe(cpu, memory, 5, "normal"))
            self.assertIsNone(policy.observe(cpu, memory, 5, "normal"))
            self.assertEqual(policy.observe(cpu, memory, 5, "normal"), "boring")

    def test_spike_resets(self):
        policy = Policy()
        policy.observe(100, 20, 5, "normal")
        policy.observe(20, 20, 5, "normal")
        self.assertIsNone(policy.observe(100, 20, 10, "normal"))

    def test_manual_boring_is_never_released(self):
        policy = Policy()
        for _ in range(100):
            self.assertIsNone(policy.observe(0, 0, 5, "manual"))

    def test_cooldown_and_minimum_hold(self):
        policy = Policy()
        for _ in range(17):
            self.assertIsNone(policy.observe(10, 20, 5, "resource-guard"))
        self.assertEqual(policy.observe(10, 20, 5, "resource-guard"), "restore")

    def test_both_metrics_must_recover(self):
        policy = Policy()
        for _ in range(30):
            self.assertIsNone(policy.observe(10, 85, 5, "resource-guard"))
        for _ in range(11):
            self.assertIsNone(policy.observe(10, 20, 5, "resource-guard"))
        self.assertEqual(policy.observe(10, 20, 5, "resource-guard"), "restore")


class MazeTests(unittest.TestCase):
    def test_generated_rounds_and_movement(self):
        for seed in range(8):
            game = Maze(seed)
            for _ in range(250):
                game.tick()
                self.assertIn(game.pac, game.graph)
                self.assertTrue(all(p in game.graph for p in game.ghosts))
                self.assertTrue(game.dots <= set(game.graph))
                self.assertGreaterEqual(game.lives, 1)
            self.assertGreater(game.score, 0)

    def test_round_reset(self):
        game = Maze(42)
        game.dots.clear()
        game.clock = game.ready_until + 1
        game.tick()
        self.assertEqual(game.level, 2)
        self.assertTrue(game.dots)


if __name__ == "__main__":
    unittest.main()
