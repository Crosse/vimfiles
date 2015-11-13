.PHONY: update_git update_repo submodules ycm

update_git: update_repo submodules

update_repo:
	@echo "==> Updating local repo"
	@git pull --rebase


submodules:
	@echo "==> Updating submodules"
	@git submodule update --init --recursive

ycm:
	@echo "==> Building YouCompleteMe"
	@$(CURDIR)/bundle/YouCompleteMe/install.py	\
			--clang-completer		\
			--gocode-completer		\
			--omnisharp-completer



