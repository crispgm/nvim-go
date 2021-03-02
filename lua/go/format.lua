local M = {}

local vim = vim
local Job = require('plenary.job')
local config = require('go.config')
local util = require('go.util')

function M.format(opt)
    local formatter = config.options.formatter
    return pcall(M[formatter], opt)
end

function M.gofmt(opt)
    local file_path = vim.api.nvim_buf_get_name(0)
    local cwd = vim.fn.expand('%:p:h')
    vim.api.nvim_exec('write', true)
    Job:new({
        command = 'gofmt',
        args = { '-w', file_path },
        cwd = cwd,
        on_exit = function(j, return_val)
            if return_val == 0 then
                util.show_success('GoFmt')
            else
                util.show_error('GoFmt', j, return_val)
            end
        end,
    }):sync()
    vim.api.nvim_exec('edit!', true)
end

function M.goimports(opt)
    local file_path = vim.api.nvim_buf_get_name(0)
    local cwd = vim.fn.expand('%:p:h')
    vim.api.nvim_exec('write', true)
    Job:new({
        command = 'goimports',
        args = { '-w', file_path },
        cwd = cwd,
        on_exit = function(j, return_val)
            if return_val == 0 then
                util.show_success('GoImports')
            else
                util.show_error('GoImports', j, return_val)
            end
        end,
    }):sync()
    vim.api.nvim_exec('edit!', true)
end

return M
