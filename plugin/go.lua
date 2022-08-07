if vim.g.loaded_nvim_go == 1 then
    return
end
vim.g.loaded_nvim_go = 1

vim.api.nvim_create_user_command('GoInstallBinaries', function(_)
    require('go.install').install_binaries()
end, {
    nargs = 0,
})

vim.api.nvim_create_user_command('GoUpdateBinaries', function(_)
    require('go.install').update_binaries()
end, {
    nargs = 0,
})
