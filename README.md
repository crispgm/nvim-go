# nvim-go

[![build](https://github.com/crispgm/nvim-go/actions/workflows/ci.yml/badge.svg)](https://github.com/crispgm/nvim-go/actions/workflows/ci.yml)

A minimal implementation of Golang development plugin,
which handles features that LSP (Language Server Protocol) client not provide.

Neovim 0.5 embeds a built-in LSP client and we are able to do most of vim-go's features by LSP client like `gopls`,
`nvim-go` collaborates with these features to get Golang development done.

This project is still under early development and you may use at your own risk.

## Features

- Auto format with `:GoFormat` when saving. (LSP supports this but it lacks `goimports`)
- Run linters with `:GoLint` (via `golangci-lint`) automatically.
- Quickly test with `:GoTestFunc` and `:GoTestFile`.
- Import packages with `:GoGet` and `:GoImport`.
- And more features are under development.

### LSP Client

We recommend `gopls` LSP client to handle language features:
- Code Completion (with `nvim-compe` or `completion.nvim`).
- Declaration, definition, implementation, references, and etc.

## Installation

Neovim nightly (0.5) is required for `nvim-go` to work.

With vim-plug:
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
    -- linters: golint, errcheck, golangci-lint
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

## Plan

### v0.1

- [x] Import
- [x] GoLint: show virtual text
- [ ] Bug fixes and polishing

### v0.2

- [ ] Struct Tag
- [ ] GoTest: GoTestPkg
- [ ] GoRename
- [ ] GoImpl

### v0.3

- [ ] Paste as JSON
- [ ] Doc
