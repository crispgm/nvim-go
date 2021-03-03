# nvim-go (WIP)

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

## Usage

Setup:
```lua
require('go').setup{}
```

Defaults:
```lua
require('go').setup{
    linter = 'golint',
    -- formatter: goimports, gofmt
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

- [ ] Setup
  - [x] Options
  - [ ] GoInstallBinaries
  - [ ] GoUpdateBinaries
- [ ] Format
  - [x] GoFormat: format with formatter
  - [x] GoFmt: run `gofmt`
  - [x] GoImports: run `goimports`
  - [ ] Gofumpt
  - [x] auto command
- [ ] Lint
  - [x] show quickfix
  - [x] show virtual text (there is bug)
  - [ ] GoLint
  - [ ] Golint
  - [ ] Govet
  - [ ] Errcheck
  - [ ] Golangci-lint
  - [x] auto command
- [ ] Test
  - [x] show test result with popup window
  - [x] GoTestFunc
  - [x] GoTestFile
  - [ ] GoTestPkg
  - [x] GoTestOpen
- [ ] Import
  - [ ] GoImport
  - [ ] GoImportDoc
  - [ ] GoImportOpen
- [ ] Struct Tag
- [ ] Paste as JSON
- [ ] Impl
