nmap Q <Nop> " 'Q' in normal mode enters Ex mode. You almost never want this.

" --- close Quickfix / Location List window
function! CloseQuickfixAndFocusCode()
    try | lclose | catch | endtry
    try | cclose | catch | endtry
    if &filetype == 'nerdtree'
        wincmd p
    endif
endfunction

nnoremap <silent> <C-q> :call CloseQuickfixAndFocusCode()<CR>

" --- Tab / Shift+Tab ---
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" --- close current buffer
nnoremap <leader>bd :bdelete<CR>
