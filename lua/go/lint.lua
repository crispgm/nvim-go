local M = {}

local vim = vim
local Job = require('plenary.job')
local config = require('go.config')
local output = require('go.output')

function M.lint()
    local formatter = 'golint'
    local file_path = vim.api.nvim_buf_get_name(0)
    local cwd = vim.fn.expand('%:p:h')
    vim.api.nvim_exec('write', true)
    local results, code = Job:new({
        command = formatter,
        args = { '-set_exit_status', file_path },
        cwd = cwd,
    }):sync()
    if code == 0 then
        output.show_success('GoLint')
    else
        local bufnr = vim.api.nvim_get_current_buf()
        local qf_list = {}
        for _, v in ipairs(results) do
            local o = vim.fn.split(v, ':')
            local ln, col, msg = o[2], o[3], vim.trim(o[4])
            if config.options.lint_prompt_style == 'vt' then
                vim.api.nvim_buf_set_virtual_text(bufnr, 0, ln-1, {{msg, 'WarningMsg'}}, {})
            else
                table.insert(qf_list, {bufnr = bufnr, filename = file_path, type = 'W', lnum = ln, col = col, text = msg})
            end
        end
        if config.options.lint_prompt_style == 'qf' then
            local height = 4
            if #results < height then height = #results end
            vim.api.nvim_command(string.format('copen %d', height))
            local qf = {title = 'GoLint', items = qf_list}
            vim.fn.setqflist({}, ' ', qf)
        end
    end
end

return M
