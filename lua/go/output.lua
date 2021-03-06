local M = {}

local vim = vim
local Popup = require('popup')

function M.show_success(prefix, msg)
    local succ = 'Success'
    if msg ~= nil then
        succ = msg
    end
    print(string.format('[%s] %s', prefix, succ))
    vim.api.nvim_echo({{prefix, 'healthSuccess'}, {' ' .. succ}}, true, {})
end

function M.show_error(prefix, msg)
    vim.api.nvim_echo({{prefix, 'healthError'}, {' ' .. msg}}, true, {})
end

function M.show_warning(prefix, msg)
    vim.api.nvim_echo({{prefix, 'healthWarning'}, {' ' .. msg}}, true, {})
end

function M.show_job_success(prefix, results)
    M.show_success(prefix)
    for _, v in ipairs(results) do
        print(v)
    end
end

function M.show_job_error(prefix, code, results)
    M.show_error(prefix, string.format('Error: %d', code))
    for _, v in ipairs(results) do
        print(v)
    end
end

local function calc_popup_size()
    local win_width = vim.fn.winwidth(0)
    local win_height = vim.fn.winheight(0)
    local width = 80
    if win_width < width then width = win_width end
    local top = win_height - 11
    return top, width
end

function M.popup_job_result(results)
    local bufnr = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, results)
    local top, width = calc_popup_size()
    Popup.create(bufnr, {
        line = top,
        col = 2,
        border = { 1, 1, 1, 1 },
        cursorline = true,
        minheight = 10,
        minwidth = width,
        highlight = 'Normal',
    })
end

return M
