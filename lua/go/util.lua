local M = {}

local vim = vim

function M.show_success(prefix)
    print(string.format('[%s] Success', prefix))
end

function M.show_error(prefix, msg)
    print(string.format('[%s] %s', prefix, msg))
end

function M.show_job_success(prefix, results)
    print(string.format('[%s] Success', prefix))
    for _, v in ipairs(results) do
        print(v)
    end
end

function M.show_job_error(prefix, code, results)
    print(string.format('[%s] Error: %d', prefix, code))
    for _, v in ipairs(results) do
        print(v)
    end
end

function M.current_word()
    return vim.fn.expand('<cword>')
end

return M
