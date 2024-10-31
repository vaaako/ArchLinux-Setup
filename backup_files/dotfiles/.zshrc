## ZSH CONFIG ##
ZSH_DIR=~/.config/zsh
# Ruby
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"


# HISTORY
# ZSH don't save history by default
HISTFILE="${ZSH_DIR}/.zsh_history"
setopt appendhistory
HISTSIZE=1000000
SAVEHIST=1000000

# Useful options
setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
stty stop undef # Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')

# Disable beep
unsetopt BEEP

# Completions
autoload -Uz compinit
zstyle ':completion:*' menu select
_comp_options+=(globdots) # Include hidden files

# Ignore Case
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Colors
autoload -U colors && colors

# Enable HOME, END and DELETE keys
bindkey "^[[H"  beginning-of-line
bindkey "^[[F"  end-of-line
bindkey "^[[3~" delete-char
# Enable Ctrl + Arrows
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Enable vi mode
# bindkey -v

# Enable Zoxide
eval "$(zoxide init --cmd cd zsh)"


## ALIASES ##
# Safe rm
rm() {
	# Check if the first argument is -rf, if so, remove it from the arguments
	if [[ "$1" == "-rf" ]]; then
		shift
	fi

	# Check if any argument is a wildcard or directory symbol
	for arg in "$@"; do
		if [[ "$arg" == "*" || "$arg" == "/" ]]; then
			echo "Ignoring wildcard or directory symbol: $arg"
			continue
		fi
	done

	# Use gio to move files to trash
	gio trash "$@"
}

# Unsafe rm
alias urm='/bin/rm -i'


# Linux
alias grep='grep --color=auto'
alias ls='exa --icons'
# alias rm='rm -i'
alias largest='du -ah "${1:-.}" | sort -rh | tail -n +2 | head -n 10 | awk '\''{printf "\033[1m%s\033[0m %s\n", $1, substr($0, index($0, $2))}'\'''
#              sget size      sort largest   ignore "."    10 first    bold size

# Alias
alias py='python3'
alias nv='nvim'
alias icat='kitten icat'

# Neofetch
alias neofetch='neofetch --source ~/.config/neofetch/arch_trans.txt --ascii_colors 14 9 15 --colors 5 4 13 9 7'
alias neowofetch='neofetch --source ~/.config/neofetch/arch_trans2.txt --ascii_colors 14 9 15 --colors 5 4 13 9 7'

# Full commands
alias removeorphans='sudo pacman -Rncs $(pacman -Qdtq)'
alias logmein-hamachi='sudo /etc/init.d/logmein-hamachi'
alias open-ports='sudo lsof -i -P -n | grep LISTEN'
alias copy-image='xclip -selection clipboard -t image/png -i'

# ffmpeg
mkv-to-mp4() {
	if [ ! "$1" ]; then
		echo "Incorrect usage: No input video provided"
		echo "Correct Usage: video-to-mp4 <mp4 video>"
		return 1
	fi

	ffmpeg -i "$1" -codec copy "${1%.mkv}.mp4"
}

video-to-gif() {
	if [ ! "$1" ]; then
		echo "Incorrect usage: No input video provided"
		echo "Correct Usage: video-to-gif <input> [size]"
		return 1
	fi

	local WIDTH="320"
	if [ "$2" ]; then
		WIDTH="$2"
	fi


	ffmpeg -i "$1" -vf "fps=24,scale=$WIDTH:-1:flags=lanczos" "${1%.*}.gif"
}

mp3-to-m4a() {
	if [ ! "$1" ]; then
		echo "Incorrect usage: No input mp3 provided"
		echo "Correct Usage: mp3-to-m4a <mp3 file>"
		return 1
	fi

	ffmpeg -i "$1" -c:v copy -c:a aac "${1%.*}.m4a"
}

# rclone
alias drive-mount='rclone mount --daemon --vfs-cache-mode full gdrive:/ ~/Drive'
alias drive-umount='umount ~/Drive'



## VCS ##
autoload -Uz vcs_info

# Enable only git 
zstyle ':vcs_info:*' enable git

# setup a hook that runs before every ptompt. 
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

# Check for untracked files in directory
# From https://github.com/zsh-users/zsh/blob/master/Misc/vcs_info-examples
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

+vi-git-untracked(){
	if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
		git status --porcelain | grep '??' &> /dev/null ; then
		# This will show the marker if there are any untracked files in repo.
		# If instead you want to show the marker only if there are untracked
		# files in $PWD, use:
		#[[ -n $(git ls-files --others --exclude-standard) ]] ; then
		hook_com[staged]+='!' # signify new files with a bang
	fi
}

zstyle ':vcs_info:*' check-for-changes true

STATUS="%m%u%c"
BRANCH="%b"
zstyle ':vcs_info:git:*' formats "%F{blue}(%f%F{red}${STATUS}%f %F{yellow}% %F{magenta}$BRANCH%f%F{blue})%f"

setopt PROMPT_SUBST



## PLUGINS ##
# zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions
source "${ZSH_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh"
bindkey '^ ' autosuggest-accept # Ctrl + Space to accept suggestion

## PS1 ##
TIME='%*'
FULL_DIR='%~'
CMD_STATUS='%(?.%F{blue}⏺.%F{red}⏺)%f'
GIT='${vcs_info_msg_0_}'
NEWLINE=$'\n'

#  PROMPT="┌──${CMD_STATUS} (%F{blue}${TIME}%f) - [%n@%m]${NEWLINE}"
# PROMPT+="└─  %F{magenta}${FULL_DIR}%f ${GIT}> "


PROMPT="${CMD_STATUS} %F{magenta}(%f%F{blue}${TIME}%f%F{magenta})%f %F{magenta}${FULL_DIR}%f %F{blue}>%f "
RPROMPT="${GIT}%F{blue}"
# PROMPT='%2/ $(git_branch_name)' Created by newuser for 5.9

pokemon-colorscripts -r




# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Created by `pipx` on 2024-04-30 22:29:17
export PATH="$PATH:/home/vako/.local/bin"

export PATH=$PATH:/home/vako/.spicetify
