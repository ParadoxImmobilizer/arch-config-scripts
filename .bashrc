#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Alias definitions
alias ls="ls --color=auto -Al"		# Set ls to always print in full mode + w/ color
alias grep="grep --color=auto"		# Set grep to always print in color
alias view="less ~/scripts/.bashrc"	# List all aliases currently available
alias comp="source ~/.bash_profile"	# Recompile alias/function definitions after editing .bashrc
alias aww="yay -R"					# (Arch Linux only) remove a program
alias get-ip="curl ipinfo.io"		# Get ip, region, isp, etc.

# Programs to always run with sudo
alias vim="sudo vim"
alias pacman="sudo pacman"
alias docker="sudo docker"
alias docker-compose="sudo docker-compose"
alias systemctl="sudo systemctl"
alias wg="sudo wg"
alias wg-quick="sudo wg-quick"
alias mc="sudo mc"
alias shutdown="sudo shutdown"
alias reboot="sudo reboot"

# Function definitions (more complex functions should be in their own file in ~\scripts)
function pacmirror {	# For Arch Linux Only (update mirrorlist)
	curl -s "https://www.archlinux.org/mirrorlist/?country=US&protocol=https&ip_version=4" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 10 - > ~/tempmirrorlist
	sudo cp ~/tempmirrorlist /etc/pacman.d/mirrorlist && rm ~/tempmirrorlist
}

function cl {
	cd $1 &&
	ls
}

function susudo {
	$loc = $(pwd)
	sudo /bin/su -c 'cd $loc && $@'
}

# Declare color codes for PS1
CYAN="$(tput setaf 116)"
RESET="$(tput sgr0)"

# Declare PS1
PS1='\[${CYAN}\]\u \w\$ \[${RESET}\]'

# Startup commands
export PATH="${PATH}:/home/${USER}/scripts"
clear
neofetch