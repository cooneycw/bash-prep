# bash-prep help system
# Sourced from ~/.bashrc via bash-prep block

bp() {
    local BOLD='\033[1m'
    local CYAN='\033[0;36m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[0;33m'
    local MAGENTA='\033[0;35m'
    local RESET='\033[0m'
    local DIM='\033[2m'

    local section="${1:-help}"

    case "$section" in
        keys|keybindings)
            echo -e "${BOLD}${CYAN}Key Bindings${RESET}"
            echo "────────────────────────────────────────"
            echo -e "  ${GREEN}Ctrl-R${RESET}         Fuzzy history search (fzf)"
            echo -e "  ${GREEN}Ctrl-T${RESET}         Fuzzy file finder"
            echo -e "  ${GREEN}Alt-C${RESET}          Fuzzy directory changer"
            echo -e "  ${GREEN}Up/Down${RESET}        History search by prefix"
            echo -e "  ${GREEN}Ctrl-Left/Right${RESET} Move cursor by word"
            echo -e "  ${GREEN}Tab${RESET}            Case-insensitive completion (single press)"
            ;;

        tools)
            echo -e "${BOLD}${CYAN}Installed Tools${RESET}"
            echo "────────────────────────────────────────"
            echo -e "  ${GREEN}bat${RESET}   ${DIM}(batcat)${RESET}  Syntax-highlighted cat"
            echo -e "  ${GREEN}fd${RESET}    ${DIM}(fdfind)${RESET}  Fast file finder (respects .gitignore)"
            echo -e "  ${GREEN}rg${RESET}    ${DIM}(ripgrep)${RESET} Fast recursive search"
            echo -e "  ${GREEN}fzf${RESET}             Fuzzy finder for anything"
            echo -e "  ${GREEN}tree${RESET}            Directory tree visualization"
            echo -e "  ${GREEN}ncdu${RESET}            Interactive disk usage explorer"
            echo -e "  ${GREEN}jq${RESET}              JSON processor"
            echo -e "  ${GREEN}htop${RESET}            Interactive process viewer"
            echo ""
            echo -e "  ${BOLD}Common patterns:${RESET}"
            echo -e "  ${YELLOW}fd -e py${RESET}                   Find all .py files"
            echo -e "  ${YELLOW}rg 'pattern' -t py${RESET}         Search Python files"
            echo -e "  ${YELLOW}rg -l 'TODO'${RESET}               List files with TODOs"
            echo -e "  ${YELLOW}bat -r 10:20 file${RESET}          Show lines 10-20"
            echo -e "  ${YELLOW}fd -e log --exec rm {}${RESET}     Delete all .log files"
            echo -e "  ${YELLOW}curl api | jq '.data[]'${RESET}    Extract JSON array"
            ;;

        git)
            echo -e "${BOLD}${CYAN}Git Shortcuts${RESET}"
            echo "────────────────────────────────────────"
            echo -e "  ${GREEN}gs${RESET}    git status"
            echo -e "  ${GREEN}gd${RESET}    git diff"
            echo -e "  ${GREEN}gds${RESET}   git diff --staged"
            echo -e "  ${GREEN}gl${RESET}    git log --oneline --graph (last 20)"
            echo -e "  ${GREEN}gla${RESET}   git log --oneline --graph --all (last 30)"
            echo -e "  ${GREEN}ga${RESET}    git add"
            echo -e "  ${GREEN}gc${RESET}    git commit"
            echo -e "  ${GREEN}gco${RESET}   git checkout"
            echo -e "  ${GREEN}gb${RESET}    git branch"
            echo -e "  ${GREEN}gp${RESET}    git push"
            echo -e "  ${GREEN}gpu${RESET}   git pull"
            echo -e "  ${GREEN}gst${RESET}   git stash"
            ;;

        aliases)
            echo -e "${BOLD}${CYAN}Aliases${RESET}"
            echo "────────────────────────────────────────"
            echo -e "  ${MAGENTA}Navigation${RESET}"
            echo -e "  ${GREEN}..${RESET} ${GREEN}...${RESET} ${GREEN}....${RESET}   Go up 1/2/3 directories"
            echo -e "  ${GREEN}-${RESET}             Go to previous directory"
            echo ""
            echo -e "  ${MAGENTA}Listing${RESET}"
            echo -e "  ${GREEN}ll${RESET}            ls -alFh (long, human sizes)"
            echo -e "  ${GREEN}la${RESET}            ls -A (all except . and ..)"
            echo -e "  ${GREEN}lt${RESET}            ls -lhtr (newest last)"
            echo -e "  ${GREEN}lS${RESET}            ls -lhSr (largest last)"
            echo -e "  ${GREEN}t${RESET}             tree -L 2 (quick overview)"
            echo -e "  ${GREEN}t3${RESET}            tree -L 3"
            echo ""
            echo -e "  ${MAGENTA}Safety${RESET}"
            echo -e "  ${GREEN}cp${RESET}            cp -iv (confirm + verbose)"
            echo -e "  ${GREEN}mv${RESET}            mv -iv (confirm + verbose)"
            echo -e "  ${GREEN}mkdir${RESET}         mkdir -pv (create parents)"
            echo ""
            echo -e "  ${MAGENTA}Info${RESET}"
            echo -e "  ${GREEN}df${RESET}            df -h (human-readable)"
            echo -e "  ${GREEN}free${RESET}          free -h"
            echo -e "  ${GREEN}ports${RESET}         Show listening ports"
            echo -e "  ${GREEN}myip${RESET}          Show public IP"
            echo -e "  ${GREEN}path${RESET}          Show PATH one per line"
            echo -e "  ${GREEN}now${RESET}           Current timestamp"
            echo -e "  ${GREEN}psg${RESET}           Search running processes"
            echo -e "  ${GREEN}reload${RESET}        Re-source ~/.bashrc"
            ;;

        functions|func)
            echo -e "${BOLD}${CYAN}Functions${RESET}"
            echo "────────────────────────────────────────"
            echo -e "  ${GREEN}mkcd${RESET} ${YELLOW}<dir>${RESET}           Create directory and cd into it"
            echo -e "  ${GREEN}extract${RESET} ${YELLOW}<file>${RESET}        Universal archive extractor"
            echo -e "  ${GREEN}fkill${RESET}                 Fuzzy-search and kill a process"
            echo -e "  ${GREEN}serve${RESET} ${YELLOW}[port]${RESET}          Quick HTTP server (default: 8000)"
            echo -e "  ${GREEN}jsonpp${RESET} ${YELLOW}[file]${RESET}         Pretty-print JSON (pipe or file)"
            ;;

        help|*)
            echo -e "${BOLD}${CYAN}bash-prep${RESET} ${DIM}— shell enhancement kit${RESET}"
            echo "────────────────────────────────────────"
            echo -e "  ${GREEN}bp keys${RESET}        Key bindings (Ctrl-R, Ctrl-T, etc.)"
            echo -e "  ${GREEN}bp tools${RESET}       Installed tools & common patterns"
            echo -e "  ${GREEN}bp git${RESET}         Git shortcut aliases"
            echo -e "  ${GREEN}bp aliases${RESET}     All aliases (nav, listing, safety)"
            echo -e "  ${GREEN}bp functions${RESET}   Utility functions (extract, mkcd, etc.)"
            echo ""
            echo -e "  ${DIM}https://github.com/cooneycw/bash-prep${RESET}"
            ;;
    esac
}
