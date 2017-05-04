function! crosse#win#load() abort
    if ! g:os.is_windows
        return
    endif

    " Windows-specific settings
    behave mswin
    source $VIMRUNTIME/mswin.vim

    if has("gui_running") && exists("&renderoptions")
        if g:os.is_windows
            " Use DirectX to draw glyphs on Windows. This is new in Vim 8.
            set renderoptions=type:directx
        endif
    endif
endfunction
