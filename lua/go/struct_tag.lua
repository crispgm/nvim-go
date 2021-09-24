local M = {}

local vim = vim
local config = require('go.config')
local output = require('go.output')
local util = require('go.util')

local function get_extra_args(args, start, cmd)
    if #args < start then
        return
    end
    for i = start, #args do
        table.insert(cmd, args[i])
    end
end

local function modify_tags(prefix, args)
    local line_start = args[1]
    local line_end = args[2]
    local file_path = vim.fn.expand('%:p')
    local cmd = { 'gomodifytags', '-w', '-file', file_path }
    if line_start == line_end then
        -- this means it might be a `type SomeObject struct` line, so use -struct with struct name
        local line = vim.fn.getline(line_start)
        local matches = vim.fn.matchlist(
            line,
            '^type\\s\\+\\(\\S\\+\\)\\s\\+struct'
        )
        if matches ~= nil and #matches >= 2 then
            table.insert(cmd, '-struct')
            table.insert(cmd, matches[2])
        else -- treat it as just a line number
            table.insert(cmd, '-line')
            table.insert(cmd, string.format('%d,%d', line_start, line_end))
        end
    else
        -- just modify by line numbers
        table.insert(cmd, '-line')
        table.insert(cmd, string.format('%d,%d', line_start, line_end))
    end

    local opt = config.options
    if prefix == 'GoAddTags' then
        table.insert(cmd, '-add-tags')
        if #args >= 4 then
            table.insert(cmd, args[4])
        elseif opt.tags_name then
            table.insert(cmd, opt.tags_name)
        else
            output.show_error(prefix, 'tag name should be presented')
            return
        end
        if opt.tags_transform then
            table.insert(cmd, '-transform')
            table.insert(cmd, opt.tags_transform)
        end
        if opt.tags_options then
            for _, option in ipairs(opt.tags_options) do
                table.insert(cmd, '-add-options')
                table.insert(cmd, option)
            end
        end
        if opt.tags_flags ~= nil and #opt.tags_flags > 0 then
            for _, flag in ipairs(opt.tags_flags) do
                table.insert(cmd, flag)
            end
        end
        get_extra_args(args, 5, cmd)
    elseif prefix == 'GoRemoveTags' then
        local tags = args[4]
        table.insert(cmd, '-remove-tags')
        table.insert(cmd, tags)
        get_extra_args(args, 5, cmd)
    elseif prefix == 'GoClearTags' then
        table.insert(cmd, '-clear-tags')
    elseif prefix == 'GoAddTagOptions' then
        table.insert(cmd, '-add-options')
        table.insert(cmd, args[4])
        get_extra_args(args, 5, cmd)
    elseif prefix == 'GoRemoveTagOptions' then
        table.insert(cmd, '-remove-options')
        table.insert(cmd, args[4])
        get_extra_args(args, 5, cmd)
    elseif prefix == 'GoClearTagOptions' then
        table.insert(cmd, '-clear-options')
    else
        return
    end

    local view = vim.fn.winsaveview()
    vim.api.nvim_exec('noautocmd write', true)
    vim.fn.jobstart(cmd, {
        on_exit = function(_, code, _)
            if code == 0 then
                output.show_success(prefix, 'Success')
                vim.api.nvim_exec('edit', true)
                vim.fn.winrestview(view)
            end
        end,
        on_stderr = function(_, data, _)
            local results = table.concat(data, '\n')
            output.show_error(prefix, results)
        end,
    })
end

function M.add_tags(args)
    if not util.binary_exists('gomodifytags') then
        return
    end
    local prefix = 'GoAddTags'
    if #args < 2 then
        output.show_error(prefix, 'line number should be presented')
        return
    end
    modify_tags(prefix, args)
end

function M.remove_tags(args)
    if not util.binary_exists('gomodifytags') then
        return
    end
    local prefix = 'GoRemoveTags'
    if #args < 4 then
        output.show_error(prefix, 'tag name should be presented')
        return
    end
    modify_tags(prefix, args)
end

function M.clear_tags(args)
    if not util.binary_exists('gomodifytags') then
        return
    end
    local prefix = 'GoClearTags'
    if #args < 2 then
        output.show_error(prefix, 'line number should be presented')
        return
    end
    modify_tags(prefix, args)
end

function M.add_options(args)
    if not util.binary_exists('gomodifytags') then
        return
    end
    local prefix = 'GoAddTagOptions'
    if #args < 4 then
        output.show_error(prefix, 'tag option should be presented')
        return
    end
    modify_tags(prefix, args)
end

function M.remove_options(args)
    if not util.binary_exists('gomodifytags') then
        return
    end
    local prefix = 'GoRemoveTagOptions'
    if #args < 4 then
        output.show_error(prefix, 'tag option should be presented')
        return
    end
    modify_tags(prefix, args)
end

function M.clear_options(args)
    if not util.binary_exists('gomodifytags') then
        return
    end
    local prefix = 'GoClearTagOptions'
    if #args < 2 then
        output.show_error(prefix, 'line number should be presented')
        return
    end
    modify_tags(prefix, args)
end

return M
