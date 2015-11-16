.PHONY: install update ycm

install:
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
