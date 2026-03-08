# devenv

![CI](https://github.com/fearless-spider/devenv/actions/workflows/blank.yml/badge.svg)
![License](https://img.shields.io/badge/license-BSD--3--Clause-blue)
![Platforms](https://img.shields.io/badge/platform-Arch%20|%20Ubuntu%20|%20Fedora%20|%20macOS-lightgrey)

A glamorous shell scripts with [gum](https://github.com/charmbracelet/gum) to install development tools, libraries,.. on :

![devenv usage](https://github.com/fearless-spider/devenv/blob/main/devenv_gum_2.png?raw=true)

> Interactive selection powered by [gum](https://github.com/charmbracelet/gum)

## Operating System

- Arch Linux
- Fedora Linux
- Ubuntu Linux
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
- [ ] openSUSE / Debian support

## 🤝 Contributing

Contributions, issues and feature requests are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md).

## ⭐️ Support

Give a ⭐️ if this project helped you!

## 📝 License

The [BSD 3-Clause "New" or "Revised" License](LICENSE)

![Alt](https://repobeats.axiom.co/api/embed/fce7ee20cc2c2e38a374e6162ea381f476306d15.svg "Repobeats analytics image")
