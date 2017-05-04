" Fonts section.  First, create a list of desired fonts for GUI vims.
let s:fonts = ["Source Code Pro", "Consolas", "Inconsolata", "Lucida Console", "Monospace"]
let s:win_font_size = "11"
let s:mac_font_size = "15"
let s:unix_font_size = "11"

let s:print_fonts = s:fonts
let s:print_font_size = "h8"

" Use the same fonts for printing as for the GUI.
let &printfont = join(s:print_fonts, ":" . s:print_font_size . ",")

function! crosse#fonts#load() abort
    if g:os.is_windows
        let s:font_size=s:win_font_size
    elseif g:os.is_mac
        " MacVim-specific settings
        let s:font_size=s:mac_font_size
        " Enable ligatures in fonts that support them.
        " This only works for MacVim currently.
        " Examples of good fonts for coding that use ligatures include:
        "   - Fira Code (https://github.com/tonsky/FiraCode)
        "   - Hasklig (https://github.com/i-tu/Hasklig)
        " See https://medium.com/larsenwork-andreas-larsen/ligatures-coding-fonts-5375ab47ef8e
        " for more information on why ligatures can be useful for coding fonts.
        if has("gui_running") && exists("&macligatures")
            set macligatures
        endif
    else
        " Unix-specific settings for everthing else.
        let s:font_size=s:unix_font_size
    end

    if has("gui_running")
        " The font to use for GVim/MacVim
        let s:gui_fonts = []
        for s:font in s:fonts
            let s:gui_fonts += [s:font . " " . s:font_size]
            let s:gui_fonts += [substitute(s:font, " ", "_", "g") . ":h" . s:font_size]
        endfor
        let &guifont = join(s:gui_fonts, ",")
    end
endfunction
