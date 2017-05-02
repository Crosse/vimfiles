PYENV := $(shell command -v pyenv;)
PYENV_ROOT := $(shell pyenv root)
PY2_VER := 2.7.11
PY3_VER := 3.6.1
RBENV := $(shell command -v rbenv;)
RBENV_ROOT := $(shell rbenv root)
RUBY_VER := 2.3.1

default: help

build: 			## Install vim-plug, plugins, and neovim.
build: neovim vim-plug plugins

neovim:			##@neovim Meta-target to set up neovim.
neovim: pysetup neovim-ruby
	@ln -svnf $(CURDIR) $(XDG_CONFIG_HOME)/nvim

neovim-py2env: $(PYENV_ROOT)/versions/neovim2
$(PYENV_ROOT)/versions/neovim2:
ifdef PYENV
	$(PYENV) install -s $(PY2_VER)
	$(PYENV) virtualenv $(PY2_VER) neovim2
else
	$(error pyenv not installed, or not found in $$PATH)
endif

neovim-py3env: $(PYENV_ROOT)/versions/neovim3
$(PYENV_ROOT)/versions/neovim3:
ifdef PYENV
	$(PYENV) install -s $(PY3_VER)
	$(PYENV) virtualenv $(PY3_VER) neovim3
else
	$(error pyenv not installed, or not found in $$PATH)
endif

pysetup:		##@neovim Create Neovim-specific Python virtualenvs.
pysetup: neovim-py2env neovim-py3env
	$(PYENV_ROOT)/versions/neovim2/bin/pip install neovim
	$(PYENV_ROOT)/versions/neovim3/bin/pip install neovim flake8
	ln -svf $(PYENV_ROOT)/versions/neovim3/bin/flake8 ${HOME}/bin/flake8
	@echo "function! python#init()" > $(CURDIR)/autoload/python.vim
	@echo "  let g:python_host_prog = '$(PYENV_ROOT)/versions/neovim2/bin/python'" >> $(CURDIR)/autoload/python.vim
	@echo "  let g:python3_host_prog = '$(PYENV_ROOT)/versions/neovim3/bin/python'" >> $(CURDIR)/autoload/python.vim
	@echo "endfunction" >> $(CURDIR)/autoload/python.vim

neovim-ruby: $(RBENV_ROOT)/versions/$(RUBY_VER)
$(RBENV_ROOT)/versions/$(RUBY_VER):
ifdef RBENV
	# It'd be really nice if neovim had g:ruby_host_prog like it
	# does for Python (see above), but it doesn't. So this target is
	# sort of useless right now. I'm going to leave it in on the
	# change that g:ruby_host_prog gains steam and makes it into
	# neovim at some point.
	$(RBENV) install -s $(RUBY_VER)
	$(RBENV) local $(RUBY_VER)
	gem install neovim
else
	$(error rbenv not installed, or not found in $$PATH)
endif

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
	mkdir -p $@

.PHONY: default build neovim neovim-py2env neovim-py3env info vim-plug plugins-update plugins clean pysetup

include mk/cross-platform.mk
