.PHONY: update ycm

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



