local M = {}

local vim = vim
local Job = require('plenary.job')
local config = require('go.config')
local output = require('go.output')

function M.format(opt)
    local formatter = config.options.formatter
    return pcall(M[formatter], opt)
end

function M.gofmt()
    local file_path = vim.api.nvim_buf_get_name(0)
    local cwd = vim.fn.expand('%:p:h')
    vim.api.nvim_exec('write', true)
    local results, code = Job:new({
        command = 'gofmt',
        args = { '-w', file_path },
        cwd = cwd,
    }):sync()
    if code == 0 then
        util.show_success('GoFmt')
    else
        util.show_job_error('GoFmt', code, results)
    end
    vim.api.nvim_exec('edit!', true)
end

function M.goimports()
    local file_path = vim.api.nvim_buf_get_name(0)
    local cwd = vim.fn.expand('%:p:h')
    vim.api.nvim_exec('write', true)
    local results, code = Job:new({
        command = 'goimports',
        args = { '-w', file_path },
        cwd = cwd,
    }):sync()
    if code == 0 then
        util.show_success('GoImports')
    else
        util.show_job_error('GoImports', code, results)
    end
    vim.api.nvim_exec('edit!', true)
end

return M
