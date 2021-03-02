local M = {}

M.options =  {
    linter = 'golint',
    -- formatter: goimports, gofmt
    formatter = 'goimports',
    -- test flags: -count=1 will disable cache
    test_flags = {'-v'},
    test_timeout = '30s',
    -- show test result with popup window
    test_popup = true,
}

return M
