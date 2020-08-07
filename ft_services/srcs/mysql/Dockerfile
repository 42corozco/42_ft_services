FROM alpine:latest

RUN apk update \
	&& apk add mysql mysql-client

ADD srcs/init.sh .
ADD srcs/my.cnf /etc/

EXPOSE 3306

ENTRYPOINT ["/bin/sh", "/init.sh"]
