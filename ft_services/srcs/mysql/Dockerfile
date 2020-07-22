FROM alpine:latest

RUN apk update
RUN apk add mysql mysql-client openrc
RUN mkdir -p /run/mysqld && openrc \
	&& touch /run/openrc/softlevel
COPY srcs/init.sh /tmp/init.sh
COPY srcs/my.cnf /etc/mysql/my.cnf

EXPOSE 3306

CMD sh /tmp/init.sh ; /usr/bin/mysqld -u root ;
