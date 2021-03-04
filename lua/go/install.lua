local M = {}

local vim = vim
local config = require('go.config')
local output = require('go.output')

-- Install binaries
function M.install_binaries()
    print('[GoInstallBinaries] Starting...')
    for _, tool in ipairs(config.tools) do
        vim.api.nvim_command(string.format('echom "[GoInstallBinaries] Installing %s: %s ..."', tool.name, tool.repo))
        vim.fn.jobstart({'go', 'get', tool.repo}, {
            on_exit = function(_, code)
                if code == 0 then
                    output.show_success('GoInstallBinaries', string.format('Installed %s', tool.name))
                end
            end,
            on_stderr = function(_, data)
                local results = table.concat(data, "\n")
                output.show_error('GoInstallBinaries', results)
            end,
        })
    end
end

return M
