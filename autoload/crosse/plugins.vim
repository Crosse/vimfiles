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

    if has('nvim')
        "set termguicolors
    endif

    filetype off
    let g:plug_window = 'botright new | resize 15'

    call plug#begin()

    " Load plugins here.

    " lean & mean status/tabline for vim that's light as air
    Plug 'vim-airline/vim-airline'
                \ | Plug 'vim-airline/vim-airline-themes'
    let g:airline#extensions#tabline#enabled = 1

    " Set custom symbols to use.
    if !exists("g:airline_symbols")
        let g:airline_symbols = {}
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

    " a Git wrapper so awesome, it should be illegal
    Plug 'tpope/vim-fugitive'

    " A vim plugin to display the indention levels with thin vertical lines
    Plug 'Yggdroot/indentLine'

    " Go development plugin for Vim
    Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': 'go' }
    let g:go_fmt_command = "goimports"
    let g:go_fmt_autosave = 1
    let g:go_auto_type_info = 1
    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_fields = 1
    let g:go_highlight_types = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_interfaces = 1
    let g:go_highlight_structs = 1
    let g:go_highlight_build_constraints = 1
    let g:go_list_type = "quickfix"
    au FileType go nmap <Leader>gb <Plug>(go-doc-browser)

    " Syntax checking hacks for vim
    Plug 'scrooloose/syntastic'
    let g:syntastic_go_checkers = ['golint', 'govet', 'go', 'errcheck']
    let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    " I only want to use one checker for Python, and I want to use them
    " in this order. Find the first available one and use that
    " exclusively. (Maybe this isn't needed.)
    for pychecker in ['flake8', 'pyflake', 'pylint']
        if executable(pychecker)
            let g:syntastic_python_checkers = [pychecker]
            break
        endif
    endfor

    " A tree explorer plugin for Vim.
    " ...and a git plugin for NERDTree.
    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
                \ | Plug 'Xuyuanp/nerdtree-git-plugin'

    " Exit Vim when NERDTree is the only window open.
    " autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    " Open NERDTree automatically when Vim starts.
    "autocmd VimEnter * if exists("loaded_nerd_tree") | NERDTree | endif
    "autocmd StdinReadPre * let s:std_in=1
    "autocmd VimEnter * if (exists("loaded_nerd_tree") && argc() == 0 && !exists("s:std_in")) | NERDTree | endif

    " Toggle NERDTree using Ctrl-N
    map <C-N> :NERDTreeToggle<CR>

    " Plugins that require Python support hide here.
    if has('python') || has('python3')
        " YouCompleteMe, a code-completion engine for Vim
        " The following if-statements build up a command line depending
        " on whether various things are installed. For instance, if
        " msbuild is installed, then instruct YCM's installer to build
        " the OmniSharp completer.
        if g:os.is_windows
            let ycm_install_command = ['install.py']
        else
            let ycm_install_command = ['./install.py']
        endif
        call add(ycm_install_command, '--clang-completer')

        if executable('msbuild.exe') || executable('xbuild')
            call add(ycm_install_command, '--omnisharp-completer')
        endif

        if executable('go')
            call add(ycm_install_command, '--gocode-completer')
        endif

        if executable('node') && executable('npm')
            call add(ycm_install_command, '--tern-completer')
        endif

        if executable('cargo')
            call add(ycm_install_command, '--racer-completer')
        endif

        Plug 'Valloric/YouCompleteMe', { 'do': join(ycm_install_command) }
                    \ | Plug 'rdnetto/YCM-Generator', { 'branch': 'stable', 'on': 'YcmGenerateConfig'}
        let g:ycm_key_list_select_completion = ['<Down>']
        let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
        let g:ycm_autoclose_preview_window_after_insertion = 1
        " This is the end of the YCM stuff.

        " EditorConfig plugin for Vim (see http://editorconfig.org)
        Plug 'editorconfig/editorconfig-vim'

        " Visualize your Vim undo tree.
        Plug 'sjl/gundo.vim'
        map <silent> <F4> :GundoToggle<CR>
        imap <silent> <F4> <C-O>:GundoToggle<CR>

        Plug 'kovisoft/slimv', { 'for': 'lisp' }
        let g:slimv_swank_cmd = '!tmux new-window -d -n REPL-SBCL "sbcl --load ~/.vim/plugged/slimv/slime/start-swank.lisp"'
    endif

    if executable('ctags') || executable('exctags')
        " Vim plugin that displays tags in a window, ordered by scope
        " https://github.com/majutsushi/tagbar
        Plug 'majutsushi/tagbar'
        nmap <leader>t :TagbarToggle<CR>

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

    " vim-systemd-syntax - because I hate myself, but not that much
    Plug 'Matt-Deacalion/vim-systemd-syntax', { 'for': 'systemd'}

    " Vim syntax file for Docker's Dockerfile
    Plug 'ekalinin/Dockerfile.vim', {'for': 'Dockerfile'}

    " Vim syntax for TOML
    Plug 'cespare/vim-toml', {'for': 'toml'}

    " Fuzzy file, buffer, mru, tag, etc finder. You need this.
    Plug 'ctrlpvim/ctrlp.vim'
    let g:ctrlp_show_hidden=1

    " Vim syntax highlighting for .tmux.conf
    Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}
                \ | Plug 'tmux-plugins/vim-tmux-focus-events'

    " A better JSON plugin for Vim
    Plug 'elzr/vim-json', {'for': 'json'}
    " ...but disable quote concealment
    let g:vim_json_syntax_conceal = 0

    " Vim configuration for Rust.
    Plug 'rust-lang/rust.vim', {'for': 'rust'}
    " Run rustfmt on buffer save
    let g:rustfmt_autosave = 1

    " Shows a git diff in the gutter.
    Plug 'airblade/vim-gitgutter'

    " Adds file type glyphs/icons to popular Vim plugins<Paste>
    Plug 'ryanoasis/vim-devicons'

    Plug 'xolox/vim-misc'
                \ | Plug 'xolox/vim-easytags'

    let g:easytags_async = 1
    let g:easytags_auto_highlight = 0
    let g:easytags_autorecurse = 0
    let g:easytags_dynamic_files = 1
    let g:easytags_by_filetype = '~/.cache/nvim/tags/by-filetype'

    " Base16 theme(s) for Vim.
    Plug 'chriskempson/base16-vim'

    " All plugins must be added before the following line.
    call plug#end()

    " Brief help
    " :PlugStatus        - Check the status of plugins
    " :PlugInstall       - install plugins
    " :PlugUpdate        - update plugins
    " :PlugUpgrade       - update vim-plug itself
    " :PlugClean(!)      - confirm (or auto-approve) removal of unused plugins
    "
    " see https://github.com/junegunn/vim-plug for more information.
endfunction
