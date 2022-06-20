local M = {}

local vim = vim
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
    -- redirect stderr to stdout so neovim won't crash
    table.insert(args, '2>&1')

    return table.concat(args, ' ')
end

local function valid_func_name(func_name)
    if not func_name then
        return false
    end
    if
        vim.startswith(func_name, 'Test')
        or vim.startswith(func_name, 'Example')
    then
        return true
    end

    return false
end

local function split_file_name(str)
    return vim.fn.split(vim.fn.split(str, ' ')[2], '(')[1]
end

local function valid_buf()
    local buf_nr = vim.api.nvim_get_current_buf()
    if
        vim.api.nvim_buf_is_valid(buf_nr)
        and vim.api.nvim_buf_get_option(buf_nr, 'buflisted')
    then
        return true
    end

    return false
end

local function do_test(prefix, cmd)
    if not valid_buf() then
        return
    end
    -- calc popup window size here
    local pos = output.calc_popup_size()
    local function on_event(_, data, event)
        if config.options.test_popup and not util.empty_output(data) then
            vim.api.nvim_exec_autocmds(
                'User',
                { pattern = 'NvimGoTestPopupPre' }
            )
            output.popup_job_result(data, {
                title = prefix,
                pos = pos,
                filetype = 'nvimgo-test-popup',
            })
            vim.api.nvim_exec_autocmds(
                'User',
                { pattern = 'NvimGoTestPopupPost' }
            )
            return
        else
            local outputs = {}
            for _, v in ipairs(data) do
                if string.len(v) > 0 then
                    table.insert(outputs, v)
                end
            end
            if #outputs > 0 then
                local msg = table.concat(output, '\n')
                if event == 'stdout' then
                    output.show_info(prefix, msg)
                elseif event == 'stderr' then
                    output.show_error(prefix, msg)
                end
            end
        end
    end

    local cwd = vim.fn.expand('%:p:h')
    local env = config.options.test_env
    local opts = {
        on_exit = function(_, code, _)
            if code ~= 0 then
                output.show_warning(
                    prefix,
                    string.format('error code: %d', code)
                )
            end
        end,
        cwd = cwd,
        on_stdout = on_event,
        on_stderr = on_event,
        stdout_buffered = true,
        stderr_buffered = true,
    }
    if env ~= nil and next(env) ~= nil then
        opts['env'] = env
    end
    vim.fn.jobstart(cmd, opts)
end

function M.test()
    if not util.binary_exists('go') then
        return
    end

    local prefix = 'GoTest'
    local cmd = { 'go', 'test' }
    do_test(prefix, build_args(cmd))
end

function M.test_all()
    if not util.binary_exists('go') then
        return
    end

    local prefix = 'GoTestAll'
    local cmd = { 'go', 'test', './...' }
    do_test(prefix, build_args(cmd))
end

function M.test_func(opt)
    if not util.binary_exists('go') then
        return
    end

    local prefix = 'GoTestFunc'
    local func_name = ''
    -- this is not available now actually
    if opt and opt.func then
        func_name = opt.func
    else
        local line = vim.fn.search([[func \(Test\|Example\)]], 'bcnW')
        if line == 0 then
            output.show_error(
                prefix,
                string.format('Test func not found: %s', func_name)
            )
            return
        end
        local cur_line = vim.fn.getline(line)
        func_name = split_file_name(cur_line)
    end
    if not valid_func_name(func_name) then
        output.show_error(
            'GoTestFunc',
            string.format('Invalid test func: %s', func_name)
        )
        return
    end
    local cmd = {
        'go',
        'test',
        '-run',
        vim.fn.shellescape(string.format('^%s$', func_name)),
    }
    do_test(prefix, build_args(cmd))
end

function M.test_file()
    if not util.binary_exists('go') then
        return
    end

    local prefix = 'GoTestFile'
    local pattern = vim.regex('^func [Test|Example]')
    local lines = vim.api.nvim_buf_get_lines(
        vim.api.nvim_get_current_buf(),
        1,
        -1,
        false
    )
    local func_names = {}
    if #lines == 0 then
        return
    end
    for _, line in ipairs(lines) do
        local col_from, _ = pattern:match_str(line)
        if col_from then
            local fn = split_file_name(line)
            if valid_func_name(fn) then
                table.insert(func_names, fn)
            end
        end
    end
    local cmd = {
        'go',
        'test',
        '-run',
        vim.fn.shellescape(
            string.format('^%s$', table.concat(func_names, '|'))
        ),
    }
    do_test(prefix, build_args(cmd))
end

local function valid_file(fn)
    if vim.endswith(fn, '_test.go') then
        return 1
    elseif vim.endswith(fn, '.go') then
        return 0
    end

    return -1
end

function M.test_open(cmd)
    local buf_nr = vim.api.nvim_get_current_buf()
    local file_path = vim.api.nvim_buf_get_name(buf_nr)
    local new_fn
    local vf = valid_file(file_path)
    if vf == 1 then
        new_fn = file_path:gsub('_test.go$', '.go')
    elseif vf == 0 then
        new_fn = file_path:gsub('.go$', '_test.go')
    else
        output.show_error('GoTestOpen', 'not a `.go` file')
        return
    end

    if cmd == nil or cmd == '' then
        cmd = config.options.test_open_cmd
    end
    vim.api.nvim_command(string.format('%s %s', cmd, new_fn))
end

-- export for testing
M._valid_file = valid_file
M._valid_func_name = valid_func_name
M._split_file_name = split_file_name
M._build_args = build_args

return M
