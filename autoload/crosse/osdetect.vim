" Determine the operating system once, so we don't have to do it over
" and over again
function! crosse#osdetect#load()
    let g:os = {}
    let l:os_types = {}
    let l:os_types.win    = ["win16", "win32", "win32unix", "win64", "win95"]
    let l:os_types.mac    = ["mac", "macunix"]
    let l:os_types.unix   = ["unix"]  " Note that MacVim also identifies as unix
    let l:os_types.other  = ["amiga", "beos", "dos16", "dos32", "os2", "qnx", "vms"]
    let l:os_types.all    = l:os_types.win + l:os_types.mac + l:os_types.unix + l:os_types.other

    for g:os.fullname in l:os_types.all
        if has(g:os.fullname)
            break
        endif
    endfor
    let g:os.name = "other"
    let g:os.is_windows = 0
    let g:os.is_mac = 0
    let g:os.is_unix = 0
    if index(l:os_types.win, g:os.fullname) >= 0
        let g:os.name = "windows"
        let g:os.is_windows = 1
    else
        "let g:os.realname = substitute(system("uname"), "\n", "", "")
        if index(l:os_types.mac, g:os.fullname) >= 0
            let g:os.name = "mac"
            let g:os.is_mac = 1
        elseif index(l:os_types.unix, g:os.fullname) >= 0
            let g:os.name = "unix"
            let g:os.is_unix = 1
        endif
    endif
endfunction
