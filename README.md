# nvim-go

[![build](https://github.com/crispgm/nvim-go/actions/workflows/ci.yml/badge.svg)](https://github.com/crispgm/nvim-go/actions/workflows/ci.yml)

A minimal implementation of Golang development plugin written in Lua for Neovim.

## Introduction

Neovim (from v0.5) embeds a built-in Language Server Protocol (LSP) client. And Debug Adapter Protocol (DAP) are also brought into Neovim as a general debugger. With the power of them, we are able to easily turn Neovim into a powerful editor.

`nvim-go` is designed to collaborate with them, provides sufficient features, and leverages community toolchains to get Golang development done.

## Features

- Auto format with `:GoFormat` (via `goimports`, `gofmt`, and `gofumpt`) when saving.
- Run linters with `:GoLint` (via `revive`) automatically.
- Quickly test with `:GoTest`, `:GoTestFunc`, `:GoTestFile` and `:GoTestAll`. Generate test with `:GoAddTest`.
- Import packages with `:GoGet` and `:GoImport`.
- Modify struct tags with `:GoAddTags`, `:GoRemoveTags`, `:GoClearTags`, `:GoAddTagOptions`, `:GoRemoveTagOptions` and `:GoClearTagOptions`.
- Generates JSON models with `:GoQuickType` (via `quicktype`).

[Screenshots](https://github.com/crispgm/nvim-go/wiki#screenshots)

## Recommended Features

This section can be regarded as a guide or common practice to develop with `nvim-go`, LSP (`gopls`) and DAP.
If you are familiar with these tools or other equivalent, you may skip this chapter.

<details>
<summary>&lt;Show/Hide the guide&gt;</summary>

### Language Server

Language server provides vital language features to make Golang development easy.
We highly recommend you to use LSP client together with `nvim-go`.

1. Setup `gopls` with [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig).
2. Setup your favorite completion engine such as [nvim-cmp](https://github.com/hrsh7th/nvim-cmp).
3. Map the following methods based on what you need:

- Declaration: `vim.lsp.buf.declaration()`
- Definition: `vim.lsp.buf.definition()` and `vim.lsp.buf.type_definition()`
- Implementation: `vim.lsp.buf.implementation()`
- Hover: `vim.lsp.buf.hover()`
- Signature: `vim.lsp.buf.signature_help()`
- References: `vim.lsp.buf.reference()`
- Symbols: `vim.lsp.buf.document_symbol()` and `vim.lsp.buf.workspace_symbol()`
- Rename: `vim.lsp.buf.rename()`

### Debugger

- [nvim-dap](https://github.com/mfussenegger/nvim-dap)

</details>

## Installation

Prerequisites:

- Neovim (>= 0.7)
- [npm](https://www.npmjs.com) (for quicktype)

Install with your favorite package manager:

```lua
" dependencies
use('nvim-lua/plenary.nvim')

" nvim-go
use('crispgm/nvim-go')

" (optional) if you enable nvim-notify
use('rcarriga/nvim-notify')

" (recommend) LSP config
use('neovim/nvim-lspconfig')
```

Finally, run `:GoInstallBinaries` after plugin installed.

> Install `quicktype` with `yarn` or `pnpm`:

`nvim-go` install `quicktype` with `npm` by default, you may replace it with `yarn` or `pnpm`.

```lua
require('go').config.update_tool('quicktype', function(tool)
    tool.pkg_mgr = 'yarn'
end)
```

## Usage

### Setup

```lua
-- setup nvim-go
require('go').setup({})

-- setup lsp client
require('lspconfig').gopls.setup({})
```

### Defaults

```lua
require('go').setup({
    -- notify: use nvim-notify
    notify = false,
    -- auto commands
    auto_format = true,
    auto_lint = true,
    -- linters: revive, errcheck, staticcheck, golangci-lint
    linter = 'revive',
    -- linter_flags: e.g., {revive = {'-config', '/path/to/config.yml'}}
    linter_flags = {},
    -- lint_prompt_style: qf (quickfix), vt (virtual text)
    lint_prompt_style = 'qf',
    -- formatter: goimports, gofmt, gofumpt
    formatter = 'goimports',
    -- test flags: -count=1 will disable cache
    test_flags = {'-v'},
    test_timeout = '30s',
    test_env = {},
    -- show test result with popup window
    test_popup = true,
    test_popup_auto_leave = false,
    test_popup_width = 80,
    test_popup_height = 10,
    -- test open
    test_open_cmd = 'edit',
    -- struct tags
    tags_name = 'json',
    tags_options = {'json=omitempty'},
    tags_transform = 'snakecase',
    tags_flags = {'-skip-unexported'},
    -- quick type
    quick_type_flags = {'--just-types'},
})
```

### Manual

Display within Neovim with:

```vim
:help nvim-go
```

## Advanced Configuration

### Statusline Count

[vim-airline](https://github.com/vim-airline/vim-airline):

```lua
function! LintIssuesCount()
    if exists('g:nvim_go#lint_issues_count')
        return g:nvim_go#lint_issues_count
    endif
endfunction
call airline#parts#define_function('nvim_go', 'LintIssuesCount')
call airline#parts#define_condition('nvim_go', '&filetype == "go"')
let g:airline_section_warning = airline#section#create_right(['nvim_go'])
```

[lightline](https://github.com/itchyny/lightline.vim):

```lua
function! LintIssuesCount()
    if exists('g:nvim_go#lint_issues_count') && &filetype == 'go'
        return g:nvim_go#lint_issues_count
    endif
endfunction
let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'readonly', 'filename', 'modified', 'lintcount' ] ]
  \ },
  \ 'component_function': {
  \   'lintcount': 'LintIssuesCount'
  \ },
  \ }
```

[nvim-hardline](https://github.com/ojroques/nvim-hardline):

```lua
require('hardline').setup({
    -- ...
    sections = {
        {
            class = 'error',
            item = function()
                if
                    vim.bo.filetype == 'go'
                    and vim.g['nvim_go#lint_issues_count'] ~= nil
                then
                    return vim.g['nvim_go#lint_issues_count']
                else
                    return ''
                end
            end,
        },
    -- ...
    }
```

### Show Lint Issues without Focusing

```viml
augroup NvimGo
  autocmd!
  autocmd User NvimGoLintPopupPost wincmd p
augroup END
```

## License

[MIT](/LICENSE)
