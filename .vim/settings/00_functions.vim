function! Focus_code_window()
    if &filetype ==# 'nerdtree'
        wincmd p
        if &filetype ==# 'nerdtree'
            wincmd l
        endif
    endif
endfunction
