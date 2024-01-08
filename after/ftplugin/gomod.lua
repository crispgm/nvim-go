local opt = require('go.config').options
local group = vim.api.nvim_create_augroup('nvim_go_mod', { clear = true })

if opt.auto_format then
    vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
        group = group,
        pattern = 'go.mod',
        command = 'GoFormat',
    })
end
