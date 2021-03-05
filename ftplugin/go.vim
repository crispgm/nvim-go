" actions with default
command! GoFormat lua require('go.format').format{}
command! GoLint   lua require('go.lint').lint{}
" specific linter/formatter
command! Gofmt         lua require('go.format').gofmt{}
command! Goimports     lua require('go.format').goimports{}
command! Gofumpt       lua require('go.format').gofumpt{}
command! Golint        lua require('go.lint').golint{}
command! Goerrcheck    lua require('go.lint').errcheck{}
command! Gostatischeck lua require('go.lint').statischeck{}
" testing
command! GoTestFunc  lua require('go.test').test_func{}
command! GoTestFile  lua require('go.test').test_file{}
command! GoToTest    lua require('go.test').test_open()
" import
command! -nargs=1 GoGet    lua require('go.import').get(<f-args>)
command! -nargs=1 GoImport lua require('go.import').import(<f-args>)

augroup nvim_go
  autocmd!
  autocmd BufWritePre  <buffer> GoFormat
  autocmd BufWritePost <buffer> GoLint
augroup END
