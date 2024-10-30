#!/bin/bash
check_debian() {
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt upgrade -y
        cd
        git clone https://github.com/MrScratchcat/custom-linux-commands
        cd custom-linux-commands/
        sudo cp * /bin
        cd /bin
        sudo chmod +x *
        cd
        sudo rm -r custom-linux-commands/
        gpu=$(lspci | grep -i vga | awk '{print $5}')
        kernel=$(uname -r)
        return 0
    fi
    return 1
}

check_arch() {
    if command -v pacman &> /dev/null; then
        sudo pacman -Syyu --noconfirm
        if command -v flatpak &> /dev/null
        then
            echo flatpak is installed > /dev/null
        else
            sudo pacman -S flatpak --noconfirm
        fi
        cd
        git clone https://github.com/MrScratchcat/custom-linux-commands-arch
        cd custom-linux-commands-arch
        chmod +x * > /dev/null 2>&1
        sudo cp * /bin
        cd /bin
        sudo chmod +x * > /dev/null 2>&1
        cd
        rm -rf custom-linux-commands-arch
        return 0
    fi
    return 1
}

if check_debian; then
    exit 0
elif check_arch; then
    exit 0
else
    echo "Unknown system or not Debian/Arch-based."
    exit 1
fi
