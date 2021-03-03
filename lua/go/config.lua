local M = {}

M.options =  {
    -- linters: golint, govet, errcheck, golangci-lint
    linters = {'golint', 'govet', 'errcheck'},
    -- lint_prompt_style: qf (quickfix), vt (virtual text)
    lint_prompt_style = 'qf',
    -- formatter: goimports, gofmt
    formatter = 'goimports',
    -- test flags: -count=1 will disable cache
    test_flags = {'-v'},
    test_timeout = '30s',
    -- show test result with popup window
    test_popup = true,
}

return M
