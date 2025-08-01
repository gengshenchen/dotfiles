" autoload/karlstatus.vim

" 定義一個函式，用來產生我們想要的狀態列字串
" 注意函式名稱的特殊格式：{插件名}#{函式名}
function! karlstatus#get_status()
    " 獲取當前模式
    let l:mode = mode()
    " 根據模式顯示不同的文字
    if l:mode ==# 'n'
        let l:mode_str = '[NOR]'
    elseif l:mode ==# 'i'
        let l:mode_str = '[INS]'
    elseif l:mode ==# 'v'
        let l:mode_str = '[VIS]'
    else
        let l:mode_str = '[' . toupper(l:mode) . ']'
    endif

    " 獲取檔名
    let l:filename = expand('%:t')
    if l:filename == ''
        let l:filename = '[No Name]'
    endif

    " 獲取行號資訊
    let l:line_info = line('.') . '/' . line('$')

    " %-0{...} 是 statusline 的特殊語法，代表左對齊
    " %= 代表左右兩側的分隔點
    let l:status_string = l:mode_str . ' | %f' . ' %= ' . l:line_info

    " 回傳最終組合好的字串
    return l:status_string
endfunction
