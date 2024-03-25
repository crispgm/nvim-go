local M = {}

local vim = vim
local util = require('go.util')

local function do_mod(args)
    if not util.binary_exists('go') then
        return
    end
    vim.api.nvim_command('!go mod ' .. args)
end

function M.mod(fargs)
    do_mod(table.concat(fargs, ' '))
end

return M
