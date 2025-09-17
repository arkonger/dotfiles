" A collection of maps and functions to handle long code comments without word
"   wrap:
" -----------------------------------------------------------------------------
"   __        : Splits the current line at the start of the word containing
"                 column 80.
" -----------------------------------------------------------------------------
"   _<Enter>  : Splits the current line using __, adds the comment delimiter
"                 (which is assumed to be the current word) to the start of
"                 the new line, and matches the previous line's indentation.
" -----------------------------------------------------------------------------
"   _-        : Works just as _<Enter>, but also indents the text after the
"                 delimiter
" -----------------------------------------------------------------------------
"   _<BS>     : Merges the current line with the previous one by deleting the
"                 comment delimiter and all the whitespace before the start of
"                 the text, and then backspacing into the previous line.
" -----------------------------------------------------------------------------
"   IndentComment(internalIndent)
"             : A function which performs the indentation in _<Enter> and _-
"               Arg: boolean internalIndent, which specifies whether to indent
"                 after the delimiter. For _<Enter>, this is false. For _-,
"                 this is true.
" -----------------------------------------------------------------------------
"   SplitLine()
"             : A function which performs the line splitting in __
"               Return: either 0, indicating that it successfully split the
"                 line, or 1, indicating that it could not split the line.
" -----------------------------------------------------------------------------
"   UnsplitLine()
"             : A function which performs the deletion in _<BS>
" -----------------------------------------------------------------------------

function! SplitLine()
  " If the current line is less than 80 characters long, it doesn't need split.
  if strchars(getline(".")) <= 80
    return 1
  endif
  
  " Move the cursor to column 80
  normal 80|wB
  
  " Switch to insert mode, type <BS><CR><Esc> to split the line
  normal i
  return 0
endfunction

function! IndentComment(internalIndent)
  " Get the starting column
  let col1 = virtcol(".")
  
  " Grab the comment delimiter
  normal yW

  " If the line doesn't need to split, there's nothing to do
  if SplitLine()
    return
  endif

  " Neovim sometimes formats comments based on syntax files. If the current
  "   column is greater than the starting column, then we can assume neovim
  "   detected that we were in a comment block. All that should be done is to
  "   indent if we're supposed to, and then return. 
  if virtcol(".") > col1
    if a:internalIndent
      exec "normal Wi\<Tab>\<Esc>"
    endif
    normal ^
    return
  endif

  " Get the column we wound up at
  let col2 = virtcol(".")

  " Pastes the comment delimiter, and then adds a tab if internalIndent is true
  exec "normal P" . (a:internalIndent ? "a\<Tab>\<Esc>" : "")

  " Returns the cursor to the beginning of the line
  normal ^

  " Now the indentation needs to be checked. If the two columns are equal,
  "   then autoindent worked properly. Otherwise, the line is indented to
  "   match. 
  if col1 == col2
    return
  else
    let tabs = float2nr(ceil((col1-col2)/&shiftwidth))
    exec "normal V" . tabs . ">^"
  endif
endfunction

function! UnsplitLine()
  " Deletes from the comment delimiter to the start of the text, then deletes
  "   from there to the start of the line, then drops in and out of insert
  "   mode to delete the newline. 
  normal dwd0i
  
  " If the previous line did not end with a space, one needs to be added.
  "   Since the <Esc> at the end of the previous command moves the cursor back
  "   one, the current character is the last one of the previous line. 
  if getline(".")[col(".")-1] =~ '\s'
    " Even if a space is not needed, the cursor should still be moved to the
    "   start so that the command can be repeated as desired. 
    normal ^
    return
  endif
  
  " The previous line did not end with a space, so one is added and the cursor
  "   is moved to the beginning of the line. 
  normal a ^
endfunction

nmap <silent> __ :call SplitLine()<CR>
nmap <silent> _<Enter> :call IndentComment(0)<CR>
nmap <silent> _- :call IndentComment(1)<CR>
nmap <silent> _<BS> :call UnsplitLine()<CR>

"""""""""""""""""""""""""""""""""""""""
" Other assorted maps and functions:  |
"""""""""""""""""""""""""""""""""""""""

" A function to toggle tabs/spaces
function! ToggleTabs()
  set invexpandtab
  if &expandtab
    echo "Spaces enabled"
  else
    echo "Tabs enabled"
  endif
endfunction
" A map to call ToggleTabs()
nmap <silent> _<Tab> :call ToggleTabs()<CR>

" The default behavior of Y is redundant with yy, and inconsistent with D/dd
"   and C/cc. 
" New behavior: yank to end of line
nmap <silent> Y y$

" The default behavior of [n]>> is redundant with >[n]>, and it's nice to be
"   able to indent a single line multiple times without switching to visual
"   mode or spamming >>. 
" New behavior: indent current line [n] times
nmap <silent> >> @='V>'<Esc>

" A function to toggle a "very magic mode" shortcut: 
"   Vim has a very versatile search function, given that it is capable of
"     executing all but the most arcane RegExes. However, the default search
"     behavior notably interprets many special characters (such as
"     parentheses, brackets, and even periods and plus signs) as literal
"     characters; to use them as special characters in a RegEx, they need to
"     be escaped. While this is very convenient for mundane (non-RegEx)
"     searches, it makes even simple RegExes quite cumbersome to type.
"     Fortunately, the \v and \V metacharacters can be used to drop in and out
"     of "very magic mode", which interprets all special characters as such --
"     no need to escape!
"   A simple map can be used to default to VMM by prepending searches with \v,
"     but this may not always be desirable. Therefore, the below function sets
"     and unsets the map as a toggle. 
function! ToggleVMM()
  if !exists("s:VMM")
    let s:VMM=0
  endif
  if s:VMM
    nunmap /
    nunmap ?
    echo "Very magic mode disabled"
    let s:VMM=0
  else
    nmap / /\v
    nmap ? ?\v
    echo "Very magic mode enabled"
    let s:VMM=1
  endif
endfunction
" A map to call ToggleVMM()
nmap <silent> _/ :call ToggleVMM()<CR>

" A map to clear search results by emptying the search register
nmap <silent> _? :let @/=""<CR>

" A function to toggle case sensitivity
function! ToggleIgnoreCase()
  set invignorecase
  if &ignorecase
    echo "Searches will ignore case"
  else
    echo "Searches will respect case"
  endif
endfunction
" A map to call ToggleIgnoreCase()
nmap <silent> <M-i> :call ToggleIgnoreCase()<CR>

" A function to toggle default behavior of cursor row/column highlighting. 
function! ToggleDefaultCucCul()
  if !exists("s:DefaultCucCul")
    let s:DefaultCucCul=0
  endif
  if s:DefaultCucCul
    echo "Column/Row highlighting disabled"
    let s:DefaultCucCul=0
    set nocursorcolumn nocursorline
  else
    echo "Column/Row highlighting enabled"
    let s:DefaultCucCul=1
    set cursorcolumn cursorline
  endif
endfunction
nmap <silent> _+ :call ToggleDefaultCucCul()<CR>

" A function to enable or disable cursor row/column highlighting, contingent
"   on the current default behavior. This is called by the below autocommands
"   so that only the current window has highlights. 
"   Arg: boolean enable, which indicates whether to enable or disable
"     highlighting. 
function! SetCucCul(enable)
  " Set default behavior
  if !exists("s:DefaultCucCul")
    let s:DefaultCucCul=0
  endif

  " Get the value to set
  let l:CucCul = s:DefaultCucCul && a:enable
  
  " Set it
  let &cursorcolumn=l:CucCul
  let &cursorline=l:CucCul
endfunction
au WinLeave * :call SetCucCul(0)
au WinEnter * :call SetCucCul(1)

" Insert a newline, but stay in normal mode
nmap <M-o> o
nmap <M-O> O

" Maps Alt+J/K to scroll down one, keeping the cursor centered. 
nmap <M-J> jzz
nmap <M-K> kzz

" Maps Alt+j/k to move the cursor down/up in a wrapped line
nmap <M-j> gj
nmap <M-k> gk

" And in insert mode, Alt+Up/Down
imap <M-Up> gk
imap <M-Down> gj

" Navigate tabs quicker
nmap <M-h> gT
nmap <M-l> gt
nmap <silent> <M-H> :tabmove -
nmap <silent> <M-L> :tabmove +

function! ToggleColorColumn()
  if &colorcolumn
    set colorcolumn=0
    echo "Color column disabled"
  else
    set colorcolumn=80
    echo "Color column enabled"
  endif
endfunction
nmap <silent> _<Bar> :call ToggleColorColumn()<CR>

" Reload configs
nmap <silent> _u :source $MYVIMRC<CR>

" Open a terminal in new tab
nmap <silent> <M-t> :tabnew \| terminal<CR>

" Toggle nvim-tree
nmap <silent> <M-T> :NvimTreeToggle<CR>

" Toggle colorizer
nmap <silent> <M-c> :ColorizerToggle<CR>

" Use <Esc> to get out of terminal...
tmap <Esc> 
" ...unless ctrl is also pressed
tnoremap <C-Esc> <Esc>

" Yank to "+ (system clipboard)
nmap <M-y> "+y
" And in visual mode
vmap <M-y> "+y
" Yank line (this can also be done with <M-y>y but this is provided for
"   convenience)
nmap <M-y><M-y> "+yy
" Yank to EOL
nmap <M-Y> "+y$

" Toggle line wrap and linebreak
function! ToggleWrap()
  if &wrap
    set nowrap nolinebreak
    echo "Line wrap disabled"
  else
    set wrap linebreak
    echo "Line wrap enabled"
  endif
endfunction
nmap <silent> _w :call ToggleWrap()<CR>
