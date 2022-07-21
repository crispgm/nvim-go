local M = {}

local vim = vim
local config = require('go.config')
local output = require('go.output')
local util = require('go.util')

function M.add_iferr()
    if not util.binary_exists('iferr') then
        return
    end
    local prefix = 'GoIfErr'
    local boff = vim.fn.wordcount().cursor_bytes
    local cmd = (config.get_tool('iferr').name .. ' -pos ' .. boff)
    local data = vim.fn.systemlist(cmd, vim.fn.bufnr('%'))

    if vim.v.shell_error ~= 0 then
        output.show_error(
            prefix,
            'command ' .. cmd .. ' exited with code ' .. vim.v.shell_error
        )
        return
    end

    local pos = vim.fn.getcurpos()[2]
    vim.fn.append(pos, data)
    vim.cmd([[silent normal! j=2j]])
    vim.fn.setpos('.', pos)
end

return M
