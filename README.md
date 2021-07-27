# nvim-go

[![build](https://github.com/crispgm/nvim-go/actions/workflows/ci.yml/badge.svg)](https://github.com/crispgm/nvim-go/actions/workflows/ci.yml)

A minimal implementation of Golang development plugin written in Lua for neovim nightly (0.5).

Neovim 0.5 embeds a built-in LSP (Language Server Protocol) client so that
we are able to do most of vim-go's features by LSP client,
`nvim-go` collaborates with these features to get Golang development done.

## Plugin Features

- Auto format with `:GoFormat` when saving. (LSP supports this but it lacks `goimports`)
- Run linters with `:GoLint` (via `golint`) automatically.
- Quickly test with `:GoTest`, `:GoTestFunc`, `:GoTestFile` and `:GoTestAll`.
- Import packages with `:GoGet` and `:GoImport`.
- Modify struct tags with `:GoAddTags`, `:GoRemoveTags`, `:GoClearTags`, `:GoAddTagOptions`, `:GoRemoveTagOptions` and `:GoClearTagOptions`.
- Generates JSON models with `:GoQuickType` (via `quicktype`).
- And more features are under development.

## Language Features

Language server provides useful language features to make Golang development easy.
`nvim-go` does not provide these features but collaborates with them.

This section can be considered as a guide or common practice to develop with `nvim-go` and `gopls`:
- Code Completion via `nvim-compe` or `completion.nvim`
- Declaration: `vim.lsp.buf.declaration()`
- Definition: `vim.lsp.buf.definition()` and `vim.lsp.buf.type_definition()`
- Implementation: `vim.lsp.buf.implementation()`
- Hover: `vim.lsp.buf.hover()`
- Signature: `vim.lsp.buf.signature_help()`
- References: `vim.lsp.buf.reference()`
- Symbols: `vim.lsp.buf.document_symbol()` and `vim.lsp.buf.workspace_symbol()`
- Rename: `vim.lsp.buf.rename()`

## Other Features

- Debug: we recommend [vim-delve](https://github.com/sebdah/vim-delve)

## Installation

Prerequisites:
- Neovim nightly (0.5)
- [yarn](http://yarnpkg.com) (for quicktype)

Install with vim-plug:
```viml
" dependencies
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
" nvim-go
Plug 'crispgm/nvim-go'
" (recommend) LSP config
Plug 'neovim/nvim-lspconfig'
```

Run:
```shell
nvim +PlugInstall
```

Finally, run `:GoInstallBinaries` after plugin installed.

## Usage

### Setup

```lua
-- setup nvim-go
require('go').setup{}

-- setup lsp client
require('lspconfig').gopls.setup{}
```

### Defaults

```lua
require('go').setup{
    -- auto commands
    auto_format = true,
    auto_lint = true,
    -- linters: golint, errcheck, staticcheck, golangci-lint
    linter = 'golint',
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
    test_popup_width = 80,
    test_popup_height = 10,
    -- struct tags
    tags_name = 'json',
    tags_options = {'json=omitempty'},
    tags_transform = 'snakecase',
    tags_flags = {'-skip-unexported'},
    -- quick type
    quick_type_flags = {'--just-types'},
}
```

### Manual

Display within neovim with:
```vim
:help nvim-go
```

## Known Issues

- Upstream Issue: `golangci-lint` may mess up quickfix due to stderr output [#3](https://github.com/crispgm/nvim-go/issues/3)

## License

[MIT](/LICENSE)
