FROM alpine:latest

RUN apk update && apk upgrade
RUN apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session

RUN wget http://files.directadmin.com/services/all/phpMyAdmin/phpMyAdmin-5.0.2-all-languages.tar.gz \
	&& tar zxvf phpMyAdmin-5.0.2-all-languages.tar.gz \
	&& rm phpMyAdmin-5.0.2-all-languages.tar.gz \
	&& mv phpMyAdmin-5.0.2-all-languages /usr/share/phpmyadmin \
	&& rm -rf /var/cache/apk/*

COPY srcs/config.inc.php /usr/share/phpmyadmin/config.inc.php

EXPOSE 5000

CMD php -S 0.0.0.0:5000 -t /usr/share/phpmyadmin
