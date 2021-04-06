" actions with default
command! GoFormat lua require('go.format').format{}
command! GoLint   lua require('go.lint').lint()
" specific linter/formatter
command! Gofmt         lua require('go.format').gofmt{}
command! Goimports     lua require('go.format').goimports()
command! Gofumpt       lua require('go.format').gofumpt()
command! Golangcilint  lua require('go.lint').golangci_lint()
command! Golint        lua require('go.lint').golint()
command! Goerrcheck    lua require('go.lint').errcheck()
command! Gostaticcheck lua require('go.lint').staticcheck()
" testing
command! GoTest      lua require('go.test').test()
command! GoTestAll   lua require('go.test').test_all()
command! GoTestFunc  lua require('go.test').test_func{}
command! GoTestFile  lua require('go.test').test_file()
command! GoToTest    lua require('go.test').test_open()
" import
command! -nargs=1 GoGet    lua require('go.import').get(<f-args>)
command! -nargs=1 GoImport lua require('go.import').import(<f-args>)
" struct tag
command! -nargs=* -range GoAddTags    lua require('go.struct_tag').add_tags{<line1>, <line2>, <count>, <f-args>}
command! -nargs=* -range GoRemoveTags lua require('go.struct_tag').remove_tags{<line1>, <line2>, <count>, <f-args>}
command! -nargs=* -range GoClearTags  lua require('go.struct_tag').clear_tags{<line1>, <line2>, <count>, <f-args>}

lua << EOB
local config = require('go.config')
local api = vim.api

api.nvim_command([[augroup nvim_go]])
api.nvim_command([[  autocmd!]])
if config.options.auto_format then
  api.nvim_command([[autocmd BufWritePre  <buffer> GoFormat]])
end
if config.options.auto_lint then
  api.nvim_command([[autocmd BufWritePost <buffer> GoLint]])
end
api.nvim_command([[augroup END]])
EOB
