local M = {}

local vim = vim
local popup = require('popup')
local config = require('go.config')

function M.show_info(prefix, msg)
    vim.api.nvim_echo({ { prefix }, { ' ' .. msg } }, true, {})
end

function M.show_success(prefix, msg)
    local succ = 'Success'
    if msg ~= nil then
        succ = msg
    end
    vim.api.nvim_echo({ { prefix, 'Function' }, { ' ' .. succ } }, true, {})
end

function M.show_error(prefix, msg)
    vim.api.nvim_echo({ { prefix, 'ErrorMsg' }, { ' ' .. msg } }, true, {})
end

function M.show_warning(prefix, msg)
    vim.api.nvim_echo({ { prefix, 'WarningMsg' }, { ' ' .. msg } }, true, {})
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

function M.calc_popup_size()
	local win_height = vim.fn.winheigth(0)
	local win_width = vim.fn.winwidth(0)
	local pos_opts = {
		height = tonumber(config.options.popup_height),
		width = tonumber(config.options.popup_width),
	}
    -- config first, but default none
    -- then follows colorcolumn
    if not config.options.popup_width then
        local cc = tonumber(vim.wo.colorcolumn) or 0
        if cc >= pos_opts.width then
            pos_opts.width = cc
        end
    end
    -- Check that we do not exceed win boundaries
	if win_width > -1 and pos_opts.width > (win_width - 2) then
		pos_opts.width = win_width - 4
	end
    if win_height > -1 then
		if pos_opts.height > (win_height - 2) then
			pos_opts.height = win_height - 2
		end
    end
    return pos_opts
end

function M.close_popup(win_id, buf_nr)
    if
        vim.api.nvim_buf_is_valid(buf_nr)
        and not vim.api.nvim_buf_get_option(buf_nr, 'buflisted')
    then
        vim.api.nvim_buf_delete(buf_nr, { force = true })
    end

    if not vim.api.nvim_win_is_valid(win_id) then
        return
    end

    vim.api.nvim_win_close(win_id, true)
end

function M.close_popups(popup_win, popup_buf, border_win, border_buf)
    M.close_popup(popup_win, popup_buf)
    M.close_popup(border_win, border_buf)
end

function M.popup_job_result(results, opts)
	local win_height = vim.fn.winheigth(0)
    local buf_nr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf_nr, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_lines(buf_nr, 0, -1, true, results)
    local actual_content_height = vim.api.nvim_buf_line_count(buf_nr)
    local title = opts.title
    local pos_opts = opts.pos_opts
	local top = win_height - (math.min(pos_opts.height, actual_content_height) + 1)
    local popup_win, popup_opts = popup.create(buf_nr, {
        title = title,
        line = top,
        col = 2,
        border = { 1, 1, 1, 1 },
        cursorline = true,
        maxheight = pos_opts.height,
        minwidth = 80,
		width = pos_opts.width,
        highlight = 'GoTestResult',
    })
    vim.api.nvim_win_set_option(popup_win, 'wrap', false)
    local popup_bufnr = buf_nr
    local border_bufnr = popup_opts.border and popup_opts.border.bufnr
    local border_win = popup_opts.border and popup_opts.border.win_id
    if border_win then
        vim.api.nvim_win_set_option(
            border_win,
            'winhl',
            'Normal:GoTestResultBorder'
        )
    end

    local on_buf_leave = string.format(
        [[  autocmd BufLeave <buffer> ++nested ++once :silent lua require('go.output').close_popups(%s,%s,%s,%s)]],
        popup_win,
        popup_bufnr,
        border_win,
        border_bufnr
    )

    vim.cmd([[augroup NvimGoPopup]])
    vim.cmd([[  autocmd!]])
    vim.cmd(on_buf_leave)
    vim.cmd([[augroup END]])
end

return M
