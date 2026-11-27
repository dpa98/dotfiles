# dotfiles

Mi configuración en Linux: **Neovim** (Lua), **zsh** + Oh My Zsh + Powerlevel10k, **Alacritty** y **tmux**.

## Instalación

```bash
git clone https://github.com/dpa98/dotfiles.git ~/projects/dotfiles
cd ~/projects/dotfiles
./install.sh
```

El script enlaza los archivos en `$HOME`. Usa GNU Stow si está disponible; si no, crea symlinks directos. Antes de sobrescribir, guarda backups con fecha.

Para probar sin tocar tu HOME real:

```bash
HOME=/tmp/dotfiles-test ./install.sh
```

## Requisitos

- `zsh`, Oh My Zsh y el tema `powerlevel10k`
- `neovim` >= 0.10 (`lazy.nvim` se instala solo)
- `alacritty`, `tmux`, `ripgrep`, `make`
- Fuente **JetBrains Mono Nerd Font**
- Opcional: `stow` (`sudo pacman -S stow`)
- `pyright` y `ruff` se instalan con Mason desde Neovim

Los paquetes instalados en mi máquina están en [`packages.txt`](packages.txt) como referencia.

## Estructura

```
dotfiles/
├── install.sh                 # Stow (o symlinks) + backups
├── nvim/                      # init.lua, lua/config y lua/plugins
├── zsh/                       # .zshrc, .p10k.zsh y .zshrc.local.example
├── git/                       # .gitconfig público + .gitignore_global
├── tmux/                      # .tmux.conf
├── terminal/                  # alacritty.toml + tema gruvbox-material
└── docs/                      # licencia del tema
```

## Notas

- La configuración de Neovim está dividida en `lua/config` y `lua/plugins`.
- Neovim, lualine y Alacritty usan el mismo colorscheme, `gruvbox-material`.
- `~/.zshrc.local` queda fuera del repo: ahí van tokens y ajustes de cada máquina.
- El `.gitconfig` solo tiene alias y preferencias; la identidad y las credenciales se configuran en local.

```bash
git config --local user.name "Tu nombre"
git config --local user.email "tu@email.com"
git config --local credential.helper '!gh auth git-credential'
```

## Licencia

El archivo de colores de Alacritty viene de [alacritty/alacritty-theme](https://github.com/alacritty/alacritty-theme) (Apache-2.0); la licencia está en [`docs/alacritty-theme-LICENSE`](docs/alacritty-theme-LICENSE).
