# nvim-go

[![build](https://github.com/crispgm/nvim-go/actions/workflows/ci.yml/badge.svg)](https://github.com/crispgm/nvim-go/actions/workflows/ci.yml)

A minimal implementation of Golang development plugin,
which handles features that LSP (Language Server Protocol) client not provide.

Neovim 0.5 embeds a built-in LSP client and we are able to do most of vim-go's features by LSP client like `gopls`,
`nvim-go` collaborates with these features to get Golang development done.

This project is still under early development and you may use at your own risk.

## Features

- Auto format with `:GoFormat` when saving
- Run linters with `:GoLint` (via `golangci-lint`) automatically
- Quickly test with `:GoTestFunc` and `:GoTestFile`

### LSP Client

We recommend `gopls` LSP client to handle the following:
- Code Completion
- Definitions, references, and other language parts
- Diagnosis

## Installation

Neovim nightly (0.5) is required for `nvim-go` to work.

With vim-plug:
```viml
-- dependencies
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
-- nvim-go
Plug 'crispgm/nvim-go'
-- LSP client config
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

- [x] Setup
  - [x] Options
  - [x] GoInstallBinaries
- [x] Format
  - [x] GoFormat: format with formatter
  - [x] Gofmt
  - [x] Goimports
  - [x] Gofumpt
  - [x] auto command
- [x] Lint
  - [x] show quickfix
  - [x] GoLint: lint with linter
  - [x] Golint
  - [x] Errcheck
  - [x] staticcheck
  - [x] Golangci-lint
  - [x] auto command
- [x] Test
  - [x] show test result with popup window
  - [x] GoTestFunc
  - [x] GoTestFile
  - [x] GoTestOpen

### v0.2

- [ ] Import
  - [x] GoGet
  - [ ] GoImport
  - [ ] GoImportDoc
  - [ ] GoImportOpen
- [ ] Struct Tag
- [ ] GoTest: GoTestPkg
- [ ] GoRename
- [ ] GoImpl
- [ ] Paste as JSON
- [ ] GoLint: show virtual text
