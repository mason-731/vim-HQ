if exists("b:current_syntax")
  finish
endif

syntax match HQTitle 'UndotreeToggle'

highlight! default link HQTitle Title

let b:current_syntax = 'hq'
