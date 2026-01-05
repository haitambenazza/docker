FROM debian:12

RUN apt update -y && apt install nginx openssl iputils-ping  -y 

COPY tools/nginx.conf /etc/nginx/conf.d
COPY tools/script.sh /usr/local/bin/script.sh
COPY tools/doc.html /var/www/html/doc.html
RUN mkdir -p /etc/nginx/ssl/
RUN openssl req -x509 -newkey rsa:2048 -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt\
    -sha256 -days 3650 -nodes \
    -subj "/CN=hbenazza.42.fr" 
RUN chmod +x /usr/local/bin/script.sh
RUN rm -rf /etc/nginx/sites-enabled/default


ENTRYPOINT [ "script.sh"]

