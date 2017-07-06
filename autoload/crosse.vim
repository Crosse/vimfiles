let g:crosse_loaded = 1

function! crosse#init() abort
    let l:order = [
                \ 'osdetect',
                \ 'python',
                \ 'fonts',
                \ 'printing',
                \ 'mappings',
                \ 'win',
                \ 'plugins',
                \ 'colors',
                \ ]

    for l:plugin_name in l:order
        exec('call crosse#' . l:plugin_name . '#load()')
    endfor
endfunction
