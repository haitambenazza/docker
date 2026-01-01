FROM debian:12

RUN apt update -y && \
    apt install -y mariadb-server mariadb-client

COPY tools/mariadb.sh /usr/local/bin/mariadb.sh
COPY tools/50-server.cnf /etc/mysql/mariadb.conf.d
RUN chmod +rw /etc/mysql/mariadb.conf.d

RUN chmod +x /usr/local/bin/mariadb.sh
RUN apt install iputils-ping -y

CMD ["./usr/local/bin/mariadb.sh"]