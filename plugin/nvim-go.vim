if exists('g:loaded_nvim_go') | finish | endif
let g:loaded_nvim_go = 1

command! GoFormat lua require('go.format').format{}
command! GoFmt lua require('go.format').gofmt{}
command! GoImports lua require('go.format').goimports{}

augroup nvim_go
  autocmd!
  autocmd BufWritePre *.go GoFormat
augroup END

command! GoTestFile lua require('go.test').test_file{}
