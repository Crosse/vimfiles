"""""""""""""""""""""""""""""""""""""""""""""""""
"                                               "
"           vim-plug and Vim plugins            "
"                                               "
"""""""""""""""""""""""""""""""""""""""""""""""""

function! crosse#plugins#load() abort
    if g:os.is_windows
        let s:vimdir = glob("$HOME/vimfiles")
    elseif g:os.is_unix || g:os.is_mac
        let s:vimdir = glob("$HOME/.vim")
    else
        echom "Unable to determine the location of your Vim home!"
    endif

    if empty(glob(s:vimdir. "/autoload/plug.vim"))
        echom "Vim-plug not found"
        return
    endif

    if has('nvim') && exists('+termguicolors')
        set termguicolors
    endif

    filetype off

    call plug#begin()

    """""""""""""""""""""""""""""""""""""""""""""""""
    "                                               "
    "               language support                "
    "                                               "
    """""""""""""""""""""""""""""""""""""""""""""""""

    """""""""""""""""""""""""""""""""""""""""""""""""
    "             language server spec              "
    "                                               "
    " http://langserver.org is an emerging standard "
    " for performing language-specific actions in a "
    " standard way for any client (Vim, Emacs,      "
    " VSCode, etc.) to use.                         "
    """""""""""""""""""""""""""""""""""""""""""""""""

    " Asynchronous Lint Engine, with language client support
    Plug 'w0rp/ale'
    let g:ale_fix_on_save = 1
    let g:ale_completion_enabled = 1
    let g:airline#extensions#ale#enabled = 1
    let g:ale_echo_msg_error_str = 'E'
    let g:ale_echo_msg_warning_str = 'W'
    let g:ale_echo_msg_format = '[%linter%: %severity%] %s %code%'
    let g:ale_linters = {
                \ 'c':      ['clangtidy', 'cppcheck'],
                \ 'go':     ['gometalinter', 'gofmt'],
                \ 'python': ['flake8', 'mypy', 'pydocstyle', 'pylint', 'pyls'],
                \ 'rust':   ['rls'],
                \}
    let g:ale_fixers = {
                \ 'c':      ['remove_trailing_lines', 'trim_whitespace'],
                \ 'go':     ['gofmt', 'goimports', 'remove_trailing_lines', 'trim_whitespace'],
                \ 'python': ['add_blank_lines_for_python_control_statements', 
                \            'yapf', 'isort', 'remove_trailing_lines', 'trim_whitespace'],
                \ 'rust':   ['rustfmt', 'remove_trailing_lines', 'trim_whitespace'],
                \}

    let g:ale_go_gometalinter_options = '--fast'
    let $PATH = $PATH . ':' . fnamemodify(g:python3_host_prog, ':p:h')
    let g:ale_rust_rls_toolchain = 'stable'
    let g:ale_python_pyls_executable = 'pipenv'
    let g:ale_python_pyls_options = '-vv --log-file ' . tempname()
    let g:ale_cmake_cmakelint_options = '--linelength=120'

    let s:cppcheck_suppressions_file = expand('~/.config/cppcheck/suppressions')
    if filereadable(s:cppcheck_suppressions_file)
        let g:ale_c_cppcheck_options = '-I include/ -I common/include/ --enable=all --inline-suppr --suppressions-list=' . s:cppcheck_suppressions_file
    endif

    " The de facto Go plugin for Vim.
    Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
"    let g:go_fmt_command = "goimports"
    let g:go_fmt_autosave = 0
"    let g:go_auto_type_info = 1
    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_fields = 1
    let g:go_highlight_types = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_interfaces = 1
    let g:go_highlight_structs = 1
    let g:go_highlight_build_constraints = 1
"    let g:go_list_type = "quickfix"
    au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
"    au FileType go setlocal noexpandtab shiftwidth=8

    " Ideally, using a Go language server would be the best option.
    " However, the current Go LS doesn't support completion; instead,
    " let's use gocode, which is "an autocompletion daemon for the Go
    " programming language.  This hooks into nvim-completion-manager.
    Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh', 'for': 'go' }

    Plug 'rust-lang/rust.vim', {'for': 'rust'}              " The de facto Rust plugin for Vim.
    let g:rustfmt_autosave = 1                              " Run rustfmt on buffer save

    Plug 'kovisoft/slimv', { 'for': 'lisp' }                " Lisp support. Because, why not?
    let g:slimv_swank_cmd = '!tmux new-window -d -n REPL-SBCL "sbcl --load ~/.vim/plugged/slimv/slime/start-swank.lisp"'

    Plug 'elixir-editors/vim-elixir', { 'for': 'elixir' }   " Support for the Elixir language.

    Plug 'elzr/vim-json', {'for': 'json'}                   " A better JSON plugin for Vim
    let g:vim_json_syntax_conceal = 0                       " ...but disable quote concealment, because wtf

    Plug 'guns/vim-sexp'                                    " Precision Editing for S-expressions
    Plug 'tpope/vim-repeat'                                 " enable repeating supported plugin maps with '.'

    Plug 'tpope/vim-fireplace', {'for': 'clojure'}          " Clojure REPL support
    Plug 'clojure-vim/vim-cider', {'for': 'clojure'}        " Additional IDE-like functionality for Clojure development using cider-nrepl


    """""""""""""""""""""""""""""""""""""""""""""""""
    "                                               "
    "          general development support          "
    "                                               "
    """""""""""""""""""""""""""""""""""""""""""""""""

    Plug 'editorconfig/editorconfig-vim'                    " EditorConfig plugin for Vim (see http://editorconfig.org)
    Plug 'tpope/vim-fugitive'                               " a Git wrapper so awesome, it should be illegal
    Plug 'airblade/vim-gitgutter'                           " Shows a git diff in the gutter.
    Plug 'rhysd/committia.vim'                              " More pleasant editing of commit messages

    if executable('ctags') || executable('exctags')
        " Vim plugin that displays tags in a window, ordered by scope
        " https://github.com/majutsushi/tagbar
        "Plug 'majutsushi/tagbar', { 'on': [ 'Tagbar', 'TagbarToggle', 'TagbarOpen' ] }
        Plug 'majutsushi/tagbar'
        nmap <leader>t :TagbarToggle<CR>
        nmap <F8> :TagbarToggle<CR>

        let g:tagbar_autoclose=1

        " tagbar relies on Exuberant Ctags. If 'ctags' is not this (as
        " is the case on OSX and other BSD variants), then invoking
        " tagbar will fail with an error explaining this.
        "
        " With that in mind, use exctags if it exists. (On OSX, this is
        " installed by pkgsrc.) Other versions of ctags with different
        " names could be handled similarly.
        if executable('exctags')
            let g:tagbar_ctags_bin = 'exctags'
        endif
    endif

    Plug 'luochen1990/rainbow'
    let g:rainbow_active = 1

    nnoremap <F7> :RainbowToggle<CR>
    inoremap <F7> <C-O>:RainbowToggle<CR>

    Plug 'jsfaint/gen_tags.vim'                             " Async plugin for vim and neovim to ease the use of ctags/gtags.
    let g:loaded_gentags#ctags = 1                          " If true, Disable ctags support.
    let g:gen_tags#use_cache_dir = 1                        " If false, store tags files in SCM dir (or ~/.cache, if not in an SCM repo).
    let g:gen_tags#gtags_split = 'v'                        " Split vertically on find.
    let g:gen_tags#gtags_auto_gen = 1                       " if true, auto-generate gtags if in an SCM repo.

    Plug 'jaxbot/semantic-highlight.vim'                    " Semantic Highlighting for Vim

    Plug 'vim-scripts/paredit.vim'                          " Add or remove matched characters in pairs.
    Plug 'tpope/vim-surround'                               " quoting/parenthesizing made simple
    Plug 'tpope/vim-repeat'                                 " enable repeating supported plugin maps with '.'

    """""""""""""""""""""""""""""""""""""""""""""""""
    "                                               "
    "       simple syntax/indentation plugins       "
    "                                               "
    """""""""""""""""""""""""""""""""""""""""""""""""

    " vim-systemd-syntax - because I hate myself, but not that much
    Plug 'Matt-Deacalion/vim-systemd-syntax', { 'for': 'systemd' }

    Plug 'ekalinin/Dockerfile.vim', {'for': 'Dockerfile'}   " Vim syntax file for Docker's Dockerfile
    Plug 'cespare/vim-toml', {'for': 'toml'}                " Vim syntax for TOML
    Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}           " Vim syntax highlighting for .tmux.conf

    Plug 'tpope/vim-markdown', {'for': ['markdown', 'COMMIT_EDITMSG', 'PULLREQ_EDITMSG']}
    let g:markdown_syntax_conceal = 0
    let g:markdown_fenced_languages = [ 'html', 'python', 'bash=sh', 'sh', 'vim', 'viml=vim' ]

    Plug 'mfukar/robotframework-vim'


    """""""""""""""""""""""""""""""""""""""""""""""""
    "                                               "
    "               visual stylings                 "
    "                                               "
    """""""""""""""""""""""""""""""""""""""""""""""""

    Plug 'ryanoasis/vim-devicons'                           " Adds file type glyphs/icons to popular Vim plugins
    Plug 'chriskempson/base16-vim'                          " Base16 theme(s) for Vim.

    Plug 'RRethy/vim-illuminate'                            " Selectively illuminate other uses of the current word
    let g:Illuminate_delay = 500
    let g:Illuminate_ftblacklist = ['nerdtree', 'COMMIT_EDITMSG']
    highlight link illuminatedWord Visual                   " ...and use the Visual style instead of cursorline style

    " lean & mean status/tabline for vim that's light as air
    Plug 'vim-airline/vim-airline'
                \ | Plug 'vim-airline/vim-airline-themes'   " Airline themes live in a separate repo
    let g:airline#extensions#tabline#enabled = 1
    if !exists("g:airline_symbols")
        let g:airline_symbols = {}                          " Set custom symbols to use.
    endif
    " If using a font with Powerline support, these will look fantastic.
    " If not, get ready for the Unicode box-o-wtf all over the place.
    " Fonts with support for the Powerline glyphs include Source Code
    " Pro and Fira Code.
    let g:airline_left_alt_sep = ''
    let g:airline_left_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.linenr = ''
    let g:airline_symbols.paste = '[paste]'
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.whitespace = 'Ξ'
    set noshowmode                                          " Since airline shows the mode, there's no reason to show it again.

    Plug 'Yggdroot/indentLine'                              " A vim plugin to display the indention levels with thin vertical lines

    " A tree explorer plugin for Vim.
    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
    Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' } " ...and a git plugin for NERDTree.
    map <C-N> :NERDTreeToggle<CR>                           " Toggle NERDTree using Ctrl-N


    """""""""""""""""""""""""""""""""""""""""""""""""
    "                                               "
    "          general Vim enhancements             "
    "                                               "
    """""""""""""""""""""""""""""""""""""""""""""""""

    Plug 'ctrlpvim/ctrlp.vim'                               " Fuzzy file, buffer, mru, tag, etc finder. You need this.
    let g:ctrlp_show_hidden=1                               " Show hidden files and folders
    let g:ctrlp_custom_ignore = {
                \ 'file': 'Cargo\.lock'
                \}

    if has('python') || has('python3')
        Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }       " Visualize your Vim undo tree.
        map <silent> <F4> :GundoToggle<CR>                  " Use F4 to toggle the Gundo pane
        imap <silent> <F4> <C-O>:GundoToggle<CR>
    endif

    Plug 'tmux-plugins/vim-tmux-focus-events'               " Make terminal vim and tmux work better together.
    Plug 'roxma/vim-tmux-clipboard'                         " seamless integration for vim and tmux's clipboard.
    Plug 'jremmen/vim-ripgrep'                              " Use RipGrep in Vim and display results in a quickfix list


    """""""""""""""""""""""""""""""""""""""""""""""""
    "                                               "
    "               YouCompleteMe.                  "
    "   (That's right, it gets its own section.)    "
    """""""""""""""""""""""""""""""""""""""""""""""""
    if has('python') || has('python3')
        let ycm_install_command = ['./install.py']
        call add(ycm_install_command, '--clang-completer')
        Plug 'Valloric/YouCompleteMe',
                    \ { 'frozen': 1,
                    \   'do': join(ycm_install_command),
                    \    'for': ['c', 'cpp']
                    \ }
        let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
        let g:ycm_autoclose_preview_window_after_insertion = 1
"        let g:ycm_key_list_select_completion = ['<Down>']
    endif

    " All plugins must be added before the following line.
    call plug#end()
endfunction
