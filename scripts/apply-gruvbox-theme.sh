#!/bin/sh
#
# apply-gruvbox-theme.sh (v5 - Cross-platform)
# 支持 GNOME Terminal (Linux) 和 Terminal.app (macOS)

set -e

# --- 顏色數據 ---
PROFILE_NAME="Gruvbox-Dark"
PALETTE="#282828 #CC241D #98971A #D79921 #458588 #B16286 #689D6A #A89984 #928374 #FB4934 #B8BB26 #FABD2F #83A598 #D3869B #8EC07C #EBDBB2"
BACKGROUND_COLOR="#282828"
FOREGROUND_COLOR="#EBDBB2"
BOLD_COLOR="#EBDBB2"

# --- macOS Terminal.app 配置 ---
apply_macos_terminal() {
    SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
    PROFILE_FILE="${SCRIPT_DIR}/Gruvbox-Dark.terminal"

    # 生成 Terminal.app profile (plist 格式)
    cat > "$PROFILE_FILE" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>name</key>
    <string>Gruvbox-Dark</string>
    <key>type</key>
    <string>Window Settings</string>
    <key>BackgroundColor</key>
    <data>
    YnBsaXN0MDDUAQIDBAUGBwpYJHZlcnNpb25ZJGFyY2hpdmVyVCR0b3BYJG9i
    amVjdHMSAAGGoF8QD05TS2V5ZWRBcmNoaXZlctEICVRyb290gAGjCwwTVSRu
    dWxs0w0ODxARElVOU1JHQlxOU0NvbG9yU3BhY2VWJGNsYXNzTxAYMC4xNTY4
    NjI3NDUxIDAuMTU2ODYyNzQ1MQAQAYAC0hQVFhdaJGNsYXNzbmFtZVgkY2xh
    c3Nlc1dOU0NvbG9yohYYWE5TT2JqZWN0CBAaHykkKTJAQkRJW2RmeHqAAAAA
    AAABAQAAAAAAAAkAAAAAAAAAAAAAAAAAAACC
    </data>
    <key>TextColor</key>
    <data>
    YnBsaXN0MDDUAQIDBAUGBwpYJHZlcnNpb25ZJGFyY2hpdmVyVCR0b3BYJG9i
    amVjdHMSAAGGoF8QD05TS2V5ZWRBcmNoaXZlctEICVRyb290gAGjCwwTVSRu
    dWxs0w0ODxARElVOU1JHQlxOU0NvbG9yU3BhY2VWJGNsYXNzTxAoMC45MjE1
    Njg2Mjc1IDAuODU4ODIzNTI5NCAwLjY5ODAzOTIxNTcAEAGAAtIUFRYXWiRj
    bGFzc25hbWVYJGNsYXNzZXNXTlNDb2xvcqIWGFhOU09iamVjdAgQGh8kKTJA
    QkRJW2RmeHqAAAAAAAAAAQEAAAAAAAAJAAAAAAAAAAAAAAAAAAAAkg==
    </data>
    <key>TextBoldColor</key>
    <data>
    YnBsaXN0MDDUAQIDBAUGBwpYJHZlcnNpb25ZJGFyY2hpdmVyVCR0b3BYJG9i
    amVjdHMSAAGGoF8QD05TS2V5ZWRBcmNoaXZlctEICVRyb290gAGjCwwTVSRu
    dWxs0w0ODxARElVOU1JHQlxOU0NvbG9yU3BhY2VWJGNsYXNzTxAoMC45MjE1
    Njg2Mjc1IDAuODU4ODIzNTI5NCAwLjY5ODAzOTIxNTcAEAGAAtIUFRYXWiRj
    bGFzc25hbWVYJGNsYXNzZXNXTlNDb2xvcqIWGFhOU09iamVjdAgQGh8kKTJA
    QkRJW2RmeHqAAAAAAAAAAQEAAAAAAAAJAAAAAAAAAAAAAAAAAAAAkg==
    </data>
    <key>CursorColor</key>
    <data>
    YnBsaXN0MDDUAQIDBAUGBwpYJHZlcnNpb25ZJGFyY2hpdmVyVCR0b3BYJG9i
    amVjdHMSAAGGoF8QD05TS2V5ZWRBcmNoaXZlctEICVRyb290gAGjCwwTVSRu
    dWxs0w0ODxARElVOU1JHQlxOU0NvbG9yU3BhY2VWJGNsYXNzTxAoMC45MjE1
    Njg2Mjc1IDAuODU4ODIzNTI5NCAwLjY5ODAzOTIxNTcAEAGAAtIUFRYXWiRj
    bGFzc25hbWVYJGNsYXNzZXNXTlNDb2xvcqIWGFhOU09iamVjdAgQGh8kKTJA
    QkRJW2RmeHqAAAAAAAAAAQEAAAAAAAAJAAAAAAAAAAAAAAAAAAAAkg==
    </data>
    <key>Font</key>
    <data>
    YnBsaXN0MDDUAQIDBAUGBwpYJHZlcnNpb25ZJGFyY2hpdmVyVCR0b3BYJG9i
    amVjdHMSAAGGoF8QD05TS2V5ZWRBcmNoaXZlctEICVRyb290gAGkCwwRElUk
    bnVsbNMNDg8QFBVWTlNOYW1lViRjbGFzc1ZOU1NpemVfEBBNZW5sby1SZWd1
    bGFygAIjQCgAAAAAAAAS0hMUFRZaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0Zv
    bnSiFRdYTlNPYmplY3QIEBofJCkyQEJER0xSXWZoeouNjwAAAAAAAAEBAAAA
    AAAAGAAAAAAAAAAAAAAAAAAAAJg=
    </data>
    <key>UseBoldFonts</key>
    <true/>
    <key>columnCount</key>
    <integer>120</integer>
    <key>rowCount</key>
    <integer>36</integer>
</dict>
</plist>
PLIST

    echo "Generated Terminal.app profile: $PROFILE_FILE"
    echo "To install: open '$PROFILE_FILE' (double-click or 'open' command)"
    echo "Then set Gruvbox-Dark as default in Terminal > Preferences > Profiles"

    # 自动导入 profile
    if command -v open >/dev/null 2>&1; then
        open "$PROFILE_FILE"
        echo "Profile imported into Terminal.app."
    fi
}

# --- Linux GNOME Terminal 配置 ---
apply_gnome_terminal() {
    if ! command -v dconf >/dev/null 2>&1; then
        echo "Error: dconf command not found. Skipping GNOME Terminal theme."
        return
    fi

    PROFILE_LIST=$(dconf read /org/gnome/terminal/legacy/profiles:/list | tr -d '[]' | tr , "\n" | sed "s/'//g")

    for PROFILE_UUID in $PROFILE_LIST; do
        PROFILE_VISIBLE_NAME=$(dconf read /org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/visible-name | tr -d "'")
        if [ "$PROFILE_VISIBLE_NAME" = "$PROFILE_NAME" ]; then
            echo "Profile '$PROFILE_NAME' already exists. Setting it as default."
            dconf write /org/gnome/terminal/legacy/profiles:/default "'$PROFILE_UUID'"
            return
        fi
    done

    echo "Creating new GNOME Terminal profile: '$PROFILE_NAME'..."

    NEW_PROFILE_UUID=$(uuidgen)
    PROFILE_PATH="/org/gnome/terminal/legacy/profiles:/:$NEW_PROFILE_UUID/"

    if [ -z "$PROFILE_LIST" ]; then
        CMD_LIST="['$NEW_PROFILE_UUID']"
    else
        EXISTING_LIST=$(echo "$PROFILE_LIST" | sed "s/^/'/; s/ /', '/g; s/$/'/")
        CMD_LIST="[$EXISTING_LIST, '$NEW_PROFILE_UUID']"
    fi

    DCONF_PALETTE_CONTENT=""
    for color in $PALETTE; do
        DCONF_PALETTE_CONTENT="${DCONF_PALETTE_CONTENT}'${color}', "
    done
    DCONF_PALETTE_CONTENT=$(echo "$DCONF_PALETTE_CONTENT" | sed 's/, $//')
    DCONF_PALETTE="[${DCONF_PALETTE_CONTENT}]"

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
}

# --- 主流程 ---
case "$(uname)" in
    Darwin)
        apply_macos_terminal
        ;;
    *)
        apply_gnome_terminal
        ;;
esac
