"" Whitespace
set nowrap                      " Turns off text wrap
set tabstop=2                   " Sets tab width to two spaces
set shiftwidth=2                " Sets the width of ">>" shifts to two spaces
" set expandtab                   " Expands tabs into spaces (doesn't affect
                                "   existing tabs)
set backspace=indent,eol,start  " Backspace through everything in insert mode
set autoindent									" Automatically indents new lines
set mouse=a											" Enables mouse control
set number                      " Turns on line numbers
set relativenumber              " Makes line numbers relative to the current
                                "   line (i.e. the current line shows its line
                                "   number normally, but all other lines
                                "   instead show their distance from the
                                "   current line). 
set hlsearch                    " Highlights search results
set timeoutlen=1500             " Extends the timeout length to 1.5s when
                                "   there are multiple possible commands
set showcmd                     " Show what has been typed in command mode
syntax on												" Colors text according to syntax
colorscheme elflord							" Sets the theme
source ~/.vimmaps               " Loads my custom key maps
