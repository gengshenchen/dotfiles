#!/bin/bash

# ==============================================================================
# Script Name: clean_system.sh
# Description: System cleanup and interactive large file removal.
#              Supports Ubuntu/Debian (apt) and macOS (brew).
# Usage: sudo ./clean_system.sh
# ==============================================================================

# Colors for formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

OS_TYPE="$(uname)"

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: This script must be run as root.${NC}"
   exit 1
fi

# Function: Display current disk usage
show_disk_usage() {
    local stage=$1
    echo -e "\n${BLUE}=== Disk Usage [$stage] ===${NC}"
    df -h / | grep -v Filesystem
    echo "-----------------------------------"
}

# Function: Convert KB to human-readable (portable, no numfmt dependency)
human_readable_kb() {
    local kb=$1
    awk "BEGIN {
        val = $kb;
        if (val >= 1048576) printf \"%.1fG\", val/1048576;
        else if (val >= 1024) printf \"%.1fM\", val/1024;
        else printf \"%dK\", val;
    }"
}

# Function: Clean system caches and logs (Linux)
system_cleanup_linux() {
    echo -e "\n${YELLOW}>>> Starting System Cleanup (Linux)...${NC}"

    # 1. Apt cleanup
    echo -e "${GREEN}[1/4] Cleaning apt cache and unused dependencies...${NC}"
    apt-get update -qq
    apt-get autoremove -y
    apt-get clean

    # 2. Journalctl cleanup (retain last 3 days)
    echo -e "${GREEN}[2/4] Vacuuming systemd journals (keeping last 3 days)...${NC}"
    journalctl --vacuum-time=3d

    # 3. Clear thumbnail cache for all users
    echo -e "${GREEN}[3/4] Clearing thumbnail caches...${NC}"
    rm -rf /home/*/.cache/thumbnails/*
    rm -rf /root/.cache/thumbnails/*

    # 4. Snap cache (optional but effective)
    if [ -d "/var/lib/snapd/cache" ]; then
        echo -e "${GREEN}[4/4] Cleaning snap cache...${NC}"
        rm -rf /var/lib/snapd/cache/*
    fi

    echo -e "${YELLOW}>>> System Cleanup Complete.${NC}"
}

# Function: Clean system caches and logs (macOS)
system_cleanup_macos() {
    echo -e "\n${YELLOW}>>> Starting System Cleanup (macOS)...${NC}"

    # 1. Homebrew cleanup
    if command -v brew &> /dev/null; then
        echo -e "${GREEN}[1/3] Cleaning Homebrew cache and outdated versions...${NC}"
        brew cleanup --prune=all
    fi

    # 2. Clear user caches
    echo -e "${GREEN}[2/3] Clearing user caches...${NC}"
    for user_home in /Users/*/; do
        if [ -d "${user_home}Library/Caches" ]; then
            rm -rf "${user_home}Library/Caches/"* 2>/dev/null
        fi
    done

    # 3. Clear system logs
    echo -e "${GREEN}[3/3] Clearing old system logs...${NC}"
    rm -rf /var/log/asl/*.asl 2>/dev/null
    rm -rf /private/var/log/asl/*.asl 2>/dev/null

    echo -e "${YELLOW}>>> System Cleanup Complete.${NC}"
}

# Function: Find and manage large files (cross-platform)
manage_large_files() {
    echo -e "\n${YELLOW}>>> Large File Manager${NC}"
    echo "This will search for the top 10 largest files (larger than 100MB)."
    read -p "Enter directory to search (default: /): " SEARCH_DIR
    SEARCH_DIR=${SEARCH_DIR:-/}

    echo -e "${BLUE}Searching in '$SEARCH_DIR'... (this may take a moment)${NC}"

    TMP_FILE=$(mktemp)

    # find + du 方式，兼容 macOS 和 Linux（不使用 GNU -printf）
    find "$SEARCH_DIR" -type f -size +100M 2>/dev/null | while read -r filepath; do
        size_kb=$(du -k "$filepath" 2>/dev/null | awk '{print $1}')
        if [ -n "$size_kb" ]; then
            echo "$size_kb $filepath"
        fi
    done | sort -rn | head -n 10 > "$TMP_FILE"

    if [[ ! -s "$TMP_FILE" ]]; then
        echo -e "${GREEN}No files larger than 100MB found in $SEARCH_DIR.${NC}"
        rm "$TMP_FILE"
        return
    fi

    while IFS= read -r line; do
        size_kb=$(echo "$line" | awk '{print $1}')
        filepath=$(echo "$line" | cut -d ' ' -f2-)

        size_human=$(human_readable_kb "$size_kb")

        echo -e "\n${BLUE}Found File:${NC} $filepath"
        echo -e "${BLUE}Size:${NC} $size_human"

        read -p "Do you want to DELETE this file? (y/n): " choice
        case "$choice" in
            y|Y )
                rm -f "$filepath"
                if [[ $? -eq 0 ]]; then
                    echo -e "${RED}Deleted.${NC}"
                else
                    echo -e "${RED}Failed to delete.${NC}"
                fi
                ;;
            * )
                echo -e "${GREEN}Skipped.${NC}"
                ;;
        esac
    done < "$TMP_FILE"

    rm "$TMP_FILE"
}

# ==============================================================================
# Main Execution Flow
# ==============================================================================

clear

if [[ "$OS_TYPE" == "Darwin" ]]; then
    TITLE="macOS Storage Cleaner & Assistant"
else
    TITLE="Ubuntu Storage Cleaner & Assistant"
fi

echo -e "${YELLOW}=========================================${NC}"
echo -e "${YELLOW}   ${TITLE}    ${NC}"
echo -e "${YELLOW}=========================================${NC}"

# 1. Show 'Before' Usage
show_disk_usage "BEFORE"

# 2. Run System Cleanup
read -p "Run system cleanup? (y/n): " run_clean
if [[ "$run_clean" =~ ^[Yy]$ ]]; then
    if [[ "$OS_TYPE" == "Darwin" ]]; then
        system_cleanup_macos
    else
        system_cleanup_linux
    fi
else
    echo "Skipping system cleanup."
fi

# 3. Interactive Large File Search
read -p "Do you want to search for and manage large files? (y/n): " run_large
if [[ "$run_large" =~ ^[Yy]$ ]]; then
    manage_large_files
fi

# 4. Show 'After' Usage
show_disk_usage "AFTER"

echo -e "\n${GREEN}Done!${NC}"
