syntax on
set nocompatible
set shortmess+=I
set number
set relativenumber
set laststatus=2
set backspace=indent,eol,start
set ignorecase
set smartcase
set incsearch
set noerrorbells visualbell t_vb=
set mouse+=a
set showcmd
set clipboard=unnamedplus

"filetype
filetype on
filetype indent on
filetype plugin on

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" temp file path
set directory^=$HOME/.vim/swap//
set updatecount=20
set backup
set backupdir^=$HOME/.vim/backup//
set undofile
set undodir^=$HOME/.vim/undo//

" auto save
set updatetime=1000
augroup AutoSave
    autocmd!
    autocmd CursorHold,CursorHoldI,FocusLost * silent! update
    autocmd VimLeavePre * silent! wall
augroup END


" auto delete whitespace in line tail
autocmd BufWritePre * :%s/\s\+$//e

