#!/bin/bash
set -euo pipefail

echo "DEVENV.sh - A glamorous shell scripts to install development tools, libraries,.. on Arch, Fedora, Ubuntu and MacOSX "
echo "Programming languages: Python, Elixir, Erlang, Ruby, Rust, Go, Lua, R-lang, JavaScript, TypeScript, Haskell, Perl, Java, Julia, C/C++, Bash, PHP"
echo "Databases: PostgreSQL, MongoDB, SQLite, MySQL"
echo "Tools: Disk, Ngrok, Terminal, Cava, GitHub, IRC, Ollama"
echo "Games: Tetris, Snake"

CI_MODE=false
UNINSTALL_MODE=false

for arg in "${@}"; do
  case "$arg" in
    --ci)         CI_MODE=true ;;
    --uninstall)  UNINSTALL_MODE=true ;;
  esac
done

# ─── Install log ──────────────────────────────────────────────────────────────
DEVENV_LOG="${HOME}/.devenv_installed"

# Append one tracked entry: recordInstall "Python" "python python-pip python-pipx"
recordInstall() {
  local component="$1" packages="$2"
  echo "$(date -u +%Y-%m-%dT%H:%M:%SZ)|${distro}|${component}|${packages}" >> "${DEVENV_LOG}"
}

# Serialise the full selection set after a run
persistInstallRecord() {
  local ts; ts=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  echo "# session ${ts} | distro=${distro} | platform=${platform}" >> "${DEVENV_LOG}"
  echo "LANGUAGES=${p_languages//$'\n'/,}"  >> "${DEVENV_LOG}"
  echo "DATABASES=${databases//$'\n'/,}"   >> "${DEVENV_LOG}"
  echo "TOOLS=${tools//$'\n'/,}"           >> "${DEVENV_LOG}"
  echo "GAMES=${games//$'\n'/,}"           >> "${DEVENV_LOG}"
  echo "---"                               >> "${DEVENV_LOG}"
}

# ─── Uninstall handler ────────────────────────────────────────────────────────
if [[ "$UNINSTALL_MODE" = true ]]; then
  if [[ ! -f "${DEVENV_LOG}" ]]; then
    echo "No install record found at ${DEVENV_LOG}" && exit 1
  fi

  # Collect unique component|packages pairs from log
  mapfile -t entries < <(grep -v '^#' "${DEVENV_LOG}" | grep -v '^---' | grep -v '^[A-Z]')
  if [[ ${#entries[@]} -eq 0 ]]; then
    echo "Install log is empty or contains no per-component entries." && exit 1
  fi

  declare -A comp_pkg_map
  for entry in "${entries[@]}"; do
    IFS='|' read -r _ _ component packages <<< "$entry"
    comp_pkg_map["$component"]="$packages"
  done

  selected=$(printf '%s\n' "${!comp_pkg_map[@]}" \
    | gum choose --no-limit --header "Select components to UNINSTALL:")

  # Detect remove command
  if   command -v pacman &>/dev/null; then remove_cmd="sudo pacman -Rs --noconfirm"
  elif command -v apt    &>/dev/null; then remove_cmd="sudo apt remove -y"
  elif command -v yum    &>/dev/null; then remove_cmd="sudo yum remove -y"
  elif command -v brew   &>/dev/null; then remove_cmd="brew uninstall"
  else echo "No supported package manager found." && exit 1
  fi

  while IFS= read -r comp; do
    pkgs="${comp_pkg_map[$comp]}"
    echo "Removing ${comp}: ${pkgs}"
    # shellcheck disable=SC2086
    $remove_cmd $pkgs || true
    # Remove from log
    sed -i.bak "/|${comp}|/d" "${DEVENV_LOG}"
  done <<< "$selected"

  echo "Done. See ${DEVENV_LOG} for remaining installed components."
  exit 0
fi

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

if [ -n "${ZSH_VERSION:-}" ]; then
	shell='zsh'
elif [ -n "${FISH_VERSION:-}" ]; then
	shell='fish'
	curl -sL https://git.io/fisher | . && fisher install jorgebucaran/fisher
	fisher install reitzig/sdkman-for-fish@v1.4.0
elif [ -n "${BASH_VERSION:-}" ]; then
	shell='bash'
fi

# Required packages
echo "Installing base packages"

if [ "$platform" = "linux" ]; then
	echo "Determined platform: $distro"

	if [[ "$distro" = "Arch Linux" || "$distro" = "Garuda Linux" || "$distro" = "EndeavourOS" || "$distro" = "CachyOS Linux" ]]; then
		sudo pacman -Syu --noconfirm
		sudo pacman -S --noconfirm base-devel git curl openssl readline xz zlib libtool automake gum
	elif [ "$distro" = "Ubuntu" ]; then
		sudo apt-get update
		sudo apt-get upgrade -y
		sudo apt-get install -y build-essential git curl libfftw3-dev libyaml-dev \
			libreadline-dev libedit-dev libssl-dev \
			libasound2-dev libncursesw5-dev libpulse-dev libtool automake
		sudo mkdir -p /etc/apt/keyrings
		curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/charm.gpg
		echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
		sudo apt update && sudo apt install -y gum
	elif [ "$distro" = "Fedora Linux" ]; then
		# chown -R $USER /usr/local/lib
		sudo yum update -y
		sudo yum install -y gcc gcc-c++ make readline readline-devel libtool automake zlib-devel bzip2 ncurses-devel libyaml-devel
		printf '[charm]\nname=Charm\nbaseurl=https://repo.charm.sh/yum/\nenabled=1\ngpgcheck=1\ngpgkey=https://repo.charm.sh/yum/gpg.key\n' | sudo tee /etc/yum.repos.d/charm.repo
		sudo rpm --import https://repo.charm.sh/yum/gpg.key
		sudo yum install -y gum
	fi
elif [ "$platform" = "darwin" ]; then
	echo "Determined platform: $platform"
	brew update && brew upgrade
	brew install git curl libtool automake openssl readline xz zlib autoconf-archive gum
fi

if [[ "$CI_MODE" = true ]]; then
  echo "[CI] Non-interactive mode — using smoke-test selections"
  p_languages="Python Go"
  databases="PostgreSQL"
  tools="NeoVim Docker"
  games=""
else
  gum style \
    --foreground 36 --border-foreground 36 --border double \
    --align center --width 50 --margin "1 2" --padding "2 4" \
    'devenv.sh' 'A glamorous shell scripts to install development tools, libraries on Linux and MacOSX'

  AVAILABLE_LANGUAGES=("C/C++" "Ruby" "JavaScript" "TypeScript" "Go" "PHP" "Python" "Erlang" "Elixir" "Rust" "Java" "Lua" "Haskell" "Perl" "Julia" "R-lang")
  p_languages=$(gum choose "${AVAILABLE_LANGUAGES[@]}" --no-limit --height 16 --header "Which programming language(s) do you need?")

  AVAILABLE_DATABASES=("PostgreSQL" "SQLite" "MongoDB" "MySQL")
  databases=$(gum choose "${AVAILABLE_DATABASES[@]}" --no-limit --height 4 --header "Which database(s) do you need?")

  AVAILABLE_TOOLS=("NeoVim" "Docker" "Makefile" "GitHub" "IRC" "Qemu" "Ngrok" "Email" "Disk" "Terminal" "Cava" "Ollama" "Redis")
  tools=$(gum choose "${AVAILABLE_TOOLS[@]}" --no-limit --height 13 --header "Which tool(s) do you need?")

  AVAILABLE_GAMES=("Snake" "Tetris")
  games=$(gum choose "${AVAILABLE_GAMES[@]}" --no-limit --height 2 --header "Which game(s) do you need?")
fi

if [ "$platform" = "linux" ]; then
	if [[ "$distro" = "Arch Linux" || "$distro" = "Garuda Linux" || "$distro" = "EndeavourOS" || "$distro" = "CachyOS Linux" ]]; then

		for p_language in $p_languages; do
			if [[ "$p_language" = *"Python"* ]]; then
				sudo pacman -S --noconfirm python python-pip python-pipx
				recordInstall "Python" "python python-pip python-pipx"
			fi

			if [[ "$p_language" = *"Erlang"* || "$p_language" = *"Elixir"* ]]; then
				sudo pacman -S --noconfirm erlang
				yay -S rebar3
				recordInstall "Erlang" "erlang rebar3"
			fi

			if [[ "$p_language" = *"Elixir"* ]]; then
				sudo pacman -S --noconfirm elixir
				yay -S elixir-ls
				recordInstall "Elixir" "elixir elixir-ls"
			fi

			if [[ "$p_language" = *"Ruby"* ]]; then
				sudo pacman -S --noconfirm ruby
				yay -S rbenv
				recordInstall "Ruby" "ruby rbenv"
			fi

			if [[ "$p_language" = *"Rust"* ]]; then
				sudo pacman -S --noconfirm rust rust-analyzer cargo
				recordInstall "Rust" "rust rust-analyzer cargo"
			fi

			if [[ "$p_language" = *"Go"* ]]; then
				sudo pacman -S --noconfirm go gopls
				recordInstall "Go" "go gopls"
			fi

			if [[ "$p_language" = *"Lua"* ]]; then
				sudo pacman -S --noconfirm lua luarocks lua-language-server
				recordInstall "Lua" "lua luarocks lua-language-server"
			fi

			if [[ "$p_language" = *"R-lang"* ]]; then
				yay -S r-rlang
				recordInstall "R-lang" "r-rlang"
			fi

			if [[ "$p_language" = *"JavaScript"* || "$p_language" = *"TypeScript"* ]]; then
				sudo pacman -S --noconfirm nodejs npm prettier
				yay -S nvm
				recordInstall "JavaScript" "nodejs npm prettier nvm"
			fi

			if [[ "$p_language" = *"TypeScript"* ]]; then
				sudo pacman -S --noconfirm typescript
				recordInstall "TypeScript" "typescript"
			fi

			if [[ "$p_language" = *"Haskell"* ]]; then
				sudo pacman -S --noconfirm ghc haskell-language-server cabal-install
				recordInstall "Haskell" "ghc haskell-language-server cabal-install"
			fi

			if [[ "$p_language" = *"Perl"* ]]; then
				sudo pacman -S --noconfirm perl
				yay -S perl-perl-languageserver
				recordInstall "Perl" "perl perl-perl-languageserver"
			fi

			if [[ "$p_language" = *"Java"* ]]; then
				sudo pacman -S --noconfirm jdk-openjdk gradle maven
				recordInstall "Java" "jdk-openjdk gradle maven"
			fi

			if [[ "$p_language" = *"Julia"* ]]; then
				sudo pacman -S --noconfirm julia
				recordInstall "Julia" "julia"
			fi

			if [[ "$p_language" = *"Bash"* ]]; then
				sudo pacman -S --noconfirm bash-language-server shfmt shellcheck
				recordInstall "Bash" "bash-language-server shfmt shellcheck"
			fi

			if [[ "$p_language" = *"C/C++"* ]]; then
				sudo pacman -S --noconfirm cppcheck astyle iniparser
				yay -S cmake-language-server
				recordInstall "C/C++" "cppcheck astyle iniparser cmake-language-server"
			fi

			if [[ "$p_language" = *"PHP"* ]]; then
				sudo pacman -S --noconfirm php composer
				recordInstall "PHP" "php composer"
			fi
		done

		for database in $databases; do
			if [[ "$database" = *"PostgreSQL"* ]]; then
				sudo pacman -S --noconfirm postgresql
				recordInstall "PostgreSQL" "postgresql"
			fi

			if [[ "$database" = *"SQLite"* ]]; then
				sudo pacman -S --noconfirm sqlite
				recordInstall "SQLite" "sqlite"
			fi

			if [[ "$database" = *"MongoDB"* ]]; then
				yay -S mongodb-bin mongodb-tools-bin mongosh-bin
				recordInstall "MongoDB" "mongodb-bin mongodb-tools-bin mongosh-bin"
			fi

			if [[ "$database" = *"MySQL"* ]]; then
				sudo pacman -S --noconfirm mysql
				recordInstall "MySQL" "mysql"
			fi
		done

		for tool in $tools; do
			if [[ "$tool" = *"NeoVim"* ]]; then
				sudo pacman -S --noconfirm neovim
				recordInstall "NeoVim" "neovim"
			fi

			if [[ "$tool" = *"Docker"* ]]; then
				sudo pacman -S --noconfirm docker docker-buildx docker-compose containerd
				sudo usermod -aG docker ${USER:-$(whoami)}
				[[ "$CI_MODE" = false ]] && newgrp docker || true
				recordInstall "Docker" "docker docker-buildx docker-compose containerd"
			fi

			if [[ "$tool" = *"GitHub"* ]]; then
				sudo pacman -S --noconfirm github-cli
				recordInstall "GitHub" "github-cli"
			fi

			if [[ "$tool" = *"Makefile"* ]]; then
				sudo pacman -S --noconfirm checkmake
			fi

			if [[ "$tool" = *"Cava"* ]]; then
				sudo pacman -S --noconfirm fftw ncurses espeak-ng portaudio
				yay -S cava
			fi

			if [[ "$tool" = *"Disk"* ]]; then
				sudo pacman -S --noconfirm ncdu
			fi

			if [[ "$tool" = *"Terminal"* ]]; then
				sudo pacman -S --noconfirm ripgrep fd lazygit tmux
			fi

			if [[ "$tool" = *"Ngrok"* ]]; then
				yay -S ngrok
			fi

			if [[ "$tool" = *"IRC"* ]]; then
				sudo pacman -S --noconfirm irssi
			fi

			if [[ "$tool" = *"Qemu"* ]]; then
				sudo pacman -S --noconfirm qemu-full
			fi

			if [[ "$tool" = *"Email"* ]]; then
				echo "Not supported"
			fi

			if [[ "$tool" = *"Ollama"* ]]; then
				curl -fsSL https://ollama.com/install.sh | sh
			fi

			if [[ "$tool" = *"Redis"* ]]; then
				sudo pacman -S --noconfirm redis
			fi
		done

		for game in $games; do
			if [[ "$game" = *"Tetris"* ]]; then
				yay -S tetris-terminal-git
			fi
		done

	elif [ "$distro" = "Ubuntu" ]; then

		for p_language in $p_languages; do
			if [[ "$p_language" = *"Python"* ]]; then
				sudo apt install -y python3-full python3-pip
				recordInstall "Python" "python3-full python3-pip"
			fi

			if [[ "$p_language" = *"Erlang" || "$p_language" = *"Elixir"* ]]; then
				sudo apt install -y erlang rebar3 # elixir-ls
				recordInstall "Erlang" "erlang rebar3"
			fi

			if [[ "$p_language" = *"Elixir"* ]]; then
				sudo apt install -y elixir # elixir-ls
				recordInstall "Elixir" "elixir"
			fi

			if [[ "$p_language" = *"Ruby"* ]]; then
				sudo apt install -y ruby-full
				recordInstall "Ruby" "ruby-full"
			fi

			if [[ "$p_language" = *"Rust"* ]]; then
				curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh
				sudo apt install -y rust-analyzer
				recordInstall "Rust" "rust-analyzer"
			fi

			if [[ "$p_language" = *"Go"* ]]; then
				sudo apt install -y golang-go gopls
				recordInstall "Go" "golang-go gopls"
			fi

			if [[ "$p_language" = *"Lua"* ]]; then
				sudo apt install -y lua5.4 luarocks # lua-language-server
				recordInstall "Lua" "lua5.4 luarocks"
			fi

			if [[ "$p_language" = *"R-lang"* ]]; then
				sudo apt install -y r-base
				recordInstall "R-lang" "r-base"
			fi

			if [[ "$p_language" = *"JavaScript"* || "$p_language" = *"TypeScript"* ]]; then
				sudo apt install -y nodejs npm
				curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
				recordInstall "JavaScript" "nodejs npm"
			fi

			if [[ "$p_language" = *"TypeScript"* ]]; then
				sudo apt install -y node-typescript
				recordInstall "TypeScript" "node-typescript"
			fi

			if [[ "$p_language" = *"Haskell"* ]]; then
				curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
				ghcup install ghc haskell-language-server
			fi

			if [[ "$p_language" = *"Perl"* ]]; then
				sudo apt install -y perl perl-perl-languageserver
				recordInstall "Perl" "perl perl-perl-languageserver"
			fi

			if [[ "$p_language" = *"Java"* ]]; then
				sudo apt install -y default-jdk gradle
				recordInstall "Java" "default-jdk gradle"
			fi

			if [[ "$p_language" = *"PHP"* ]]; then
				sudo add-apt-repository -y ppa:ondrej/php
				sudo apt -y install php8.4 php8.4-{curl,apcu,intl,mbstring,opcache,pgsql,mysql,sqlite3,redis,xml,zip}
				php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
				php composer-setup.php --quiet && sudo mv composer.phar /usr/local/bin/composer
				rm composer-setup.php
				recordInstall "PHP" "php8.4"
			fi
		done

		for database in $databases; do
			if [[ "$database" = *"PostgreSQL"* ]]; then
				sudo apt install -y postgresql
				recordInstall "PostgreSQL" "postgresql"
			fi

			if [[ "$database" = *"SQLite"* ]]; then
				sudo apt install -y sqlite
				recordInstall "SQLite" "sqlite"
			fi

			if [[ "$database" = *"MongoDB"* ]]; then
				curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
				  sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg
				echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
				sudo apt update
				sudo apt install -y mongodb-org
				recordInstall "MongoDB" "mongodb-org"
			fi

			if [[ "$database" = *"MySQL"* ]]; then
				sudo apt install -y mysql-server
				recordInstall "MySQL" "mysql-server"
			fi
		done

		for tool in $tools; do
			if [[ "$tool" = *"NeoVim"* ]]; then
				sudo apt install -y neovim
				recordInstall "NeoVim" "neovim"
			fi

			if [[ "$tool" = *"Docker"* ]]; then
				sudo install -m 0755 -d /etc/apt/keyrings
				sudo curl -fsSL -o /etc/apt/keyrings/docker.asc https://download.docker.com/linux/ubuntu/gpg
				sudo chmod a+r /etc/apt/keyrings/docker.asc
				echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
				sudo apt update

				# Install Docker engine and standard plugins
				sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

				# Give this user privileged Docker access
				sudo usermod -aG docker ${USER:-$(whoami)}

				# Limit log size to avoid running out of disk
				echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json
				recordInstall "Docker" "docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
			fi

			if [[ "$tool" = *"GitHub"* ]]; then
				sudo apt install -y gh
				recordInstall "GitHub" "gh"
			fi

			if [[ "$tool" = *"Makefile"* ]]; then
				sudo apt install -y checkmake
				recordInstall "Makefile" "checkmake"
			fi

			if [[ "$tool" = *"Cava"* ]]; then
				sudo apt install -y espeak-ng cava
				recordInstall "Cava" "espeak-ng cava"
			fi

			if [[ "$tool" = *"Disk"* ]]; then
				sudo apt install -y ncdu
				recordInstall "Disk" "ncdu"
			fi

			if [[ "$tool" = *"Ngrok"* ]]; then
				curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc |
					sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null &&
					echo "deb https://ngrok-agent.s3.amazonaws.com buster main" |
					sudo tee /etc/apt/sources.list.d/ngrok.list &&
					sudo apt update &&
					sudo apt install -y ngrok
				recordInstall "Ngrok" "ngrok"
			fi

			if [[ "$tool" = *"IRC"* ]]; then
				sudo apt install -y irssi
				recordInstall "IRC" "irssi"
			fi

			if [[ "$tool" = *"Qemu"* ]]; then
				sudo apt install -y qemu-system
				recordInstall "Qemu" "qemu-system"
			fi

			if [[ "$tool" = *"Email"* ]]; then
				echo "Not supported"
			fi

			if [[ "$tool" = *"Ollama"* ]]; then
				curl -fsSL https://ollama.com/install.sh | sh
			fi

			if [[ "$tool" = *"Redis"* ]]; then
				sudo apt-get install -y lsb-release curl gpg
				curl -fsSL https://packages.redis.io/gpg | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
				sudo chmod 644 /usr/share/keyrings/redis-archive-keyring.gpg
				echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
				sudo apt-get update
				sudo apt-get install -y redis
				recordInstall "Redis" "redis"
			fi
		done

		for game in $games; do
			if [[ "$game" = *"Tetris"* ]]; then
				echo "Not supported"
			fi
		done

	elif [ "$distro" = "Fedora Linux" ]; then

		for p_language in $p_languages; do
			if [[ "$p_language" = *"Python"* ]]; then
				sudo yum install -y python-pip python-devel
				recordInstall "Python" "python-pip python-devel"
			fi

			if [[ "$p_language" = *"Erlang"* || "$p_language" = *"Elixir"* ]]; then
				sudo yum install -y erlang rebar
				recordInstall "Erlang" "erlang rebar"
			fi

			if [[ "$p_language" = *"Elixir"* ]]; then
				sudo yum install -y elixir
				recordInstall "Elixir" "elixir"
			fi

			if [[ "$p_language" = *"Ruby"* ]]; then
				sudo yum install -y ruby ruby-devel rubygems
				recordInstall "Ruby" "ruby ruby-devel rubygems"
			fi

			if [[ "$p_language" = *"Rust"* ]]; then
				sudo yum install -y rust rust-analyzer cargo
				recordInstall "Rust" "rust rust-analyzer cargo"
			fi

			if [[ "$p_language" = *"Go"* ]]; then
				sudo yum install -y go
				recordInstall "Go" "go"
			fi

			if [[ "$p_language" = *"Lua"* ]]; then
				sudo yum install -y lua luarocks
				recordInstall "Lua" "lua luarocks"
			fi

			if [[ "$p_language" = *"R-lang"* ]]; then
				sudo yum install -y R
				recordInstall "R-lang" "R"
			fi

			if [[ "$p_language" = *"JavaScript"* || "$p_language" = *"TypeScript"* ]]; then
				sudo yum install -y nodejs npm
				sudo npm install -g nvm prettier
				recordInstall "JavaScript" "nodejs npm"
			fi

			if [[ "$p_language" = *"TypeScript"* ]]; then
				sudo yum install -y typescript
				recordInstall "TypeScript" "typescript"
			fi

			if [[ "$p_language" = *"Haskell"* ]]; then
				sudo dnf copr enable petersen/haskell-language-server
				sudo yum install -y ghc-compiler haskell-language-server
				recordInstall "Haskell" "ghc-compiler haskell-language-server"
			fi

			if [[ "$p_language" = *"Perl"* ]]; then
				sudo yum install -y perl
				sudo cpan Perl::LanguageServer
				recordInstall "Perl" "perl"
			fi

			if [[ "$p_language" = *"Java"* ]]; then
				sudo yum install -y java
				recordInstall "Java" "java"
			fi

			if [[ "$p_language" = *"PHP"* ]]; then
				sudo dnf install -y php-cli phpunit composer php-mysqli
				recordInstall "PHP" "php-cli phpunit composer php-mysqli"
			fi
		done

		for database in $databases; do
			if [[ "$database" = *"PostgreSQL"* ]]; then
				sudo yum install -y postgresql-server postgresql postgresql-devel
				recordInstall "PostgreSQL" "postgresql-server postgresql postgresql-devel"
			fi

			if [[ "$database" = *"SQLite"* ]]; then
				sudo yum install -y sqlite sqlite-devel
				recordInstall "SQLite" "sqlite sqlite-devel"
			fi

			if [[ "$database" = *"MongoDB"* ]]; then
				echo "Not supported"
			fi

			if [[ "$database" = *"MySQL"* ]]; then
				sudo yum install -y mysql-server
				recordInstall "MySQL" "mysql-server"
			fi
		done

		for tool in $tools; do
			if [[ "$tool" = *"NeoVim"* ]]; then
				sudo yum install -y neovim
				recordInstall "NeoVim" "neovim"
			fi

			if [[ "$tool" = *"Docker"* ]]; then
				sudo dnf -y install dnf-plugins-core
				sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
				sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
				sudo usermod -aG docker ${USER:-$(whoami)}
				[[ "$CI_MODE" = false ]] && systemctl enable --now docker || true
				recordInstall "Docker" "docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
			fi

			if [[ "$tool" = *"GitHub"* ]]; then
				sudo yum install -y gh
				recordInstall "GitHub" "gh"
			fi

			if [[ "$tool" = *"Makefile"* ]]; then
				sudo yum install -y checkmake
				recordInstall "Makefile" "checkmake"
			fi

			if [[ "$tool" = *"Cava"* ]]; then
				sudo yum install -y espeak-ng cava
				recordInstall "Cava" "espeak-ng cava"
			fi

			if [[ "$tool" = *"Disk"* ]]; then
				sudo yum install -y ncdu
				recordInstall "Disk" "ncdu"
			fi

			if [[ "$tool" = *"Ngrok"* ]]; then
				echo "Not supported"
			fi

			if [[ "$tool" = *"IRC"* ]]; then
				sudo yum install -y irssi
				recordInstall "IRC" "irssi"
			fi

			if [[ "$tool" = *"Qemu"* ]]; then
				sudo yum install -y qemu-kvm bridge-utils libvirt virt-install
				recordInstall "Qemu" "qemu-kvm bridge-utils libvirt virt-install"
			fi

			if [[ "$tool" = *"Email"* ]]; then
				echo "Not supported"
			fi

			if [[ "$tool" = *"Ollama"* ]]; then
				curl -fsSL https://ollama.com/install.sh | sh
			fi

			if [[ "$tool" = *"Redis"* ]]; then
				sudo yum install -y redis
				recordInstall "Redis" "redis"
			fi
		done

		for game in $games; do
			if [[ "$game" = *"Tetris"* ]]; then
				echo "Not supported"
			fi
		done
	fi
elif [ "$platform" = "darwin" ]; then
	for p_language in $p_languages; do
		if [[ "$p_language" = *"Python"* ]]; then
			brew install python pyenv pyenv-virtualenv
			recordInstall "Python" "python pyenv pyenv-virtualenv"
		fi

		if [[ "$p_language" = *"Ruby"* ]]; then
			brew install ruby rbenv standard solargraph
			recordInstall "Ruby" "ruby rbenv standard solargraph"
		fi

		if [[ "$p_language" = *"Erlang"* || "$p_language" = *"Elixir"* ]]; then
			brew install erlang rebar3
			recordInstall "Erlang" "erlang rebar3"
		fi

		if [[ "$p_language" = *"Elixir"* ]]; then
			brew install elixir elixir-ls
			recordInstall "Elixir" "elixir elixir-ls"
		fi

		if [[ "$p_language" = *"Rust"* ]]; then
			brew install rust rust-analyzer
			recordInstall "Rust" "rust rust-analyzer"
		fi

		if [[ "$p_language" = *"Lua"* ]]; then
			brew install lua lua-language-server cmake
			recordInstall "Lua" "lua lua-language-server cmake"
		fi

		if [[ "$p_language" = *"JavaScript"* || "$p_language" = *"TypeScript"* ]]; then
			brew install node nvm
			recordInstall "JavaScript" "node nvm"
		fi

		if [[ "$p_language" = *"TypeScript"* ]]; then
			brew install typescript
			recordInstall "TypeScript" "typescript"
		fi

		if [[ "$p_language" = *"Go"* ]]; then
			brew install go gopls golangci-lint
			recordInstall "Go" "go gopls golangci-lint"
		fi

		if [[ "$p_language" = *"Haskell"* ]]; then
			brew install ghc ghcup haskell-language-server
			recordInstall "Haskell" "ghc ghcup haskell-language-server"
		fi

		if [[ "$p_language" = *"Perl"* ]]; then
			brew install perl
			recordInstall "Perl" "perl"
		fi

		if [[ "$p_language" = *"Java"* ]]; then
			brew install java gradle maven
			recordInstall "Java" "java gradle maven"
		fi

		if [[ "$p_language" = *"Bash"* ]]; then
			brew install bash-language-server shfmt shellcheck
			recordInstall "Bash" "bash-language-server shfmt shellcheck"
		fi

		if [[ "$p_language" = *"C/C++"* ]]; then
			brew install cppcheck astyle iniparser clang-format cmake-language-server
			recordInstall "C/C++" "cppcheck astyle iniparser clang-format cmake-language-server"
		fi

		if [[ "$p_language" = *"PHP"* ]]; then
			brew install php
			recordInstall "PHP" "php"
		fi
	done

	for database in $databases; do
		if [[ "$database" = *"PostgreSQL"* ]]; then
			brew install postgresql
			recordInstall "PostgreSQL" "postgresql"
		fi

		if [[ "$database" = *"SQLite"* ]]; then
			brew install sqlite3
			recordInstall "SQLite" "sqlite3"
		fi

		if [[ "$database" = *"MongoDB"* ]]; then
			brew tap mongodb/brew
			brew install mongodb/brew/mongodb-community
			recordInstall "MongoDB" "mongodb-community"
		fi

		if [[ "$database" = *"MySQL"* ]]; then
			brew install mysql
			recordInstall "MySQL" "mysql"
		fi
	done

	for tool in $tools; do
		if [[ "$tool" = *"NeoVim"* ]]; then
			brew install neovim
			recordInstall "NeoVim" "neovim"
		fi

		if [[ "$tool" = *"Docker"* ]]; then
			brew install docker docker-compose hadolint
			recordInstall "Docker" "docker docker-compose hadolint"
		fi

		if [[ "$tool" = *"GitHub"* ]]; then
			brew install gh gitlint
			recordInstall "GitHub" "gh gitlint"
		fi

		if [[ "$tool" = *"Makefile"* ]]; then
			brew install checkmake
			recordInstall "Makefile" "checkmake"
		fi

		if [[ "$tool" = *"Cava"* ]]; then
			brew install fftw ncurses espeak portaudio cava
			recordInstall "Cava" "fftw ncurses espeak portaudio cava"
		fi

		if [[ "$tool" = *"Disk"* ]]; then
			brew install ncdu
			recordInstall "Disk" "ncdu"
		fi

		if [[ "$tool" = *"Ngrok"* ]]; then
			brew install ngrok
			recordInstall "Ngrok" "ngrok"
		fi

		if [[ "$tool" = *"Terminal"* ]]; then
			brew install ripgrep fd lazygit tmux powerlevel10k circumflex
			recordInstall "Terminal" "ripgrep fd lazygit tmux powerlevel10k circumflex"
		fi

		if [[ "$tool" = *"IRC"* ]]; then
			brew install irssi
			recordInstall "IRC" "irssi"
		fi

		if [[ "$tool" = *"Qemu"* ]]; then
			brew install qemu libvirt
			recordInstall "Qemu" "qemu libvirt"
		fi

		if [[ "$tool" = *"Email"* ]]; then
			brew install pass isync msmtp abook urlview neomutt
			recordInstall "Email" "pass isync msmtp abook urlview neomutt"
		fi

		if [[ "$tool" = *"Ollama"* ]]; then
			echo "Please download it from https://ollama.com/download/mac"
		fi

		if [[ "$tool" = *"Redis"* ]]; then
			brew install redis
		fi
	done

	for game in $games; do
		if [[ "$game" = *"Tetris"* ]]; then
			brew install samtay/tui/tetris
		fi
	done

	export LIBTOOL=$(which glibtool)
	export LIBTOOLIZE=$(which glibtoolize)
	ln -sf $(which glibtoolize) /usr/local/bin/libtoolize
	ln -sf /usr/lib/libncurses.dylib /usr/local/lib/libncursesw.dylib
fi

if [[ "$p_languages" = *"Ruby"* ]]; then
	gem update --user-install
	gem install --user-install solargraph rubocop neovim tmuxinator
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
	go install github.com/maaslalani/typer@latest
	go install github.com/mritd/gitflow-toolkit/v2@latest

	[[ "$CI_MODE" = false ]] && sudo "$(go env GOPATH)/bin/gitflow-toolkit" install || true
fi

for game in $games; do
	if [[ "$game" = *"Snake"* && "$p_languages" = *"Go"* ]]; then
		go install github.com/DyegoCosta/snake-game@latest
	fi
done

if [[ "$tools" = *"GitHub"* ]]; then
	gh extension install dlvhdr/gh-dash
fi

if [[ "$p_languages" = *"JavaScript"* || "$p_languages" = *"TypeScript"* ]]; then
	npm i -g eslint vscode-langservers-extracted markdownlint-cli write-good \
		fixjson @fsouza/prettierd stylelint shopify-cli cross-env webpack \
		sass serverless npm-run-all nativescript dockerfile-language-server-nodejs \
		neovim gulp
fi

if [[ "$p_languages" = *"Java"* ]]; then
	curl -s "https://get.sdkman.io" | bash
fi

# ─── Persist this session's selections ───────────────────────────────────────
persistInstallRecord
echo "Install record saved to ${DEVENV_LOG}"
