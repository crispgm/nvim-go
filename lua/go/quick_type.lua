local M = {}

local vim = vim
local config = require('go.config')
local output = require('go.output')

function M.quick_type(_, src, pkg_name, top_level)
    local prefix = 'GoQuickType'
    local cur_line = vim.fn.line('.')
    local cmd = {
        'quicktype',
        '--src',
        src,
        '--lang',
        'go',
        '--src-lang',
        'json',
    }
    if pkg_name ~= nil and #pkg_name > 0 then
        table.insert(cmd, '--package')
        table.insert(cmd, pkg_name)
    else
        -- auto detect package name
        local first_line = vim.fn.getline(1)
        local matches = vim.fn.matchlist(
            first_line,
            '^package\\s\\+\\(\\S\\+\\)$'
        )
        if matches ~= nil and #matches >= 2 then
            pkg_name = matches[2]
            table.insert(cmd, '--package')
            table.insert(cmd, pkg_name)
        end
    end
    if top_level ~= nil and #top_level > 0 then
        table.insert(cmd, '--top-level')
        table.insert(cmd, top_level)
    end
    -- add extra args
    local opt = config.options
    if opt.quick_type_flags ~= nil and opt.quick_type_flags then
        for _, flag in ipairs(opt.quick_type_flags) do
            table.insert(cmd, flag)
        end
    end

    vim.fn.jobstart(cmd, {
        on_exit = function(_, code, _)
            if code == 0 then
                output.show_success(prefix, 'Success')
            end
        end,
        on_stdout = function(_, data, _)
            if data and #data > 0 then
                for i = 1, #data do
                    vim.fn.append(cur_line, data[#data + 1 - i])
                end
            end
        end,
        on_stderr = function(_, data, _)
            local results = table.concat(data, '\n')
            output.show_error(prefix, results)
        end,
    })
end

return M
