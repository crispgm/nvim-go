local M = {}

local vim = vim
local config = require('go.config')
local output = require('go.output')

function M.lint()
    -- local linters = config.options.linters
    local linters = {'golint'}
    for _, linter in ipairs(linters) do
        pcall(M[linter], {})
    end
end

function M.golint()
    local linter = 'golint'
    local file_path = vim.api.nvim_buf_get_name(0)
    local bufnr = vim.api.nvim_get_current_buf()
    vim.fn.jobstart({linter, '-set_exit_status', file_path}, {
        on_exit = function(_, code)
            if code ~= 0 then
                output.show_warning('GoLint', string.format('error code: %d', code))
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
                output.show_error('GoLint', table.concat(err_list, '\n'))
            end
            if config.options.lint_prompt_style == 'qf' and #qf_list > 0 then
                local height = 4
                if #data < height then height = #data end
                vim.api.nvim_command(string.format('copen %d', height))
                local qf = {title = 'GoLint', items = qf_list}
                vim.fn.setqflist({}, ' ', qf)
            end
        end,
    })
end

return M
