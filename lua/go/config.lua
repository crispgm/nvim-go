local M = {}

M.options = {
    -- auto commands
    auto_lint = true,
    auto_format = true,
    -- linter: revive, staticcheck, errcheck, golangci-lint
    linter = 'revive',
    -- lint_prompt_style: qf (quickfix), vt (virtual text)
    lint_prompt_style = 'qf',
    -- formatter: goimports, gofmt, gofumpt
    formatter = 'goimports',
    -- test flags: -count=1 will disable cache
    test_flags = { '-v' },
    test_timeout = '30s',
    test_env = {},
    -- show test result with popup window
    test_popup = true,
    test_popup_width = 80,
    test_popup_height = 10,
    -- test open
    test_open_cmd = 'edit',
    -- struct tags
    tags_name = 'json',
    tags_options = { 'json=omitempty' },
    tags_transform = 'snakecase',
    tags_flags = { '-skip-unexported' },
    -- quick type
    quick_type_flags = { '--just-types' },
}

M.tools = {
    { name = 'gopls', src = 'golang.org/x/tools/gopls@latest' },
    { name = 'golint', src = 'golang.org/x/lint/golint' },
    { name = 'revive', src = 'github.com/mgechev/revive' },
    { name = 'goimports', src = 'golang.org/x/tools/cmd/goimports' },
    { name = 'gofumpt', src = 'mvdan.cc/gofumpt' },
    { name = 'errcheck', src = 'github.com/kisielk/errcheck' },
    { name = 'staticheck', src = 'honnef.co/go/tools/cmd/staticcheck' },
    {
        name = 'golangci-lint',
        src = 'github.com/golangci/golangci-lint/cmd/golangci-lint',
    },
    { name = 'gomodifytags', src = 'github.com/fatih/gomodifytags' },
    { name = 'quicktype', src = 'quicktype', pkg_mgr = 'yarn' },
}

function M.get_tool(name)
    for _, value in ipairs(M.tools) do
        if value.name == name then
            return value
        end
    end

    return nil
end

function M.update_tool(name, callback)
    for _, value in ipairs(M.tools) do
        if value.name == name then
            if type(callback) == 'function' then
                callback(value)
                return true
            end
        end
    end

    return false
end

return M
