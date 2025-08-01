" --- .ui file use qt designer ---
autocmd BufReadPost,BufNewFile *.ui call OpenQtDesigner(expand('%')) | bd!
function! OpenQtDesigner(file)
    if executable("designer")
        silent execute '!designer "' . a:file . '" &'
    else
        echohl ErrorMsg
        echom "Err: Qt Designer not found in PATH"
        echohl None
    endif
endfunction

" --- termdebug for gdb debug ---
" --- use: :Termdebug app-path
packadd termdebug
augroup TermdebugMappings
    autocmd!
    autocmd VimEnter * nnoremap <silent> <F5> :Run<CR>
    autocmd VimEnter * nnoremap <silent> <F8> :Break<CR>
    autocmd VimEnter * nnoremap <silent> <Leader>s :Step<CR>
    autocmd VimEnter * nnoremap <silent> <Leader>n :Over<CR>
    autocmd VimEnter * nnoremap <silent> <F12> :Finish<CR>
augroup END

