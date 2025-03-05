#!/bin/bash

echo "DEVENV.sh - A glamorous shell scripts to install development tools, libraries,.. on Arch, Fedora, Ubuntu and MacOSX "
echo "Programming languages: Python, Elixir, Erlang, Ruby, Rust, Go, Lua, R-lang, JavaScript, TypeScript, Haskell, Perl, Java, Julia, C/C++, Bash, PHP"
echo "Databases: PostgreSQL, MongoDB, SQLite, MySQL"
echo "Tools: Disk, Ngrok, Terminal, Cava, GitHub, IRC, Ollama"

platform='unknown'
distro='unknown'
shell='sh'
unamestr=$(uname)
if [ "$unamestr" = 'Linux' ]; then
	platform='linux'
	distro=$(cat /etc/*-release | grep -w NAME | cut -d= -f2 | tr -d '"')
elif [ "$unamestr" = 'Darwin' ]; then
	platform='darwin'
fi

if [ -n "$ZSH_VERSION" ]; then
	shell='zsh'
elif [ -n "$FISH_VERSION" ]; then
	shell='fish'
	curl -sL https://git.io/fisher | . && fisher install jorgebucaran/fisher
	fisher install reitzig/sdkman-for-fish@v1.4.0
elif [ -n "$BASH_VERSION" ]; then
	shell='bash'
fi

# Required packages
echo "Installing base packages"

if [ "$platform" = "linux" ]; then
	distro=$(cat /etc/*-release | grep -w NAME | cut -d= -f2 | tr -d '"')
	echo "Determined platform: $distro"

	if [[ "$distro" = "Arch Linux" || "$distro" = "Garuda Linux" || "$distro" = "EndeavourOS" || "$distro" = "CachyOS Linux" ]]; then
		sudo pacman -Syu
		sudo pacman -S base-devel git curl openssl readline xz zlib libtool automake gum
	elif [ "$distro" = "Ubuntu" ]; then
		sudo apt-get update
		sudo apt-get upgrade
		sudo apt-get install build-essential git curl libfftw3-dev libyaml-dev \
			libreadline-dev libedit-dev libssl-dev \
			libasound2-dev libncursesw5-dev libpulse-dev libtool automake
		sudo mkdir -p /etc/apt/keyrings
		curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
		echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
		sudo apt update && sudo apt install gum
	elif [ "$distro" = "Fedora Linux" ]; then
		# chown -R $USER /usr/local/lib
		sudo yum update
		sudo yum groupinstall "Development Tools"
		sudo yum install readline readline-devel libtool automake zlib.i686 bzip2-libs.i686 ncurses-devel
		echo '[charm]
		name=Charm
		baseurl=https://repo.charm.sh/yum/
		enabled=1
		gpgcheck=1
		gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo
		sudo rpm --import https://repo.charm.sh/yum/gpg.key
		sudo yum install gum
	fi
elif [ "$platform" = "darwin" ]; then
	echo "Determined platform: $platform"
	brew update && brew upgrade
	brew install git curl libtool automake openssl readline xz zlib autoconf-archive gum
fi

gum style \
	--foreground 36 --border-foreground 36 --border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	'devenv.sh' 'A glamorous shell scripts to install development tools, libraries on Linux and MacOSX'

AVAILABLE_LANGUAGES=("C/C++" "Ruby" "JavaScript" "TypeScript" "Go" "PHP" "Python" "Erlang" "Elixir" "Rust" "Java" "Lua" "Haskell" "Perl" "Julia" "R-lang")
p_languages=$(gum choose "${AVAILABLE_LANGUAGES[@]}" --no-limit --height 16 --header "What programming language(s) do you need?")

AVAILABLE_DATABASES=("PostgreSQL" "SQLite" "MongoDB" "MySQL")
databases=$(gum choose "${AVAILABLE_DATABASES[@]}" --no-limit --height 4 --header "What database(s) do you need?")

AVAILABLE_TOOLS=("Docker" "Makefile" "GitHub" "IRC" "Email" "Disk" "Terminal" "Cava")
tools=$(gum choose "${AVAILABLE_TOOLS[@]}" --no-limit --height 8 --header "What tool(s) do you need?")

if [ "$platform" = "linux" ]; then
	distro=$(cat /etc/*-release | grep -w NAME | cut -d= -f2 | tr -d '"')
	echo "Determined platform: $distro"
	if [[ "$distro" = "Arch Linux" || "$distro" = "Garuda Linux" || "$distro" = "EndeavourOS" || "$distro" = "CachyOS Linux" ]]; then

		for p_language in $p_languages; do
			if [[ "$p_language" = *"Python"* ]]; then
				sudo pacman -S python python-pip python-pipx
			fi

			if [[ "$p_language" = *"Erlang" || "$p_language" = *"Elixir"* ]]; then
				sudo pacman -S erlang
				yay -S rebar3
			fi

			if [[ "$p_language" = *"Elixir"* ]]; then
				sudo pacman -S elixir
				yay -S elixir-ls
			fi

			if [[ "$p_language" = *"Ruby"* ]]; then
				sudo pacman -S ruby
				yay -S rbenv
			fi

			if [[ "$p_language" = *"Rust"* ]]; then
				sudo pacman -S rust rust-analyzer cargo
			fi

			if [[ "$p_language" = *"Go"* ]]; then
				sudo pacman -S go gopls
			fi

			if [[ "$p_language" = *"Lua"* ]]; then
				sudo pacman -S lua luarocks lua-language-server
			fi

			if [[ "$p_language" = *"R-lang"* ]]; then
				yay -S r-rlang
			fi

			if [[ "$p_language" = *"JavaScript"* || "$p_language" = *"TypeScript"* ]]; then
				sudo pacman -S nodejs npm prettier
				yay -S nvm
			fi

			if [[ "$p_language" = *"TypeScript"* ]]; then
				sudo pacman -S typescript
			fi

			if [[ "$p_language" = *"Haskell"* ]]; then
				sudo pacman -S ghc haskell-language-server cabal-install
			fi

			if [[ "$p_language" = *"Perl"* ]]; then
				sudo pacman -S perl
				yay -S perl-perl-languageserver
			fi

			if [[ "$p_language" = *"Java"* ]]; then
				sudo pacman -S jdk-openjdk gradle maven
			fi

			if [[ "$p_language" = *"Julia"* ]]; then
				sudo pacman -S julia
			fi

			if [[ "$p_language" = *"Bash"* ]]; then
				sudo pacman -S bash-language-server shfmt shellcheck
			fi

			if [[ "$p_language" = *"C/C++"* ]]; then
				sudo pacman -S cppcheck astyle iniparser
				yay -S cmake-language-server
			fi

			if [[ "$p_language" = *"PHP"* ]]; then
				sudo pacman -S php composer
			fi
		done

		for database in $databases; do
			if [[ "$database" = *"PostgreSQL"* ]]; then
				sudo pacman -S postgresql
			fi

			if [[ "$database" = *"SQLite"* ]]; then
				sudo pacman -S sqlite
			fi

			if [[ "$database" = *"MongoDB"* ]]; then
				yay -S mongodb-bin mongodb-tools-bin mongosh-bin
			fi
		done

		for tool in $tools; do
			if [[ "$tool" = *"Docker"* ]]; then
				sudo pacman -S docker docker-buildx docker-compose containerd
				sudo usermod -aG docker $USER
				newgrp docker
			fi

			if [[ "$tool" = *"Makefile"* ]]; then
				sudo pacman -S checkmake
			fi

			if [[ "$tool" = *"Games"* ]]; then
				yay -S tetris-terminal-git
			fi

			if [[ "$tool" = *"Cava"* ]]; then
				sudo pacman -S fftw ncurses espeak-ng portaudio
				yay -S cava
			fi

			if [[ "$tool" = *"Disk"* ]]; then
				sudo pacman -S ncdu
			fi

			if [[ "$tool" = *"Terminal"* ]]; then
				sudo pacman -S ripgrep fd lazygit tmux github-cli
			fi

			if [[ "$tool" = *"Ngrok"* ]]; then
				yay -S ngrok
			fi

			if [[ "$tool" = *"Ollama"* ]]; then
				curl -fsSL https://ollama.com/install.sh | sh
			fi
		done

	elif [ "$distro" = "Ubuntu" ]; then

		for p_language in $p_languages; do
			if [[ "$p_language" = *"Python"* ]]; then
				sudo apt-get install python3-full python3-pip
			fi

			if [[ "$p_language" = *"Erlang" || "$p_language" = *"Elixir"* ]]; then
				sudo apt-get install erlang rebar3 # elixir-ls
			fi

			if [[ "$p_language" = *"Elixir"* ]]; then
				sudo apt-get install elixir # elixir-ls
			fi

			if [[ "$p_language" = *"Ruby"* ]]; then
				sudo apt-get install ruby-full
			fi

			if [[ "$p_language" = *"Rust"* ]]; then
				curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh
				sudo apt-get install rust-analyzer
			fi

			if [[ "$p_language" = *"Go"* ]]; then
				sudo apt-get install golang-go gopls
			fi

			if [[ "$p_language" = *"Lua"* ]]; then
				sudo apt-get install lua5.4 luarocks # lua-language-server
			fi

			if [[ "$p_language" = *"R-lang"* ]]; then
				sudo apt-get install r-base
			fi

			if [[ "$p_language" = *"JavaScript"* || "$p_language" = *"TypeScript"* ]]; then
				sudo apt-get install nodejs npm
				curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
			fi

			if [[ "$p_language" = *"TypeScript"* ]]; then
				sudo apt-get install node-typescript

			fi

			if [[ "$p_language" = *"Haskell"* ]]; then
				curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
				ghcup install ghc haskell-language-server
			fi

			if [[ "$p_language" = *"Perl"* ]]; then
				sudo apt-get install perl perl-perl-languageserver
			fi

			if [[ "$p_language" = *"Java"* ]]; then
				sudo apt-get install default-jdk gradle
			fi

			if [[ "$p_language" = *"PHP"* ]]; then
				sudo add-apt-repository -y ppa:ondrej/php
				sudo apt -y install php8.4 php8.4-{curl,apcu,intl,mbstring,opcache,pgsql,mysql,sqlite3,redis,xml,zip}
				php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
				php composer-setup.php --quiet && sudo mv composer.phar /usr/local/bin/composer
				rm composer-setup.php
			fi
		done

		for database in $databases; do
			if [[ "$database" = *"PostgreSQL"* ]]; then
				sudo apt-get install postgresql
			fi

			if [[ "$database" = *"SQLite"* ]]; then
				sudo apt-get install sqlite
			fi

			if [[ "$database" = *"MongoDB"* ]]; then
				curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc
				sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
				echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
				sudo apt-get update
				sudo apt-get install -y mongodb-org
			fi
		done

		for tool in $tools; do
			if [[ "$tool" = *"Docker"* ]]; then
				sudo install -m 0755 -d /etc/apt/keyrings
				sudo wget -qO /etc/apt/keyrings/docker.asc https://download.docker.com/linux/ubuntu/gpg
				sudo chmod a+r /etc/apt/keyrings/docker.asc
				echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
				sudo apt update

				# Install Docker engine and standard plugins
				sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

				# Give this user privileged Docker access
				sudo usermod -aG docker ${USER}

				# Limit log size to avoid running out of disk
				echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json
			fi

			if [[ "$tool" = *"Cava"* ]]; then
				sudo apt-get install espeak-ng cava
			fi

			if [[ "$tool" = *"Ollama"* ]]; then
				curl -fsSL https://ollama.com/install.sh | sh
			fi
		done

	elif [ "$distro" = "Fedora Linux" ]; then

		for p_language in $p_languages; do
			if [[ "$p_language" = *"Python"* ]]; then
				sudo yum install python-pip python-devel
			fi

			if [[ "$p_language" = *"Erlang"* || "$p_language" = *"Elixir"* ]]; then
				sudo yum install erlang rebar
			fi

			if [[ "$p_language" = *"Elixir"* ]]; then
				sudo yum install elixir
			fi

			if [[ "$p_language" = *"Ruby"* ]]; then
				sudo yum install libyaml-devel ruby ruby-devel rubygems
			fi

			if [[ "$p_language" = *"Rust"* ]]; then
				sudo yum install rust rust-analyzer cargo
			fi

			if [[ "$p_language" = *"Go"* ]]; then
				sudo yum install go
			fi

			if [[ "$p_language" = *"Lua"* ]]; then
				sudo yum install lua luarocks
			fi

			if [[ "$p_language" = *"R-lang"* ]]; then
				sudo yum install R
			fi

			if [[ "$p_language" = *"JavaScript"* ]]; then
				sudo yum install nodejs npm
				sudo npm install -g nvm prettier
			fi

			if [[ "$p_language" = *"TypeScript"* ]]; then
				sudo yum install typescript
			fi

			if [[ "$p_language" = *"Haskell"* ]]; then
				sudo dnf copr enable petersen/haskell-language-server
				sudo yum install ghc-compiler haskell-language-server
			fi

			if [[ "$p_language" = *"Perl"* ]]; then
				sudo yum install perl
				sudo cpan Perl::LanguageServer
			fi

			if [[ "$p_language" = *"Java"* ]]; then
				sudo yum install java
			fi

			if [[ "$p_language" = *"PHP"* ]]; then
				sudo dnf install php-cli phpunit composer php-mysqli
			fi
		done

		for database in $databases; do
			if [[ "$database" = *"PostgreSQL"* ]]; then
				sudo yum install postgresql-server postgresql postgresql-devel
			fi

			if [[ "$database" = *"SQLite"* ]]; then
				sudo yum install sqlite sqlite-devel
			fi

			if [[ "$database" = *"MongoDB"* ]]; then
				echo "Not supported"
			fi
		done

		for tool in $tools; do
			if [[ "$tool" = *"GitHub"* ]]; then
				sudo yum install gh
			fi

			if [[ "$tool" = *"Cava"* ]]; then
				sudo yum install ncurses-libs.i686 espeak-ng cava
			fi

			if [[ "$tool" = *"Qemu"* ]]; then
				sudo yum install qemu-kvm bridge-utils libvirt virt-install
			fi

			if [[ "$tool" = *"Ollama"* ]]; then
				curl -fsSL https://ollama.com/install.sh | sh
			fi
		done
	fi
elif [ "$platform" = "darwin" ]; then
	for p_language in $p_languages; do
		if [[ "$p_language" = *"Python"* ]]; then
			brew install python pyenv pyenv-virtualenv
		fi

		if [[ "$p_language" = *"Ruby"* ]]; then
			brew install ruby rbenv standard solargraph
		fi

		if [[ "$p_language" = *"Erlang"* || "$p_language" = *"Elixir"* ]]; then
			brew install erlang rebar3
		fi

		if [[ "$p_language" = *"Elixir"* ]]; then
			brew install elixir elixir-ls
		fi

		if [[ "$p_language" = *"Rust"* ]]; then
			brew install rust rust-analyzer
		fi

		if [[ "$p_language" = *"Lua"* ]]; then
			brew install lua lua-language-server cmake
		fi

		if [[ "$p_language" = *"JavaScript"* || "$p_language" = *"TypeScript"* ]]; then
			brew install node nvm
		fi

		if [[ "$p_language" = *"TypeScript"* ]]; then
			brew install typescript
		fi

		if [[ "$p_language" = *"Go"* ]]; then
			brew install go gopls golangci-lint
		fi

		if [[ "$p_language" = *"Haskell"* ]]; then
			brew install ghc ghcup haskell-language-server
		fi

		if [[ "$p_language" = *"Perl"* ]]; then
			brew install perl
		fi

		if [[ "$p_language" = *"Java"* ]]; then
			brew install java gradle maven
		fi

		if [[ "$p_language" = *"Bash"* ]]; then
			brew install bash-language-server shfmt shellcheck
		fi

		if [[ "$p_language" = *"C/C++"* ]]; then
			brew install cppcheck astyle iniparser clang-format cmake-language-server
		fi

		if [[ "$p_language" = *"PHP"* ]]; then
			brew install php
		fi
	done

	for database in $databases; do
		if [[ "$database" = *"PostgreSQL"* ]]; then
			brew install postgresql
		fi

		if [[ "$database" = *"SQLite"* ]]; then
			brew install sqlite3
		fi

		if [[ "$database" = *"MongoDB"* ]]; then
			brew tap mongodb/brew
			brew install mongodb/brew/mongodb-community
		fi
	done

	for tool in $tools; do
		if [[ "$tools" = *"Docker"* ]]; then
			brew cask install docker
			brew install hadolint
		fi

		if [[ "$tools" = *"Makefile"* ]]; then
			brew install checkmake
		fi

		if [[ "$tool" = *"GitHub"* ]]; then
			brew install gh gitlint
		fi

		if [[ "$tool" = *"Cava"* ]]; then
			brew install fftw ncurses espeak portaudio cava
		fi

		if [[ "$tool" = *"Disk"* ]]; then
			brew install ncdu
		fi

		if [[ "$tool" = *"Terminal"* ]]; then
			brew install ripgrep fd lazygit tmux github-cli powerlevel10k circumflex
		fi

		if [[ "$tool" = *"IRC"* ]]; then
			brew install irssi
		fi

		if [[ "$tool" = *"Email"* ]]; then
			brew install pass isync msmtp abook urlview neomutt
		fi

		if [[ "$tool" = *"Ollama"* ]]; then
			echo "Please download it from https://ollama.com/download/mac"
		fi
	done

	export LIBTOOL='which glibtool'
	export LIBTOOLIZE='which glibtoolize'
	ln -s 'which glibtoolize' /usr/local/bin/libtoolize
	ln -s /usr/lib/libncurses.dylib /usr/local/lib/libncursesw.dylib
fi

if [[ "$p_languages" = *"Ruby"* ]]; then
	sudo gem update
	sudo gem install solargraph rubocop neovim tmuxinator
fi

if [[ "$p_languages" = *"Python"* ]]; then
	curl https://pyenv.run | bash
fi

if [[ "$p_languages" = *"Lua"* ]]; then
	sudo luarocks install luacheck
fi

if [[ "$p_languages" = *"Rust"* ]]; then
	cargo install selene stylua efmt bliss
fi

if [[ "$p_languages" = *"Go"* ]]; then
	go install mvdan.cc/sh/v3/cmd/shfmt@latest
	go install github.com/maaslalani/nap@main
	go install github.com/DyegoCosta/snake-game@latest
	go install github.com/maaslalani/typer@latest
	go install github.com/mritd/gitflow-toolkit/v2@latest

	sudo gitflow-toolkit install
fi

if [[ "$tools" = *"GitHub"* ]]; then
	gh extension install dlvhdr/gh-dash
fi

if [[ "$p_languages" = *"JavaScript"* || "$p_languages" = *"TypeScript"* ]]; then
	sudo npm i -g eslint vscode-langservers-extracted markdownlint-cli write-good \
		fixjson @fsouza/prettierd stylelint shopify-cli cross-env webpack \
		sass serverless npm-run-all nativescript dockerfile-language-server-nodejs \
		neovim gulp
fi

if [[ "$p_languages" = *"Java"* ]]; then
	curl -s "https://get.sdkman.io" | bash
	sdk install gradle
fi
