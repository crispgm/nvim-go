local M = {}

local vim = vim
local config = require('go.config')
local output = require('go.output')
local util = require('go.util')

local function operate_tags(prefix, file_path, line_start, line_end)
    local cmd = {'gomodifytags', '-w', '-file', file_path}
    if line_start == line_end then
        local line = vim.fn.getline(line_start)
        local matches = vim.fn.matchlist(line, '^type\\s\\+\\(\\S\\+\\)\\s\\+struct')
        if matches ~= nil and #matches >= 2 then
            table.insert(cmd, '-struct')
            table.insert(cmd, matches[2])
        end
    else
        table.insert(cmd, '-line')
        table.insert(cmd, string.format('%d,%d', line_start, line_end))
    end

    local opt = config.options.struct_tag
    if prefix == 'GoAddTags' then
        if opt.tags then
            table.insert(cmd, '-add-tags')
            table.insert(cmd, opt.tags)
        else
            return
        end
        if opt.transform then
            table.insert(cmd, '-transform')
            table.insert(cmd, opt.transform)
        end
        if opt.options then
            for _, option in ipairs(opt.options) do
                table.insert(cmd, '-add-options')
                table.insert(cmd, option)
            end
        end
        if opt.skip_unexported then
            table.insert(cmd, '-skip-unexported')
        end
    else
        table.insert(cmd, '-clear-tags')
    end

    vim.api.nvim_exec('write', true)
    vim.fn.jobstart(cmd, {
        on_exit = function(_, code)
            if code == 0 then
                output.show_success(prefix, 'Success')
                vim.api.nvim_exec('edit!', true)
            end
        end,
        on_stderr = function(_, data)
            local results = table.concat(data, '\n')
            output.show_error(prefix, results)
        end,
    })
end

function M.add_tags(args)
    if not util.binary_exists('gomodifytags') then return end
    local line_start = args[1]
    local line_end = args[2]
    -- TODO: support other manual postfix
    local file_path = vim.fn.expand('%:p')
    operate_tags('GoAddTags', file_path, line_start, line_end)
end

function M.clear_tags(args)
    if not util.binary_exists('gomodifytags') then return end
    local line_start = args[1]
    local line_end = args[2]
    local file_path = vim.fn.expand('%:p')
    operate_tags('GoClearTags', file_path, line_start, line_end)
end

return M
