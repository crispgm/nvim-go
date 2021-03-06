local M = {}

local vim = vim
local config = require('go.config')
local system = require('go.system')
local output = require('go.output')
local util = require('go.util')

function M.lint()
    local linter = config.options.linter:gsub('-', '_')
    pcall(M[linter], {})
end

local function do_lint(linter, args)
    if not util.binary_exists(linter) then return end
    local file_path = vim.api.nvim_buf_get_name(0)
    local bufnr = vim.api.nvim_get_current_buf()
    local cmd = system.wrap_file_command(linter, args, file_path)
    vim.fn.jobstart(cmd, {
        on_exit = function(_, code)
            if code ~= 0 then
                output.show_warning(linter, string.format('error code: %d', code))
            end
        end,
        on_stdout = function(_, data)
            local qf_list = {}
            local err_list = {}
            for _, v in ipairs(data) do
                local o = vim.fn.split(v, ':')
                if type(o) == 'table' and #o > 0 then
                    local ln, col, msg = o[2], o[3], vim.trim(o[4])
                    if config.options.lint_prompt_style == 'vt' then
                        vim.api.nvim_buf_set_virtual_text(bufnr, 0, ln-1, {{msg, 'WarningMsg'}}, {})
                    else
                        table.insert(qf_list, {
                            bufnr = bufnr,
                            filename = file_path,
                            type = 'W',
                            lnum = ln,
                            col = col,
                            text = msg})
                    end
                else
                    if string.len(v) > 0 then
                        table.insert(err_list, v)
                    end
                end
            end
            if #err_list > 0 then
                output.show_error(linter, table.concat(err_list, '\n'))
            end
            if config.options.lint_prompt_style == 'qf' and #qf_list > 0 then
                local height = 4
                if #data < height then height = #data end
                vim.api.nvim_command(string.format('copen %d', height))
                local qf = {title = linter, items = qf_list}
                vim.fn.setqflist({}, ' ', qf)
            end
        end,
    })
end

function M.golangci_lint()
    do_lint('golangci-lint', {'--out-format=line-number', '--print-issued-lines=false', 'run'})
end

function M.golint()
    do_lint('golint', {'-set_exit_status'})
end

function M.errcheck()
    do_lint('errcheck', {})
end

function M.staticcheck()
    do_lint('staticcheck', {'-checks=all'})
end

return M
