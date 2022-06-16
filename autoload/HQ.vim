"
" メイン処理
"
function! HQ#Main() abort
    " 新規バッファをフローティングウィンドウで開く
    call HQ#OpenFloatingWindow()
    " バッファの設定をする
    call HQ#SetBufferConfig()
    " バッファ内のマッピングを定義する
    call HQ#DefineBufferMapping()
    " リスト作成処理
    let cnt = 1
    for key in keys(g:hq_commands)
        " 描画する
        if len(g:hq_commands[key]) == 1
            call setline(cnt, ' [' . key . ']' . '  ' . g:hq_commands[key][0])
        elseif len(g:hq_commands[key]) == 2
            call setline(cnt, ' [' . key . ']' . '  ' . g:hq_commands[key][0] . '  ' . '('  . g:hq_commands[key][1] . ')')
        else
            continue
        endif
        " キーにコマンドをマッピングする
        execute 'nnoremap <buffer><silent><nowait>' key
                    \ ':call nvim_win_close(0, v:true)<CR>'
                    \ ':call execute("' g:hq_commands[key][0] '", "")<cr>'
        let cnt += 1
    endfor
    " 初期カーソル位置を指定
    call cursor(1, 3)
    " ハイライト処理
    call HQ#Highlight()
endfunction

"
" 新規バッファをフローティングウィンドウで開く
"
function! HQ#OpenFloatingWindow() abort
    let total_cnt = len(g:hq_commands) " コマンド総数
    let width = 60
    let height = total_cnt
    let buf = nvim_create_buf(v:false, v:true)
    let ui = nvim_list_uis()[0]
    let opts = {'relative': 'editor',
                \ 'width': width,
                \ 'height': height,
                \ 'col': (ui.width/2) - (width/2),
                \ 'row': (ui.height/2) - (height/2),
                \ 'anchor': 'NW',
                \ 'style': 'minimal',
                \ }
    let win = nvim_open_win(buf, 1, opts)
endfunction

"
" バッファの設定をする
"
function! HQ#SetBufferConfig() abort
    setlocal buftype=nofile
    setlocal noswapfile     " スワップファイルを作成しない
    setlocal bufhidden=wipe " バッファがウィンドウ内から表示されなくなったら削除
    setlocal nonumber       " 行番号を表示しない
    setlocal nowrap         " 改行しない
    setlocal nocursorline   " カーソル行をハイライトしない
    setlocal nocursorcolumn " カーソル列をハイライトしない
endfunction

"
" バッファ内のマッピングを定義する
"
function! HQ#DefineBufferMapping() abort
    " バッファ内での既存マッピングを無効化
    map <buffer> a <nop>
    map <buffer> b <nop>
    map <buffer> f <nop>
    map <buffer> h <nop>
    map <buffer> i <nop>
    map <buffer> l <nop>
    map <buffer> v <nop>
    map <buffer> w <nop>
    map <buffer> x <nop>
    " バッファを閉じるマッピングを登録
    nmap <silent><buffer> q :call nvim_win_close(0, v:true)<CR>
    nmap <silent><buffer> <esc> :call nvim_win_close(0, v:true)<CR>
    nmap <buffer> <Plug>(hq-toggle) :call nvim_win_close(0, v:true)<CR>
    " コマンドを実行するマッピングを登録
    nmap <buffer> <CR> :call HQ#ExecuteCommand(getline('.')[col('.')-1])<CR>
endfunction

"
" エンターでカーソル位置のコマンドを実行
"
function! HQ#ExecuteCommand(idx) abort
    call nvim_win_close(0, v:true)
    call execute(g:hq_commands[a:idx][0], "")
endfunction

"
" ハイライト処理
"
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
