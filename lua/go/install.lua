local M = {}

local vim = vim
local config = require('go.config')
local output = require('go.output')

-- Install binaries
function M.install_binaries()
    if vim.fn.executable('go') == 0 then
        output.show_error('GoInstallBinaries', 'Install Golang at first')
    end

    for _, tool in ipairs(config.tools) do
        if vim.fn.executable(tool.name) == 1 then
            goto skip_to_next
        end
        local msg = string.format('[GoInstallBinaries] Installing %s: %s ...', tool.name, tool.repo)
        vim.api.nvim_echo({{msg}}, true, {})
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

        ::skip_to_next::
    end
end

-- Update binaries
function M.update_binaries()
    for _, tool in ipairs(config.tools) do
        local msg = string.format('[GoUpdateBinaries] Installing %s: %s ...', tool.name, tool.repo)
        vim.api.nvim_echo({{msg}}, true, {})
        vim.fn.jobstart({'go', 'get', '-u', tool.repo}, {
            on_exit = function(_, code)
                if code == 0 then
                    output.show_success('GoUpdateBinaries', string.format('Installed %s', tool.name))
                end
            end,
            on_stderr = function(_, data)
                local results = table.concat(data, "\n")
                output.show_error('GoUpdateBinaries', results)
            end,
        })
    end
end

return M
