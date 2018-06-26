""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim: set wildignore+=*/plugged/*:
"
" Copyright (c) 2009-2017 Seth Wright (seth@crosse.org)
"
" Permission to use, copy, modify, and distribute this software for any
" purpose with or without fee is hereby granted, provided that the above
" copyright notice and this permission notice appear in all copies.
"
" THE SOFTWARE IS PROVIDED 'AS IS' AND THE AUTHOR DISCLAIMS ALL WARRANTIES
" WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
" MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
" ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
" WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
" ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
" IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Things to note:
" * If you 'export EDITOR=vim' in your shell startup scripts and want to
"   be able to edit crontabs ('crontab -e'), you'll want to add the
"   following line to your .profile:
"
"     alias crontab="VIM_CRONTAB=true crontab"
"
"   This will disable some backup features that crontab (at least on Mac
"   OS X) does not like.  See http://goo.gl/LP6X0 for more information.

" * The following keys and their functions are defined below.  This
"   doesn't include everything; mostly just the 'convenience' keys.  If I
"   remapped a key just to change how it works slightly (like PageUp), but
"   it still works mostly the same way as before, I am not including it
"   here.
"
"   F2 - toggle spell check
"   F4 - toggle Gundo
"   F5 - toggle list mode; i.e., 'Show Codes'
"   F6 - execute 'make' in the current directory
"   F7 - toggle Rainbow Parentheses
"   F8 - toggle Tagbar (also <leader>t)
"   F9 - toggle nearest fold open and closed
"   F10 - toggle the fold column
"
"   Enter - in normal mode, disable search highlighting temporarily
"   Ctrl-Space - toggle nearest fold open and closed
"   Ctrl-Enter - same as 'O'; i.e., insert a line above the current line
"   Ctrl-J - mapped to 'tabnext'
"   Ctrl-K - mapped to 'tabprevious'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" This file isn't compatible with vi.
" Note: nvim ignores this. It is basically always set.
set nocompatible

" don't have files trying to override this .vimrc.  If you like adding
" modelines to files you edit, you may want to unset this.
"set nomodeline

" Clear any existing autocommands
if has("autocmd")
    autocmd!
endif

filetype plugin indent on

" GVim default window size
if has("gui_running") && !exists("g:loaded_WindowSizes")
    set lines=60
    set columns=120

    " Use this to not have GVim reset the window size every time you
    " reload this file (":so ~/.vimrc").
    let g:loaded_WindowSizes = 1
endif

if has("gui_running")
    " Turn off the toolbar
    set guioptions-=T
endif

let mapleader = ","

call crosse#init()

""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                "
"            Editor Visual Stylings              "
"                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable line numbering
set number

" Flash the window instead of beeping
set visualbell

" show matching brackets / parentheses
set showmatch

" Disable visual line-wrapping.  This does not prevent hard-wraps.
set nowrap

" Turn syntax highlighting on, if vim supports it
if has("syntax") && (&t_Co > 2 || has("gui_running"))
    syntax on

    " This sets up a 'gutter' line at 76 characters.
"    if exists("+colorcolumn")
"        set colorcolumn=76
"        highlight ColorColumn ctermbg=DarkCyan guibg=DarkCyan
"    endif

    if has("extra_search")
        " Turn on search highlighting
        set hlsearch
        " Use Enter in Normal mode to disable highlighing after searching
        nmap <silent> <CR> :nohlsearch<CR>
    endif
endif

" Enable folding.  This uses syntax folding (so your syntax file must
" support folding).  It doesn't start folded by default, and sets up a
" left-hand gutter of four columns dedicated to the folding structure.
" The fold column is hidden by default; you can make it visible with
" <F10>.
if has("folding")
    set foldmethod=syntax
    set foldnestmax=10
    set foldenable
    set foldcolumn=0
    set foldlevel=255

    " This toggles the nearest fold open and closed.
    map <F9> za
    imap <F9> <C-O>za

    " A function to toggle the fold column.
    map <F10> :call FoldColumnToggle()<CR>
    function! FoldColumnToggle()
        if &foldcolumn
            setlocal foldcolumn=0
        else
            setlocal foldcolumn=4
        endif
    endfunction
endif




""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                "
"                  Status Line                   "
"                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""

" use '[RO]' for '[readonly]' to save space in the message line:
set shortmess+=r

if has("cmdline_info")
    " display the current mode and partially-typed commands in the status
    " line:
    set showcmd
    " Always display the current cursor position in the lower right corner
    " of the Vim window.  Note that 'statusline' (below) takes precendence
    " over this option, but if you have a Vim that was not compiled with
    " 'statusline' at least you'll have a ruler...if it was compiled with
    " 'cmdline_info'.
    set ruler
endif

" Set up an informative status line.
if has("statusline") && !(exists("g:loaded_airline") && g:loaded_airline)
    if version >= 700
        set statusline=%-02.2n\ %t\ %y\ %m\ %r\ %L\ lines%=\ %lL,%cC\ \(%P\)
        " Always show the status line
        set laststatus=2
    endif
endif



""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                "
"                  Indentation                   "
"                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""

" use four spaces for each step of (auto)indent.
set shiftwidth=4
" hitting <Tab> will insert four spaces instead.
set softtabstop=4
" round indent to multiple of shiftwidth.
set shiftround
" use spaces instead of tabs to insert a tab.
set expandtab
" Copy indent from current line when starting a new line.
" Also deletes indents if nothing else is written on the line.
set autoindent



""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                "
"               Text Formatting                  "
"                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""

" don't automatically format 'text' as it is typed; i.e. only do this with
" comments, and reflow at 72 characters:
set formatoptions-=t
set formatoptions+=c
set textwidth=72



""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                "
"                    General                     "
"                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""

" Disable some things that tick off crontab on at least Mac OSX.  See
" http://goo.gl/LP6X0 for more information.
if exists("$VIM_CRONTAB")
    set nobackup
    set nowritebackup
endif

" have fifty lines of command-line (etc) history:
set history=50

" Things to save in .viminfo:
" Save 10 items in the search pattern history;
" Save marks for the last 10 edited files;
" Don't save marks for files in /tmp or /Volumes;
" Do not store file marks;
" Disable 'hlsearch' when loading the viminfo file;
" Save 100 lines for each register.
set viminfo=/10,'10,r/tmp,r/Volumes,f0,h,\"100

" have command-line completion <Tab> (for filenames, help topics, option
" names) first list the available options and complete the longest common
" part, then have further <Tab>s cycle through the possibilities:
set wildmode=longest,full
set wildmenu

" Ignore case when completing file names and directories.
if exists("&wildignorecase")
    set wildignorecase
endif

if exists ("&wildignore")
    set wildignore+=*.pyc,*.bak,*.class,*.orig,*~,*.swp,*.swo
    set wildignore+=*.so,*.dll,*.dylib,*.o,*.exe
    set wildignore+=.git,.hg,.bzr,.svn,CVS
    set wildignore+=*/build/*,*/tmp/*,*/vendor/*,*/target/*
    set wildignore+=*.zip,*/.deps/*,
endif

" Enable the mouse in all modes. This can be weird sometimes.
if has("mouse")
    set mouse=a
    " ...or just Visual, Insert, and Command modes.
    "set mouse=vic
endif

" enable spell-checking, if we have it.
" you'll probably want to read ':help spell'.
if has("spell")
    set nospell
    " Map F2 to toggle spell-check mode:
    map <silent> <F2> :set spell!<CR>:set spell?<CR>
    imap <silent> <F2> <C-O>:set spell!<CR><C-O>:set spell?<CR>
endif

" Look in the current directory and work upwards for a tags file.
set tags=./tags,./TAGS,/

" Lower the timeout when pressing <Esc>
set timeout timeoutlen=3000 ttimeoutlen=100

" make searches case-insensitive, unless they contain upper-case letters:
set ignorecase
set smartcase

" show the 'best match so far' as search strings are typed:
set incsearch

" assume the /g flag on :s substitutions to replace all matches in a line:
set gdefault

" allow <BkSpc> to delete line breaks, beyond the start of the current
" insertion, and over indentations:
set backspace=eol,start,indent

" Encoding-related things
if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    set encoding=utf-8
    setglobal fileencoding=utf-8
    set fileencodings=ucs-bom,utf-8,latin1,default

    " Change the characters used in list mode to some utf-8 characters,
    " if available.
    set listchars=eol:¬
    set listchars+=extends:❯
    set listchars+=precedes:❮
    set listchars+=trail:·
    set listchars+=nbsp:·
    set listchars+=tab:»·


    set showbreak=↪
endif

" Keep the cursor in the same column, if possible, when using C-U and
" C-D, etc.
set nostartofline

" Indicates a fast terminal connection.  More characters will be sent to
" the screen for redrawing, instead of using insert/delete line
" commands.  Improves smoothness of redrawing when there are multiple
" windows and the terminal does not support a scrolling region.
" Note: nvim ignores this.
set ttyfast

" Do not redraw screen while executing macros, registers and other
" commands that have not been typed.
set lazyredraw

" Control the behavior when switching between buffers:
" * Jump to the first open window that contains the specified buffer (if
"   there is one).
" * Also consider windows in other tab pages.
" * Open a new tab before loading a buffer for a quickfix command that
" display errors.
if version <= 700
    set switchbuf=useopen,usetab
else
    set switchbuf=useopen,usetab,newtab
endif

" Minimal number of screen lines to keep above and below the cursor.
set scrolloff=3

" Automatically save the buffer when performing various commands.
set autowrite

" Do not unload a buffer when it is abandoned. Helps when moving between
" multiple buffers so that Vim doesn't try to reload the file every
" single time.
set hidden

" Set the terminal title, if possible.
set title

" Open splits to the right or below the current window for vsp/sp, respectively.
set nosplitbelow splitright


""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                "
"                   Functions                    "
"                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""

" Used to toggle the QuickFix window open and closed. Mapped to
" <leader>q (see below).
let g:quickfix_is_open = 0
function! QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
    else
        copen
        let g:quickfix_is_open = 1
    endif
endfunction
nnoremap <leader>q :call QuickfixToggle()<CR>





" Avoid some security problems with directory-specific vimrc files
" This should be the last line of the file.
set secure
