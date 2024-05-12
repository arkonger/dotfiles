# Function to confirm which files the user wants linked. 
# Args: 
#   $1: Shortname of the file
#   $2: Link URL
function confirm {
  while true; do
    read -n 1 -p "Would you like to link $1? (Y/n) "
    echo ''
    case $REPLY in
      "y" | "" | " ")
        ln -fs "$(pwd -P)/$1" $2 && {
          echo -e "Successfully linked $2 to $1.\n" && break
        } || {
          echo -e "Failed to link $1.\n" && break
        }
        ;;
      "n")
        break
        ;;
      *)
        echo -ne "Unrecognized option: "
        echo $REPLY
        echo "Type 'y' for yes (default if left blank), or 'n' for no"
        ;;
    esac
  done
}

SHORT=(.bashrc i3_config workplace_swapper.py kitty.conf lazy.lua .vimrc maps.vim init.vim elfemperor.vim)
DEST=(~/.bashrc ~/.config/i3/config ~/.config/i3/scripts/workplace_swapper.py ~/.config/kitty/kitty.conf ~/.config/nvim/lazy.lua ~/.vimrc ~/.vim/maps.vim ~/.config/nvim/init.vim ~/.config/nvim/colors/elfemperor.vim)

for ((i = 0; i < ${#SHORT[@]}; i++)); do
  confirm ${SHORT[$i]} ${DEST[$i]}
done
