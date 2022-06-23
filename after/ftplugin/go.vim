" format
function! GoFormatters(A, L, P)
  let formatters = ['gofmt', 'goimports', 'gofumpt']
  let matches = []

  for formatter in formatters
    if formatter =~? '^' . strpart(a:A, 1)
      call add(matches, formatter)
    endif
  endfor

  return matches
endfunction
command! -nargs=? -complete=customlist,GoFormatters GoFormat lua require('go.format').format(<f-args>)

" lint
function! GoLinters(A, L, P)
  let linters = ['revive', 'golangci_lint', 'errcheck', 'staticcheck', 'golint']
  let matches = []

  for linter in linters
    if linter =~? '^' . strpart(a:A, 1)
      call add(matches, linter)
    endif
  endfor

  return matches
endfunction
command! -nargs=? -complete=customlist,GoLinters GoLint lua require('go.lint').lint(<f-args>)

" testing
command! GoTest lua require('go.test').test()
command! GoTestAll lua require('go.test').test_all()
command! GoTestFunc lua require('go.test').test_func()
command! GoTestFile lua require('go.test').test_file()
command! -nargs=? -complete=command GoToTest lua require('go.test').test_open(<f-args>)
command! GoAddTest lua require('go.gotests').add_test()

" import
command! -nargs=1 GoGet lua require('go.import').get(<f-args>)
command! -nargs=1 GoImport lua require('go.import').import(<f-args>)

" struct tag
command! -nargs=* -range GoAddTags lua require('go.struct_tag').add_tags({<line1>, <line2>, <count>, <f-args>})
command! -nargs=* -range GoRemoveTags lua require('go.struct_tag').remove_tags({<line1>, <line2>, <count>, <f-args>})
command! -nargs=* -range GoClearTags lua require('go.struct_tag').clear_tags({<line1>, <line2>, <count>, <f-args>})

" struct tag options
command! -nargs=* -range GoAddTagOptions lua require('go.struct_tag').add_options({<line1>, <line2>, <count>, <f-args>})
command! -nargs=* -range GoRemoveTagOptions lua require('go.struct_tag').remove_options({<line1>, <line2>, <count>, <f-args>})
command! -nargs=* -range GoClearTagOptions lua require('go.struct_tag').clear_options({<line1>, <line2>, <count>, <f-args>})

" quicktype
command! -nargs=* -complete=file GoQuickType lua require('go.quick_type').quick_type(<count>, <f-args>)

lua << EOB
local opt = require('go.config').options
local cmd = vim.api.nvim_command

cmd([[augroup nvim_go]])
cmd([[  autocmd! * <buffer>]])
if opt.auto_format then
  cmd([[autocmd BufWritePre <buffer> GoFormat]])
end
if opt.auto_lint then
  cmd([[autocmd BufWritePost <buffer> GoLint]])
end
cmd([[augroup END]])
EOB
