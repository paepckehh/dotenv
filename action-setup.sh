#!/bin/sh

# config
github_user="paepckehh"

# global
os=$( uname )
dts=$( date -u +%Y-%m-%dT%H:%M:%SZ )

module_setupenv() {
	echo "[start][module:setupenv]"
	sh -c $( curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh )
	cd || exit 1
	git clone git@github.com:$github_user/dotenv .dotenv
	mkdir -p .attic/$dts 
	touch .vimrc .zshrc .zshrc.pre-oh-my-zsh 
	mv -f .vimrc .zshrc .zshrc.pre-oh-my-zsh .attic/$dts/ 
	ln -fs .dotenv/vimrc .vimrc
	ln -fs .dotenv/zshrc .zshrc
	ln -fs .dotenv/zshrc.pre-oh-my-zsh .zshrc.pre-oh-my-zsh
	gh auth login
	gh auth setup-git
	echo "[end][module:setupenv]"
}

module_brew() {
	echo "[start][module:brew]"
	brew info 
	if [ $? != 0 ]; then 
		sh -c $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
	fi
	brew upgrade
	brew install openssh curl tmux vim neovim git gh zsh htop go tldr ripgrep fzf
	brew install --cask lulu istat-menus keka firefox libreoffice opencore-patcher virtualbox docker
	setup
	echo "[end][module:brew]"
}

darwin() {
	module_brew
	module_setupenv
}

linux() {
	module_brew
	module_setupenv
}

freebsd() {
	echo '...pending!'
}

init() {
	echo "[start][$os]"
	case $os in
		Darwin) darwin;;
		Linux) linux;;
		FreeBSD) freebsd;;
		*) echo "unable to recognise os" && exit 1;;
	esac
	echo "[end][$os]"
}

backup() {
	cd && cd .dotenv || exit 1
	if [ -x .git ]; then
		git add .
		git commit -m 'update env'
		git push
	fi
}

case $1 in
	backup) backup ;;
	*) init ;;
esac
