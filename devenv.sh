#!/bin/bash

echo "DEVENV.sh - A glamorous shell scripts to install development tools, libraries,.. on Arch, Fedora, Ubuntu and MacOSX "
echo "Programming languages: python, elixir, erlang, ruby, rust, go, lua, r-lang, javascript, typescript, haskell, perl, java, julia, cpp, bash, php"
echo "Databases: PostgreSQL, MongoDB, SQLite"
echo "Tools: disk, ngrok, terminal, ollama"

platform='unknown'
unamestr=$(uname)
if [ "$unamestr" = 'Linux' ]; then
	platform='linux'
elif [ "$unamestr" = 'Darwin' ]; then
	platform='darwin'
fi

read -p "What programming language do you need ex. python (separated by a space - all for all available languages)? " p_language

read -p "What database do you need ex. sqlite (separated by a space - all for all available databases)? " database

read -p "What tools do you need ex. docker (separated by a space - all for all available tools)? " tools

if [ "$platform" = "linux" ]; then
	distro=$(cat /etc/*-release | grep -w NAME | cut -d= -f2 | tr -d '"')
	echo "Determined platform: $distro"
	if [[ "$distro" = "Arch Linux" || "$distro" = "Garuda Linux" || "$distro" = "EndeavourOS" || "$distro" = "CachyOS Linux" ]]; then
		sudo pacman -Syu
		sudo pacman -S base-devel git curl openssl readline xz zlib libtool automake

		if [[ "$p_language" = *"python"* || "$p_language" = "all" ]]; then
			sudo pacman -S python python-pip python-pipx
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
			sudo pacman -S rust rust-analyzer cargo
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
			sudo pacman -S ghc haskell-language-server cabal-install
		fi

		if [[ "$p_language" = *"perl"* || "$p_language" = "all" ]]; then
			sudo pacman -S perl
			yay -S perl-perl-languageserver
		fi

		if [[ "$p_language" = *"java"* || "$p_language" = "all" ]]; then
			sudo pacman -S jdk-openjdk gradle maven
		fi

		if [[ "$p_language" = *"julia"* || "$p_language" = "all" ]]; then
			sudo pacman -S julia
		fi

		if [[ "$p_language" = *"bash"* || "$p_language" = "all" ]]; then
			sudo pacman -S bash-language-server shfmt shellcheck
		fi

		if [[ "$p_language" = *"cpp"* || "$p_language" = "all" ]]; then
			sudo pacman -S cppcheck astyle iniparser
			yay -S cmake-language-server
		fi

		if [[ "$p_language" = *"php"* || "$p_language" = "all" ]]; then
			sudo pacman -S php composer
		fi

		if [[ "$database" = *"postgresql"* || "$database" = "all" ]]; then
			sudo pacman -S postgresql
		fi

		if [[ "$database" = *"sqlite"* || "$database" = "all" ]]; then
			sudo pacman -S sqlite
		fi

		if [[ "$database" = *"mongo"* || "$database" = "all" ]]; then
			yay -S mongodb-bin mongodb-tools-bin mongosh-bin
		fi

		if [[ "$tools" = *"docker"* || "$tools" = "all" ]]; then
			sudo pacman -S docker docker-buildx docker-compose containerd
			sudo usermod -aG docker $USER
			newgrp docker
		fi

		if [[ "$tools" = *"makefile"* || "$tools" = "all" ]]; then
			sudo pacman -S checkmake
		fi

		if [[ "$tools" = *"games"* || "$tools" = "all" ]]; then
			yay -S tetris-terminal-git
		fi

		if [[ "$tools" = *"cava"* || "$tools" = "all" ]]; then
			sudo pacman -S fftw ncurses espeak-ng portaudio
			yay -S cava
		fi

		if [[ "$tools" = *"disk"* || "$tools" = "all" ]]; then
			sudo pacman -S ncdu
		fi

		if [[ "$tools" = *"terminal"* || "$tools" = "all" ]]; then
			sudo pacman -S ripgrep fd lazygit tmux github-cli gum
		fi

		if [[ "$tools" = *"ngrok"* || "$tools" = "all" ]]; then
			yay -S ngrok
		fi

		if [[ "$tools" = *"ollama"* || "$tools" = "all" ]]; then
			curl -fsSL https://ollama.com/install.sh | sh
		fi

	elif [ "$distro" = "Ubuntu" ]; then
		sudo apt-get update
		sudo apt-get upgrade
		sudo apt-get install build-essential git curl libfftw3-dev libyaml-dev \
			libreadline-dev libedit-dev libssl-dev \
			libasound2-dev libncursesw5-dev libpulse-dev libtool automake

		if [[ "$p_language" = *"python"* || "$p_language" = "all" ]]; then
			sudo apt-get install python3-full python3-pip
		fi

		if [[ "$p_language" = *"erlang" || "$p_language" = *"elixir"* || "$p_language" = "all" ]]; then
			sudo apt-get install erlang elixir rebar3 # elixir-ls
		fi

		if [[ "$p_language" = *"ruby"* || "$p_language" = "all" ]]; then
			sudo apt-get install ruby-full
		fi

		if [[ "$p_language" = *"rust"* || "$p_language" = "all" ]]; then
			curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh
			sudo apt-get install rust-analyzer
		fi

		if [[ "$p_language" = *"go"* || "$p_language" = "all" ]]; then
			sudo apt-get install golang-go gopls
		fi

		if [[ "$p_language" = *"lua"* || "$p_language" = "all" ]]; then
			sudo apt-get install lua5.4 luarocks # lua-language-server
		fi

		if [[ "$p_language" = *"r-lang"* || "$p_language" = "all" ]]; then
			sudo apt-get install r-base
		fi

		if [[ "$p_language" = *"javascript"* || "$p_language" = *"typescript"* || "$p_language" = "all" ]]; then
			sudo apt-get install nodejs npm
			curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
		fi

		if [[ "$p_language" = *"typescript"* || "$p_language" = "all" ]]; then
			sudo apt-get install node-typescript

		fi

		if [[ "$p_language" = *"haskell"* || "$p_language" = "all" ]]; then
			curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
			ghcup install ghc haskell-language-server
		fi

		if [[ "$p_language" = *"perl"* || "$p_language" = "all" ]]; then
			sudo apt-get install perl perl-perl-languageserver
		fi

		if [[ "$p_language" = *"java"* || "$p_language" = "all" ]]; then
			sudo apt-get install default-jdk gradle
		fi

		if [[ "$database" = *"postgresql"* || "$database" = "all" ]]; then
			sudo apt-get install postgresql
		fi

		if [[ "$database" = *"sqlite"* || "$database" = "all" ]]; then
			sudo apt-get install sqlite
		fi

		if [[ "$database" = *"mongo"* || "$database" = "all" ]]; then
			curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc
			sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
			echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
			sudo apt-get update
			sudo apt-get install -y mongodb-org
		fi

		if [[ "$tools" = *"cava"* || "$tools" = "all" ]]; then
			sudo apt-get install espeak-ng cava
		fi

		if [[ "$tools" = *"ollama"* || "$tools" = "all" ]]; then
			curl -fsSL https://ollama.com/install.sh | sh
		fi

	elif [ "$distro" = "Fedora Linux" ]; then
		# chown -R $USER /usr/local/lib
		sudo yum update
		sudo yum groupinstall "Development Tools"
		sudo yum install readline readline-devel libtool automake zlib.i686 bzip2-libs.i686 ncurses-devel

		if [[ "$p_language" = *"python"* || "$p_language" = "all" ]]; then
			sudo yum install python-pip python-devel
		fi

		if [[ "$p_language" = *"erlang"* || "$p_language" = *"elixir"* || "$p_language" = "all" ]]; then
			sudo yum install erlang elixir rebar
		fi

		if [[ "$p_language" = *"ruby"* || "$p_language" = "all" ]]; then
			sudo yum install libyaml-devel ruby ruby-devel rubygems
		fi

		if [[ "$p_language" = *"rust"* || "$p_language" = "all" ]]; then
			sudo yum install rust rust-analyzer cargo
		fi

		if [[ "$p_language" = *"go"* || "$p_language" = "all" ]]; then
			sudo yum install go
		fi

		if [[ "$p_language" = *"lua"* || "$p_language" = "all" ]]; then
			sudo yum install lua luarocks
		fi

		if [[ "$p_language" = *"r-lang"* || "$p_language" = "all" ]]; then
			sudo yum install R
		fi

		if [[ "$p_language" = *"javascript"* || "$p_language" = "all" ]]; then
			sudo yum install nodejs npm
			sudo npm install -g nvm prettier
		fi

		if [[ "$p_language" = *"typescript"* || "$p_language" = "all" ]]; then
			sudo yum install typescript
		fi

		if [[ "$p_language" = *"haskell"* || "$p_language" = "all" ]]; then
			sudo dnf copr enable petersen/haskell-language-server
			sudo yum install ghc-compiler haskell-language-server
		fi

		if [[ "$p_language" = *"perl"* || "$p_language" = "all" ]]; then
			sudo yum install perl
			sudo cpan Perl::LanguageServer
		fi

		if [[ "$p_language" = *"java"* || "$p_language" = "all" ]]; then
			sudo yum install java
		fi

		if [[ "$database" = *"postgresql"* || "$database" = "all" ]]; then
			sudo yum install postgresql-server postgresql postgresql-devel
		fi

		if [[ "$database" = *"sqlite"* || "$database" = "all" ]]; then
			sudo yum install sqlite sqlite-devel
		fi

		if [[ "$database" = *"mongo"* || "$database" = "all" ]]; then
			echo "Not supported"
		fi

		if [[ "$tools" = *"github"* || "$tools" = "all" ]]; then
			sudo yum install gh
		fi

		if [[ "$tools" = *"cava"* || "$tools" = "all" ]]; then
			sudo yum install ncurses-libs.i686 espeak-ng cava
		fi

		if [[ "$tools" = *"qemu"* || "$tools" = "all" ]]; then
			sudo yum install qemu-kvm bridge-utils libvirt virt-install
		fi

		if [[ "$tools" = *"ollama"* || "$tools" = "all" ]]; then
			curl -fsSL https://ollama.com/install.sh | sh
		fi

	fi
elif [ "$platform" = "darwin" ]; then
	echo "Determined platform: $platform"
	brew update && brew upgrade
	brew install git curl libtool automake openssl readline xz zlib autoconf-archive

	if [[ "$p_language" = *"python"* || "$p_language" = "all" ]]; then
		brew install python pyenv pyenv-virtualenv
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
		brew install lua lua-language-server cmake
	fi

	if [[ "$p_language" = *"javascript"* || "$p_language" = *"javascript"* || "$p_language" = "all" ]]; then
		brew install node nvm typescript
	fi

	if [[ "$p_language" = *"go"* || "$p_language" = "all" ]]; then
		brew install go gopls golangci-lint
	fi

	if [[ "$p_language" = *"haskell"* || "$p_language" = "all" ]]; then
		brew install ghc ghcup haskell-language-server
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

	if [[ "$database" = *"mongo"* || "$database" = "all" ]]; then
		brew tap mongodb/brew
		brew install mongodb/brew/mongodb-community
	fi

	if [[ "$tools" = *"docker"* || "$tools" = "all" ]]; then
		brew install hadolint
	fi

	if [[ "$tools" = *"makefile"* || "$tools" = "all" ]]; then
		brew install checkmake
	fi

	if [[ "$p_language" = *"java"* || "$p_language" = "all" ]]; then
		brew install gradle maven
	fi

	if [[ "$p_language" = *"bash"* || "$p_language" = "all" ]]; then
		brew install bash-language-server shfmt shellcheck
	fi

	if [[ "$p_language" = *"cpp"* || "$p_language" = "all" ]]; then
		brew install cppcheck astyle iniparser clang-format cmake-language-server
	fi

	if [[ "$tools" = *"github"* || "$tools" = "all" ]]; then
		brew install gh gitlint
	fi

	if [[ "$tools" = *"cava"* || "$tools" = "all" ]]; then
		brew install fftw ncurses espeak portaudio cava
	fi

	if [[ "$tools" = *"disk"* || "$tools" = "all" ]]; then
		brew install ncdu
	fi

	if [[ "$tools" = *"terminal"* || "$tools" = "all" ]]; then
		brew install ripgrep fd lazygit tmux github-cli gum powerlevel10k circumflex
	fi

	if [[ "$tools" = *"irc"* || "$tools" = "all" ]]; then
		brew install irssi
	fi

	if [[ "$tools" = *"email"* || "$tools" = "all" ]]; then
		brew install pass isync msmtp abook urlview neomutt
	fi

	if [[ "$tools" = *"ollama"* || "$tools" = "all" ]]; then
		echo "Please download it from https://ollama.com/download/mac"
	fi

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

if [[ "$tools" = *"github"* || "$tools" = "all" ]]; then
	gh extension install dlvhdr/gh-dash
fi

if [[ "$p_language" = *"javascript"* || "$p_language" = *"typescript"* || "$p_language" = "all" ]]; then
	sudo npm i -g eslint vscode-langservers-extracted markdownlint-cli write-good \
		fixjson @fsouza/prettierd stylelint shopify-cli cross-env webpack \
		sass serverless npm-run-all nativescript dockerfile-language-server-nodejs \
		neovim gulp
fi

if [[ "$p_language" = *"java"* || "$p_language" = "all" ]]; then
	curl -s "https://get.sdkman.io" | bash
	sdk install gradle
fi

if [ -n "$ZSH_VERSION" ]; then
	zsh_shell=true
elif [ -n "$FISH_VERSION" ]; then
	fish_shell=true
	curl -sL https://git.io/fisher | . && fisher install jorgebucaran/fisher
	fisher install reitzig/sdkman-for-fish@v1.4.0
elif [ -n "$BASH_VERSION" ]; then
	bash_shell=true
fi
