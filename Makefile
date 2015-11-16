.PHONY: vim-plug install update ycm

default: update install

vim-plug:
	@echo "==> Downloading vim-plug"
	@$(DLCMD) autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

install: vim-plug
	@echo "==> Symlinking Vim config files into $(HOME)"
	@ln -sfn "$(CURDIR)/.vimrc" "$(HOME)/.vimrc"
	@ln -sfn "$(CURDIR)/" "$(HOME)/.vim"
	@echo "Be sure to 'make update' if necessary."

update:
	@echo "==> Updating local repo from remote"
	@git pull --rebase
	@echo "==> Updating submodules"
	@git submodule update --init --recursive

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
