#!/bin/bash

DOTFILES_PATH="$HOME/.dotfiles"

if [[ "`uname -a`" == *"fedora"* ]]; then
    sudo dnf copr enable gourlaysama/dust
    sudo dnf install -y \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf update -y
    sudo dnf install -y rofi neovim wine xclip gcc exa ripgrep dust fd-find zsh \
        alacritty tmux mpv ipython python3 gdb make cmake g++ dejavu-fonts-all \
        ruby gem java-17-openjdk-devel java-17-openjdk clang-tools-extra \
        xz-devel openssl-devel fontawesome-fonts acpi i3blocks feh dunst \
        deluge-gtk rust-analyzer lxappearance htop curl wget

    # codecs
    sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} \
        gstreamer1-plugin-openh264 gstreamer1-libav \
        --exclude=gstreamer1-plugins-bad-free-devel
    sudo dnf install -y lame\* --exclude=lame-devel
    sudo dnf group upgrade -y --with-optional Multimedia --allowerasing
fi

pip install --upgrade pip
pip install --upgrade pwntools
gem install one_gadget

mkdir -p ~/.config
mkdir -p ~/.config/mpv
mkdir -p ~/.config/tmux
mkdir -p ~/.config/i3
mkdir -p ~/.config/helix

ln -sf "$DOTFILES_PATH/mpv.conf" ~/.config/mpv/mpv.conf
ln -sf "$DOTFILES_PATH/pwninit_template.py" ~/.config/pwninit_template.py
ln -sf "$DOTFILES_PATH/tmux.conf" ~/.config/tmux/tmux.conf
ln -sf "$DOTFILES_PATH/alacritty.yml" ~/.config/alacritty.yml
ln -sf "$DOTFILES_PATH/zshrc" ~/.zshrc
ln -sf "$DOTFILES_PATH/nvim-config" ~/.config/nvim
ln -sf "$DOTFILES_PATH/sway_config" ~/.config/i3/config

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
rustup component add rustfmt
rustup component add clippy

if command -v ipython &> /dev/null
then
    ipython profile create ctf
    mkdir -p ~/.config/ipython
    ln -sf $DOTFILES_PATH/ctf_ipython_config.py ~/.config/ipython/profile_ctf/ipython_config.py
else
    echo "NO IPYTHON DETECTED"
fi

if command -v git &> /dev/null
then
    git config --global pager.branch false
    git config --global user.name "tabun-dareka"
    git config --global user.email "tabun.dareka@protonmail.com"
    git config --global credential.helper store
else
    echo "NO GIT DETECTED"
fi
