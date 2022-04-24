#!/usr/bin/env bash
# An incron script to apply open_basedir setting to wpstarter based WP sites

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"

sleep 120

if [[ ! -f "$1/$2/wpstarter.json" ]]; then
    exit
fi

# grep -m1 -> return only one match
default_fpm=$(update-alternatives --quiet --query php-fpm.sock | grep Value -m1 | cut -d" " -f2)
# /run/php/php7.4-fpm.sock

fpmfname=$(basename "$default_fpm")
# php7.4-fpm.sock

# Remove '.sock' from above
fpmfname=${fpmfname%.sock}
# Now we have 'php7.4-fpm'

fpmversion=$(echo "$fpmfname" | cut -c4-6)
phpfpm_service_name="$fpmfname"".service"

if [[ -f "/etc/php/$fpmversion/fpm/php.ini" ]]; then

    echo "
[HOST=$2]
open_basedir=$1/$2:/tmp" | tee -a "/etc/php/$fpmversion/fpm/php.ini"

    if  systemctl is-enabled "$phpfpm_service_name" && systemctl is-active "$phpfpm_service_name"; then
        systemctl reload "$phpfpm_service_name"
    fi
else
    logger "INCRON Job : Cannot find out php-fpm version: $fpmversion"
fi
