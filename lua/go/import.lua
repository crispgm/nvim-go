local M = {}

local vim = vim
local util = require('go.util')

local function delimit_pkg(pkg)
    if not pkg then
        return ''
    end

    if vim.startswith(pkg, '"') then
        pkg = string.sub(pkg, 2)
    end
    if vim.endswith(pkg, '"') then
        pkg = string.sub(pkg, 1, #pkg - 1)
    end
    if vim.endswith(pkg, '/') then
        pkg = string.sub(pkg, 1, #pkg - 1)
    end

    return pkg
end

local function need_go_get(pkg)
    if string.find(pkg, '%.') then
        return true
    end

    return false
end

function M.get(pkg)
    if not util.binary_exists('go') then
        return
    end

    if not pkg then
        return
    end
    vim.api.nvim_command('!go get -u -v ' .. pkg)
end

-- find the right place to add import
-- There are three way to import:
-- > import "fmt" or import ("fmt")
-- > import (
-- >     "fmt"
-- >     abbrev "something"
-- > )
local function switch_import(pkg)
    local pkg_line = -1
    local append_line = -1
    local insert_mode = ''
    local former_pkg = ''

    local index, total = 1, vim.fn.line('$')
    while index <= total do
        local line = vim.fn.getline(index)
        local matches
        -- just skip empty lines
        if #line == 0 then
            goto skip_to_next
        end

        -- package line
        matches = vim.fn.matchstr(line, '^package\\s\\+')
        if matches ~= nil and #matches > 0 then
            pkg_line = index
            goto skip_to_next
        end

        -- import (
        matches = vim.fn.matchstr(line, '^import\\s\\+($')
        if matches ~= nil and #matches > 0 then
            append_line = index
            insert_mode = 'add'
            break
        end

        -- other imports
        matches = vim.fn.matchstr(line, '^import\\s\\+')
        if matches ~= nil and #matches > 0 then
            append_line = index
            insert_mode = 'edit'
            former_pkg = string.gsub(line, 'import%s', '')
            former_pkg = string.gsub(former_pkg, '%(', '')
            former_pkg = string.gsub(former_pkg, '%)', '')
            break
        end

        ::skip_to_next::
        index = index + 1
    end

    if append_line >= 0 then
        if insert_mode == 'add' then
            vim.fn.append(append_line, string.format('\t"%s"', pkg))
        elseif insert_mode == 'edit' then
            vim.fn.setline(append_line, 'import (')
            vim.fn.append(append_line, ')')
            vim.fn.append(append_line, string.format('\t%s', former_pkg))
            vim.fn.append(append_line, string.format('\t"%s"', pkg))
        end
    end
    if insert_mode == '' and pkg_line >= 0 then
        vim.fn.append(pkg_line, ')')
        vim.fn.append(pkg_line, string.format('\t"%s"', pkg))
        vim.fn.append(pkg_line, 'import (')
        vim.fn.append(pkg_line, '')
    end
end

function M.import(pkg)
    if not util.binary_exists('go') then
        return
    end

    pkg = delimit_pkg(pkg)
    if not pkg then
        return
    end
    if need_go_get(pkg) then
        M.get(pkg)
    end
    switch_import(pkg)
end

M._test_delimit_pkg = delimit_pkg
M._test_need_go_get = need_go_get

return M
