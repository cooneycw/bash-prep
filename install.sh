#!/usr/bin/env bash
# bash-prep installer
# Sets up an enhanced bash environment on Ubuntu/Debian machines.
#
# Usage:
#   git clone https://github.com/cooneycw/bash-prep.git
#   cd bash-prep
#   ./install.sh
#
# What it does:
#   1. Installs CLI tools (tree, bat, fd, fzf, ripgrep, ncdu, jq)
#   2. Deploys ~/.inputrc (readline config)
#   3. Deploys ~/.bash_aliases (aliases and functions)
#   4. Patches ~/.bashrc with enhanced prompt, history, shell options, fzf
#
# Safe to re-run: backs up existing files and skips already-applied changes.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR/dotfiles"
BACKUP_DIR="$HOME/.bash-prep-backup/$(date +%Y%m%d-%H%M%S)"
MARKER="# >>> bash-prep >>>"
MARKER_END="# <<< bash-prep <<<"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info()  { echo -e "${CYAN}[info]${RESET}  $*"; }
ok()    { echo -e "${GREEN}[ok]${RESET}    $*"; }
warn()  { echo -e "${YELLOW}[warn]${RESET}  $*"; }
err()   { echo -e "${RED}[error]${RESET} $*" >&2; }

backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        mkdir -p "$BACKUP_DIR"
        cp "$file" "$BACKUP_DIR/$(basename "$file")"
        info "Backed up $file -> $BACKUP_DIR/$(basename "$file")"
    fi
}

# -----------------------------------------------------------------
# Step 0: Detect OS and package manager
# -----------------------------------------------------------------
detect_package_manager() {
    if command -v apt-get &>/dev/null; then
        echo "apt"
    elif command -v dnf &>/dev/null; then
        echo "dnf"
    elif command -v yum &>/dev/null; then
        echo "yum"
    elif command -v pacman &>/dev/null; then
        echo "pacman"
    elif command -v brew &>/dev/null; then
        echo "brew"
    else
        echo "unknown"
    fi
}

# -----------------------------------------------------------------
# Step 1: Install CLI tools
# -----------------------------------------------------------------
install_tools() {
    local pkg_mgr
    pkg_mgr=$(detect_package_manager)

    echo ""
    echo -e "${BOLD}Step 1: Installing CLI tools${RESET}"
    echo "────────────────────────────────────────"

    case "$pkg_mgr" in
        apt)
            local packages=(tree bat fd-find fzf ripgrep ncdu jq git)
            local to_install=()
            for pkg in "${packages[@]}"; do
                if dpkg -s "$pkg" &>/dev/null; then
                    ok "$pkg already installed"
                else
                    to_install+=("$pkg")
                fi
            done
            if [ ${#to_install[@]} -gt 0 ]; then
                info "Installing: ${to_install[*]}"
                sudo apt-get update -qq
                sudo apt-get install -y -qq "${to_install[@]}"
                ok "Packages installed"
            fi
            ;;
        dnf)
            local packages=(tree bat fd-find fzf ripgrep ncdu jq git)
            info "Installing: ${packages[*]}"
            sudo dnf install -y "${packages[@]}"
            ok "Packages installed"
            ;;
        yum)
            warn "yum detected - some packages may need EPEL repository"
            sudo yum install -y tree jq git ncdu
            ok "Base packages installed (bat/fd/fzf/rg may need manual install)"
            ;;
        pacman)
            local packages=(tree bat fd fzf ripgrep ncdu jq git)
            info "Installing: ${packages[*]}"
            sudo pacman -S --noconfirm --needed "${packages[@]}"
            ok "Packages installed"
            ;;
        brew)
            local packages=(tree bat fd fzf ripgrep ncdu jq git)
            info "Installing: ${packages[*]}"
            brew install "${packages[@]}"
            ok "Packages installed"
            ;;
        *)
            warn "Unknown package manager. Please install manually:"
            warn "  tree bat fd-find fzf ripgrep ncdu jq git"
            ;;
    esac
}

# -----------------------------------------------------------------
# Step 2: Deploy ~/.inputrc
# -----------------------------------------------------------------
install_inputrc() {
    echo ""
    echo -e "${BOLD}Step 2: Installing ~/.inputrc${RESET}"
    echo "────────────────────────────────────────"

    if [ -f "$HOME/.inputrc" ]; then
        if diff -q "$DOTFILES_DIR/inputrc" "$HOME/.inputrc" &>/dev/null; then
            ok "~/.inputrc already up to date"
            return
        fi
        backup_file "$HOME/.inputrc"
    fi

    cp "$DOTFILES_DIR/inputrc" "$HOME/.inputrc"
    ok "Installed ~/.inputrc"
}

# -----------------------------------------------------------------
# Step 3: Deploy ~/.bash_aliases
# -----------------------------------------------------------------
install_bash_aliases() {
    echo ""
    echo -e "${BOLD}Step 3: Installing ~/.bash_aliases${RESET}"
    echo "────────────────────────────────────────"

    if [ -f "$HOME/.bash_aliases" ]; then
        if diff -q "$DOTFILES_DIR/bash_aliases" "$HOME/.bash_aliases" &>/dev/null; then
            ok "~/.bash_aliases already up to date"
            return
        fi
        backup_file "$HOME/.bash_aliases"
    fi

    cp "$DOTFILES_DIR/bash_aliases" "$HOME/.bash_aliases"
    ok "Installed ~/.bash_aliases"
}

# -----------------------------------------------------------------
# Step 4: Deploy help system
# -----------------------------------------------------------------
install_help() {
    echo ""
    echo -e "${BOLD}Step 4: Installing help system${RESET}"
    echo "────────────────────────────────────────"

    mkdir -p "$HOME/.bash-prep"

    if [ -f "$HOME/.bash-prep/bp_help.sh" ]; then
        if diff -q "$DOTFILES_DIR/bp_help.sh" "$HOME/.bash-prep/bp_help.sh" &>/dev/null; then
            ok "~/.bash-prep/bp_help.sh already up to date"
            return
        fi
        backup_file "$HOME/.bash-prep/bp_help.sh"
    fi

    cp "$DOTFILES_DIR/bp_help.sh" "$HOME/.bash-prep/bp_help.sh"
    ok "Installed ~/.bash-prep/bp_help.sh (type 'bp' for help)"
}

# -----------------------------------------------------------------
# Step 5: Patch ~/.bashrc
# -----------------------------------------------------------------
patch_bashrc() {
    echo ""
    echo -e "${BOLD}Step 4: Patching ~/.bashrc${RESET}"
    echo "────────────────────────────────────────"

    local bashrc="$HOME/.bashrc"

    # Create ~/.bashrc if it doesn't exist
    if [ ! -f "$bashrc" ]; then
        touch "$bashrc"
        warn "Created empty ~/.bashrc"
    fi

    # Check if already patched
    if grep -qF "$MARKER" "$bashrc"; then
        info "bash-prep block found in ~/.bashrc - replacing with latest version"
        backup_file "$bashrc"
        # Remove old block
        sed -i "/$MARKER/,/$MARKER_END/d" "$bashrc"
    else
        backup_file "$bashrc"
    fi

    # Comment out conflicting settings in the original bashrc
    # (History settings, prompt settings, shell options we override)
    local tmpfile
    tmpfile=$(mktemp)
    cp "$bashrc" "$tmpfile"

    # Comment out lines we're overriding (only if not already commented)
    sed -i 's/^HISTCONTROL=/#[bash-prep] &/' "$tmpfile"
    sed -i 's/^HISTSIZE=/#[bash-prep] &/' "$tmpfile"
    sed -i 's/^HISTFILESIZE=/#[bash-prep] &/' "$tmpfile"
    sed -i 's/^shopt -s histappend/#[bash-prep] &/' "$tmpfile"
    # Comment out old PS1/PROMPT_COMMAND exports that would conflict
    sed -i "s/^export PS1=/#[bash-prep] &/" "$tmpfile"
    sed -i "s/^PS1=/#[bash-prep] &/" "$tmpfile"
    sed -i "s/^PROMPT_COMMAND=/#[bash-prep] &/" "$tmpfile"

    cp "$tmpfile" "$bashrc"
    rm "$tmpfile"

    # Append the bash-prep block
    {
        echo ""
        echo "$MARKER"
        cat "$DOTFILES_DIR/bashrc_append"
        echo ""
        echo "$MARKER_END"
    } >> "$bashrc"

    ok "Patched ~/.bashrc"
}

# -----------------------------------------------------------------
# Main
# -----------------------------------------------------------------
main() {
    echo ""
    echo -e "${BOLD}${CYAN}bash-prep installer${RESET}"
    echo -e "${BOLD}${CYAN}═══════════════════${RESET}"
    echo "Enhanced bash environment for any machine."
    echo ""

    # Verify we have the dotfiles
    if [ ! -d "$DOTFILES_DIR" ]; then
        err "dotfiles/ directory not found. Run this script from the bash-prep repo root."
        exit 1
    fi

    install_tools
    install_inputrc
    install_bash_aliases
    install_help
    patch_bashrc

    echo ""
    echo -e "${BOLD}${GREEN}Installation complete!${RESET}"
    echo "────────────────────────────────────────"
    if [ -d "$BACKUP_DIR" ]; then
        echo -e "  Backups saved to: ${CYAN}$BACKUP_DIR${RESET}"
    fi
    echo ""
    echo "  Open a ${BOLD}new terminal${RESET} to activate, or run:"
    echo -e "    ${CYAN}source ~/.bashrc${RESET}"
    echo ""
    echo -e "  ${BOLD}Key features:${RESET}"
    echo "    Ctrl-R  Fuzzy history search (fzf)"
    echo "    Ctrl-T  Fuzzy file finder"
    echo "    Alt-C   Fuzzy directory changer"
    echo "    ..      Go up one directory"
    echo "    t       Tree view (2 levels)"
    echo "    gs      Git status"
    echo "    gl      Git log (graph)"
    echo "    bat     Syntax-highlighted cat"
    echo "    fd      Fast file finder"
    echo "    rg      Fast recursive grep"
    echo ""
}

main "$@"
