# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository for Vim + shell development environment, targeting Linux (Ubuntu/Debian) and macOS. Primary languages supported: C/C++, Rust. Uses Gruvbox Dark theme throughout.

## Key Commands

- **Deploy to a new machine:** `sh install.sh` (installs deps, symlinks configs, sets up plugins and terminal theme)
- **Update all Vim plugins:** `git submodule update --remote --merge`
- **Add a new Vim plugin:** `git submodule add <url> .vim/pack/plugins/start/<name>`
- **Regenerate helptags:** `vim -Es -u NONE -c 'helptags ALL' -c 'q'`

## Architecture

### Vim Configuration (modular)

`.vimrc` sources numbered files from `.vim/settings/` in order:

- `00_functions.vim` — shared helper functions (e.g., `Focus_code_window`)
- `01_basic.vim` — core settings, leader key (`<Space>`), fold config, auto-save, whitespace trimming
- `02_plugins.vim` — plugin configs: NERDTree, vim-lsp (clangd + rust-analyzer), asyncomplete, ALE (formatting only), fzf, tagbar, airline
- `03_mappings.vim` — key mappings: buffer navigation (Tab/S-Tab), `<leader>bd` close, `<leader>w` save
- `04_appearance.vim` — colorscheme (Gruvbox Dark)
- `05_integrations.vim` — Qt Designer auto-open for `.ui` files, Termdebug (GDB) with F5/F8/F12 mappings

### Plugin Management

Vim 8 native packages via git submodules in `.vim/pack/plugins/start/`. All plugins listed in `.gitmodules`.

### Shell Configuration

- `.bashrc.base` — shared shell config sourced from user's `.bashrc`; includes `vf` function (rg+fzf+vim), system aliases
- Local overrides go in `~/.bashrc.local` (not tracked)

### Git Configuration

- `.gitconfig` — shared git config with aliases, diff/merge tools (vimdiff), pull rebase, conditional includes
- User identity configured via `~/.gitconfig.local`, `~/.gitconfig.work`, `~/.gitconfig.github` (not tracked)

### LSP Setup

clangd is configured with `--compile-commands-dir=out` and cross-compiler query-driver. Projects need `compile_commands.json` in an `out/` directory. ALE handles formatting only (linting disabled, `ale_disable_lsp = 1`).

## Conventions

- Comments and README are in Chinese (Traditional/Simplified mixed)
- `install.sh` is location-independent (auto-detects its own directory)
- Temp files (swap, backup, undo) go to `~/.vim-tmp/`, not in the repo
