.PHONY: default vim-plug install update ycm

default: update install

vim-plug:
	@echo "==> Downloading vim-plug"
	@$(DLCMD) $(CURDIR)/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

install: vim-plug plugins
	@echo "==> Symlinking Vim config files into $(HOME)"
	@ln -sfn "$(CURDIR)/.vimrc" "$(HOME)/.vimrc"
	@ln -sfn "$(CURDIR)/" "$(HOME)/.vim"

plugins: vim-plug
	@echo "==> Installing plugins"
	@vim -u $(CURDIR)/.vimrc +PlugUpgrade +PlugInstall +qall

update:
	@echo "==> Updating local repo from remote"
	@git pull --rebase
	@echo "==> Updating submodules"
	@git submodule update --init --recursive

clean:
	@echo "==> Removing installed plugins"
	@$(RM) -rf $(CURDIR)/bundle $(CURDIR)/plugged
	@echo "==> Removing vim-plug"
	@$(RM) -rf $(CURDIR)/autoload/plug.vim

ycm:
	@echo "==> Building YouCompleteMe"
	@$(CURDIR)/bundle/YouCompleteMe/install.py	\
			--clang-completer		\
			--gocode-completer		\
			--omnisharp-completer


WGET := $(shell command -v wget)
CURL := $(shell command -v curl)

ifdef WGET
	DLCMD := $(WGET) -O
else ifdef CURL
	DLCMD := $(CURL) -sLo
else
	@echo "Neither curl nor wget are installed"
	exit
endif
