.PHONY: default vim-plug install update ycm

default: vim-plug plugins nvim
	@echo "==> If $(HOME)/.vimrc exists, you may want to remove it."

nvim:
	@ln -svnf $(CURDIR) $(XDG_CONFIG_HOME)/nvim

vim-plug:
	@echo "==> Downloading vim-plug"
	@$(DLCMD) $(CURDIR)/autoload/plug.vim \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

plugins-update:
	@echo "==> Updating plugins"
	@vim -u $(CURDIR)/vimrc +PlugUpgrade +PlugUpdate +qall

plugins: vim-plug
	@echo "==> Installing plugins"
	@vim -u $(CURDIR)/vimrc +PlugUpgrade +PlugInstall +qall

clean:
	@echo "==> Removing installed plugins"
	@$(RM) -rf $(CURDIR)/bundle $(CURDIR)/plugged
	@echo "==> Removing vim-plug"
	@$(RM) -rf $(CURDIR)/autoload/plug.vim

WGET := $(shell command -v wget;)
CURL := $(shell command -v curl;)

ifdef WGET
	DLCMD := $(WGET) -O
else ifdef CURL
	DLCMD := $(CURL) -sLo
else
	@echo "Neither curl nor wget are installed"
	exit
endif
