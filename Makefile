default: help

build: 		## Install vim-plug, plugins, and nvim
build: vim-plug plugins nvim

nvim:		## Symlink ${XDG_CONFIG_HOME}/nvim to this directory
nvim:
	@ln -svnf $(CURDIR) $(XDG_CONFIG_HOME)/nvim

vim-plug:	##@plugins Download vim-plug
vim-plug: $(CURDIR)/autoload
	@echo "==> Downloading vim-plug"
	@$(DOWNLOADER) $(DL_OPTS) \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
	    > $(CURDIR)/autoload/plug.vim

plugins-update:	##@plugins Upgrade vim-plug and update all plugins
plugins-update:
	@echo "==> Updating plugins"
	@vim -u $(CURDIR)/vimrc +PlugUpgrade +PlugUpdate +qall

plugins:	##@plugins Install vim-plug and plugins
plugins: vim-plug
	@echo "==> Installing plugins"
	@vim -u $(CURDIR)/vimrc +PlugUpgrade +PlugInstall +qall

clean:		## Remove all installed plugins and vim-plug
clean:
	@echo "==> Removing installed plugins"
	@$(RM) -rf $(CURDIR)/bundle $(CURDIR)/plugged
	@echo "==> Removing vim-plug"
	@$(RM) -rf $(CURDIR)/autoload/plug.vim

$(CURDIR)/autoload:
	mkdir -p $@

.PHONY: default build info vim-plug plugins-update plugins clean

include mk/cross-platform.mk
