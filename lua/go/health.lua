local M = {}

local health = vim.health or require('health')
local tools = require('go.config').tools

-- The "report_" prefix is deprecated and will be removed in 0.11. If the
-- replacements are available, we want to use those instead.
local report_start = health.start or health.report_start
local report_ok = health.ok or health.report_ok
local report_error = health.error or health.report_error
local report_info = health.info or health.report_info

function M.check()
    report_start('Binaries')
    local any_err = true
    if vim.fn.executable('go') == 1 then
        report_info('Go installed.')
    else
        report_error('Go is not installed.')
        any_err = false
    end
    for _, val in ipairs(tools) do
        if vim.fn.executable(val.name) == 1 then
            report_info('Tool installed: ' .. val.name)
        else
            report_error('Missing tool: ' .. val.name)
        end
    end
    if any_err then
        report_ok('No issues found')
    end
end

return M
