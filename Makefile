PY2_VER := 2.7.11
PY3_VER := 3.6.1
RUBY_VER := 2.3.1

default: help

include mk/cross-platform.mk
include mk/anyenv.mk
include mk/python.mk
include mk/ruby.mk

build: 			## Install vim-plug, plugins, and neovim.
build: neovim vim-plug plugins

neovim:			##@neovim Meta-target to set up neovim.
neovim: pysetup $(RBENV_PATH)/versions/$(RUBY_VER)
	@ln -svnf $(CURDIR) $(XDG_CONFIG_HOME)/nvim

pysetup:		##@neovim Create Neovim-specific Python virtualenvs.
pysetup: neovim-py2env neovim-py3env
	@mkdir -p $(CURDIR)/autoload/crosse
	@echo "function! crosse#python#load() abort" > $(CURDIR)/autoload/crosse/python.vim
	@echo "  let g:python_host_prog = '$(PYENV_PATH)/versions/neovim2/bin/python'" >> $(CURDIR)/autoload/crosse/python.vim
	@echo "  let g:python3_host_prog = '$(PYENV_PATH)/versions/neovim3/bin/python'" >> $(CURDIR)/autoload/crosse/python.vim
	@echo "endfunction" >> $(CURDIR)/autoload/crosse/python.vim

neovim-py2env: |$(PYENV_PATH)/versions/$(PY2_VER) pyenv-virtualenv $(PYENV_PATH)/versions/neovim2
	@$(PYENV_PATH)/versions/neovim2/bin/pip install neovim python-language-server

neovim-py3env: |$(PYENV_PATH)/versions/$(PY3_VER) pyenv-virtualenv $(PYENV_PATH)/versions/neovim3
	@$(PYENV_PATH)/versions/neovim3/bin/pip install neovim flake8 python-language-server
	@ln -svf $(PYENV_PATH)/versions/neovim3/bin/flake8 ${HOME}/bin/flake8

$(PYENV_PATH)/versions/neovim2:
	@pyenv virtualenv $(PY2_VER) neovim2
$(PYENV_PATH)/versions/neovim3:
	@pyenv virtualenv $(PY3_VER) neovim3

vim-plug:		##@plugins Download vim-plug
vim-plug: $(CURDIR)/autoload
	@echo "==> Downloading vim-plug"
	@$(DOWNLOADER) $(DL_OPTS) \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
	    > $(CURDIR)/autoload/plug.vim

plugins-update:		##@plugins Upgrade vim-plug and update all plugins
plugins-update:
	@echo "==> Updating plugins"
	@vim -u $(CURDIR)/vimrc +PlugUpgrade +PlugUpdate +qall

plugins:		##@plugins Install vim-plug and plugins
plugins: vim-plug
	@echo "==> Installing plugins"
	@vim -u $(CURDIR)/vimrc +PlugUpgrade +PlugInstall +qall

clean:			## Remove all installed plugins and vim-plug
clean:
	@echo "==> Removing installed plugins"
	@$(RM) -rf $(CURDIR)/plugged $(CURDIR)/plugged
	@echo "==> Removing vim-plug"
	@$(RM) -rf $(CURDIR)/autoload/plug.vim
	@echo "==> Removing neovim python autoload file"
	@$(RM) -f $(CURDIR)/autoload/python.vim

$(CURDIR)/autoload:
	@mkdir -p $@

.PHONY: default build neovim pysetup neovim-py2env neovim-py3env vim-plug plugins-update plugins clean

