local M = {}

local vim = vim
local config = require('go.config')
local system = require('go.system')
local output = require('go.output')
local util = require('go.util')

function M.format(opt)
    local formatter = config.options.formatter
    return pcall(M[formatter], opt)
end

local function do_fmt(formatter, args)
    if not util.binary_exists(formatter) then return end
    local buf_nr = vim.api.nvim_get_current_buf()
    local file_path = vim.api.nvim_buf_get_name(buf_nr)
    vim.api.nvim_exec('write', true)
    local cmd = system.wrap_file_command(formatter, args, file_path)
    vim.fn.jobstart(cmd, {
        on_exit = function(_, code)
            if code == 0 then
                vim.api.nvim_exec('edit!', true)
            else
                output.show_error(formatter, string.format('Error: %d', code))
            end
        end,
    })
end

function M.gofmt()
    do_fmt('gofmt', {'-w'})
end

function M.goimports()
    do_fmt('goimports', {'-w'})
end

function M.gofumpt()
    do_fmt('gofumpt', {'-l', '-w'})
end

return M
