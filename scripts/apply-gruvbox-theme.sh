#!/bin/sh
#
# apply-gruvbox-theme.sh (v4 - Final Corrected Version)
# 修正了 profile list 和 palette 字串的拼接邏輯，確保 dconf 格式正確。

set -e

# --- 顏色數據 ---
PROFILE_NAME="Gruvbox-Dark"
PALETTE="#282828 #CC241D #98971A #D79921 #458588 #B16286 #689D6A #A89984 #928374 #FB4934 #B8BB26 #FABD2F #83A598 #D3869B #8EC07C #EBDBB2"
BACKGROUND_COLOR="#282828"
FOREGROUND_COLOR="#EBDBB2"
BOLD_COLOR="#EBDBB2"

if ! command -v dconf >/dev/null 2>&1; then
    echo "Error: dconf command not found."
    exit 1
fi

PROFILE_LIST=$(dconf read /org/gnome/terminal/legacy/profiles:/list | tr -d '[]' | tr , "\n" | sed "s/'//g")

for PROFILE_UUID in $PROFILE_LIST; do
    PROFILE_VISIBLE_NAME=$(dconf read /org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/visible-name | tr -d "'")
    if [ "$PROFILE_VISIBLE_NAME" = "$PROFILE_NAME" ]; then
        echo "Profile '$PROFILE_NAME' already exists. Setting it as default."
        dconf write /org/gnome/terminal/legacy/profiles:/default "'$PROFILE_UUID'"
        exit 0
    fi
done

echo "Creating new GNOME Terminal profile: '$PROFILE_NAME'..."

NEW_PROFILE_UUID=$(uuidgen)
PROFILE_PATH="/org/gnome/terminal/legacy/profiles:/:$NEW_PROFILE_UUID/"

# --- 【修正】構造正確的 Profile 列表 ---
if [ -z "$PROFILE_LIST" ]; then
    # 如果原始列表是空的
    CMD_LIST="['$NEW_PROFILE_UUID']"
else
    # 如果原始列表非空
    EXISTING_LIST=$(echo "$PROFILE_LIST" | sed "s/^/'/; s/ /', '/g; s/$/'/")
    CMD_LIST="[$EXISTING_LIST, '$NEW_PROFILE_UUID']"
fi

# --- 【修正】構造正確的 Palette 列表 ---
DCONF_PALETTE_CONTENT=""
for color in $PALETTE; do
    DCONF_PALETTE_CONTENT="${DCONF_PALETTE_CONTENT}'${color}', "
done
# 移除最後多餘的 ", "
DCONF_PALETTE_CONTENT=$(echo "$DCONF_PALETTE_CONTENT" | sed 's/, $//')
DCONF_PALETTE="[${DCONF_PALETTE_CONTENT}]"


# --- 開始寫入顏色設定 ---
dconf write /org/gnome/terminal/legacy/profiles:/list "$CMD_LIST"
dconf write ${PROFILE_PATH}visible-name "'$PROFILE_NAME'"
dconf write ${PROFILE_PATH}palette "$DCONF_PALETTE"
dconf write ${PROFILE_PATH}background-color "'$BACKGROUND_COLOR'"
dconf write ${PROFILE_PATH}foreground-color "'$FOREGROUND_COLOR'"
dconf write ${PROFILE_PATH}bold-color "'$BOLD_COLOR'"
dconf write ${PROFILE_PATH}use-theme-colors "false"
dconf write ${PROFILE_PATH}bold-color-same-as-fg "true"
dconf write /org/gnome/terminal/legacy/profiles:/default "'$NEW_PROFILE_UUID'"

echo "Profile '$PROFILE_NAME' created and set as default."
echo "Please restart your terminal to see the changes."
