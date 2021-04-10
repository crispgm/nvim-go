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
    -- struct tags
    struct_tag = {
        tags = 'json',
        options = {'json=omitempty'},
        transform = 'snakecase',
        skip_unexported = true,
    },
    -- quick type
    quick_type_flags = {'--just-types-and-package'},
}

M.tools = {
    { name = 'gopls',         src = 'golang.org/x/tools/gopls@latest'},
    { name = 'golint',        src = 'golang.org/x/lint/golint'},
    { name = 'goimports',     src = 'golang.org/x/tools/cmd/goimports'},
    { name = 'gofumpt',       src = 'mvdan.cc/gofumpt'},
    { name = 'errcheck',      src = 'github.com/kisielk/errcheck'},
    { name = 'staticheck',    src = 'honnef.co/go/tools/cmd/staticcheck'},
    { name = 'golangci-lint', src = 'github.com/golangci/golangci-lint/cmd/golangci-lint'},
    { name = 'gomodifytags',  src = 'github.com/fatih/gomodifytags'},
    { name = 'quicktype',     src = 'quicktype', pkg_mgr = 'yarn'},
}

return M
