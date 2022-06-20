local M = {}

local vim = vim
local config = require('go.config')
local system = require('go.system')
local output = require('go.output')
local util = require('go.util')

-- virtual text ns_id
local ns_id = 0

function M.lint(lnt)
    if not config.is_set(config.options.linter) then
        return
    end
    local linter = config.options.linter:gsub('-', '_')
    if lnt ~= nil then
        linter = lnt
    end
    pcall(M[linter], {})
end

local function show_quickfix(qf_list)
    if not qf_list then
        return
    end

    vim.api.nvim_exec_autocmds('User', { pattern = 'NvimGoLintPopupPre' })
    local win_nr = vim.fn.winnr()
    local height = 4
    if #qf_list > 0 and #qf_list < height then
        height = #qf_list
    end
    vim.fn.setloclist(win_nr, qf_list, 'r')
    vim.api.nvim_command(string.format('lopen %d', height))
    vim.api.nvim_exec_autocmds('User', { pattern = 'NvimGoLintPopupPost' })
end

local function clear_quickfix()
    local win_nr = vim.fn.winnr()
    vim.fn.setloclist(win_nr, {})
    vim.api.nvim_command('lclose')
end

local function clear_virtual_text()
    if ns_id > 0 then
        vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
        ns_id = 0
    end
end

local function combine_args(linter, args)
    local result = args

    if config.options.linter_flags == nil then
        return result
    end
    if config.options.linter_flags[linter] == nil then
        return result
    end
    local linter_flags = config.options.linter_flags[linter]
    if #linter_flags > 0 and next(linter_flags, #linter_flags) == nil then
        -- check if it is an array
        for _, flag in ipairs(linter_flags) do
            table.insert(result, flag)
        end
    end

    return result
end

local function do_lint(linter, args)
    if not util.binary_exists(linter) then
        return
    end
    local buf_nr = vim.api.nvim_get_current_buf()
    local file_path = vim.api.nvim_buf_get_name(buf_nr)
    -- `golangci-lint` requires package folder in some cases
    if linter == 'golangci-lint' then
        file_path = vim.fn.expand('%:p:h')
    end
    local cmd = system.wrap_file_command(
        linter,
        combine_args(linter, args),
        file_path
    )
    -- clear former prompt
    clear_virtual_text()
    local qf_list = {}
    local issues_count = 0
    local function on_event(_, data, _)
        local err_list = {}
        for _, v in ipairs(data) do
            local o = vim.fn.split(v, ':')
            if type(o) == 'table' and #o >= 4 then
                local fn, ln, col, msg = o[1], o[2], o[3], ''
                for i = 4, #o do
                    msg = msg .. o[i]
                end
                if config.options.lint_prompt_style == 'vt' then
                    ns_id = vim.api.nvim_create_namespace('NvimGoLint')
                    vim.api.nvim_buf_set_virtual_text(buf_nr, ns_id, ln - 1, {
                        { msg, 'WarningMsg' },
                    }, {})
                else
                    table.insert(qf_list, {
                        buf_nr = buf_nr,
                        filename = fn,
                        type = 'W',
                        lnum = ln,
                        col = col,
                        text = msg,
                    })
                end
                issues_count = issues_count + 1
            else
                if string.len(v) > 0 then
                    table.insert(qf_list, {
                        buf_nr = buf_nr,
                        filename = file_path,
                        type = 'W',
                        text = v,
                    })
                    issues_count = issues_count + 1
                end
            end
        end
        vim.g['nvim_go#lint_issues_count'] = issues_count
        if #err_list > 0 then
            output.show_error(linter, table.concat(err_list, '\n'))
        end
        if config.options.lint_prompt_style == 'qf' then
            if #qf_list > 0 then
                show_quickfix(qf_list)
            else
                clear_quickfix()
            end
        end
    end

    -- job
    vim.fn.jobstart(cmd, {
        on_stdout = on_event,
        on_stderr = on_event,
        stdout_buffered = true,
        stderr_buffered = true,
    })
end

function M.golangci_lint()
    do_lint('golangci-lint', {
        '--out-format=line-number',
        '--print-issued-lines=false',
        'run',
    })
end

function M.revive()
    do_lint('revive', {})
end

function M.golint()
    do_lint('golint', { '-set_exit_status' })
end

function M.errcheck()
    do_lint('errcheck', {})
end

function M.staticcheck()
    do_lint('staticcheck', { '-checks=all' })
end

return M
