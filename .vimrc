"" Whitespace
set nowrap                      " Turns off text wrap
set tabstop=2 shiftwidth=2      " Sets tab width to two spaces
set expandtab                   " Converts tabs to spaces
set backspace=indent,eol,start  " Backspace through everything in insert mode
set autoindent									" Automatically indents new lines
set mouse=a											" Enables mouse control
set number relativenumber       " Turns on line numbers, and makes the line
                                "   numbers for all lines (other than the
                                "   current line) measure the distance from
                                "   the current line
syntax on												" Colors text according to syntax
colorscheme elflord							" Sets the theme
set hlsearch                    " Highlights search results
source ~/.vimmaps               " Adds a collection of custom key maps
