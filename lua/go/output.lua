local M = {}

local vim = vim
local Popup = require('popup')

function M.show_success(prefix, msg)
    local suc = 'Success'
    if msg ~= nil then
        suc = msg
    end
    print(string.format('[%s] %s', prefix, suc))
end

function M.show_error(prefix, msg)
    print(string.format('[%s] %s', prefix, msg))
end

function M.show_job_success(prefix, results)
    print(string.format('[%s] Success', prefix))
    for _, v in ipairs(results) do
        print(v)
    end
end

function M.show_job_error(prefix, code, results)
    print(string.format('[%s] Error: %d', prefix, code))
    for _, v in ipairs(results) do
        print(v)
    end
end

local function calc_popup_size()
    local winnr = vim.fn.winbufnr('')
    local win_width = vim.fn.winwidth(winnr)
    local win_height = vim.fn.winheight(winnr)
    local width = 80
    if win_width < width then width = win_width end
    local top_offset = win_height - 11
    return top_offset, width
end

function M.popup_job_result(results)
    local bufnr = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, results)
    local top_offset, width = calc_popup_size()
    Popup.create(bufnr, {
        line = top_offset,
        col = 2,
        border = { 1, 1, 1, 1 },
        cursorline = true,
        minheight = 10,
        minwidth = width,
        highlight = 'Normal',
    })
end

return M
