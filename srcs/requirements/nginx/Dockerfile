FROM debian:12

RUN apt update -y && apt install nginx openssl -y 

COPY tools/nginx.conf /etc/nginx/conf.d
COPY tools/script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh
RUN rm -rf /etc/nginx/sites-enabled/default


ENTRYPOINT [ "script.sh"]

