# Path to the oh-my-zsh installation.
export ZSH="/home/kyle/.oh-my-zsh"

# Bash uses HOSTNAME, so set this for compatibility with BFR scripts.
HOSTNAME=$HOST

# Disabled to use Pure theme.
ZSH_THEME=""

# Use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files under VCS as dirty.
# This makes repository status check for large repositories much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"


# --------------------------------
# User configuration
# --------------------------------

# Enable Pure theme
fpath+=('/home/kyle/.nvm/versions/node/v14.17.0/lib/node_modules/pure-prompt/functions')
# fpath+=('/home/kyle/.nvm/versions/node/v11.8.0/lib/node_modules/pure-prompt/functions')

autoload -U promptinit; promptinit
prompt pure

# Override system pallette with precise gruvbox colors for Vim
source "$HOME/.vim/plugged/gruvbox/gruvbox_256palette.sh"

# Base16 Shell for setting bright colors which don't work in gnome-terminal
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# Set terminal colorscheme using script
# NOTE: this isn't necessary when using Hyper -- there you have to
# use a Hyper plugin.
base16_gruvbox-dark-hard

# Disable background colors during LS that make it hard to read.
# Format is: bold;font-color;bg-color
export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"



# MUST COME AFTER COLORS BUT BEFORE GIT ALIASES (or else aliases will be overwritten)
# Load plugins:
# vvvvvvvvvvvvvvvvvvvvvvvvvv
# NOTE: syntax-highlighting must be the last loaded plugin
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
plugins=(git colored-man-pages zsh-autosuggestions zsh-syntax-highlighting)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'


source $ZSH/oh-my-zsh.sh

# For a full list of active aliases, run `alias`.

# Plain Aliases
# alias light="base16_gruvbox-light-soft"
# alias dark="base16_gruvbox-dark-hard"
alias da="deactivate" # virtualenv
alias reload="source ~/.zshrc"
alias ll="ls -la" # show hidden files
alias echo_colors='for code in {0..255}; do echo -e "\e[38;05;${code}m $code: test"; done'
alias today='vi ~/notes/today/$(date "+%Y-%m-%d").md'
alias yesterday='vi ~/notes/today/$(ls ~/notes/today | sort | tail -n 1)'
# alias deploy="(cd ~/webapps/wize && eb deploy knowledge-staging)"


# Vim aliases
alias vi="nvim"
alias vim="nvim"
alias vimdiff="nvim -d"

# Git Aliases
alias add="git add"
alias gac="git add -A && git commit -m $1"
alias clean="git reset --hard HEAD && git clean -df"
alias ff="git pull --ff-only"
alias amend="git commit --amend"
alias b="git branch"
alias branch="git branch"
alias commit="git commit"
alias co="git checkout"
alias diff="git diff --color"
alias diffc="git diff --color --cached"
alias fetch="git fetch && git fetch --tags"
alias gs="git status --short"
alias l="git l"
alias lg1="git lg1"
alias pull="git pull origin HEAD"
alias push="git push -u origin HEAD"
alias remotes="git remote -v | ag fetch | sed 's/(fetch)//g' | tr '\t' ' ' | column -t"
alias show="git show"
alias staged="git diff --staged"
alias stash="git stash"
alias unstash="git stash apply"
alias merge="git merge"
alias tag="git tag"

cd_git_root(){
	cd $(git rev-parse --show-toplevel)
}

zz(){
    ~/.screenlayout/klm_screen_layout.sh
}

# tmux functions
t(){
    if [ -n "$1" ]; then
        tmux new -s "$1"
    else
        tmux
    fi
}
td(){
    tmux detach
}
ts(){
    tmux switch -t "$1"
}

# Open vim with output of FZF
v(){
    nvim $(fzf)
}

source ~/.fuzzyrc
source ~/.knowledge_rc
# source ~/.wize_rc  Commented out for BFR
source ~/.bearflag_rc

export EDITOR=nvim;

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add current directory node modules
export PATH=./node_modules/.bin/:$PATH

# KLM: commented out for BFR since python version 3.7 doesn't support
# export WORKON_HOME=$HOME/virtualenvs
# source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
# virtualenvwrapper setup

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# source /opt/ros/melodic/setup.zsh
# UNCOMMENT TO REBUILD EVERYTHING!
# source ~/.bearflag_docker_setup_melodic.bash
# source ~/.bearflag_extended_bashrc
# Where the koda and yogi functions live (and pingkoda and kv for koda video)
source ~/bearflag/bfr-puppet-r10k/modules/workstation_alias/templates/workstation_bash_extension.erb


alias fd=fdfind


