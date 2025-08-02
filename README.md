# My Personal Dotfiles

這是我個人的 Vim 和 Shell 開發環境設定檔倉庫，使用 Git 進行版本控制，旨在實現開發環境的快速、自動化部署。

## ✨ 功能特性

* **模組化 Vim 設定**: 將龐大的 `.vimrc` 拆分為多個職責單一的小檔案，易於維護。
* **可攜式環境**: 透過一鍵安裝腳本，可以在任何新的 Linux/macOS 電腦上快速還原完整的開發環境。
* **插件管理**: 使用 Vim 8+ 原生套件管理功能，並透過 Git Submodules 鎖定插件版本。
* **統一的視覺風格**: 自動為 GNOME Terminal 設定與 Vim 一致的 Gruvbox Dark 主題，提供沉浸式體驗。
* **IDE 級別功能**: 整合了 `vim-lsp` 和 `clangd`，為 C/C++ 開發提供智能補全、語法檢查和程式碼跳轉等功能。

---

## 🚀 快速開始 (在新電腦上部署)

### 1. 前置依賴

在執行安裝腳本前，請確保您的系統已安裝以下工具：

* `git`
* `vim` (版本 >= 8.2)
* `clangd` (用於 C/C++ LSP)
* `cmake` (用於生成 `compile_commands.json`)

在 Ubuntu/Debian 系統上，可以透過以下命令安裝：
```bash
sudo apt update
sudo apt install -y git vim  cmake clangd
```

### 2. Clone 倉庫

將此 `dotfiles` 倉庫 clone 到您喜歡的任何位置。推薦使用 `--recursive` 參數來同時 clone 所有插件 (Git Submodules)。

```bash
git clone --recursive [https://github.com/gengshenchen/dotfiles.git](https://github.com/gengshenchen/dotfiles.git) ~/dotfiles
```

### 3. 執行一鍵安裝腳本

進入倉庫目錄，並執行安裝腳本。

```bash
cd ~/dotfiles
sh install.sh
```

腳本將會自動完成以下所有工作：
* 備份您現有的 `~/.vim` 和 `~/.vimrc` (如果存在)。
* 建立符號連結，將倉庫中的設定檔連結到您的Home目錄。
* 安裝所有 Vim 插件。
* 為 GNOME Terminal 設定 Gruvbox Dark 主題。

安裝完成後，請**完全重啟您的終端機**以使所有設定生效。

---

## 🔧 維護與更新

### 更新插件

所有 Vim 插件都作為 Git Submodules 進行管理。要更新所有插件到最新版本，請執行：

```bash
cd ~/dotfiles
git submodule update --remote --merge
# 更新後，記得提交變更
git commit -am "Update Vim plugins"
git push
```

### 新增插件

1.  進入插件目錄：
    ```bash
    cd .vim/pack/vendor/start
    ```
2.  將新插件作為 submodule 加入：
    ```bash
    git submodule add <插件的 Git URL> <插件名稱>
    ```
3.  回到根目錄並提交變更。

---

## 📁 結構概覽

* `.vimrc`: Vim 的主設定檔，負責載入所有模組。
* `.vim/`: Vim 的主要設定目錄。
    * `settings/`: 模組化的 Vim 設定檔。
    * `pack/vendor/start/`: 使用 Vim 8 原生套件管理和 Git Submodules 存放所有插件。
* `scripts/`: 存放輔助設定腳本（例如終端機主題）。
* `install.sh`: 主安裝腳本。

