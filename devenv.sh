#!/bin/bash

echo "DEVENV.sh - A glamorous shell scripts to install development tools, libraries,.. on arch, macosx, fedora and ubuntu"

platform='unknown'
unamestr=$(uname)
if [ "$unamestr" = 'Linux' ]; then
	platform='linux'
elif [ "$unamestr" = 'Darwin' ]; then
	platform='darwin'
fi

read -p "What programming language do you need(separated by a space - all for all available languages)? " p_language

read -p "What database do you need(separated by a space - all for all available databases)? " database

if [ "$platform" = "linux" ]; then
	distro=$(cat /etc/*-release | grep -w NAME | cut -d= -f2 | tr -d '"')
	echo "Determined platform: $distro"
	if [[ "$distro" = "Arch Linux" || "$distro" = "Garuda Linux" || "$distro" = "EndeavourOS" ]]; then
		sudo pacman -Syy
		sudo pacman -Su
		sudo pacman -S base-devel git curl openssl readline xz zlib libtool automake

		if [[ "$p_language" = *"python"* || "$p_language" = "all" ]]; then
			sudo pacman -S python python-pip
		fi

		if [[ "$p_language" = *"erlang" || "$p_language" = *"elixir"* || "$p_language" = "all" ]]; then
			sudo pacman -S erlang elixir
			yay -S rebar3 elixir-ls
		fi

		if [[ "$p_language" = *"ruby"* || "$p_language" = "all" ]]; then
			sudo pacman -S ruby
			yay -S rbenv
		fi

		if [[ "$p_language" = *"rust"* || "$p_language" = "all" ]]; then
			sudo pacman -S rust rust-analyzer
		fi

		if [[ "$p_language" = *"go"* || "$p_language" = "all" ]]; then
			sudo pacman -S go gopls
		fi

		if [[ "$p_language" = *"lua"* || "$p_language" = "all" ]]; then
			sudo pacman -S lua luarocks lua-language-server
		fi

		if [[ "$p_language" = *"r-lang"* || "$p_language" = "all" ]]; then
			yay -S r-rlang
		fi

		if [[ "$p_language" = *"javascript"* || "$p_language" = *"typescript"* || "$p_language" = "all" ]]; then
			sudo pacman -S nodejs npm prettier
			yay -S nvm
		fi

		if [[ "$p_language" = *"typescript"* || "$p_language" = "all" ]]; then
			sudo pacman -S typescript
		fi

		if [[ "$p_language" = *"haskell"* || "$p_language" = "all" ]]; then
			sudo pacman -S ghc haskell-language-server
		fi

		if [[ "$p_language" = *"perl"* || "$p_language" = "all" ]]; then
			sudo pacman -S perl perl-perl-languageserver
		fi

		if [[ "$p_language" = *"java"* || "$p_language" = "all" ]]; then
			sudo pacman -S jdk-openjdk gradle
		fi

		if [[ "$database" = *"postgresql"* || "$database" = "all" ]]; then
			sudo pacman -S postgresql
		fi

		if [[ "$database" = *"sqlite"* || "$database" = "all" ]]; then
			sudo pacman -S sqlite
		fi

		sudo pacman -S iniparser fftw ncurses espeak-ng \
			portaudio astyle shfmt cppcheck bash-language-server \
			shellcheck ripgrep fd lazygit ncdu tmux github-cli gum
		yay -S checkmake hadolint cava tetris-terminal-git
	elif [ "$distro" = "Ubuntu Linux" ]; then
		sudo apt-get update
		sudo apt-get upgrade
		sudo apt-get install build-essential git curl libfftw3-dev \
			libasound2-dev libncursesw5-dev libpulse-dev libtool automake

		if [[ "$p_language" = *"rust"* || "$p_language" = "all" ]]; then
			curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh
			sudo apt-get install rust-analyzer
		fi

		if [[ "$p_language" = *"ruby"* || "$p_language" = "all" ]]; then
			sudo apt-get install ruby-full
		fi

		if [[ "$p_language" = *"java"* || "$p_language" = "all" ]]; then
			sudo apt-get install default-jdk gradle
		fi
		sudo apt-get install gum cava espeak-ng
	elif [ "$distro" = "Fedora Linux" ]; then
		sudo yum update
		sudo yum groupinstall "Development Tools"
		sudo yum install readline readline-devel libtool automake zlib.i686 bzip2-libs.i686

		if [[ "$p_language" = *"erlang"* || "$p_language" = *"elixir"* || "$p_language" = "all" ]]; then
			sudo yum install erlang elixir rebar
		fi

		if [[ "$p_language" = *"java"* || "$p_language" = "all" ]]; then
			sudo yum install java
		fi

		if [[ "$p_language" = *"python"* || "$p_language" = "all" ]]; then
			sudo yum install python-pip
		fi

		if [[ "$p_language" = *"go"* || "$p_language" = "all" ]]; then
			sudo yum install go
		fi

		if [[ "$p_language" = *"rust"* || "$p_language" = "all" ]]; then
			sudo yum install rust rust-analyzer cargo
		fi

		if [[ "$p_language" = *"javascript"* || "$p_language" = "all" ]]; then
			sudo yum install nodejs
		fi

		if [[ "$p_language" = *"lua"* || "$p_language" = "all" ]]; then
			sudo yum install lua luarocks
		fi

		if [[ "$p_language" = *"ruby"* || "$p_language" = "all" ]]; then
			sudo yum install ruby ruby-devel rubygems
		fi

		if [[ "$database" = *"postgresql"* || "$database" = "all" ]]; then
			sudo yum install postgresql
		fi

		sudo yum install cava espeak-ng gh qemu-kvm bridge-utils libvirt virt-install ncurses-libs.i686
	fi
elif [ "$platform" = "darwin" ]; then
	echo "Determined platform: $platform"
	brew update && brew upgrade
	brew install git curl libtool automake openssl readline xz zlib autoconf-archive

	if [[ "$p_language" = *"python"* || "$p_language" = "all" ]]; then
		brew install python
	fi

	if [[ "$p_language" = *"ruby"* || "$p_language" = "all" ]]; then
		brew install ruby rbenv
	fi

	if [[ "$p_language" = *"erlang"* || "$p_language" = *"elixir"* || "$p_language" = "all" ]]; then
		brew install erlang elixir rebar3 elixir-ls
	fi

	if [[ "$p_language" = *"rust"* || "$p_language" = "all" ]]; then
		brew install rust rust-analyzer
	fi

	if [[ "$p_language" = *"lua"* || "$p_language" = "all" ]]; then
		brew install lua lua-language-server
	fi

	if [[ "$p_language" = *"go"* || "$p_language" = "all" ]]; then
		brew install go
	fi

	if [[ "$p_language" = *"javascript"* || "$p_language" = *"javascript"* || "$p_language" = "all" ]]; then
		brew install node nvm typescript
	fi

	if [[ "$p_language" = *"go"* || "$p_language" = "all" ]]; then
		brew install go gopls golangci-lint
	fi

	if [[ "$p_language" = *"haskell"* || "$p_language" = "all" ]]; then
		brew install ghc haskell-language-server
	fi

	if [[ "$p_language" = *"perl"* || "$p_language" = "all" ]]; then
		brew install perl
	fi

	if [[ "$database" = *"postgresql"* || "$database" = "all" ]]; then
		brew install postgresql
	fi

	if [[ "$database" = *"sqlite"* || "$database" = "all" ]]; then
		brew install sqlite3
	fi

	if [[ "$p_language" = *"java"* || "$p_language" = "all" ]]; then
		brew install gradle
	fi

	brew install shellcheck ripgrep fd lazygit ncdu \
		hadolint checkmake gh gum fftw ncurses \
		portaudio cava astyle shfmt cppcheck gitlint \
		espeak circumflex clang-format bash-language-server \
		efm-langserver
	export LIBTOOL='which glibtool'
	export LIBTOOLIZE='which glibtoolize'
	ln -s 'which glibtoolize' /usr/local/bin/libtoolize
	ln -s /usr/lib/libncurses.dylib /usr/local/lib/libncursesw.dylib
fi

if [[ "$p_language" = *"ruby"* || "$p_language" = "all" ]]; then
	sudo gem update
	sudo gem install solargraph rubocop neovim tmuxinator
fi

if [[ "$p_language" = *"python"* || "$p_language" = "all" ]]; then
	curl https://pyenv.run | bash
	pip install -U pip
	pip install flake8 black isort cmake-language-server djlint pynvim
fi

if [[ "$p_language" = *"lua"* || "$p_language" = "all" ]]; then
	sudo luarocks install luacheck
fi

if [[ "$p_language" = *"rust"* || "$p_language" = "all" ]]; then
	cargo install selene stylua efmt bliss
fi

if [[ "$p_language" = *"go"* || "$p_language" = "all" ]]; then
	go install mvdan.cc/sh/v3/cmd/shfmt@latest
	go install github.com/maaslalani/nap@main
	go install github.com/DyegoCosta/snake-game@latest
	go install github.com/maaslalani/typer@latest
	go install github.com/mritd/gitflow-toolkit/v2@latest

	sudo gitflow-toolkit install
fi

gh extension install dlvhdr/gh-dash

if [[ "$p_language" = *"javascript"* || "$p_language" = *"typescript"* || "$p_language" = "all" ]]; then
	npm i -g eslint vscode-langservers-extracted markdownlint-cli write-good \
		fixjson @fsouza/prettierd stylelint shopify-cli cross-env webpack \
		sass serverless npm-run-all nativescript dockerfile-language-server-nodejs \
		neovim gulp
fi

if [[ "$p_language" = *"java"* || "$p_language" = "all" ]]; then
	curl -s "https://get.sdkman.io" | bash
	sdk install gradle
fi

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
