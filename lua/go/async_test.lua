local M = {}

local vim = vim
local config = require('go.config')
local util = require('go.util')
local output = require('go.output')

local correctly_formatted = "^    .+%.go:%d+: .+$"

local function queue()
    local out = {}
    out.push = function(item)
        table.insert(out, 1, item)
    end
    out.pop = function()
        if #out > 0 then
            return table.remove(out, #out)
        end
    end
    out.iterator = function()
        return function()
            return out.pop()
        end
    end
    return out
end

local function test()
    local out = { lines = queue() }
    out.add_msg = function(msg)
        out.lines.push(msg)
    end
    out.last_msgs = function()
        return out.lines.iterator()
    end
    out.last_msg = function()
        return out.lines.pop()
    end
    return out
end

local function split_and_rev_cwd(dir)
    local rev_pwd = {}
    local working_dir = dir and dir or vim.fn.getcwd()
    local split_pwd = vim.fn.split(working_dir, "/")
    for i = #split_pwd, 1, -1 do
        rev_pwd[#rev_pwd + 1] = split_pwd[i]
    end
    return rev_pwd
end

local function calc_relative_path_to(pn, cwd)
    local rev_pwd = split_and_rev_cwd(cwd)
    local rev_pn = split_and_rev_cwd(pn)
    local spn = vim.fn.split(pn, "/")

    local go_down = ""
    local common = nil
    for _, pwd1 in ipairs(rev_pwd) do
        local common_i = nil
        for i, p1 in ipairs(rev_pn) do
            if p1 == pwd1 then
                common_i = i
                break
            end
        end
        if not common_i then
            go_down = go_down .. "../"
        else
            common = common_i
            break
        end
    end

    local path_to = go_down
    for i = #spn - common + 1 + 1, #spn do -- +1 index correx +1 common dir remove
        path_to = path_to .. spn[i] .. "/"
    end
    return path_to
end

local function parse_qf_line(qf_list, test_event)
    if string.match(test_event.Msg, correctly_formatted) then
        local path_to_testfile = calc_relative_path_to(test_event.Package)
        local path_corrected_msg = string.gsub(
            test_event.Msg,
            "^    ",
            path_to_testfile
        )
        local filename, lnum, text = string.match(
            path_corrected_msg,
            "^(.+%.go):(%d+): (.+)$"
        )
        table.insert(qf_list, {
            filename = filename,
            lnum = lnum,
            type = 'E',
            module = test_event.Name,
            text = text,
        })
    end
end

local function parse_output_lines(test_event)
    local qf_list = {}
    if string.match(test_event.Name, "^Example.+$") then
        local cur_testfile_bufnr = test_event.BufferNr
        table.insert(qf_list, {
            bufnr = cur_testfile_bufnr,
            pattern = "^func " .. test_event.Name,
            type = 'E',
            module = test_event.Name,
            text = "FAIL",
        })
        for msg in test_event.Messages do
            local noise = string.match(msg, '^=== ') or string.match(msg, '^--- ')
            if not noise then
                table.insert(qf_list, {
                    bufnr = cur_testfile_bufnr,
                    module = ' ',
                    text = msg,
                    valid = false,
                })
            end
        end

    elseif string.match(test_event.Name, "^Test.+$") then
        for msg in test_event.Messages do
            test_event.Msg = msg
            parse_qf_line(qf_list, test_event)
        end
    end
    return qf_list
end

local function test_run()
    local out = {
        current_test = {},
        list = {},
        -- Example tests doesn't log filename and line number. For all but
        -- GoTestAll we can use current buffer and search pattern.
        cur_testfile_bufnr = vim.api.nvim_get_current_buf(),
    }
    out.parse_test_output_line = function(line, process)
        if not line or line == "" then return end
        local test_event = vim.fn.json_decode(line)
        if not test_event.Test or test_event.Test == "" then return end

        local action = test_event.Action
        local tkey = test_event.Package .. test_event.Test

        if action == "run" then
            out.current_test[tkey] = test()
        elseif action == "fail" then
            if not out.current_test[tkey] then return end
            local qf_list = parse_output_lines({
                Messages = out.current_test[tkey].last_msgs(),
                Package = test_event.Package,
                Name = test_event.Test,
                BufferNr = out.cur_testfile_bufnr,
            })
            if qf_list ~= nil and #qf_list > 0 then
                process(qf_list)
            end
            out.current_test[tkey] = nil
        elseif action == "output" then
            if not out.current_test[tkey] then return end
            out.current_test[tkey].add_msg(test_event.Output)
        elseif action == "pass" then
            out.current_test[tkey] = nil
        end
    end

    return out
end

local function quickfix(prefix)
    local out = { win_nr = nil, title = prefix }
    out.show = function(qf_list)
        if not qf_list then return end

        if out.win_nr ~= nil then
            vim.fn.setloclist(out.win_nr, qf_list, 'a')
            return
        end

        local win_nr = vim.fn.winnr()
        local height = vim.o.lines / 5 -- 20% of the height
        height = height < 3 and 3 or height
        local title = out.title and out.title or "go test result"

        vim.fn.setloclist(win_nr, qf_list, 'r')
        vim.fn.setloclist(win_nr, {}, 'a', { title = title })
        vim.api.nvim_command(string.format('lopen %d', height))
        out.win_nr = win_nr
    end
    out.clear = function()
        if not out.win_nr then return end
        vim.fn.setloclist(out.win_nr, {})
        vim.api.nvim_command('lclose')
    end
    out.is_on = function()
        return out.win_nr ~= nil
    end
    return out
end

local function sub_path(rev_path, cut_count)
    local path = ""
    for i = 1, #rev_path - cut_count do
        if i == 1 and rev_path[i] ~= "."
            and not string.find(rev_path[i], "/")
        then
            path = "/"
        end
        path = path .. rev_path[i] .. "/"
    end
    return path
end

local function module_root(cwd)
    local working_dir = cwd and cwd or vim.fn.getcwd()
    local rev_cwd = vim.fn.split(working_dir, "/")
    for i = 0, #rev_cwd do
        local sb = sub_path(rev_cwd, i)
        if util.is_file(sb .. "go.mod") then
            return sb
        end
    end
    return working_dir
end

local function calc_working_dir(prefix)
    local cwd = vim.fn.expand('%:p:h')
    if prefix == "GoTestAll" then
        cwd = module_root()
    end
    return cwd
end

function M.do_test(prefix, cmd)
    if not util.valid_buf() then
        return
    end
    local qf_win = quickfix(prefix)
    local trun = test_run()
    local function on_event(_, data, _)
        if not util.empty_output(data) then
            for _, line in ipairs(data) do
                trun.parse_test_output_line(line, function(qfl)
                    qf_win.show(qfl)
                end)
            end
        end
    end

    local cwd = calc_working_dir(prefix)
    local env = config.options.test_env
    local opts = {
        on_exit = function(_, code, _)
            if code ~= 0 then
                output.show_warning(
                    prefix,
                    string.format('error code: %d', code)
                )
            elseif not qf_win.is_on() then
                qf_win.clear()
                output.show_info(prefix, "✅ PASS")
            end
        end,
        cwd = cwd,
        on_stdout = on_event,
        on_stderr = on_event,
    }
    if env ~= nil and next(env) ~= nil then
        opts['env'] = env
    end
    vim.fn.jobstart(cmd, opts)
end

-- export for testing
M._calc_relative_path_to = calc_relative_path_to
M._module_root = module_root
M._test_run = test_run

return M
