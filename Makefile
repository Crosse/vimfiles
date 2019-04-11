VIM ?= $(shell command -v vim;)
SHELL := bash

default: help

include mk/cross-platform.mk

build: 			## Install vim-plug and plugins.
build: vim-plug plugins

neovim:			## Set up neovim.
neovim: $(XDG_CONFIG_HOME)/nvim pysetup

$(XDG_CONFIG_HOME)/nvim:
	@ln -snf $(CURDIR) $^

pysetup:		## Setup Python for Vim/Neovim.
pysetup: python2 python3 autoload/crosse/python.vim

python2:		## Install prerequisites for Python2 support.
python2: python/py2/.Pipfile.installed
python/py2/.Pipfile.installed:
	@echo "==> Installing prerequisites for Python 2 support"
	@cd "$(@D)" && pipenv install
	@touch "$@"

python3:		## Install prerequisites for Python3 support.
python3: python/py3/.Pipfile.installed
python/py3/.Pipfile.installed:
	@echo "==> Installing prerequisites for Python 3 support"
	@cd "$(@D)" && pipenv install
	@touch "$@"

autoload/crosse/python.vim:
	@echo "Telling Vim where to look for its Python interpreters"
	@mkdir -p "$(@D)"
	@echo "function! crosse#python#load() abort" > "$@"
	@echo "  let g:python_host_prog = '$(shell cd python/py2 && pipenv --py)'" >> "$@"
	@echo "  let g:python3_host_prog = '$(shell cd python/py3 && pipenv --py)'" >> "$@"
	@echo "endfunction" >> "$@"

vim-plug:		##@plugins Download vim-plug
vim-plug: autoload/plug.vim

autoload/plug.vim:
	@echo "==> Downloading vim-plug"
	@$(DOWNLOADER) $(DL_OPTS) \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
	    > $(CURDIR)/autoload/plug.vim

plugins-update:		##@plugins Upgrade vim-plug and update all plugins
plugins-update:
	@echo "==> Updating plugins"
	@$(VIM) +PlugUpgrade +PlugUpdate +qall

plugins:		##@plugins Install vim-plug and plugins
plugins: vim-plug
	@echo "==> Installing plugins"
	@$(VIM) +PlugUpgrade +PlugInstall +qall

clean:			## Remove all installed plugins and vim-plug
clean:
	@echo "==> Removing installed plugins"
	@$(RM) -rf $(CURDIR)/plugged $(CURDIR)/plugged
	@echo "==> Removing vim-plug"
	@$(RM) -rf $(CURDIR)/autoload/plug.vim
	@echo "==> Removing neovim python autoload file"
	@$(RM) -f $(CURDIR)/autoload/python.vim


.PHONY: default build neovim python2 python3 pysetup vim-plug plugins-update plugins clean
