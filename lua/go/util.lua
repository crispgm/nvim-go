local M = {}

local vim = vim

function M.current_word()
    return vim.fn.expand('<cword>')
end

function M.current_line()
    return vim.fn.getline('.')
end

return M
