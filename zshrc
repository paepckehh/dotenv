#!/bin/sh
ZSH_THEME="agnoster"
plugins=(git brew)
if [[ -r "$HOME/.oh-my-zsh" ]]; then
	export ZSH="$HOME/.oh-my-zsh"
	source $ZSH/oh-my-zsh.sh
	zstyle ':omz:update' mode disabled
fi
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	ZSH_THEME="powerlevel10k/powerlevel10k"
  	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
	[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
fi
alias git-clone="git clone git@github.com:paepckehh/$REPO.git"
alias git-push="git add . && git commit -S && git push"
alias git-log="git log --show-signature"
alias l="ls -la"
alias e="vim"
eval $(ssh-agent)
export SHELLCHECK_OPTS="-e SC2086"
export LANG=en_US.UTF-8
export EDITOR='vim'
export PATH="/usr/local/bin:/usr/bin:/bin::/usr/local/sbin:/usr/sbin:/sbin"
