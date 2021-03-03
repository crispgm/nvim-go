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
        output.show_success('gofmt')
    else
        output.show_job_error('gofmt', code, results)
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
        output.show_success('goimports')
    else
        output.show_job_error('goimports', code, results)
    end
    vim.api.nvim_exec('edit!', true)
end

function M.gofumpt()
    local file_path = vim.api.nvim_buf_get_name(0)
    local cwd = vim.fn.expand('%:p:h')
    vim.api.nvim_exec('write', true)
    local results, code = Job:new({
        command = 'gofumpt',
        args = { '-l', '-w', file_path },
        cwd = cwd,
    }):sync()
    if code == 0 then
        output.show_success('gofumpt')
    else
        output.show_job_error('gofumpt', code, results)
    end
    vim.api.nvim_exec('edit!', true)
end

return M
