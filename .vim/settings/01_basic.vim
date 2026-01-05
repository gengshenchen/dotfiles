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
set synmaxcol=200

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
function! s:check_and_update() " for ale call clang-format
    if &modified
        silent! update
    endif
endfunction
set updatetime=1000
augroup AutoSave
    autocmd!
   " autocmd FocusLost * silent! update " CursorHold,CursorHoldI,
    autocmd FocusLost * call timer_start(1, {-> s:check_and_update()})
    autocmd VimLeavePre * silent! wall
augroup END

" auto delete whitespace in line tail
autocmd BufWritePre * :%s/\s\+$//e

" --- fold setting ---
" za: switch zM:(more)fold all zR:(reduce)unfold all
" \zn: fold none, \za: fold all
nnoremap <leader>zn :set nofoldenable<CR>
nnoremap <leader>za :set foldenable<CR>
" not fold for start
set foldlevelstart=99

augroup filetype_folds
    autocmd!
    autocmd FileType c,cpp,java,javascript,rust,go,sh setlocal foldmethod=syntax
    autocmd FileType python,yaml,vim setlocal foldmethod=indent
    autocmd FileType markdown,conf setlocal foldmethod=marker
augroup END

augroup filetype_comment
    autocmd!
    autocmd FileType c,cpp setlocal commentstring=//%s
augroup END

let mapleader = "\<Space>"
