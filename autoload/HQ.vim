function! HQ#Main() abort
    let total_cnt = len(g:hq_commands)

    " 新規バッファ開く
    sil! exe 'keepa' ( 'to' ) total_cnt . 'new HQ'

    setlocal buftype=nofile
    setlocal noswapfile          "スワップファイルを作成しない
    setlocal bufhidden=wipe      "バッファがウィンドウ内から表示されなくなったら削除
    setlocal nonumber            "行番号を表示しない
    setlocal nowrap              "ラップしない
    setlocal nocursorline        "カーソル行をハイライトしない
    setlocal nocursorcolumn      "カーソル列をハイライトしない

    nnoremap <silent> <buffer>
                \ <Plug>(session-close)
                \ :<C-u>bwipeout!<CR>

    nnoremap <silent> <buffer>
                \ <Plug>(session-open)
                \ :call ExecuteCom(getline('.')[col('.')-1])<CR>

    nmap <buffer> q <Plug>(session-close)
    nmap <buffer> <Plug>(hq-toggle) <Plug>(session-close)
    nmap <buffer> <esc> <Plug>(session-close)
    nmap <buffer> <CR> <Plug>(session-open)
    " 抑止
    map <buffer> l <nop>
    map <buffer> h <nop>
    map <buffer> w <nop>
    map <buffer> b <nop>
    map <buffer> i <nop>
    map <buffer> a <nop>
    map <buffer> f <nop>

    %delete _

    " 一覧作成処理
    let cnt = 1
    for k in keys(g:hq_commands)

        " リストの個数で分岐
        if len(g:hq_commands[k]) == 1
            call setline(cnt, '[' . k . ']' . '  ' . g:hq_commands[k][0])
        elseif len(g:hq_commands[k]) == 2
            call setline(cnt, '[' . k . ']' . '  ' . g:hq_commands[k][0] . '  ' . '('  . g:hq_commands[k][1] . ')')
        else
            continue
        endif

        " マッピング
        execute 'nnoremap <buffer><silent><nowait>' k
                    \ ':call execute("bwipeout!")<cr>'
                    \ ':call execute("' g:hq_commands[k][0] '", "")<cr>'
        let cnt += 1
    endfor

    " 初期カーソル位置を指定
    call cursor(1, 2)

    call HQ#Highlight()
endfunction

" エンターでカーソル位置のコマンドを実行
function! ExecuteCom(idx) abort
    call execute("bwipeout!")
    call execute(g:hq_commands[a:idx][0], "")
endfunction

" ハイライト処理
function! HQ#Highlight() abort
    if exists("b:current_syntax")
        finish
    endif

    syntax match HQKey /^\s*\[\zs[^BSVT]\{-}\ze\]/
    syntax match HQComment '\zs[\(].*'

    highlight! default link HQKey Number
    highlight! default link HQComment vimComment

    let b:current_syntax = 'hq'
endfunction

" echo 'gorilla'
" let s:buffer_name = 'vim-HQ'
" execute 'new' s:buffer_name
" silent! execute 'keepalt' ( 'top' ) '10new HQ'

" function! HQ#Main() abort
"     " floating windownで新規バッファ
"     let total_cnt = len(g:hq_commands)
"     let buf = nvim_create_buf(v:false, v:true)
"     " call nvim_buf_set_lines(buf, 0, -1, v:true, ["test", "text"])
"     let opts = {'relative': 'cursor', 'width': 30, 'height': total_cnt, 'col': 1, 'row': 1, 'anchor': 'NW', 'style': 'minimal'}
"     let win = nvim_open_win(buf, 1, opts)
"     hi MyHighlight guifg=#eceff4 guibg=#5e81ac gui=bold
"     call nvim_win_set_option(win, 'winhl', 'Normal:MyHighlight')
"     call nvim_win_set_option(win, 'winblend', 10)


"     " マッピング
"     nnoremap <buffer> <CR>
"                 \ :call ExecuteCom(getline('.')[col('.')-1], a:win)<CR>


"     " 一覧作成処理
"     let cnt = 1
"     for k in keys(g:hq_commands)

"         " 描画
"         call setline(cnt, '[' . k . ']' . '  ' . g:hq_commands[k][0])

"         " 指定のキーにマッピング
"         execute 'nnoremap <buffer><silent><nowait>' k
"                     \ ':call execute("bwipeout!")<CR>'
"                     \ ':call execute("' g:hq_commands[k][0] '", "")<CR>'

"         let cnt += 1
"     endfor

"     " 初期カーソル位置を指定
"     call cursor(1, 2)

"     call HQ#Highlight()
" endfunction

" " エンターでカーソル位置のコマンドを実行
" function! ExecuteCom(idx, win) abort
"     "ウィンドウを閉じる
"     call nvim_win_close(a:win, v:true)
"     call execute(g:hq_commands[a:idx][0], "")
" endfunction
