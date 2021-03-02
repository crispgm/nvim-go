local M = {}

local vim = vim
local Job = require('plenary.job')

function M.run(opt)
    local file_path = vim.api.nvim_buf_get_name(0)
    local cwd = vim.fn.expand('%:p:h')
    vim.api.nvim_exec('write', true)
    Job:new({
        command = 'goimports',
        args = { '-w', file_path },
        cwd = cwd,
        on_exit = function(j, return_val)
            if return_val == 0 then
                print('[GoImports] Success')
            else
                print(string.format('[GoImports] Error %d: %s', return_val, Job:result()))
            end
        end,
    }):sync()
    vim.api.nvim_exec('edit!', true)
end

return M
