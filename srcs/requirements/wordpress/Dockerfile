FROM debian:12

RUN apt update -y && apt install php-fpm php-mysql mariadb-client curl iputils-ping -y
COPY tools/www.conf /etc/php/8.2/fpm/pool.d/www.conf
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp
COPY tools/wd.sh /usr/local/bin/wordpress.sh
RUN chmod +x /usr/local/bin/wordpress.sh

CMD ["/usr/local/bin/wordpress.sh"]