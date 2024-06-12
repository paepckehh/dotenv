#!/bin/sh
eval $(ssh-agent)
plugins=(git brew)
export ZSH_THEME="powerlevel10k/powerlevel10k"
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
source ~/.p10k.zsh
zstyle ':omz:update' mode disabled
alias git-clone="git clone git@github.com:paepckehh/$REPO.git"
alias git-push="git add . && git commit -S && git push"
alias git-log="git log --show-signature"
alias l="ls -la"
alias e="vim"
export SHELLCHECK_OPTS="-e SC2086"
export LANG=en_US.UTF-8
export EDITOR='vim'
export PATH="/usr/local/bin:/usr/bin:/bin::/usr/local/sbin:/usr/sbin:/sbin"
