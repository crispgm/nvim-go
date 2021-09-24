local M = {}

local vim = vim
local config = require('go.config')
local system = require('go.system')
local output = require('go.output')
local util = require('go.util')

function M.format(fmt)
    local formatter = config.options.formatter
    if fmt ~= nil then
        formatter = fmt
    end
    return pcall(M[formatter])
end

local function do_fmt(formatter, args)
    if not util.binary_exists(formatter) then
        return
    end
    local buf_nr = vim.api.nvim_get_current_buf()
    local file_path = vim.api.nvim_buf_get_name(buf_nr)
    local view = vim.fn.winsaveview()
    vim.api.nvim_exec('noautocmd write', true)
    local cmd = system.wrap_file_command(formatter, args, file_path)
    vim.fn.jobstart(cmd, {
        on_exit = function(_, code, _)
            if code == 0 then
                output.show_success('GoFormat', 'Success')
                vim.api.nvim_exec('edit', true)
                vim.fn.winrestview(view)
            end
        end,
        on_stderr = function(_, data, _)
            if #data == 0 or #data[1] == 0 then
                return
            end
            local results = 'File is not formatted due to error.\n'
                .. table.concat(data, '\n')
            output.show_error('GoFormat', results)
        end,
    })
end

function M.gofmt()
    do_fmt('gofmt', { '-w' })
end

function M.goimports()
    do_fmt('goimports', { '-w' })
end

function M.gofumpt()
    do_fmt('gofumpt', { '-l', '-w' })
end

return M
