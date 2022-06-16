" すでにスクリプトをロードした場合は終了
if exists('g:loaded_hq')
  finish
endif
let g:loaded_hq = 1
" HQコマンドを定義
command! -nargs=0 HQ call HQ#Main()
" HQコマンドをマッピング
noremap <unique> <Plug>(hq-toggle) :<C-u>HQ<CR>
