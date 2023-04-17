local M = {}

local health = vim.health or require('health')
local tools = require('go.config').tools

function M.check()
    health.report_start('Binaries')
    local any_err = true
    if vim.fn.executable('go') == 1 then
        health.report_info('Go installed.')
    else
        health.report_error('Go is not installed.')
        any_err = false
    end
    for _, val in ipairs(tools) do
        if vim.fn.executable(val.name) == 1 then
            health.report_info('Tool installed: ' .. val.name)
        else
            health.report_error('Missing tool: ' .. val.name)
        end
    end
    if any_err then
        health.report_ok('No issues found')
    end
end

return M
