" A list of color schemes to use, in the order you want to use them
let s:schemes = ["molokai", "default", "solarized", "torte", "desert", "koehler", "slate"]

function! crosse#colors#has_colorscheme(name) abort
     let pat = "colors/" . a:name . ".vim"
     return !empty(globpath(&runtimepath, pat))
endfunction

function! crosse#colors#cycle_colorscheme(dir)
    if !exists("g:schemes") || len(g:schemes) == 0
        let g:schemes = []
        for f in split(globpath(&runtimepath, "colors/*.vim"), "\n")
            let g:schemes = g:schemes + [fnamemodify(f, ":t:r")]
        endfor
    endif
    if a:dir == 0
        let s:schemes = g:schemes
    else
        let s:schemes = reverse(copy(g:schemes))
    endif
    for f in s:schemes
        if exists("s:found")
            exec "colorscheme " . f
            unlet s:found
            break
        endif
        if f == g:colors_name
            let s:found = 1
        endif
    endfor
endfunction

function! crosse#colors#load() abort
    " Set a color scheme, only if it is found in the runtimepath.
    for s:scheme in s:schemes
        exec "colorscheme " . s:scheme
        break
    endfor
endfunction
