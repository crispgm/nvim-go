local M = {}

local Job = require('plenary.job')

function M.GoFmt()
    local filePath = vim.api.nvim_buf_get_name(0)
    local cwd = vim.fn.expand('%:p:h')
    Job:new({
        command = 'gofmt',
        args = { '-w', filePath },
        cwd = cwd,
        on_exit = function(j, return_val)
            print(return_val, j:result())
        end,
    }):sync()
end

return M
