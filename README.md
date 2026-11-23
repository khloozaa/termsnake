# 🐍 termsnake

![Bash 5+](https://img.shields.io/badge/bash-5%2B-4EAA25?logo=gnubash&logoColor=white)
![License: MIT](https://img.shields.io/badge/license-MIT-blue)
![Dependencies: none](https://img.shields.io/badge/dependencies-none-brightgreen)

Snake for your terminal, written in pure Bash. Colored blocks, smooth controls, one script, nothing to install.

![termsnake demo](screenshots/demo.gif)

## Quick start

```bash
git clone https://github.com/khloozaa/termsnake.git
cd termsnake
bash src/main.sh
```

**You need:**

- **Bash 5 or newer.** Ubuntu, Debian, Fedora, and Arch already have it. Check with `bash --version`.
- A terminal with 256 colors, at least **56 columns × 20 rows**.
- **macOS:** the built-in Bash is too old, so run `brew install bash` and start the game with `$(brew --prefix)/bin/bash termsnake.sh`.
- **Windows:** use [WSL](https://learn.microsoft.com/windows/wsl/install) and follow the Linux steps.

## Controls

| Key | Action |
|---|---|
| ← ↑ ↓ → or WASD | Move |
| Space or P | Pause |
| Enter | Play again |
| Q or Esc | Quit |

## Install (optional)

```bash
make install     # then play from anywhere with: termsnake
make uninstall
```

Make sure `~/.local/bin` is on your `PATH`.

## Features

- ⚡ Speeds up with every point you score
- 🎯 Quick key presses are queued, so tight turns work
- 🏆 Best score is saved in `~/.termsnake_highscore`
- ⏸️ Pause any time
- 🧹 Restores your terminal cleanly on exit, even on Ctrl+C

## How it works

The whole game is one Bash script.

- **Drawing:** every cell is two spaces with a colored background, positioned with ANSI escape codes.
- **Speed:** each tick repaints only the cells that changed (the new head, the old tail, and the food), so Bash keeps up with no flicker.
- **Timing and input:** `read -t` waits for a key until the next tick, using `$EPOCHREALTIME`, so controls react instantly without speeding up the game.
- **State:** the snake lives in an array, and a grid array records which cells are occupied, so collision checks are instant.
- **Cleanup:** a `trap` on `EXIT` restores your cursor, colors, and screen however the game ends.

## License

MIT
