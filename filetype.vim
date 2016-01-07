" local filetype file

if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
    " PowerShell
    au! BufRead,BufNewFile *.ps1  setfiletype ps1
    au! BufRead,BufNewFile *.psm1 setfiletype ps1
    au! BufRead,BufNewFile *.psd1 setfiletype ps1

    " *.md is Markdown, not Modula-2.
    au! BufRead,BufNewFile *.md setfiletype markdown

    " human-readable files
    au! BufRead,BufNewFile *.txt setfiletype human
    au! BufRead,BufNewFile *.tex setfiletype human
    au! BufRead,BufNewFile COMMIT_EDITMSG setlocal formatoptions+=t textwidth=72

    au! BUfRead,BufNewFile *.ino setfiletype cpp
    au! BUfRead,BufNewFile *.pde setfiletype cpp
augroup END

