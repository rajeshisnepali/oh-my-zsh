#!/bin/bash
# colors
YELLOW='\e[43m'
LRED='\e[101m'
NC='\033[0m' # No Color

getOSArchitecture() {
    arch=$(awk -F= '/^ID_LIKE/{print $2}' /etc/os-release)

    if [ "$arch" = "debian" ];
    then
        pkg='apt-get'
    else
        pkg='yum'
    fi
}

installTools() {

    echo -e "Installing ${YELLOW}Pre Tools${NC}.... \n Ignoring any install if already installed"
    sudo $pkg install -y $pre_tools
}

installZSH() {
    sudo $pkg install -y zsh

    # Verify installation by running
    zsh --version

    # install oh-my-zsh via wget
    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

    # Make it your default shell
    sudo chsh -s $(which zsh)
}

installAutoSuggestions() {
    # installing zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    # Add the plugin to the list of plugins for Oh My Zsh to load (inside ~/.zshrc):
    $(sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions)/g' ~/.zshrc)
}

# steps
getOSArchitecture
pre_tools='git'
installTools $pre_tools
installZSH
installAutoSuggestions
