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
    linter = 'golint',
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

- [x] Setup
  - [x] Options
  - [x] GoInstallBinaries
- [x] Format
  - [x] GoFormat: format with formatter
  - [x] Gofmt
  - [x] Goimports
  - [x] Gofumpt
  - [x] auto command
- [ ] Lint
  - [x] show quickfix
  - [ ] show virtual text
  - [x] GoLint: lint with linter
  - [x] Golint
  - ~~Govet~~ supported by LSP
  - [x] Errcheck
  - [x] staticcheck
  - [ ] Golangci-lint
  - [x] auto command
- [ ] Test
  - [x] show test result with popup window
  - [x] GoTestFunc
  - [x] GoTestFile
  - [ ] GoTestPkg
  - [x] GoTestOpen
- [ ] Import
  - [x] GoGet
  - [ ] GoImport
  - [ ] GoImportDoc
  - [ ] GoImportOpen
- [ ] Struct Tag
- [ ] Paste as JSON
- [ ] Impl
