#!/bin/bash

# ==============================================================================
# Script Name: clean_system.sh
# Description: Ubuntu system cleanup and interactive large file removal.
# Usage: sudo ./clean_system.sh
# ==============================================================================

# Colors for formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Function: Clean system caches and logs
system_cleanup() {
    echo -e "\n${YELLOW}>>> Starting System Cleanup...${NC}"

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

# Function: Find and manage large files
manage_large_files() {
    echo -e "\n${YELLOW}>>> Large File Manager${NC}"
    echo "This will search for the top 10 largest files (larger than 100MB)."
    read -p "Enter directory to search (default: /): " SEARCH_DIR
    SEARCH_DIR=${SEARCH_DIR:-/}

    echo -e "${BLUE}Searching in '$SEARCH_DIR'... (this may take a moment)${NC}"

    # Create a temporary file to store the list
    TMP_FILE=$(mktemp)

    # Find top 10 files > 100MB, sort by size.
    # Using printf to get size in bytes for sorting, then display path.
    # Format: [Size in KB] [FilePath]
    find "$SEARCH_DIR" -type f -size +100M -printf "%k %p\n" 2>/dev/null | sort -rn | head -n 10 > "$TMP_FILE"

    if [[ ! -s "$TMP_FILE" ]]; then
        echo -e "${GREEN}No files larger than 100MB found in $SEARCH_DIR.${NC}"
        rm "$TMP_FILE"
        return
    fi

    # Read the temp file line by line
    while IFS= read -r line; do
        # Extract size (KB) and path
        size_kb=$(echo "$line" | awk '{print $1}')
        filepath=$(echo "$line" | cut -d ' ' -f2-)

        # Convert to Human Readable format
        size_human=$(numfmt --to=iec --from-unit=1K "$size_kb")

        echo -e "\n${BLUE}Found File:${NC} $filepath"
        echo -e "${BLUE}Size:${NC} $size_human"

        # Interactive prompt
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
echo -e "${YELLOW}=========================================${NC}"
echo -e "${YELLOW}   Ubuntu Storage Cleaner & Assistant    ${NC}"
echo -e "${YELLOW}=========================================${NC}"

# 1. Show 'Before' Usage
show_disk_usage "BEFORE"

# 2. Run System Cleanup
read -p "Run system cleanup (apt, logs, cache)? (y/n): " run_clean
if [[ "$run_clean" =~ ^[Yy]$ ]]; then
    system_cleanup
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
