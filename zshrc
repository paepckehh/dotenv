export ZSH="$HOME/.oh-my-zsh"
zstyle ':omz:update' mode disabled  # disable automatic updates
ZSH_THEME="agnoster"
plugins=(git brew)
source $ZSH/oh-my-zsh.sh
alias dnsme="sudo brew services restart dnscrypt-proxy"
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
