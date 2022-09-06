local M = {}

local vim = vim
local config = require('go.config')
local output = require('go.output')

local function is_go_install()
    local cmd = 'go version'
    local out = vim.fn.system(cmd)
    local major, minor, patch = 0, 0, 0
    if out ~= nil then
        local version = out:match('go version go(%d+%.%d+%.%d+)')
        if version ~= nil then
            major, minor, patch = version:match('(%d+).(%d+).(%d+)')
            major = tonumber(major)
            minor = tonumber(minor)
            patch = tonumber(patch)
        end
    end

    vim.api.nvim_echo(
        { { string.format('Go version is %d.%d.%d', major, minor, patch) } },
        true,
        {}
    )
    if major == 1 and minor < 17 then
        return false
    end
    return true
end

local function build_cmd(tool, update, go_install)
    local cmd
    local pkg_mgr = 'go'
    if tool.pkg_mgr ~= nil then
        pkg_mgr = tool.pkg_mgr
    end
    if pkg_mgr == 'go' then
        local src = tool.src
        if go_install then
            src = tool.src .. '@latest'
            cmd = { 'go', 'install', src }
        else
            cmd = { 'go', 'get', '-u', src }
        end
    elseif pkg_mgr == 'yarn' then
        if update then
            cmd = { 'yarn', 'global', 'upgrade', tool.src }
        else
            cmd = { 'yarn', 'global', 'add', tool.src }
        end
    elseif pkg_mgr == 'npm' then
        if update then
            cmd = { 'npm', 'update', '-g', tool.src }
        else
            cmd = { 'npm', 'install', '-g', tool.src }
        end
    elseif pkg_mgr == 'pnpm' then
        if update then
            cmd = { 'pnpm', 'update', '--global', tool.src }
        else
            cmd = { 'pnpm', 'add', '--global', tool.src }
        end
    else
        return nil
    end

    return cmd
end

local function do_install(prefix, update)
    if vim.fn.executable('go') == 0 then
        output.show_error(prefix, 'Install Golang at first')
    end
    local go_install = is_go_install()

    for _, tool in ipairs(config.tools) do
        if tool.enable == false then
            goto skip_to_next
        end
        if update == false and vim.fn.executable(tool.name) == 1 then
            goto skip_to_next
        end
        local msg = string.format(
            '[%s] Installing %s: %s ...',
            prefix,
            tool.name,
            tool.src
        )
        vim.api.nvim_echo({ { msg } }, true, {})
        local cmd = build_cmd(tool, update, go_install)
        if cmd == nil then
            output.show_error(
                prefix,
                string.format('%s is not supported', tool.pkg_mgr)
            )
        end
        vim.fn.jobstart(cmd, {
            on_exit = function(_, code, _)
                if code == 0 then
                    output.show_success(
                        prefix,
                        string.format('Installed %s', tool.name)
                    )
                end
            end,
            on_stderr = function(_, data, _)
                local results = table.concat(data, '\n')
                output.show_error(prefix, results)
            end,
        })

        ::skip_to_next::
    end
end

-- Install binaries
function M.install_binaries()
    do_install('GoInstallBinaries', false)
end

-- Update binaries
function M.update_binaries()
    do_install('GoUpdateBinaries', true)
end

return M
