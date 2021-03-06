# nvim-go (WIP)

[![build](https://github.com/crispgm/nvim-go/actions/workflows/ci.yml/badge.svg)](https://github.com/crispgm/nvim-go/actions/workflows/ci.yml)

A minimal implementation of Golang development plugin, which handles features LSP not provide.

Neovim 0.5 embeds a built-in LSP and we are able to do most of vim-go's features by LSP client like `gopls`.

## Features

## Installation

Neovim nightly (0.5) is required for `nvim-go` to work.

With vim-plug:
```viml
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'crispgm/nvim-go'
```

Run `:GoInstallBinaries` after plugin installed.

## Usage

Setup:
```lua
require('go').setup{}
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

### Work with LSP

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
- [ ] Import
  - [x] GoGet
  - [ ] GoImport
  - [ ] GoImportDoc
  - [ ] GoImportOpen
- [ ] Struct Tag

### v0.2

- [ ] GoTest: GoTestPkg
- [ ] GoLint: show virtual text
- [ ] GoImpl
- [ ] Paste as JSON
