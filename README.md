# bash-prep

A portable bash shell enhancement kit. One command to set up a productive terminal on any Ubuntu/Debian machine (also supports Fedora, Arch, and macOS via Homebrew).

## Quick Start

```bash
git clone https://github.com/cooneycw/bash-prep.git
cd bash-prep
./install.sh
```

Then open a new terminal.

## What You Get

### Enhanced Prompt
A two-line colored prompt with everything you need at a glance:

```
[ok] user@hostname [CPP #42] ~/Projects/myproject (main *+)
$
```

- **Exit status**: green `ok` or red `err:1` with exit code
- **user@host**: always visible
- **Claude context**: project/branch info if `prompt-context.sh` is present
- **Path**: full working directory in blue
- **Git status**: branch name with dirty/staged/stash/upstream indicators

### CLI Tools Installed
| Tool | Replaces | What It Does |
|------|----------|--------------|
| `bat` | `cat` | Syntax-highlighted file viewer |
| `fd` | `find` | Fast, user-friendly file finder |
| `fzf` | `Ctrl-R` | Fuzzy finder for history, files, directories |
| `rg` (ripgrep) | `grep` | Blazing fast recursive search |
| `tree` | `ls -R` | Directory tree visualization |
| `ncdu` | `du` | Interactive disk usage explorer |
| `jq` | - | JSON processor |
| `htop` | `top` | Interactive process viewer |

### Key Bindings
| Key | Action |
|-----|--------|
| `Ctrl-R` | Fuzzy history search (via fzf) |
| `Ctrl-T` | Fuzzy file finder |
| `Alt-C` | Fuzzy directory changer |
| `Up/Down` | Search history by prefix (type `git` then Up) |
| `Ctrl-Left/Right` | Move cursor by word |
| `Tab` | Case-insensitive completion (single press) |

### Aliases
| Alias | Command |
|-------|---------|
| `..` / `...` / `....` | Navigate up directories |
| `ll` | `ls -alFh` |
| `lt` | `ls -lhtr` (newest last) |
| `gs` | `git status` |
| `gd` / `gds` | `git diff` / `git diff --staged` |
| `gl` | `git log --oneline --graph` |
| `t` / `t3` | `tree -L 2` / `tree -L 3` |
| `bat` | `batcat` (Ubuntu compat) |
| `fd` | `fdfind` (Ubuntu compat) |
| `reload` | `source ~/.bashrc` |

### Functions
| Function | Description |
|----------|-------------|
| `mkcd dir` | Create directory and cd into it |
| `extract file` | Universal archive extractor |
| `fkill` | Fuzzy-search and kill a process |
| `serve [port]` | Quick HTTP server (default: 8000) |
| `jsonpp [file]` | Pretty-print JSON |

## Files Modified

The installer touches three files with full backup:

| File | Action |
|------|--------|
| `~/.bashrc` | Appends enhancement block (originals commented, not deleted) |
| `~/.inputrc` | Deployed (backed up if exists) |
| `~/.bash_aliases` | Deployed (backed up if exists) |

Backups are saved to `~/.bash-prep-backup/<timestamp>/`.

## Uninstall

```bash
cd bash-prep
./uninstall.sh
```

Removes the bash-prep block from `.bashrc`, restores commented-out originals, and optionally removes `.inputrc` and `.bash_aliases`.

## Re-run / Update

Safe to re-run `./install.sh` at any time. It detects existing installations and replaces the bash-prep block with the latest version.

## Platform Notes

- **Ubuntu/Debian**: `bat` installs as `batcat`, `fd-find` as `fdfind`. Aliases handle this automatically.
- **Fedora/Arch/macOS**: Package names and binary names are native; no aliasing needed.
- **Large git repos**: If prompt feels slow, run `git config bash.showUntrackedFiles false` in that repo.
