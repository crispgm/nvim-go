local M = {}

local vim = vim
local uv = vim.loop
local output = require('go.output')

function M.current_word()
    return vim.fn.expand('<cword>')
end

function M.current_line()
    return vim.fn.getline('.')
end

function M.binary_exists(bin)
    if vim.fn.executable(bin) == 1 then
        return true
    end
    output.show_error(
        'No Binary',
        string.format('%s not exists. Run `:GoInstallBinaries`', bin)
    )
    return false
end

function M.empty_output(data)
    if #data == 0 then
        return true
    end
    if #data == 1 and data[1] == '' then
        return true
    end

    return false
end

function M.valid_buf()
    local buf_nr = vim.api.nvim_get_current_buf()
    if
        vim.api.nvim_buf_is_valid(buf_nr)
        and vim.api.nvim_buf_get_option(buf_nr, 'buflisted')
    then
        return true
    end

    return false
end

function M.exists(filename)
    local stat = uv.fs_stat(filename)
    return stat and stat.type or false
end

function M.is_dir(filename)
    return M.exists(filename) == 'directory'
end

function M.is_file(filename)
    return M.exists(filename) == 'file'
end

return M
