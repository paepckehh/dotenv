#!/bin/sh
# quick setup|restore|verify|backup my personal favorite unix env @macos @linux @freebsd @openbsd

# config
gui='true'
github_user='paepckehh'
pkg_cli='openssh curl tmux zsh vim neovim git gh jq yq shellcheck shfmt go tldr ripgrep coreutils moreutils fzf rsync htop pv'
pkg_cli_linux=''
pkg_cli_darwin=''
pkg_cli_freebsd=''
pkg_cli_openbsd=''
pkg_gui='librewolf libreoffice'
pkg_gui_linux=''
pkg_gui_darwin='lulu stats iterm2 keka'
pkg_gui_freebsd=''
pkg_gui_openbsd=''

# global
os="$(uname)"
dts="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
bgui=''
blist=''

brew_install() {
	if [ "$blist" != "" ]; then
		if [ "$bgui" = "true" ]; then
			brew install --cask $blist
		else
			brew install $blist
		fi
	fi
}

module_setup_gh() {
	echo '[start][module:setup_gh]'
	echo 'press control-c to skip'
	gh auth login
	gh auth setup-git
	git config --global commit.gpgsign true
	git config --global user.signingkey /home/me/.ssh/id_ed25519.pub
	git config --global user.email git@paepcke.de
	git config --global user.name "Paepcke, Michael"
	echo '[end][module:setup_gh]'
}

module_setup_ohmyzsh() {
	echo '[start][module:setup_ohmyzsh]'
	cd || exit 1
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	echo '[end][module:setup_ohmyzsh]'
}

module_setup_p10k() {
	mkdir -p ~/.oh-my-zsh/custom/themes
	git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
}

module_setup_dotenv() {
	echo '[start][module:setup_dotenv]'
	cd || exit 1
	if [ -x .dotenv/.git ]; then
		(cd .dotenv && git pull)
	else
		(cd && git clone git@github.com:$github_user/dotenv .dotenv)
	fi
	cd || exit 1
	mkdir -p ".attic/$dts"
	touch .vimrc .zshrc .zshrc.pre-oh-my-zsh
	mv -f .vimrc .zshrc .zshrc.pre-oh-my-zsh ".attic/$dts/"
	mkdir -p .ssh
	# ln -fs .dotenv/vimrc .vimrc
	ln -fs .dotenv/zshrc .zshrc
	ln -fs .dotenv/gitconfig .gitconfig
	mkdir -p .ssh || exit 1
	cd .ssh || exit 1
	ln -fs ../.dotenv/ssh/config config
	ln -fs ../.dotenv/ssh/known_hosts known_hosts
	ln -fs ../.dotenv/ssh/id_ed25519.pub id_ed25519.pub
	ln -fs ../.dotenv/ssh/allowed_signers allowed_signers
	cd || exit 1
	echo '[end][module:setup_dotenv]'
}

module_brew() {
	echo "[start][module:brew]"
	if [ ! "$(brew info)" ]; then
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi
	brew upgrade
	bopt='' blist=$pkg_cli brew_install
	if [ "$gui" = "true" ]; then
		bgui='' blist=$pkg_gui brew_install
	fi
	case $os in
	Linux)
		bopt='' blist=$pkg_cli_linux brew_install
		if [ "$gui" = "true" ]; then
			bgui='true' blist=$pkg_gui_linux brew_install
		fi
		;;
	Darwin)
		bopt='' blist=$pkg_cli_darwin brew_install
		if [ "$gui" = "true" ]; then
			bgui='true' blist=$pkg_gui_darwin brew_install
		fi
		;;

	esac
	echo "[end][module:brew]"
}

module_pkg() {
	case $os in
	FreeBSD)
		sudo pkg install $pkg_cli $pkg_cli_freebsd
		if [ "$gui" = "true" ]; then
			sudo pkg install $pkg_gui $pkg_gui_freebsd
		fi
		;;
	OpenBSD)
		sudo pkg_add $pkg_cli $pkg_cli_openbsd
		if [ "$gui" = "true" ]; then
			sudo pkg_add $pkg_gui $pkg_gui_openbsd
		fi
		;;
	esac
}

module_setup() {
	module_setup_ohmyzsh
	module_setup_p10k
	# module_setup_gh
	module_setup_dotenv
}

linux() {
	module_brew
	module_setup
}

darwin() {
	module_brew
	module_setup
}

freebsd() {
	module_pkg
	module_setup
}

init() {
	echo "[start][$os]"
	case $os in
	Linux) linux ;;
	Darwin) darwin ;;
	FreeBSD) freebsd ;;
	*) echo "unable to recognise os" && exit 1 ;;
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
