try
  colorscheme elfemperor        " My own slight modification of elflord
catch /^Vim\%((\a\+)\)\=:E185:/
  colorscheme elflord           " Fallback to normal elflord
endtry
set termguicolors               " Allow gui (24-bit) color palettes for
                                "   terminals which support it, rather than
                                "   the limited 256-color (or worse) palettes
set nowrap                      " Turns off text wrap
set linebreak                   " Formatting for line wrapping, when enabled.
set breakindent
set breakindentopt=shift:2
set mouse=a                     " Enables mouse control; in neovim this also
                                "   allows mouse in command mode
set timeoutlen=1500             " Extends the timeout length to 1.5s when
                                "   there are multiple possible commands
set tabstop=4 softtabstop=2     " Sets width of actual tabs to four spaces,
                                "   but acts as though they were only two.
                                "   This is more compatible, as text formatted
                                "   with tabstop=4 will still display correctly
set shiftwidth=2                " Sets the width of ">>" shifts to two spaces
set expandtab                   " Expands tabs into spaces (doesn't affect
                                "   existing tabs)
set number                      " Turns on line numbers
set relativenumber              " Makes line numbers relative to the current
                                "   line (i.e. the current line shows its line
                                "   number normally, but all other lines
                                "   instead show their distance from the
                                "   current line). 
set foldmethod=indent           " Allows automatic fold marking based on line
                                "   indentation
set foldcolumn=2                " Adds a column indicating folded lines
set foldlevelstart=99           " Expand all folds by default
set virtualedit=block           " Allow virtual block mode to extend past EOL
                                """""""""""""""""""""""""""""""""""""""""""""""
if !has('nvim')                 " Vim-specific options go here                |
                                """""""""""""""""""""""""""""""""""""""""""""""
  syntax on                       " Colors text according to syntax
  set autoindent                  " Automatically indents new lines
  set backspace=indent,eol,start  " Backspace through everything in insert mode
  set hlsearch                    " Highlights search results
  set incsearch                   " Shows search results as you type
  set showcmd                     " Show what has been typed in command mode
                                """""""""""""""""""""""""""""""""""""""""""""""
else                            " Neovim-specific options go here             |
                                """""""""""""""""""""""""""""""""""""""""""""""
  set nosmarttab                  " Make any tabs entered be tabs, regardless
                                  "   of where they're typed
  set startofline                 " Move to the first non-whitespace character
                                  "   of the line when using certain commands
  source ~/.config/nvim/lazy.lua  " Load plugins
endif                           """""""""""""""""""""""""""""""""""""""""""""""
source ~/.vim/maps.vim          " Loads my custom key maps
