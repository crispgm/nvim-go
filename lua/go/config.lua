local M = {}

M.options =  {
    -- auto commands
    auto_lint = true,
    auto_format = true,
    -- linter: golint, errcheck, golangci-lint
    linter = 'golint',
    -- lint_prompt_style: qf (quickfix), vt (virtual text)
    lint_prompt_style = 'qf',
    -- formatter: goimports, gofmt, gofumpt
    formatter = 'goimports',
    -- test flags: -count=1 will disable cache
    test_flags = {'-v'},
    test_timeout = '30s',
    test_env = {},
    -- show test result with popup window
    test_popup = true,
    struct_tag = {
        tags = 'json',
        options = {'json=omitempty'},
        transform = 'camelcase',
        skip_unexported = true,
    },
}

M.tools = {
    { name = 'gopls',         repo = 'golang.org/x/tools/gopls@latest'},
    { name = 'golint',        repo = 'golang.org/x/lint/golint'},
    { name = 'goimports',     repo = 'golang.org/x/tools/cmd/goimports'},
    { name = 'gofumpt',       repo = 'mvdan.cc/gofumpt'},
    { name = 'errcheck',      repo = 'github.com/kisielk/errcheck'},
    { name = 'staticheck',    repo = 'honnef.co/go/tools/cmd/staticcheck'},
    { name = 'golangci-lint', repo = 'github.com/golangci/golangci-lint/cmd/golangci-lint'},
    { name = 'gomodifytags',  repo = 'github.com/fatih/gomodifytags'},
}

return M
