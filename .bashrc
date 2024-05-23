# This file is processed on each interactive invocation of bash

# Exits if not interactive
[[ $- != *i* ]] && return

# Courtesy of /u/badmemekid3000 and /u/MoyensInoperants:
# https://old.reddit.com/r/linuxmasterrace/comments/dhrhab/it_took_about_an_hour_to_get_it_to_look_right_im/f3r2kq8/?context=3
echo -ne "\033[1m"
lsb_release --description --release | cut -f2 |\
  awk 'NR == 1 {print} NR > 1 {print "\t"$0}' | figlet -pf smslant | lolcat
echo -e "\033[0m"
echo -e "Welcome back, $USER! Today is $(date '+%A, %b %d.')" | lolcat

# Adds fuck functionality
eval $(thefuck --alias)

# Adds zoxide functionality
eval "$(zoxide init --cmd cd bash)"

# General bash settings
export HISTCONTROL=erasedups
export HISTSIZE=10000
export PATH=~/bin/:$PATH
set -o vi

# Make ls colorful
export LS_OPTIONS='--color=auto'
eval $(dircolors -b)
alias ls='ls $LS_OPTIONS'

# If not in a graphical session, then use legacy prompt instead
if [[ $DISPLAY == '' ]]; then {
  # Echo a blank line here for better formatting on the greeting
  echo ''

  # ANSI escapes used in the prompt
  TEAL='\e[38;2;52;255;186m'
  PURPLE='\e[38;2;205;0;205m'
  DEF='\e[0m'

  function build_prompt() {
    PRE='\[`printf $PURPLE`\]<'
    USER='\[`printf $TEAL`\]\u'
    SEP='\[`printf $PURPLE`\]@'
    DIR='\[`printf $TEAL`\]\w/'
    PROMPT='\[`printf $PURPLE`\]>'
    RESET='\[`printf $DEF`\]'
    echo "$PRE $USER $SEP $DIR $PROMPT $RESET"
  }
  PS1=`build_prompt`
}
else {
  # Adds starship functionality
  eval "$(starship init bash)"
}
fi

# Play a bell on sudo prompts
export SUDO_PROMPT=$'\a[sudo] please enter a password: '

# TODO figure out if I can even login anymore lmao
alias data="ssh nkonger@data.cs.purdue.edu"

# R.I.P. Bram Moolenaar
alias vim="nvim"
export EDITOR=nvim

# Misc aliases
alias update="source ~/.bashrc"
alias brc="vim ~/.bashrc"
alias i3c="vim ~/.config/i3/config"
alias i3b="vim ~/.config/i3/i3blocks.conf"

# Always use aria2 for downloads
alias yt-dlp="yt-dlp --downloader=aria2c"
