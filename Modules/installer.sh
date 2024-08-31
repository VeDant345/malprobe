#!/bin/bash

# Colors
cyan='\e[96m'
red='\e[91m'
green='\e[92m'
default='\e[0m'
yellow='\e[93m'

# Legends
info="${cyan}[${yellow}*${cyan}]${default}"
success="${cyan}[${green}+${cyan}]${default}"
error="${cyan}[${red}!${cyan}]${default}"

# Get sc0pe_path variable as an argument
sc0pe_path=$1

# Get username
normal_user=$2

# Check permissions
echo -en "$info Checking user privileges...\n"
user_str=$(whoami)
if [[ $user_str != *"root"* ]];then
    echo -en "$error You must be a root user to use installer!\n"
    exit 1
fi

installer(){
    echo -en "\n$info Looks like we have permission to install. Let's begin...\n"

    # Install python modules
    echo -en "$info Installing Python dependencies...\n"
    pip3 install -r requirements.txt

    # Configurating MalwareProbe's config file
    echo -en "$info Creating configuration file in ${green}/etc${default} directory\n"
    echo -en "[MalwareProbe_PATH]\n" > /etc/MalwareProbe.conf
    echo -en "sc0pe = /opt/MalwareProbe\n" >> /etc/MalwareProbe.conf
    chown $normal_user:$normal_user /etc/MalwareProbe.conf

    # Copying MalwareProbe's to /opt directory
    echo -en "$info Copying files to ${green}/opt${default} directory.\n"
    cd "$sc0pe_path/../" && cp -r MalwareProbe /opt/
    chown $normal_user:$normal_user /opt/MalwareProbe

    # Configurating libScanner.conf
    echo -en "[Rule_PATH]\n" > /opt/MalwareProbe/Systems/Android/libScanner.conf
    echo -en "rulepath = /opt/MalwareProbe/Systems/Android/YaraRules/\n\n" >> /opt/MalwareProbe/Systems/Android/libScanner.conf
    echo -en "[Decompiler]\n" >> /opt/MalwareProbe/Systems/Android/libScanner.conf
    if [ -d "/home/$normal_user/sc0pe_Base" ];then
        echo -en "decompiler = /home/$normal_user/sc0pe_Base/jadx/bin/jadx\n" >> /opt/MalwareProbe/Systems/Android/libScanner.conf
    else
        echo -en "decompiler = /usr/bin/jadx\n" >> /opt/MalwareProbe/Systems/Android/libScanner.conf
    fi

    # Copying MalwareProbe.py file into /usr/bin/
    echo -en "$info Copying ${green}MalwareProbe.py${default} to ${green}/usr/bin/${default} directory.\n"
    cd $sc0pe_path && cp MalwareProbe.py /usr/bin/qu1cksc0pe && chmod +x /usr/bin/qu1cksc0pe
    chown $normal_user:$normal_user /usr/bin/MalwareProbe

    # Check dos2unix
    dos2unix /usr/bin/MalwareProbe

    echo -en "$success Installation completed.\n"
}

uninstaller(){
    echo -en "\n$info Looks like we have permission to uninstall. Let's begin...\n"
    echo -en "$info Removing ${green}/usr/bin/MalwareProbe${default} file.\n"
    rm -rf /usr/bin/MalwareProbe
    echo -en "$info Removing ${green}/etc/MalwareProbe.conf${default} file.\n"
    rm -rf /etc/MalwareProbe.conf
    echo -en "$info Removing ${green}/opt/MalwareProbe${default} directory.\n"
    rm -rf /opt/MalwareProbe
    echo -en "$success Uninstallation completed.\n"
}

menu(){
    echo -en "$info User:$green $normal_user\n\n"
    echo -en "${cyan}[${red}1${cyan}]$default Install MalwareProbe\n"
    echo -en "${cyan}[${red}2${cyan}]$default Uninstall MalwareProbe\n\n"
    echo -en "$green>>>>$default "
    read choice
    case $choice in
        1) installer ;;
        2) uninstaller ;;
        *) echo -en "$error Wrong choice :(\n"
           exit 1 ;;
    esac
}

# Execution
menu