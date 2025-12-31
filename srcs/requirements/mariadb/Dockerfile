FROM debian:12

RUN apt update && \
    apt install -y mariadb-server mariadb-client

COPY tools/mariadb.sh /usr/local/bin/script.sh

RUN chmod +x ./usr/local/bin/script.sh

CMD ["./usr/local/bin/script.sh"]