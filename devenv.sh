#!/bin/bash

echo "DEVENV.sh - A glamorous shell scripts to install development tools, libraries,.. on arch, macosx, fedora and ubuntu"

platform='unknown'
unamestr=$(uname)
if [ "$unamestr" = 'Linux' ]; then
	platform='linux'
elif [ "$unamestr" = 'Darwin' ]; then
	platform='darwin'
fi

read -p "What programming language do you need(separated by a space)? " p_language

read -p "What database do you need(separated by a space)? " database

if [ "$platform" = "linux" ]; then
	distro=$(cat /etc/*-release | grep -w NAME | cut -d= -f2 | tr -d '"')
	echo "Determined platform: $distro"
	if [[ "$distro" = "Arch Linux" || "$distro" = "Garuda Linux" || "$distro" = "EndeavourOS" ]]; then
		sudo pacman -Syy
		sudo pacman -Su
		sudo pacman -S base-devel git curl openssl readline xz zlib libtool automake
		if [[ "$p_language" = *"python"* ]]; then
			sudo pacman -S python python-pip
		fi
		if [[ "$p_language" = *"erlang" || "$p_language" = *"elixir"* ]]; then
			sudo pacman -S erlang elixir
			yay -S rebar3 elixir-ls
		fi
		if [[ "$p_language" = *"ruby"* ]]; then
			sudo pacman -S ruby
			yay -S rbenv
		fi
		if [[ "$p_language" = *"rust"* ]]; then
			sudo pacman -S rust rust-analyzer
		fi
		if [[ "$p_language" = *"go"* ]]; then
			sudo pacman -S go gopls
		fi
		if [[ "$p_language" = *"lua"* ]]; then
			sudo pacman -S lua luarocks lua-language-server
		fi
		if [[ "$p_language" = *"r-lang"* ]]; then
			yay -S r-rlang
		fi
		if [[ "$p_language" = *"javascript"* || "$p_language" = *"typescript"* ]]; then
			sudo pacman -S nodejs npm prettier
			yay -S nvm
		fi
		if [[ "$p_language" = *"typescript"* ]]; then
			sudo pacman -S typescript
		fi
		if [[ "$p_language" = *"haskell"* ]]; then
			sudo pacman -S ghc haskell-language-server
		fi
		if [[ "$p_language" = *"perl"* ]]; then
			sudo pacman -S perl perl-perl-languageserver
		fi
		if [[ "$database" = *"postgresql"* ]]; then
			sudo pacman -S postgresql
		fi
		if [[ "$database" = *"sqlite"* ]]; then
			sudo pacman -S sqlite
		fi
		sudo pacman -S iniparser fftw ncurses espeak-ng \
			portaudio astyle shfmt cppcheck bash-language-server \
			shellcheck ripgrep fd lazygit ncdu gradle tmux github-cli gum
		yay -S checkmake hadolint cava tetris-terminal-git
	elif [ "$distro" = "Ubuntu Linux" ]; then
		sudo apt-get update
		sudo apt-get upgrade
		sudo apt-get install git curl gum rust-analyzer libfftw3-dev \
			libasound2-dev libncursesw5-dev libpulse-dev libtool automake \
			cava espeak-ng gradle
	elif [ "$distro" = "Fedora Linux" ]; then
		sudo yum update
		sudo yum install git curl gcc-c++ erlang elixir java python-pip go cargo nodejs luarocks rust rust-analyzer \
			libtool automake cava espeak-ng gh rebar ruby-devel rubygems qemu-kvm bridge-utils libvirt virt-install \
			zlib.i686 ncurses-libs.i686 bzip2-libs.i686 postgresql
	fi
elif [ "$platform" = "darwin" ]; then
	echo "Determined platform: $platform"
	brew update && brew upgrade
	brew install git curl python erlang elixir ruby rust lua go node \
		typescript ghc perl rebar3 shellcheck ripgrep fd lazygit ncdu \
		nvm hadolint checkmake postgresql gh openssl readline sqlite3 \
		xz zlib rbenv gum rust-analyzer fftw ncurses libtool automake \
		portaudio cava astyle shfmt cppcheck gitlint golangci-lint \
		lua-language-server elixir-ls samtay/tui/tetris espeak autoconf-archive \
		circumflex clang-format bash-language-server haskell-language-server \
		efm-langserver gopls gradle
	export LIBTOOL='which glibtool'
	export LIBTOOLIZE='which glibtoolize'
	ln -s 'which glibtoolize' /usr/local/bin/libtoolize
	ln -s /usr/lib/libncurses.dylib /usr/local/lib/libncursesw.dylib
fi

sudo gem update
sudo gem install solargraph rubocop neovim tmuxinator

curl https://pyenv.run | bash

sudo luarocks install luacheck

cargo install selene stylua efmt bliss

go install mvdan.cc/sh/v3/cmd/shfmt@latest
go install github.com/maaslalani/nap@main
go install github.com/DyegoCosta/snake-game@latest
go install github.com/maaslalani/typer@latest
go install github.com/mritd/gitflow-toolkit/v2@latest

sudo gitflow-toolkit install

gh extension install dlvhdr/gh-dash

pip install -U pip
pip install flake8 black isort cmake-language-server djlint pynvim

npm i -g eslint vscode-langservers-extracted markdownlint-cli write-good \
	fixjson @fsouza/prettierd stylelint shopify-cli cross-env webpack \
	sass serverless npm-run-all nativescript dockerfile-language-server-nodejs \
	neovim gulp

curl -s "https://get.sdkman.io" | bash

sdk install gradle

curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

if [ -n "$ZSH_VERSION" ]; then
	zsh_shell=true
elif [ -n "$FISH_VERSION" ]; then
	fish_shell=true
	curl -sL https://git.io/fisher | . && fisher install jorgebucaran/fisher
	fisher install reitzig/sdkman-for-fish@v1.4.0
elif [ -n "$BASH_VERSION" ]; then
	bash_shell=true
fi
