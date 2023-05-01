#!/bin/bash

if (( $EUID != 0 )); then
    echo "Por favor execute como root"
    exit
fi

clear

installTheme(){
    cd /var/www/
    tar -cvf MinecraftPurpleThemebackup.tar.gz pterodactyl
    echo "Instalando o tema..."
    cd /var/www/pterodactyl
    rm -r UniversalGamingTheme
    git clone https://github.com/SrStuxBR/UniversalGamingTheme.git
    cd UniversalGamingTheme
    rm /var/www/pterodactyl/resources/scripts/UniversalGamingTheme.css
    rm /var/www/pterodactyl/resources/scripts/index.tsx
    mv index.tsx /var/www/pterodactyl/resources/scripts/index.tsx
    mv UniversalGamingTheme.css /var/www/pterodactyl/resources/scripts/UniversalGamingTheme.css
    cd /var/www/pterodactyl

    curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    apt update
    apt install -y nodejs

    npm i -g yarn
    yarn

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear


}

installThemeQuestion(){
    while true; do
        read -p "Tem certeza de que deseja instalar o tema [y/n]? " yn
        case $yn in
            [Yy]* ) installTheme; break;;
            [Nn]* ) exit;;
            * ) echo "Por favor, responda y ou n.";;
        esac
    done
}

repair(){
    bash <(curl https://raw.githubusercontent.com/SrStuxBR/UniversalGamingTheme/main/reparar.sh)
}

restoreBackUp(){
    echo "Restaurando backup..."
    cd /var/www/
    tar -xvf UniversalGamingThemebackup.tar.gz
    rm UniversalGamingThemebackup.tar.gz

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear
}
echo "Copyright (c) 2022 StuxDev"
echo "Este programa é um software livre: você pode redistribuí-lo e/ou modificá-lo"
echo ""
echo "[1] Instalar tema"
echo "[2] Restaurar backup"
echo "[3] Painel de reparação (use se tiver um erro na instalação do tema)"
echo "[4] Saída"

read -p "Por favor, coloque um numero: " choice
if [ $choice == "1" ]
    then
    installThemeQuestion
fi
if [ $choice == "2" ]
    then
    restoreBackUp
fi
if [ $choice == "3" ]
    then
    repair
fi
if [ $choice == "4" ]
    then
    exit
fi
