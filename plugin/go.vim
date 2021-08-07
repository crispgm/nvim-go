if exists('g:loaded_nvim_go') | finish | endif
let g:loaded_nvim_go = 1

command! GoInstallBinaries lua require('go.install').install_binaries()
command! GoUpdateBinaries lua require('go.install').update_binaries()
