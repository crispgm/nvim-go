local M = {}

local vim = vim
local config = require('go.config')
local output = require('go.output')
local util = require('go.util')

local function function_surrounding_cursor()
    local ts_utils = require('nvim-treesitter.ts_utils')
    local current_node = ts_utils.get_node_at_cursor()

    if not current_node then
        return ''
    end

    local func = current_node

    while func do
        if
            func:type() == 'method_declaration'
            or func:type() == 'function_declaration'
        then
            break
        end

        func = func:parent()
    end

    if not func then
        return ''
    end

    local find_name
    find_name = function(node)
        for i = 0, node:named_child_count() - 1, 1 do
            local child = node:named_child(i)
            local type = child:type()

            if
                func:type() == 'method_declaration'
                and type == 'field_identifier'
            then
                return (ts_utils.get_node_text(child))[1]
            elseif
                func:type() == 'function_declaration'
                and type == 'identifier'
            then
                return (ts_utils.get_node_text(child))[1]
            else
                local name = find_name(child)

                if name then
                    return name
                end
            end
        end

        return nil
    end

    return find_name(func)
end

function M.add_test()
    if not util.binary_exists('gotests') then
        return
    end

    local prefix = 'GoAddTest'
    local cmd = { 'gotests' }

    -- add extra args for templates
    local opt = config.options
    if string.len(opt.gotests_template) > 0 then
        table.insert(cmd, '-template')
        table.insert(cmd, opt.gotests_template)
        if string.len(opt.gotests_template_dir) > 0 then
            table.insert(cmd, '-template_dir')
            table.insert(cmd, opt.gotests_template_dir)
        end
    end

    local func_name = function_surrounding_cursor()
    if func_name == nil or func_name == '' then
        output.show_error('no function found')
        return
    end

    table.insert(cmd, '-only')
    table.insert(cmd, func_name)

    local gofile = vim.fn.expand('%')
    table.insert(cmd, '-w')
    table.insert(cmd, gofile)

    vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        stderr_buffered = true,
        on_exit = function(_, code, _)
            if code ~= 0 then
                output.show_warning(
                    prefix,
                    string.format('error code: %d', code)
                )
            end
        end,
        on_stdout = function(_, data, _)
            local outputs = {}
            for _, v in ipairs(data) do
                if string.len(v) > 0 then
                    table.insert(outputs, v)
                end
            end
            if #outputs > 0 then
                local msg = table.concat(outputs, '\n')
                output.show_info(prefix, msg)
            end
        end,
        on_stderr = function(_, data, _)
            local results = table.concat(data, '\n')
            output.show_error(prefix, results)
        end,
    })
end

return M
