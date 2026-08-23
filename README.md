# Automatize Linux Installations

Ansible playbook that automates setting up an Ubuntu-based Linux machine for development and daily use. One command installs packages, sets up your shell, and applies your dotfiles across three machine profiles.

This script uses 3 package managers:

- [APT](https://wiki.debian.org/Apt)
- [Brew](https://brew.sh/)
- [Flatpak](https://flatpak.org/)

## Usage

```bash
./install <tag>
```

Valid tags: `home`, `work` or `wsl`.

The script must be run as a regular user (it will refuse to run as root or with `sudo`). If Ansible is missing, it installs it from the official PPA, then runs `ansible-playbook ansible.yml --ask-become-pass --tags <tag>` and asks for your sudo password when needed.

## Profiles

| Tag    | Purpose                                                                    |
| ------ | -------------------------------------------------------------------------- |
| `home` | Full desktop setup, including gaming (Wine) and personal apps              |
| `work` | Desktop setup without gaming or personal apps                              |
| `wsl`  | Minimal CLI-only setup for WSL (APT, Homebrew, fish shell and dotfiles)    |

## What gets installed

### Base (all profiles)

- APT: tmux, nala, curl, wget, stow, cmake, g++, fzf, zsh, imagemagick, ffmpeg, etc.
- Homebrew: podman, podman-compose, neovim, starship, ripgrep, yt-dlp, fd, asdf, fish, opencode, workmux
- [fish](https://fishshell.com/) from Homebrew set as default login shell
- [TPM](https://github.com/tmux-plugins/tpm) (tmux plugin manager)
- CascadiaMono Nerd Font into `~/.fonts`
- Dotfiles cloned from [Tauromachian/dotfiles](https://github.com/Tauromachian/dotfiles) and applied with GNU Stow

### Desktop only (`home`, `work`)

- APT extras: gpick, gparted, samba, fastfetch, virt-manager/QEMU-KVM virtualization stack, Japanese input (fcitx5-mozc + Noto CJK fonts)
- Flatpak: VLC, OBS Studio, Shotcut, Calibre, Brave, Bruno, Thunderbird, Gearlever, GIMP
- [Ghostty](https://ghostty.org/) terminal from the deb.griffo.io repository
- NVIDIA drivers auto-installed if the hardware is detected
- [auto-cpufreq](https://github.com/AdnanHodzic/auto-cpufreq) cloned (installer step currently disabled)
- Cinnamon desktop: keybindings loaded via dconf plus the auto-dark-light applet installed and enabled

### Home only

- Wine (WineHQ stable, with i386 architecture enabled)
- Flatpak: Steam, Telegram, Discord, Bottles
- Flatpak overrides giving Brave, Telegram and Discord access to `$HOME`

## Project layout

```
install        # Bootstrap script: validates the tag, installs Ansible, runs the playbook
ansible.yml    # Three plays, tagged home / work / wsl
tasks/*.yml    # One file per concern (apt, homebrew, flatpak, fish, dotfiles, ...)
```
