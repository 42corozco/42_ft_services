FROM alpine:latest

RUN apk update \
	&& apk upgrade \
	&& apk add nginx
RUN apk add php-fpm php-cli php7-mysqli php7 php7-openssl php7-cgi php7-xml php7-pdo php7-mcrypt php7-session php7-mysqli php7-zlib php7-json

RUN rm /etc/nginx/conf.d/default.conf
ADD srcs/default.conf /etc/nginx/conf.d/default.conf
ADD srcs/sano.sh /etc/init.d/sano.sh
RUN chmod 777 /etc/init.d/sano.sh
ADD srcs/finito.sh /finito.sh
RUN mkdir /run/nginx
RUN mkdir -p /usr/share/nginx/html

RUN wget -O wordpress.zip https://wordpress.org/latest.zip \
	&& unzip /wordpress.zip -d /usr/share/nginx/html/ 1> /dev/null  \
	&& rm wordpress.zip \
	&& rm -rf /usr/share/nginx/html/wordpress/wp-config.php
ADD srcs/wp-config.php /usr/share/nginx/html/wordpress/wp-config.php

EXPOSE 5050

CMD sh /finito.sh ;
