#!/bin/bash
if [[ $(uname) = "Darwin" ]]; then
    export OS="OSX"
elif grep -q Microsoft /proc/version; then
    export OS="wsl1"
    export PATH="$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
elif grep -q microsoft /proc/version; then
    export OS="wsl2"
    export PATH="$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
else
    export OS="linux"
fi

GIT_DIR="$( cd "$( dirname "$0"  )" && pwd  )"

if [ ! -d "$HOME/.config" ]
then
    mkdir "$HOME/.config"
fi

rm -rf $HOME/.config/nvim
ln -s -f $GIT_DIR/_vimrc ~/.vimrc
ln -s -f $GIT_DIR/nvim ~/.config/nvim
ln -s -f $GIT_DIR/_vimrc.base ~/.vimrc.base
ln -s -f $GIT_DIR/_vimrc.unimap ~/.vimrc.unimap
ln -s -f $GIT_DIR/_ideavimrc ~/.ideavimrc

# JetBrains Client on Windows reads ideavimrc from %USERPROFILE%
if [[ $OS = wsl* ]] && [ -x /mnt/c/Windows/System32/cmd.exe ]; then
    WIN_PROFILE="$(cd /mnt/c && /mnt/c/Windows/System32/cmd.exe /c 'echo %USERPROFILE%' | tr -d '\r')"
    # Empty WIN_PROFILE makes wslpath return ".", which would write through the Linux symlinks
    WIN_HOME="$(wslpath "$WIN_PROFILE")"
fi
if [[ $WIN_HOME = /mnt/* ]]; then
    WSL_GIT_DIR="//wsl.localhost/$WSL_DISTRO_NAME$GIT_DIR"
    echo "source $WSL_GIT_DIR/_ideavimrc" > "$WIN_HOME/_ideavimrc"
    echo "source $WSL_GIT_DIR/_vimrc.base" > "$WIN_HOME/.vimrc.base"
    echo "source $WSL_GIT_DIR/_vimrc.unimap" > "$WIN_HOME/.vimrc.unimap"
fi


# if in docker then return
if [ -e /sys/fs/cgroup/memory.max ] || [ -e /sys/fs/cgroup/memory/memory.limit_in_bytes ]; then
    exit 0
fi

if [ -e /.dockerenv ]; then
    exit 0
fi

if grep -qa docker /proc/self/cgroup; then
    exit 0
fi

if [ -z "$SSH_CONNECTION" ]; then
    if ! python3 -m venv --help > /dev/null 2>&1; then
        echo "'venv'(https://docs.python.org/3/library/venv.html) doesn't exist, please install it and try again."
        # exit 1
    fi
    if ! command -v npm &> /dev/null
    then
        echo "'npm'(https://nodejs.org/) doesn't exist, please install it and try again."
        exit 1
    fi
    npm install -g bash-language-server # 安装
fi
if [ -z "$SSH_CONNECTION" ]; then
    if python3 -m venv --help > /dev/null 2>&1; then
        if ! command -v pip3 &> /dev/null
        then
            if [[ $OS = "linux" ]]; then
                sudo apt install python3-pip python3-venv -y
            elif [[ $OS = "OSX" ]]; then
                sudo brew install python3-pip python3-venv
            fi
        fi
        pip3 install virtualenv > /dev/null 2>&1 || true  # PEP 668 rejects system pip installs
    fi
fi


# if [[ $OS = "linux" ]]; then
    # sudo apt-get -y install wget exuberant-ctags ripgrep
# elif [[ $OS = "OSX" ]]; then
    # brew install wget ripgrep ctags
# fi

# install fonts, https://github.com/ryanoasis/nerd-fonts
if ! command -v git &> /dev/null
then
    echo "installing git..."
    if [[ $OS = "linux" ]]; then
        sudo apt update
        sudo apt install git snapd curl wget -y
    elif [[ $OS = "OSX" ]]; then
        brew install git curl wget
    fi
fi
if ! command -v nvim &> /dev/null
then
    if [[ $OS = "linux" ]]; then
        sudo snap install --beta nvim --classic
        sudo update-alternatives --install /usr/bin/vi vi /snap/nvim/current/usr/bin/nvim 160
        sudo update-alternatives --config vi
        sudo update-alternatives --install /usr/bin/vim vim /snap/nvim/current/usr/bin/nvim 160
        sudo update-alternatives --config vim
        sudo update-alternatives --install /usr/bin/editor editor /snap/nvim/current/usr/bin/nvim 160
        sudo update-alternatives --config editor
        sudo apt update
        sudo apt install fzf ripgrep build-essential -y
    elif [[ $OS = "OSX" ]]; then
        brew install neovim fzf ripgrep
        $(brew --prefix)/opt/fzf/install
    fi
fi

# Hack Nerd Font: fetch only the Hack release archive; on WSL install it for Windows terminals
if [[ $OS = "OSX" ]]; then
    FONT_DIR="$HOME/Library/Fonts"
elif [[ $OS = wsl* ]]; then
    [[ $WIN_HOME = /mnt/* ]] && FONT_DIR="$WIN_HOME/AppData/Local/Microsoft/Windows/Fonts"
else
    FONT_DIR="$HOME/.local/share/fonts"
fi
if [ -z "$SSH_CONNECTION" ] && [ -n "$FONT_DIR" ] && [ ! -f "$FONT_DIR/HackNerdFont-Regular.ttf" ]; then
    FONT_TMP="$(mktemp -d)"
    if curl -fsSL -o "$FONT_TMP/Hack.tar.xz" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.tar.xz \
        && tar -xJf "$FONT_TMP/Hack.tar.xz" -C "$FONT_TMP"; then
        mkdir -p "$FONT_DIR"
        for font in "$FONT_TMP"/*.ttf; do
            cp "$font" "$FONT_DIR/"
            if [[ $OS = wsl* ]]; then
                # Per-user fonts on Windows are registered under HKCU
                /mnt/c/Windows/System32/reg.exe add 'HKCU\Software\Microsoft\Windows NT\CurrentVersion\Fonts' \
                    /v "$(basename "$font" .ttf) (TrueType)" /t REG_SZ \
                    /d "$(wslpath -w "$FONT_DIR/$(basename "$font")")" /f > /dev/null
            fi
        done
        [[ $OS = "linux" ]] && fc-cache -f > /dev/null 2>&1
        echo "→ Installed Hack Nerd Font to $FONT_DIR"
    else
        echo "✗ Failed to download Hack Nerd Font"
    fi
    rm -rf "$FONT_TMP"
fi

