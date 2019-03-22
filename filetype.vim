" local filetype file

augroup filetypedetect
    " PowerShell
    au! BufRead,BufNewFile *.ps1  setfiletype ps1
    au! BufRead,BufNewFile *.psm1 setfiletype ps1
    au! BufRead,BufNewFile *.psd1 setfiletype ps1

    " *.md is Markdown, not Modula-2.
    au! BufRead,BufNewFile *.md setfiletype markdown

    au! BufRead,BufNewFile CMakeLists.txt setfiletype cmake

    " human-readable files
    au! BufRead,BufNewFile *.txt setfiletype human
    au! BufRead,BufNewFile *.tex setfiletype human

    " git commit messages
    "au! BufRead,BufNewFile COMMIT_EDITMSG setlocal formatoptions+=t textwidth=72 spell
    "au! BufRead,BufNewFile PULLREQ_EDITMSG setlocal formatoptions+=t textwidth=72 spell

    " Arduino sketches.
    au! BufRead,BufNewFile *.ino setfiletype cpp
    au! BufRead,BufNewFile *.pde setfiletype cpp

    " Use tabs for Go that look 8-characters wide.
    au! FileType go setlocal noexpandtab tabstop=8 shiftwidth=8

    " Use 2 spaces to indent YAML
    au! FileType yaml setlocal expandtab tabstop=2 shiftwidth=2

    " Use 2 spaces to indent JSON.
    au! FileType json setlocal expandtab tabstop=2 shiftwidth=2

    " *.meta files are JSON files.
    au! BufRead,BufNewFile *.meta setfiletype json

    " *.yaml.in is YAML.
    au! BufRead,BufNewFile *.yaml.in setfiletype yaml
augroup END
