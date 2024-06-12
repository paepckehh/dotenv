#!/bin/sh
eval $(ssh-agent)
plugins=(git)
alias l="ls -la"
alias e="vim"
export SHELLCHECK_OPTS="-e SC2086"
export LANG=en_US.UTF-8
export EDITOR='vim'
