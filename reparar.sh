if (( $EUID != 0 )); then
    echo "Por favor execute como root"
    exit
fi

repairPanel(){
    cd /var/www/pterodactyl

    php artisan down

    rm -r /var/www/pterodactyl/resources

    curl -L sudo curl -Lo panel.tar.gz https://github.com/Next-Panel/Pterodactyl-BR/releases/latest/download/panel.tar.gz | tar -xzv

    chmod -R 755 storage/* bootstrap/cache

    composer install --no-dev --optimize-autoloader

    php artisan view:clear

    php artisan config:clear

    php artisan migrate --seed --force

    chown -R www-data:www-data /var/www/pterodactyl/*

    php artisan queue:restart

    php artisan up
}

while true; do
    read -p "Tem certeza que deseja desinstalar o tema [y/n]? " yn
    case $yn in
        [Yy]* ) repairPanel; break;;
        [Nn]* ) exit;;
        * ) echo "Por favor, responda y ou n.";;
    esac
done
