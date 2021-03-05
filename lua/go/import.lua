local M = {}

local vim = vim
local output = require('go.output')

function M.get(pkg)
    if not pkg then return end
    vim.api.nvim_command('!go get -u -v ' .. pkg)
end

function M.import(pkg)
    if not pkg then return end
end

return M
