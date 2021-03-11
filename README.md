# nvim-go

[![build](https://github.com/crispgm/nvim-go/actions/workflows/ci.yml/badge.svg)](https://github.com/crispgm/nvim-go/actions/workflows/ci.yml)

A minimal implementation of Golang development plugin written in Lua for neovim nightly (0.5).

Neovim 0.5 embeds a built-in LSP (Language Server Protocol) client so that
we are able to do most of vim-go's features by LSP client,
`nvim-go` collaborates with these features to get Golang development done.

This project is still under early development and you may use at your own risk.

## Plugin Features

- Auto format with `:GoFormat` when saving. (LSP supports this but it lacks `goimports`)
- Run linters with `:GoLint` (via `golangci-lint`) automatically.
- Quickly test with `:GoTestFunc` and `:GoTestFile`.
- Import packages with `:GoGet` and `:GoImport`.
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

## Installation

Prerequisites:
- Neovim nightly (0.5)
- [`gopls`](https://pkg.go.dev/golang.org/x/tools/gopls)

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

Setup:
```lua
-- setup nvim-go
require('go').setup{}

-- setup lsp client
require'lspconfig'.gopls.setup{}
```

Defaults:
```lua
require('go').setup{
    -- auto commands
    auto_format = true,
    auto_lint = true,
    -- linters: golint, errcheck, staticcheck, golangci-lint
    linter = 'golangci-lint',
    -- lint_prompt_style: qf (quickfix), vt (virtual text)
    lint_prompt_style = 'qf',
    -- formatter: goimports, gofmt, gofumpt
    formatter = 'goimports',
    -- test flags: -count=1 will disable cache
    test_flags = {'-v'},
    test_timeout = '30s',
    -- show test result with popup window
    test_popup = true,
}
```

## Known Issues

- Upstream Issue: `golangci-lint` may mess up quickfix dute to stderr output [#3](https://github.com/crispgm/nvim-go/issues/3)

## Plan

### v0.1

- [x] Import
- [x] GoLint: show virtual text
- [ ] Bug fixes and polishing

### v0.2

- [ ] Struct Tag
- [ ] GoTest: GoTestPkg
- [ ] GoImpl

### v0.3

- [ ] Paste as JSON
- [ ] Doc

## License

[MIT](/LICENSE)
