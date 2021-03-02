local M = {}

local vim = vim
local Job = require('plenary.job')
local config = require('go.config')

function M.run(opt)
    local formatter = config.options.formatter
    local command = string.format('go.%s', formatter)
    return require(command).run(opt)
end

return M
