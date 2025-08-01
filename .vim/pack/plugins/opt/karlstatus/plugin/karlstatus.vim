" plugin/karlstatus.vim

" 確保狀態列永遠顯示
set laststatus=2

" 設定 statusline，讓它去呼叫我們在 autoload 中定義的函式
" %! 是特殊語法，代表後面是一個函式呼叫
set statusline=%!karlstatus#get_status()
