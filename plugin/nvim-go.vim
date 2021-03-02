if exists('g:loaded_nvim_go') | finish | endif
let g:loaded_nvim_go = 1

command! GoFormat lua require('go.format').run{}
command! GoFmt lua require('go.fmt').run{}
command! GoImports lua require('go.imports').run{}

augroup nvim_go
  autocmd!
  autocmd BufWritePre *.go GoFormat
augroup END
