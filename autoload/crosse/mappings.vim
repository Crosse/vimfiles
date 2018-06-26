""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                "
"                 Key Bindings                   "
"                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""

function! crosse#mappings#load() abort
    map <leader><Right> :call crosse#colors#cycle_colorscheme(0)<CR>
    map <leader><Left> :call crosse#colors#cycle_colorscheme(1)<CR>

    " Stay in visual mode when indenting
    vnoremap > >gv
    vnoremap < <gv

    " have the usual indentation keystrokes still work in visual mode:
    vmap <C-T> >
    vmap <C-D> <LT>
    vmap <Tab> <C-T>
    vmap <S-Tab> <C-D>

    " have Y behave analogously to D and C rather than to dd and cc (which is
    " already done by yy):
    noremap Y y$

    " Copy (Yank) selected text to the OS clipboard
    noremap <leader>y "+y
    " Copy an entire line to the OS clipboard
    noremap <leader>Y "+yy

    " Paste from the OS clipboard
    noremap <leader>p "+p
    noremap <leader>P "+P

    " Toggle List mode using F5.  Like 'Show Codes' for WordPerfect.
    map <F5> :set list!<CR>:set list?<CR>
    imap <F5> <C-O>:set list!<CR><C-O>:set list?<CR>

    " Have Control-Enter do the same as 'O'
    " ...that is, insert a line above the current line.
    " This comes from Visual Studio key bindings.
    " Note that this doesn't seem to work in anything other than GVim.
    imap <C-Enter> <Esc>O

    " Remap PageUp and PageDown such that the keys act like Control-U and
    " Control-D, respectively.
    map  <PageUp>   <C-U>
    map  <PageDown> <C-D>
    imap <PageUp>   <C-O><C-U>
    imap <PageDown> <C-O><C-D>

    " Map/remap Control-J and Control-K to cycle left and right through tabs
    map  <C-J> :bnext<CR>
    map  <C-K> :bprevious<CR>
    imap <C-J> <C-O>:bnext<CR>
    imap <C-K> <C-O>:bprevious<CR>

    " Use <F6> to call :make
    map  <F6> :make<CR>
    imap <F6> <C-O>:make<CR>

    " Strip all trailing whitespace in the current file
    nnoremap <leader>W :%s/\s\+$//<CR>:let @/=''<CR>

    " Open a new vertical split and switch over to it.
    nnoremap <leader>w :vertical botright new<CR>

    " Close the location window.
    nnoremap <leader>l :lclose<CR>
endfunction
