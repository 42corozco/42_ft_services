FROM alpine:3.12.0
RUN apk --no-cache add vsftpd

ARG IP

RUN echo $IP > ip

#RUN adduser -D -h /ftp/user user
#RUN echo user:password | chpasswd
#RUN mkdir -p /ftp/user
#RUN chown user:user /ftp/user
#RUN chmod 777 /ftp/user

RUN apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY start_vsftpd.sh /bin/start_vsftpd.sh

RUN mkdir -p /etc/telegraf
COPY ./telegraf.conf /etc/telegraf/telegraf.conf

#RUN echo pasv_address=$IP >> /etc/vsftpd/vsftpd.conf

EXPOSE 21 31000

#ENTRYPOINT ["/usr/sbin/vsftpd", "/etc/vsftpd/vsftpd.conf"]
ENTRYPOINT ["/bin/start_vsftpd.sh"]
