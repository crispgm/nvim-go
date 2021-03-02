local M = {}

local vim = vim
local Job = require('plenary.job')
local config = require('go.config')
local util = require('go.util')

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
    if string.find(func_name, '^Test') or string.find(func_name, '^Example') then
        return true
    end

    return false
end

function M.test_func(opt)
    local func_name = ''
    if opt and opt.func then
        func_name = opt.func
    else
        func_name = util.current_word()
    end
    local cwd = vim.fn.expand('%:p:h')
    if not valid_func_name(func_name) then
        util.show_error('GoTestFunc', string.format('Invalid test func: %s', func_name))
        return
    end
    local args = {'test', '-run', string.format('^%s$', func_name)}
    build_args(args)
    local results, _ = Job:new({
        command = 'go',
        args = args,
        cwd = cwd,
        on_exit = function(j, return_val)
            if return_val == 0 then
                util.show_job_error('GoTestFunc', return_val, j:result())
            end
        end,
    }):sync()
    util.show_job_success('GoTestFunc', results)
end

function M.test_file()
    local file_path = vim.api.nvim_buf_get_name(0)
    local cwd = vim.fn.expand('%:p:h')
    local args = {'test', file_path}
    build_args(args)
    Job:new({
        command = 'go',
        args = args,
        cwd = cwd,
        on_exit = function(j, return_val)
            if return_val == 0 then
                util.show_success('GoTestFile')
            else
                util.show_error('GoTestFile', return_val, j:result())
            end
        end,
    }):sync()
end

return M
