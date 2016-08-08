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

    " Arduino sketches.
    au! BufRead,BufNewFile *.ino setfiletype cpp
    au! BufRead,BufNewFile *.pde setfiletype cpp

    " Use tabs for Go that look 8-characters wide.
    au! FileType go set noexpandtab tabstop=8 shiftwidth=8

    " Use 2 spaces to indent YAML
    au! FileType yaml set expandtab tabstop=2 shiftwidth=2

    " Use 2 spaces to indent JSON.
    au! FileType json set expandtab tabstop=2 shiftwidth=2
augroup END

