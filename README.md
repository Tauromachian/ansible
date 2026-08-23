# Automatize Linux Installations

Ansible playbook that automates setting up a Linux machine for development and daily use. One command installs packages, sets up your shell, and applies your dotfiles across three machine profiles.

Supports Debian/Ubuntu-based and Arch-based distributions. The native package manager (APT or pacman) is selected automatically at runtime.

On top of the native package manager, this script uses 2 more package managers:

- [Brew](https://brew.sh/)
- [Flatpak](https://flatpak.org/)

## Usage

```bash
./install <tag>
```

Valid tags: `home`, `work` or `wsl`.

The script must be run as a regular user (it will refuse to run as root or with `sudo`). If Ansible is missing, it installs it first (from the official PPA on Debian-based systems, or via pacman on Arch), then runs `ansible-playbook ansible.yml --ask-become-pass --tags <tag>` and asks for your sudo password when needed.

## Supported distributions

| Family | Detection | Notes |
| ------ | --------- | ----- |
| Debian/Ubuntu | `/etc/os-release` contains `debian` or `ubuntu` | Full support, including the `wsl` profile |
| Arch-based (Arch, Manjaro, EndeavourOS, ...) | `/etc/os-release` contains `arch` | `wsl` profile not supported; Homebrew is officially unsupported on Arch but works |

Anything else fails fast with a clear error before installing Ansible.

## Profiles

| Tag    | Purpose                                                                    |
| ------ | -------------------------------------------------------------------------- |
| `home` | Full desktop setup, including gaming (Wine) and personal apps              |
| `work` | Desktop setup without gaming or personal apps                              |
| `wsl`  | Minimal CLI-only setup for WSL (native packages, Homebrew, fish shell and dotfiles). Debian-based only. |

## What gets installed

### Base (all profiles)

- Native packages (APT or pacman): tmux, curl, wget, stow, cmake, gcc, fzf, zsh, imagemagick, ffmpeg, etc.
- Homebrew: podman, podman-compose, neovim, starship, ripgrep, yt-dlp, fd, asdf, fish, opencode, workmux
- [fish](https://fishshell.com/) from Homebrew set as default login shell
- [TPM](https://github.com/tmux-plugins/tpm) (tmux plugin manager)
- CascadiaMono Nerd Font into `~/.fonts`
- Dotfiles cloned from [Tauromachian/dotfiles](https://github.com/Tauromachian/dotfiles) and applied with GNU Stow

### Desktop only (`home`, `work`)

- Native extras: gpick, gparted, samba, fastfetch, virt-manager/QEMU virtualization stack, Japanese input (fcitx5-mozc + Noto CJK fonts)
- Flatpak: VLC, OBS Studio, Shotcut, Calibre, Brave, Bruno, Thunderbird, Gearlever, GIMP
- [Ghostty](https://ghostty.org/) terminal (deb repository on Debian-based systems; official `extra` package on Arch)
- NVIDIA drivers auto-installed if the hardware is detected (`ubuntu-drivers` on Ubuntu; `nvidia-dkms` on Arch)
- [auto-cpufreq](https://github.com/AdnanHodzic/auto-cpufreq) cloned (installer step currently disabled)
- Cinnamon desktop: keybindings loaded via dconf plus the auto-dark-light applet installed and enabled

### Home only

- Wine (WineHQ stable with i386 enabled on Debian-based systems; multilib `wine`/`wine-mono`/`wine-gecko` on Arch)
- Flatpak: Steam, Telegram, Discord, Bottles
- Flatpak overrides giving Brave, Telegram and Discord access to `$HOME`

## Project layout

```
install        # Bootstrap script: detects the distro, validates the tag, installs Ansible, runs the playbook
ansible.yml    # Three plays, tagged home / work / wsl
tasks/*.yml    # One file per concern; distro-specific ones branch on ansible_os_family
vars/*.yml     # Per-family native package name mappings (debian.yml, archlinux.yml)
```
