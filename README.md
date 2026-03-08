# devenv

![CI](https://github.com/fearless-spider/devenv/actions/workflows/blank.yml/badge.svg)
![License](https://img.shields.io/badge/license-BSD--3--Clause-blue)
![Platforms](https://img.shields.io/badge/platform-Arch%20|%20Ubuntu%20|%20Fedora%20|%20Debian%20|%20openSUSE%20|%20macOS-lightgrey)

A glamorous shell scripts with [gum](https://github.com/charmbracelet/gum) to install development tools, libraries,.. on :

![devenv usage](https://github.com/fearless-spider/devenv/blob/main/devenv_gum_2.png?raw=true)

> Interactive selection powered by [gum](https://github.com/charmbracelet/gum)

## Operating System

- Arch Linux
- Fedora Linux
- Ubuntu Linux
- Debian
- openSUSE
- macOS

## 🚀 Features

### Programming languages

- C/C++
- Rust
- Java
- Python
- Go
- Lua
- JavaScript
- TypeScript
- Ruby
- Erlang
- Elixir
- Haskell
- Perl
- Julia
- PHP
- R-lang

### Databases

- PostgreSQL
- SQLite
- MongoDB
- MySQL

### Tools

- NeoVim
- Docker
- GitHub
- Makefile
- Email
- IRC
- Disk
- Cava
- Ollama
- Terminal tools : nap, typer, fd, lazygit, tmux
- GitFlow
- Redis

### Games

- Tetris
- Snake

---

## 📦 What gets installed

| Component | Arch | Ubuntu / Debian | Fedora | openSUSE |
|-----------|------|-----------------|--------|----------|
| **Python** | `python python-pip python-pipx` | `python3-full python3-pip` | `python-pip python-devel` | `python311 python311-pip` |
| **Go** | `go gopls` | `golang-go gopls` | `go` | `go` |
| **Rust** | `rust rust-analyzer cargo` | `rust-analyzer` | `rust rust-analyzer cargo` | `rust rust-analyzer cargo` |
| **Ruby** | `ruby rbenv` | `ruby-full` | `ruby ruby-devel rubygems` | `ruby ruby-devel rubygem-bundler` |
| **Lua** | `lua luarocks lua-language-server` | `lua5.4 luarocks` | `lua luarocks` | `lua lua-devel luarocks` |
| **Java** | `jdk-openjdk gradle maven` | `default-jdk maven gradle` | `java-17-openjdk-devel` | `java-17-openjdk java-17-openjdk-devel` |
| **JavaScript** | `nodejs npm prettier` | `nodejs npm` | `nodejs npm prettier` | `nodejs npm` |
| **TypeScript** | `typescript` | `node-typescript` | `typescript` | `typescript` |
| **Haskell** | `ghc haskell-language-server cabal-install` | `haskell-platform` | `ghc cabal-install` | `ghc haskell-language-server` |
| **Erlang** | `erlang` | `erlang rebar3` | `erlang rebar` | `erlang rebar3` |
| **Elixir** | `elixir` | `elixir` | `elixir` | `elixir` |
| **Perl** | `perl` | `perl` | `perl` | `perl` |
| **PHP** | `php composer` | `php php-cli composer` | `php php-cli` | `php8 php8-cli php8-composer` |
| **R-lang** | `r-rlang` | `r-base` | `R` | `R-base R-core-devel` |
| **C/C++** | `cppcheck astyle cmake-language-server` | `cppcheck astyle` | `cppcheck astyle` | *(base-devel)* |
| **Bash** | `bash-language-server shfmt shellcheck` | `shellcheck shfmt` | `shellcheck` | *(manual)* |
| **Julia** | `julia` | `julia` | `julia` | *(manual)* |
| **PostgreSQL** | `postgresql` | `postgresql` | `postgresql-server` | `postgresql-server postgresql` |
| **SQLite** | `sqlite` | `sqlite3` | `sqlite` | `sqlite3 sqlite3-devel` |
| **MongoDB** | `mongodb-bin` (AUR) | *(Docker recommended)* | *(Docker recommended)* | *(Docker recommended)* |
| **MySQL** | `mysql` | `mysql-server` | `mariadb` | `mariadb mariadb-client` |
| **NeoVim** | `neovim` | `neovim` | `neovim` | `neovim` |
| **Docker** | `docker docker-compose containerd` | *(official repo)* | `docker docker-compose` | `docker docker-compose` |
| **Redis** | `redis` | *(official repo)* | `redis` | `redis` |
| **GitHub CLI** | `github-cli` | `gh` | `gh` | `gh` |
| **IRC** | `irssi` | `irssi` | `irssi` | `irssi` |
| **Ngrok** | *(official script)* | *(official repo)* | *(ngrok.repo)* | *(ngrok.repo)* |
| **Qemu** | `qemu-full` | `qemu-system` | `qemu-kvm libvirt` | `qemu-x86 qemu-kvm libvirt` |
| **Ollama** | *(install.sh)* | *(install.sh)* | *(install.sh)* | *(install.sh)* |
| **Tetris** | `bastet` | `bastet` | `bastet` | `tint` |

### Extras

- LSP
- Formatters

## ⚙️ Prerequisites

| Platform | Requirement |
|----------|------------|
| All      | Bash ≥ 4.0 |
| macOS    | [Homebrew](https://brew.sh) |
| Linux    | sudo access |

> [!NOTE]
> macOS ships Bash 3.2. Install `brew install bash` and run with `/usr/local/bin/bash devenv.sh`

## 📖 Usage

| Command | Description |
|---------|-------------|
| `./devenv.sh` | Interactive mode |
| `./devenv.sh --ci` | Non-interactive smoke-test (Python, Go, PostgreSQL, NeoVim, Docker) |
| `./devenv.sh --uninstall` | Remove previously installed components |

Every run appends a session record to `~/.devenv_installed`.

## 🌱 Roadmap

- [ ] `--dry-run` mode
- [ ] `mise` as universal version manager

## 🤝 Contributing

Contributions, issues and feature requests are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md).

## ⭐️ Support

Give a ⭐️ if this project helped you!

## 📝 License

The [BSD 3-Clause "New" or "Revised" License](LICENSE)

![Alt](https://repobeats.axiom.co/api/embed/fce7ee20cc2c2e38a374e6162ea381f476306d15.svg "Repobeats analytics image")
