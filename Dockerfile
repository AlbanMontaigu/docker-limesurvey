# ================================================================================================================
#
# LIMESURVEY with with my PHP-FPM implementation
#
# @see https://github.com/AlbanMontaigu/docker-nginx/blob/master/Dockerfile
# @see https://github.com/AlbanMontaigu/docker-php-fpm/blob/master/Dockerfile
# @see https://github.com/AlbanMontaigu/docker-dokuwiki
# ================================================================================================================

# Base is my custom php-fpm
FROM amontaigu/php-fpm:7.1.11

# Maintainer
MAINTAINER alban.montaigu@gmail.com

# Get limesurvey and install it
RUN mkdir -p --mode=777 /var/backup/limesurvey \
    && mkdir -p --mode=777 /usr/src/limesurvey \
    && curl -o limesurvey.tgz -SL https://www.limesurvey.org/fr/version-developpement?download=2184:limesurvey300-rc3%20171114targz \
    && tar -xzf limesurvey.tgz --strip-components=1 -C /usr/src/limesurvey \
    && rm limesurvey.tgz \
    && chown -Rfv www-data:www-data /usr/src/limesurvey

# Entrypoint to enable live customization
COPY --chmod=655 docker-entrypoint.sh /docker-entrypoint.sh

# Volume for limesurvey backup
VOLUME /var/backup/limesurvey

# grr, ENTRYPOINT resets CMD now
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord"]