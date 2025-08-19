" --- NERDTree ---
let NERDTreeShowHidden=1
augroup NERDTreeHooks
    autocmd!
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

    "autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
    nnoremap <F2> :NERDTreeToggle<CR>
augroup END

" --- vim-lsp for clangd ---
let g:lsp_log_file = expand('~/.vim-tmp/lsp.log')
let g:lsp_log_verbose = 0
if executable('clangd')
    augroup vim_lsp_register_clangd
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd']},
                    \ 'whitelist': ['c','cpp','objc','objcpp'],
                    \ })

        autocmd FileType c,cpp,objc,objcpp,h,cc,hpp,hxx  setlocal omnifunc=lsp#complete
    augroup END

    augroup lsp_cpp_key_mappings
        autocmd!
        autocmd FileType c,cpp,objc,objcpp nnoremap <buffer> gd <Plug>(lsp-definition)
        autocmd FileType c,cpp,objc,objcpp nnoremap <buffer> gr <Plug>(lsp-references)
        autocmd FileType c,cpp,objc,objcpp nnoremap <buffer> K <Plug>(lsp-hover)
        autocmd FileType c,cpp,objc,objcpp nnoremap <buffer> <leader>rn <Plug>(lsp-rename)
        autocmd FileType c,cpp,objc,objcpp nnoremap <buffer> [g <Plug>(lsp-previous-diagnostic)
        autocmd FileType c,cpp,objc,objcpp nnoremap <buffer> ]g <Plug>(lsp-next-diagnostic)
        autocmd FileType c,cpp,objc,objcpp nnoremap <buffer> <leader>ca <Plug>(lsp-code-action-float)

    augroup end
endif

" --- asyncomplete.vim ---
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_popup_delay = 150
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction
augroup asyncomplete_key_mappings
    autocmd!
    inoremap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ asyncomplete#force_refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
 "   inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() . "\<c-y>" : "\<CR>"
   inoremap <expr> <cr> pumvisible()? asyncomplete#close_popup() : "\<cr>"

    imap <c-@> <Plug>(asyncomplete_force_refresh)

    autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
augroup end


" --- ALE (Asynchronous Linting Engine) ---
let g:ale_cpp_clangformat_executable = 'clang-format'
let g:ale_c_clangformat_executable = 'clang-format'
let g:ale_linters = {
\   'c': [],
\   'cpp': [],
\}

let g:ale_fixers = {
\   'cpp': ['clang-format'],
\   'c': ['clang-format'],
\}
let g:ale_disable_lsp = 1
let g:ale_fix_on_save = 1
nnoremap <Leader>cf :ALEFix<CR>
nnoremap <leader>ci O// clang-format off<Esc>jo// clang-format on<Esc>
vnoremap <leader>ci <Esc>'>o// clang-format on<Esc>'<O// clang-format off<Esc>

" --- fzf rg ---
nnoremap <silent> <Leader>f :call Focus_code_window()<CR>:Files<CR>
nnoremap <silent> <Leader>g :call Focus_code_window()<CR>:Rg<CR>
nnoremap <silent> <Leader>b :call Focus_code_window()<CR>:Buffers<CR>
"nnoremap <silent> <Leader>r :History<CR>

"--- tagbar (outline)---
let g:tagbar_width = 35
let g:tagbar_autofocus = 1
nnoremap <silent> <leader>st :TagbarToggle<CR>

" --- vim-airline ---
let g:airline_theme = 'base16_gruvbox_dark_hard'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tabs_label = ''
let g:airline#extensions#tabline#buffers_label = ''
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
" a/b/main.cpp and  x/y/main.cpp -->  b/main.cpp 和 y/main.cpp
let g:airline#extensions#tabline#formatter = 'unique_tail'
"status line layout
let g:airline_section_a = ''
let g:airline#extensions#branch#enabled = 0
let g:airline_section_x = ''
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.whitespace = ''
let g:airline_section_z = '%l/%L:%c'
let g:airline#extensions#default#layout = [
      \ [ 'b', 'c', 'gutter' ],
      \ [ 'y', 'z', 'error', 'warning' ]
      \ ]

