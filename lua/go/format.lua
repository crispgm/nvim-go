local M = {}

local vim = vim
local config = require('go.config')
local output = require('go.output')

function M.format(opt)
    local formatter = config.options.formatter
    return pcall(M[formatter], opt)
end

function M.gofmt()
    local file_path = vim.api.nvim_buf_get_name(0)
    vim.api.nvim_exec('write', true)
    vim.fn.jobstart({'gofmt', '-w', file_path}, {
        on_exit = function(_, code)
            if code == 0 then
                vim.api.nvim_exec('edit!', true)
            else
                output.show_error('gofmt', string.format('Error: %d', code))
            end
        end,
    })
end

function M.goimports()
    local file_path = vim.api.nvim_buf_get_name(0)
    vim.api.nvim_exec('write', true)
    vim.fn.jobstart({'goimports', '-w', file_path}, {
        on_exit = function(_, code)
            if code == 0 then
                vim.api.nvim_exec('edit!', true)
            else
                output.show_error('goimports', string.format('Error: %d', code))
            end
        end,
    })
end

function M.gofumpt()
    local file_path = vim.api.nvim_buf_get_name(0)
    vim.api.nvim_exec('write', true)
    vim.fn.jobstart({'gofumpt', '-l', '-w', file_path}, {
        on_exit = function(_, code)
            if code == 0 then
                vim.api.nvim_exec('edit!', true)
            else
                output.show_error('goimports', string.format('Error: %d', code))
            end
        end,
    })
end

return M
