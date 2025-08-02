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
set updatecount=20
set backup
set undofile
let s:vim_tmp_dir = expand('~/.vim-tmp')
for dir in ['backup', 'swap', 'undo']
    let full_path = s:vim_tmp_dir . '/' . dir
    if !isdirectory(full_path)
        call mkdir(full_path, 'p')
    endif
endfor
set directory=~/.vim-tmp/swap//
set backupdir=~/.vim-tmp/backup//
set undodir=~/.vim-tmp/undo//

" auto save
set updatetime=1000
augroup AutoSave
    autocmd!
    autocmd CursorHold,CursorHoldI,FocusLost * silent! update
    autocmd VimLeavePre * silent! wall
augroup END


" auto delete whitespace in line tail
autocmd BufWritePre * :%s/\s\+$//e

