#!/bin/sh
set -e

# Backup the prev install in case of fail...
echo "[INFO] ---------------------------------------------------------------"
echo "[INFO] Backup old limesurvey installation in $(pwd)"
echo "[INFO] ---------------------------------------------------------------"
tar -zcvf /var/backup/limesurvey/limesurvey-v$(date '+%Y%m%d%H%M%S').tar.gz .
echo "[INFO] Complete! Backup successfully done in $(pwd)"

# File copy strategy taken from wordpress entrypoint
# @see https://github.com/docker-library/wordpress/blob/master/fpm/docker-entrypoint.sh
# @see https://manual.limesurvey.org/Upgrading_from_a_previous_version/fr#Upgrading_from_version_1.50_or_later_to_any_later_2.xx_version
echo "[INFO] ---------------------------------------------------------------"
echo "[INFO] Installing or upgrading limesurvey in $(pwd) - copying now..."
echo "[INFO] ---------------------------------------------------------------"
echo "[INFO] Removing old installation"
mv ./upload /tmp/limesurvey-upload
rm -rf .
echo "[INFO] Extracting new installation"
tar cvf - --one-file-system -C /usr/src/limesurvey . | tar xvf -
echo "[INFO] Restoring requested files from prev installation"
mv /tmp/limesurvey-upload ./upload

# Rights fixed
echo "[INFO] Fixing rights"
chown -Rfv www-data:www-data .

# Done
echo "[INFO] Complete! Limesurvey has been successfully installed / upgraded to $(pwd)"

# Exec main command
exec "$@"
