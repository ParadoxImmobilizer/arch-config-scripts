#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.alias

# Declare color codes for PS1
CYAN="$(tput setaf 116)"
RESET="$(tput sgr0)"

# Declare PS1
PS1='\[${CYAN}\]\u \w\$ \[${RESET}\]'

# Startup commands
clear
neofetch