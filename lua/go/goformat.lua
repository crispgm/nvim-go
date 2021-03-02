local M = {}

local vim = vim
local Job = require('plenary.job')
local config = require('go.config')

function M.run(opt)
    local linter = 'goimports'
    if config ~= nil and config.linter then
        linter = config.linter
    end

    return require(string.format('go.%s', linter)).run(opt)
end

return M
