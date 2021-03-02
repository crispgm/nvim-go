if exists('g:loaded_nvim_go') | finish | endif
let g:loaded_nvim_go = 1

command! GoFormat lua require('go.goformat').run{}
command! GoFmt lua require('go.gofmt').run{}
command! GoImports lua require('go.goimports').run{}

augroup nvim_go
  autocmd!
  autocmd BufWritePre *.go GoFormat
augroup END
