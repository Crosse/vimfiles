function! crosse#printing#load() abort
    " Set some printing options.
    " Left/Right/Top margins:  0.5in (1pt = 1/72 inch)
    " Bottom margin:  1in
    " Print line numbers
    " Paper size:  letter (default is A4)
    set printoptions=left:27pt,right:54pt,top:36pt,bottom:36pt,number:y,paper:letter,header:3
    set printheader=%<%F%=\ [Page\ %N]
endfunction
