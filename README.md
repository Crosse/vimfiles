# Vim/Nvim Configuration Files

## Installation

1. Clone this repo to `~/.vim`:

    ```console
    $ git clone git@github.com/Crosse/vimfiles.git ${HOME}/.vim
    ```

1. Use `make build` to build everything.


## Usage

Run `make` or `make help` to see all the targets the Makefile provides.

```console
usage: make [target]

neovim:
  neovim                          Meta-target to set up neovim.
  pysetup                         Create Neovim-specific Python virtualenvs.

options:
  build                           Install vim-plug, plugins, and neovim.
  clean                           Remove all installed plugins and vim-plug

other:
  help                            Show this help.

plugins:
  vim-plug                        Download vim-plug
  plugins-update                  Upgrade vim-plug and update all plugins
  plugins                         Install vim-plug and plugins
```
