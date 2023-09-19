# this file is processed on each interactive invocation of bash

# TODO where did the attribution for this go?????
echo -ne "\033[1m"
lsb_release --description --release | cut -f2 | tr '\n' ' ' |\
  figlet -f smslant | lolcat
echo -e "\033[0m"
echo -e " Welcome back, $USER! Today is $(date +%A), $(date +'%b %d').\n" |\
  lolcat

# Exits if not a tty
[[ $- != *i* ]] && return

# Adds fuck functionality
eval $(thefuck --alias)

# General bash settings
export HISTCONTROL=erasedups
export HISTSIZE=10000
export PATH=~/bin/:$PATH
set -o vi

# Make ls colorful
export LS_OPTIONS='--color=auto'
eval $(dircolors -b)
alias ls='ls $LS_OPTIONS'

# Pretty custom prompt
# ANSI escapes used in the prompt
TEAL='\e[38;2;52;255;186m'
PURPLE='\e[38;2;205;0;205m'
DEF='\e[0m'

function build_prompt() {
  PRE='\[`printf $PURPLE`\]>>=/'
  USER='\[`printf $TEAL`\]\u'
  SEP='\[`printf $PURPLE`\]/=/'
  DIR='\[`printf $TEAL`\]\w/'
  PROMPT='\[`printf $PURPLE`\]/=>'
  RESET='\[`printf $DEF`\]'
  echo "$PRE $USER $SEP $DIR $PROMPT $RESET"
}
PS1=`build_prompt`

# TODO figure out if I can even login anymore lmao
alias data="ssh nkonger@data.cs.purdue.edu"

# R.I.P. Bram Moolenaar
alias vim="nvim"

# Misc aliases
alias update="source ~/.bashrc"
alias brc="vim ~/.bashrc"
alias i3c="vim ~/.config/i3/config"
alias i3b="vim ~/.config/i3/i3blocks.conf"

# Checks for ~/bin/cdn, adds alias so that it functions as intended
# TODO why did this stop cd'ing??
if [ -f ~/bin/cdmk ]; then
  alias cdmk=". cdmk"
fi

# Always use aria2 for downloads
alias yt-dlp="yt-dlp --downloader=aria2c"
