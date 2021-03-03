local M = {}

local vim = vim
local Job = require('plenary.job')
local config = require('go.config')
local output = require('go.output')

-- Install binaries
function M.install_binaries()
    local cwd = vim.fn.expand('%:p:h')

    print('[GoInstallBinaries] Starting...')
    for _, tool in ipairs(config.tools) do
        vim.api.nvim_command(string.format('echom "[GoInstallBinaries] Installing %s: %s ..."', tool.name, tool.repo))
        local results, code = Job:new({
            command = 'go',
            args = { 'get', tool.repo },
            cwd = cwd,
        }):sync(30000)
        if code == 0 then
            output.show_success('GoInstallBinaries', string.format('Installed %s', tool.name))
        else
            output.show_job_error('GoInstallBinaries', results)
        end
    end
end

return M
