#!/bin/bash
if [[ $(uname) = "Darwin" ]]; then
    export OS="OSX"
elif grep -q Microsoft /proc/version; then
    export OS="wsl1"
    export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
elif grep -q microsoft /proc/version; then
    export OS="wsl2"
    export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
else
    export OS="linux"
fi

if [ -z "$SSH_CONNECTION" ]; then
    if ! command -v venv &> /dev/null
    then
        echo "'venv'(https://docs.python.org/3/library/venv.html) doesn't exist, please install it and try again."
        exit 1
    fi
    if ! command -v npm &> /dev/null
    then
        echo "'npm'(https://nodejs.org/) doesn't exist, please install it and try again."
        exit 1
    fi
fi
# if [ -z "$SSH_CONNECTION" ]; then
    # if ! command -v venv &> /dev/null
    # then
        # if ! command -v pip3 &> /dev/null
        # then
            # if [[ $OS = "linux" ]]; then
                # sudo apt install python3-pip python3-venv -y
            # elif [[ $OS = "OSX" ]]; then
                # sudo brew install python3-pip python3-venv
            # fi
        # fi
        # pip3 install virtualenv
    # fi
# fi


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
        sudo apt install fzf ripgrep build-essential -y
    elif [[ $OS = "OSX" ]]; then
        brew install neovim fzf ripgrep
        $(brew --prefix)/opt/fzf/install
    fi
fi

git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git $GIT_DIR/fonts
bash ./fonts/install.sh Hack

