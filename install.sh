#!/bin/bash
# install.sh

# 備份舊的設定檔
echo "Backing up old vim configs..."
mv ~/.vimrc ~/.vimrc.bak 2>/dev/null
mv ~/.vim ~/.vim.bak 2>/dev/null

# 建立符號連結 (Symbolic Links)
echo "Creating symlinks..."
ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.vim ~/.vim

# 安裝所有插件 (透過 git submodule)
echo "Installing plugins via git submodule..."
git submodule update --init --recursive

# 提示使用者手動生成 help tags
echo "Running helptags for all plugins..."
vim -c 'helptags ALL' -c 'q'

echo "Done! Your Vim environment is ready."
