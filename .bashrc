# this file is processed on each interactive invocation of bash

echo -ne "\033[1m"
lsb_release --description --release | cut -f2 | tr '\n' ' ' | figlet -f smslant | lolcat
echo -e "\033[0m"
echo -e " Welcome back, $USER! Today is $(date +%A), $(date +'%b %d').\n" | lolcat

# exits if not a tty
[[ $- != *i* ]] && return

# Adds fuck functionality
eval $(thefuck --alias)

export HISTCONTROL=erasedups
export HISTSIZE=10000
export PATH=~/bin/:$PATH
set -o vi

BLUE='\x1b[38;2;0;0;255m'
PURPLE='\x1b[38;2;255;0;255m'
CYAN='\x1b[38;2;50;255;255m'
DEF='\x1b[0m'

PS1='\[`printf ${CYAN}`\]$USER \[`printf ${BLUE}`\]@ \[`printf ${PURPLE}`\]`pwd`\[`printf ${BLUE}`\]# \[`printf ${DEF}`\]'

alias data="ssh nkonger@data.cs.purdue.edu"

alias update="source ~/.bashrc"
alias brc="vim ~/.bashrc"

# Checks for ~/bin/cdn, adds alias so that it functions as intended
if [ -f ~/bin/cdn ]; then
  alias cdn=". cdn"
fi
