local M = {}

local vim = vim
local Job = require('plenary.job')
local config = require('go.config')
local util = require('go.util')
local output = require('go.output')

local function build_args(args)
    local test_timeout = config.options.test_timeout
    if test_timeout then
        table.insert(args, string.format('-timeout=%s', test_timeout))
    end
    local test_flags = config.options.test_flags
    if test_flags then
        for _, f in ipairs(test_flags) do
            table.insert(args, f)
        end
    end

    return args
end

local function valid_func_name(func_name)
    if not func_name then return false end
    if vim.startswith(func_name, 'Test') or vim.startswith(func_name, 'Example') then
        return true
    end

    return false
end

local function split_file_name(str)
    return vim.fn.split(vim.fn.split(str, ' ')[2], '(')[1]
end

function M.test_func(opt)
    if not util.binary_exists('go') then return end

    local func_name = ''
    if opt and opt.func then
        func_name = opt.func
    else
        local line = vim.fn.search([[func \(Test\|Example\)]], 'bcnW')
        if line == 0 then
            output.show_error('GoTestFunc', string.format('Test func not found: %s', func_name))
            return
        end
        local cur_line = util.current_line()
        func_name = split_file_name(cur_line)
    end
    local cwd = vim.fn.expand('%:p:h')
    if not valid_func_name(func_name) then
        output.show_error('GoTestFunc', string.format('Invalid test func: %s', func_name))
        return
    end
    local args = {'test', '-run', string.format('^%s$', func_name)}
    build_args(args)
    local results, code = Job:new({
        command = 'go',
        args = args,
        cwd = cwd,
    }):sync()
    if config.options.test_popup then
        return output.popup_job_result(results)
    end
    if code == 0 then
        output.show_job_success('GoTestFunc', results)
    else
        output.show_job_error('GoTestFunc', code, results)
    end
end

function M.test_file()
    if not util.binary_exists('go') then return end

    local cwd = vim.fn.expand('%:p:h')
    local pattern = vim.regex('^func [Test|Example]')
    local lines = vim.api.nvim_buf_get_lines(vim.api.nvim_get_current_buf(), 1, -1, false)
    local func_names = {}
    if #lines == 0 then return end
    for _, line in ipairs(lines) do
        local col_from, _ = pattern:match_str(line)
        if col_from then
            local fn = split_file_name(line)
            if valid_func_name(fn) then
                table.insert(func_names, fn)
            end
        end
    end
    local args = {'test', '-run', string.format('^%s$', table.concat(func_names, '|'))}
    build_args(args)
    local results, code = Job:new({
        command = 'go',
        args = args,
        cwd = cwd,
    }):sync()
    if config.options.test_popup then
        return output.popup_job_result(results)
    end
    if code == 0 then
        output.show_job_success('GoTestFile', results)
    else
        output.show_error('GoTestFile', code, results)
    end
end

local function valid_file(fn)
    if vim.endswith(fn, "_test.go") then
        return 1
    elseif vim.endswith(fn, ".go") then
        return 0
    end

    return -1
end

function M.test_open()
    local file_path = vim.api.nvim_buf_get_name(0)
    local new_fn
    local vf = valid_file(file_path)
    if vf == 1 then
        new_fn = file_path:gsub("_test.go$", ".go")
    elseif vf == 0 then
        new_fn = file_path:gsub(".go$", "_test.go")
    else
        -- not even a `.go file
        return
    end
    print(new_fn)

    vim.api.nvim_command('edit' .. new_fn)
end

return M
