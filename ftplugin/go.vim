command! GoInstallBinaries lua require('go.install').install_binaries()

command! GoFormat lua require('go.format').format{}
command! Gofmt lua require('go.format').gofmt{}
command! Goimports lua require('go.format').goimports{}
command! Gofumpt lua require('go.format').gofumpt{}

command! GoLint lua require('go.lint').lint{}

augroup nvim_go
  autocmd!
  autocmd BufWritePre *.go GoLint
  autocmd BufWritePre *.go GoFormat
augroup END

command! GoTestFunc lua require('go.test').test_func{}
command! GoTestFile lua require('go.test').test_file{}
command! GoToTest lua require('go.test').test_open()
