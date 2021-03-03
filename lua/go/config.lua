local M = {}

M.options =  {
    -- linters: golint, govet, errcheck, golangci-lint
    linters = {'golint', 'govet', 'errcheck'},
    -- lint_prompt_style: qf (quickfix), vt (virtual text)
    lint_prompt_style = 'qf',
    -- formatter: goimports, gofmt, gofumpt
    formatter = 'goimports',
    -- test flags: -count=1 will disable cache
    test_flags = {'-v'},
    test_timeout = '30s',
    -- show test result with popup window
    test_popup = true,
}

M.tools = {
    { name = 'gopls',         repo = 'golang.org/x/tools/gopls@latest'},
    { name = 'golint' ,       repo = 'golang.org/x/lint/golint'},
    { name = 'goimports' ,    repo = 'golang.org/x/tools/cmd/goimports'},
    { name = 'gofumpt' ,      repo = 'mvdan.cc/gofumpt'},
    { name = 'errcheck' ,     repo = 'github.com/kisielk/errcheck'},
    { name = 'golangcilint' , repo = 'github.com/golangci/golangci-lint/cmd/golangci-lint'},
}

return M
