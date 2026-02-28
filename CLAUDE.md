# CLAUDE.md - bash-prep

## Project Overview
Portable bash shell enhancement installer. Deploys dotfiles and CLI tools on any machine via a single `./install.sh` command.

## Repository Structure
```
bash-prep/
├── install.sh          # Main installer (run this)
├── uninstall.sh        # Reverses all changes
├── dotfiles/
│   ├── inputrc         # Readline config -> ~/.inputrc
│   ├── bash_aliases    # Aliases & functions -> ~/.bash_aliases
│   └── bashrc_append   # Block appended to ~/.bashrc
├── README.md
└── CLAUDE.md
```

## Key Design Decisions
- **Append-only**: `install.sh` never deletes lines from `.bashrc`. It comments out conflicting originals with `#[bash-prep]` prefix and appends a marked block (`# >>> bash-prep >>>` / `# <<< bash-prep <<<`).
- **Idempotent**: Safe to re-run. Detects existing bash-prep block and replaces it.
- **Backup-first**: All modified files backed up to `~/.bash-prep-backup/<timestamp>/`.
- **Multi-platform**: Detects apt/dnf/pacman/brew and installs correct packages.
- **Ubuntu quirks**: Handles `batcat`/`fdfind` naming via conditional aliases in `bash_aliases`.

## Development Notes
- Test install/uninstall cycle on a clean machine or container before releasing.
- The `bashrc_append` sources `~/.bash_aliases` itself, so it works even if the user's original `.bashrc` doesn't.
- `PROMPT_COMMAND` ordering matters: `__build_prompt` must run before `history -a` to capture `$?`.
