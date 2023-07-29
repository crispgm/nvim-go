local function match_prefix(candidates, prefix)
    local matches = {}
    for _, candidate in pairs(candidates) do
        if candidate:find(prefix, 1, true) == 1 then
            table.concat(matches, candidate)
        end
    end

    return candidates
end

-- format
vim.api.nvim_create_user_command(
    'GoFormat',
    'lua require("go.format").format(<f-args>)',
    {
        nargs = '?',
        complete = function(arg_lead, cmd_line, cursor_pos)
            local prefix = arg_lead
            local _ = cmd_line
            local _ = cursor_pos
            local formatters = require('go.format').formatters()
            return match_prefix(formatters, prefix)
        end,
    }
)

-- lint
vim.api.nvim_create_user_command(
    'GoLint',
    'lua require("go.lint").lint(<f-args>)',
    {
        nargs = '?',
        complete = function(arg_lead, cmd_line, cursor_pos)
            local prefix = arg_lead
            local _ = cmd_line
            local _ = cursor_pos
            local linters = require('go.lint').linters()
            return match_prefix(linters, prefix)
        end,
    }
)

-- testing
vim.api.nvim_create_user_command(
    'GoTest', -- go test
    'lua require("go.test").test()',
    {
        nargs = 0,
    }
)
vim.api.nvim_create_user_command(
    'GoTestAll',
    'lua require("go.test").test_all()',
    {
        nargs = 0,
    }
)
vim.api.nvim_create_user_command(
    'GoTestFunc',
    'lua require("go.test").test_func()',
    {
        nargs = 0,
    }
)
vim.api.nvim_create_user_command(
    'GoTestName',
    'lua require("go.test").test_name()',
    {
        nargs = 0,
    }
)
vim.api.nvim_create_user_command(
    'GoTestFile',
    'lua require("go.test").test_file()',
    {
        nargs = 0,
    }
)
vim.api.nvim_create_user_command(
    'GoToTest',
    'lua require("go.test").test_open(<f-args>)',
    {
        nargs = '?',
        complete = 'command',
    }
)
vim.api.nvim_create_user_command(
    'GoAddTest',
    'lua require("go.gotests").add_test()',
    {
        nargs = 0,
    }
)

-- import
vim.api.nvim_create_user_command(
    'GoGet', -- go get
    'lua require("go.import").get(<f-args>)',
    {
        nargs = 1,
    }
)
vim.api.nvim_create_user_command(
    'GoImport',
    'lua require("go.import").import(<f-args>)',
    {
        nargs = 1,
    }
)

-- struct tags
vim.api.nvim_create_user_command(
    'GoAddTags',
    'lua require("go.struct_tag").add_tags({<line1>, <line2>, <count>, <f-args>})',
    {
        nargs = '*',
        range = true,
    }
)
vim.api.nvim_create_user_command(
    'GoRemoveTags',
    'lua require("go.struct_tag").remove_tags({<line1>, <line2>, <count>, <f-args>})',
    {
        nargs = '*',
        range = true,
    }
)
vim.api.nvim_create_user_command(
    'GoClearTags',
    'lua require("go.struct_tag").clear_tags({<line1>, <line2>, <count>, <f-args>})',
    {
        nargs = '*',
        range = true,
    }
)

-- struct tag options
vim.api.nvim_create_user_command(
    'GoAddTagOptions',
    'lua require("go.struct_tag").add_options({<line1>, <line2>, <count>, <f-args>})',
    {
        nargs = '*',
        range = true,
    }
)
vim.api.nvim_create_user_command(
    'GoRemoveTagOptions',
    'lua require("go.struct_tag").remove_options({<line1>, <line2>, <count>, <f-args>})',
    {
        nargs = '*',
        range = true,
    }
)
vim.api.nvim_create_user_command(
    'GoClearTagOptions',
    'lua require("go.struct_tag").clear_options({<line1>, <line2>, <count>, <f-args>})',
    {
        nargs = '*',
        range = true,
    }
)

-- quick_type
vim.api.nvim_create_user_command(
    'GoQuickType',
    'lua require("go.quick_type").quick_type(<count>, <f-args>)',
    {
        nargs = '*',
        complete = 'file',
    }
)

-- iferr
vim.api.nvim_create_user_command(
    'GoIfErr',
    'lua require("go.iferr").add_iferr()',
    {
        nargs = 0,
    }
)

-- autocmd
local opt = require('go.config').options
local group = vim.api.nvim_create_augroup('nvim_go', { clear = true })
vim.api.nvim_clear_autocmds({
    buffer = vim.api.nvim_get_current_buf(),
    group = group,
})
if opt.auto_format then
    vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
        group = group,
        pattern =  '*.go',
        command = 'GoFormat',
    })
end
if opt.auto_lint then
    vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        group = group,
        pattern = '<buffer>',
        command = 'GoLint',
    })
end
