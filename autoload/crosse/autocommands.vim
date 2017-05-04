"function! crosse#autocommands#load() abort
"    augroup crosse
"        autocmd!
"        if v:vim_did_enter
"            call crosse#setup#load()
"        else
"            autocmd VimEnter * call crosse#setup#load()
"        endif
"    augroup END
"endfunc
