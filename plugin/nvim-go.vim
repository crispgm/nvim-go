if exists('g:loaded_nvim_go') | finish | endif
let g:loaded_nvim_go = 1

command! GoFmt lua require('go.gofmt').run{}

augroup nvim_go
  autocmd!
  autocmd BufWritePre *.go GoFmt
augroup END
