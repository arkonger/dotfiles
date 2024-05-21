" A lightly edited elflord variant which (at least originally) was created to
"   make the user manual more readable. 
runtime colors/elflord.vim
let g:colors_name = 'elfemperor'

" Edit elflord to make identifiers easier to see
highlight Identifier    guifg=#34ffba

" Make certain elements match my kitty cursor
highlight CurSearch     guibg=#f701fb guifg=#FFFFFF term=NONE
highlight Visual        guibg=#d669d6 guifg=#FFFFFF
highlight CursorColumn  guibg=#533552
highlight CursorLine    guibg=#533552
highlight ColorColumn   guibg=#533552
