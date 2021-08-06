" actions with default
command! GoFormat lua require('go.format').format{}
command! GoLint   lua require('go.lint').lint()
" specific linter/formatter
command! Gofmt         lua require('go.format').gofmt{}
command! Goimports     lua require('go.format').goimports()
command! Gofumpt       lua require('go.format').gofumpt()
command! Golangcilint  lua require('go.lint').golangci_lint()
command! Gorevive      lua require('go.lint').revive()
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
" struct tag options
command! -nargs=* -range GoAddTagOptions    lua require('go.struct_tag').add_options{<line1>, <line2>, <count>, <f-args>}
command! -nargs=* -range GoRemoveTagOptions lua require('go.struct_tag').remove_options{<line1>, <line2>, <count>, <f-args>}
command! -nargs=* -range GoClearTagOptions  lua require('go.struct_tag').clear_options{<line1>, <line2>, <count>, <f-args>}
" quicktype
command! -nargs=* -complete=file GoQuickType lua require('go.quick_type').quick_type(<count>, <f-args>)

lua << EOB
local opt = require('go.config').options
local cmd = vim.api.nvim_command

cmd([[augroup nvim_go]])
cmd([[  autocmd!]])
if opt.auto_format then
  cmd([[autocmd BufWritePre  <buffer> GoFormat]])
end
if opt.auto_lint then
  cmd([[autocmd BufWritePost <buffer> GoLint]])
end
cmd([[augroup END]])
EOB
