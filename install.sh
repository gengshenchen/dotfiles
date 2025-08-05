#!/bin/bash
# install.sh (v2 - Location Independent)

# --- 前置作業 ---
# 透過 `cd` 和 `pwd` 的組合，取得這個腳本所在的目錄的絕對路徑
# 無論您在哪裡執行這個腳本，這都能確保我們找到了 dotfiles 倉庫的根目錄
SOURCE_DIR=$(cd "$(dirname "$0")" && pwd)

install_dependencies() {
    echo -e "\n${INFO}Checking and installing dependencies...${NC}"

    # 定義必要的工具列表
    local pkgs_to_install="git vim  ripgrep clangd cmake"
    local pkg_manager=""
    local install_cmd=""

    # 偵測作業系統和套件管理器
    if [[ "$(uname)" == "Darwin" ]]; then
        if ! command -v brew &> /dev/null; then
            echo -e "${ERROR}Homebrew (brew) not found. Please install it first.${NC}"
            exit 1
        fi
        pkg_manager="brew"
        install_cmd="brew install"
    elif command -v apt-get &> /dev/null; then
        pkg_manager="apt"
        install_cmd="sudo apt-get install -y"
        # 更新 apt 列表
        echo "--> Updating apt package list..."
        sudo apt-get update
    else
        echo -e "${ERROR}Unsupported package manager. Please install dependencies manually: ${pkgs_to_install}${NC}"
        return
    fi

    # 遍歷工具列表，如果不存在則安裝
    for pkg in $pkgs_to_install; do
        if ! command -v $pkg &> /dev/null; then
            echo "--> Installing ${pkg}..."
            ${install_cmd} ${pkg}
        else
            echo -e "--> ${pkg} is already installed. ${SUCCESS}Skipping.${NC}"
        fi
    done
}
install_dependencies
# 為了美觀，定義一些顏色
INFO='\033[0;34m'
SUCCESS='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${INFO}Starting Vim configuration deployment...${NC}"
echo -e "${INFO}Dotfiles repository located at: ${SOURCE_DIR}${NC}"


# --- 1. 備份舊的設定檔 ---
echo "--> Backing up existing vim configs to ~/.vimrc.bak and ~/.vim.bak..."
mv ~/.vimrc ~/.vimrc.bak 2>/dev/null
mv ~/.vim ~/.vim.bak 2>/dev/null

# --- 2.tmp ---
echo "--> Setting up temporary directories for Vim..."
mkdir -p ~/.vim-tmp/swap
mkdir -p ~/.vim-tmp/backup
mkdir -p ~/.vim-tmp/undo

# --- 3. 建立符號連結 ---
# 使用我們自動偵測到的 $SOURCE_DIR 變數，而不是寫死的 ~/dotfiles
echo "--> Creating symlinks from repository to home directory..."
ln -s "${SOURCE_DIR}/.vimrc" ~/.vimrc
ln -s "${SOURCE_DIR}/.vim" ~/.vim


# --- 4. 安裝所有插件 (透過 git submodule) ---
echo "--> Installing plugins via git submodule..."
# 確保我們在 git 倉庫的根目錄下執行
cd "${SOURCE_DIR}"
git submodule update --init --recursive


# --- 5. 自動生成 help tags ---
echo "--> Generating helptags for all plugins..."
# 使用 -Es 參數可以在「安靜模式」下執行，更乾淨
vim -Es -u NONE -c 'helptags ALL' -c 'q'

# ---6. Terminal 配置主题
echo -e "--> Configuring Terminal using our self-contained script...${NC}"
sh "${SOURCE_DIR}/scripts/apply-gruvbox-theme.sh"

echo -e "\n${SUCCESS}Done! Your full environment is ready.${NC}"
echo -e "${SUCCESS}Please RESTART your terminal completely for all changes to take effect.${NC}"

