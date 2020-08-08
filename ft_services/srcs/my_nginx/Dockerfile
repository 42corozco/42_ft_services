FROM alpine:3.12.0

RUN apk update \
		&& apk upgrade \
		&& apk add \
		nginx \
		openssl \
		openssh

RUN adduser -D -g 'www' www \
		&& mkdir /www \
		&& chown -R www:www /var/lib/nginx \
		&& chown -R www:www /www

RUN apk add telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

RUN adduser -D user
#RUN echo "www:www"| chpasswd
RUN echo "user:password" | chpasswd
RUN ssh-keygen -A

RUN mkdir -p /run/nginx/

RUN rm -rf etc/nginx/conf.d/default.conf

#RUN yes "" | openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

#RUN yes "" | openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
#		-keyout /etc/ssl/private/nginx-selfsigned.key \
#		-out /etc/ssl/certs/nginx-selfsigned.crt

COPY localhost2 /etc/nginx/conf.d/nginx.conf

COPY index.html /usr/share/nginx/html/

COPY ssh-message /etc/motd

RUN mkdir -p /etc/telegraf
COPY ./telegraf.conf /etc/telegraf/telegraf.conf

EXPOSE 80
EXPOSE 22
#EXPOSE 443

COPY start.sh ./start.sh
RUN chmod +x /start.sh
CMD sh ./start.sh
#CMD /usr/sbin/sshd && telegraf & && nginx -g 'daemon off;'
