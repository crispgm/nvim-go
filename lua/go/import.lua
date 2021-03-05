local M = {}

local vim = vim
-- local output = require('go.output')
local util = require('go.util')

function M.get(pkg)
    if not util.binary_exists('go') then return end

    if not pkg then return end
    vim.api.nvim_command('!go get -u -v ' .. pkg)
end

function M.import(pkg)
    if not pkg then return end
end

return M
