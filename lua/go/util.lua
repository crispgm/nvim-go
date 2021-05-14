local M = {}

local vim = vim
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

return M
