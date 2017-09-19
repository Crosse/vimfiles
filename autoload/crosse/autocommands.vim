function! crosse#autocommands#load() abort
    au VimEnter * RainbowParenthesesToggleAll
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadSquare
    au Syntax * RainbowParenthesesLoadBraces
    au Syntax * RainbowParenthesesLoadChevrons
endfunc
