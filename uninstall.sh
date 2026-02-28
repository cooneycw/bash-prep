#!/usr/bin/env bash
# bash-prep uninstaller
# Removes bash-prep changes and restores original dotfiles from backup.
#
# Usage: ./uninstall.sh

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

MARKER="# >>> bash-prep >>>"
MARKER_END="# <<< bash-prep <<<"

info()  { echo -e "${CYAN}[info]${RESET}  $*"; }
ok()    { echo -e "${GREEN}[ok]${RESET}    $*"; }
warn()  { echo -e "${YELLOW}[warn]${RESET}  $*"; }

echo ""
echo -e "${BOLD}${CYAN}bash-prep uninstaller${RESET}"
echo -e "${BOLD}${CYAN}════════════════════${RESET}"
echo ""

# Remove bash-prep block from ~/.bashrc
if [ -f "$HOME/.bashrc" ]; then
    if grep -qF "$MARKER" "$HOME/.bashrc"; then
        sed -i "/$MARKER/,/$MARKER_END/d" "$HOME/.bashrc"
        # Uncomment the lines we commented out
        sed -i 's/^#\[bash-prep\] //' "$HOME/.bashrc"
        ok "Removed bash-prep block from ~/.bashrc"
    else
        info "No bash-prep block found in ~/.bashrc"
    fi
fi

# Offer to remove deployed files
for file in "$HOME/.inputrc" "$HOME/.bash_aliases"; do
    if [ -f "$file" ]; then
        read -rp "Remove $file? [y/N] " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            rm "$file"
            ok "Removed $file"
        else
            info "Kept $file"
        fi
    fi
done

# Remove help system directory
if [ -d "$HOME/.bash-prep" ]; then
    rm -rf "$HOME/.bash-prep"
    ok "Removed ~/.bash-prep/"
fi

# Show backup location
BACKUP_BASE="$HOME/.bash-prep-backup"
if [ -d "$BACKUP_BASE" ]; then
    echo ""
    info "Backups are available at: $BACKUP_BASE"
    info "You can restore files manually from the most recent backup."
fi

echo ""
echo -e "${GREEN}Uninstall complete.${RESET} Open a new terminal to use the original settings."
echo ""
