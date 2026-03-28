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
# 使用 osascript (JXA) 调用 ObjC 桥接生成正确的 NSColor 归档数据
apply_macos_terminal() {
    echo "Configuring Terminal.app with Gruvbox Dark theme..."

    /usr/bin/osascript -l JavaScript <<'JSEOF'
ObjC.import('AppKit')
ObjC.import('Foundation')

// 生成 NSKeyedArchiver 归档的 NSColor 数据
function archivedColor(r, g, b) {
    var color = $.NSColor.colorWithCalibratedRedGreenBlueAlpha(r, g, b, 1.0)
    var data = $.NSKeyedArchiver.archivedDataWithRootObject(color)
    return data
}

// 生成 NSKeyedArchiver 归档的 NSFont 数据
function archivedFont(name, size) {
    var font = $.NSFont.fontWithNameSize(name, size)
    var data = $.NSKeyedArchiver.archivedDataWithRootObject(font)
    return data
}

// Gruvbox Dark 调色板 (16 ANSI colors)
var colors = {
    "ANSIBlackColor":         archivedColor(0.157, 0.157, 0.157),  // #282828
    "ANSIRedColor":           archivedColor(0.800, 0.141, 0.114),  // #CC241D
    "ANSIGreenColor":         archivedColor(0.596, 0.592, 0.102),  // #98971A
    "ANSIYellowColor":        archivedColor(0.843, 0.600, 0.129),  // #D79921
    "ANSIBlueColor":          archivedColor(0.271, 0.522, 0.533),  // #458588
    "ANSIMagentaColor":       archivedColor(0.694, 0.384, 0.525),  // #B16286
    "ANSICyanColor":          archivedColor(0.408, 0.616, 0.416),  // #689D6A
    "ANSIWhiteColor":         archivedColor(0.659, 0.600, 0.518),  // #A89984
    "ANSIBrightBlackColor":   archivedColor(0.573, 0.514, 0.455),  // #928374
    "ANSIBrightRedColor":     archivedColor(0.984, 0.286, 0.204),  // #FB4934
    "ANSIBrightGreenColor":   archivedColor(0.722, 0.733, 0.149),  // #B8BB26
    "ANSIBrightYellowColor":  archivedColor(0.980, 0.741, 0.184),  // #FABD2F
    "ANSIBrightBlueColor":    archivedColor(0.514, 0.647, 0.596),  // #83A598
    "ANSIBrightMagentaColor": archivedColor(0.827, 0.525, 0.608),  // #D3869B
    "ANSIBrightCyanColor":    archivedColor(0.557, 0.753, 0.486),  // #8EC07C
    "ANSIBrightWhiteColor":   archivedColor(0.922, 0.859, 0.698),  // #EBDBB2
}

// 构建 profile 字典
var profile = $.NSMutableDictionary.alloc.init
profile.setObjectForKey("Gruvbox-Dark", "name")
profile.setObjectForKey("Window", "type")
profile.setObjectForKey(archivedColor(0.157, 0.157, 0.157), "BackgroundColor")
profile.setObjectForKey(archivedColor(0.922, 0.859, 0.698), "TextColor")
profile.setObjectForKey(archivedColor(0.922, 0.859, 0.698), "TextBoldColor")
profile.setObjectForKey(archivedColor(0.922, 0.859, 0.698), "CursorColor")
profile.setObjectForKey(archivedFont("Menlo-Regular", 12), "Font")
profile.setObjectForKey(true, "UseBoldFonts")
profile.setObjectForKey(120, "columnCount")
profile.setObjectForKey(36, "rowCount")

// 写入 ANSI 颜色
var colorKeys = Object.keys(colors)
for (var i = 0; i < colorKeys.length; i++) {
    profile.setObjectForKey(colors[colorKeys[i]], colorKeys[i])
}

// 写入 Terminal.app 偏好设置
var defaults = $.NSUserDefaults.alloc.initWithSuiteName("com.apple.Terminal")
var ws = defaults.dictionaryForKey("Window Settings")
var newWs = ws ? $.NSMutableDictionary.dictionaryWithDictionary(ws) : $.NSMutableDictionary.alloc.init
newWs.setObjectForKey(profile, "Gruvbox-Dark")
defaults.setObjectForKey(newWs, "Window Settings")
defaults.setObjectForKey("Gruvbox-Dark", "Default Window Settings")
defaults.setObjectForKey("Gruvbox-Dark", "Startup Window Settings")
defaults.synchronize

"Gruvbox-Dark theme installed successfully"
JSEOF

    echo "Gruvbox-Dark theme set as default in Terminal.app."
    echo "Please restart Terminal.app to see the changes."
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
