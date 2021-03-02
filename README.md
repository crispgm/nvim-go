# nvim-go (WIP)

A minimal implementation of Golang development plugin, which handles features LSP not provide.

Neovim 0.5 embeds a built-in LSP and we are able to do most of vim-go's features by LSP client like `gopls`.

## Features

## Installation

Neovim nightly (0.5) is required for `nvim-go` to work.

Vim-plug:
```viml
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'crispgm/nvim-go'
```

## Usage

### Work with LSP

## Plan

- [ ] Setup
  - [ ] Options
  - [ ] GoInstallBinaries
  - [ ] GoUpdateBinaries
- [ ] Format
  - [ ] GoFormat: format with formatter
  - [x] GoFmt: run `gofmt`
- [ ] Lint
  - [ ] GoMetaLint
  - [ ] GoLint
- [ ] Test
  - [ ] GoTestFunc
  - [ ] GoTestFile
  - [ ] GoTestPkg
  - [ ] GoTestOpen
- [ ] Import
  - [ ] GoImport
  - [ ] GoImportDoc
  - [ ] GoImportOpen
- [ ] Tag
- [ ] Impl
