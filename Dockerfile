FROM debian:buster

ADD ./srcs /srcs

RUN \
	apt-get update && \
	apt-get upgrade && \
	apt-get install -y \
		 nginx \
		mariadb-server \
		php-fpm \
		php-mbstring \
		php-mysql \
		curl \
		&& \
	cd /var/www/ && \
	curl -LO https://files.phpmyadmin.net/phpMyAdmin/4.9.2/phpMyAdmin-4.9.2-all-languages.tar.gz && \
	curl -LO https://wordpress.org/latest.tar.gz && \
	tar xzvf phpMyAdmin-4.9.2-all-languages.tar.gz && \
	tar xzvf latest.tar.gz && \
	mv phpMyAdmin-4.9.2-all-languages phpmyadmin && \
	cd /var/www/html/ && \
	ln -s ../phpmyadmin ./phpmyadmin && \
	ln -s ../wordpress ./wordpress && \
	service mysql start && \
	echo "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci" | mysql && \
	echo "GRANT ALL ON wordpress.* TO 'wp-user'@'localhost' IDENTIFIED BY 'password'" | mysql && \
	echo "GRANT ALL PRIVILEGES ON *.* TO adminmysql@localhost IDENTIFIED BY 'password' WITH GRANT OPTION" | mysql && \
	echo "FLUSH PRIVILEGES" | mysql && \
	cd /etc/nginx/ && \
	mkdir ssl && \
	cp /srcs/index.php /var/www/html/ && \
	cp /srcs/localhost* /etc/nginx/ssl/ && \
	cp /srcs/default /etc/nginx/sites-available/default && \
	cp /srcs/wp-config.php /var/www/wordpress/wp-config.php && \
	cp /srcs/ssl /etc/nginx/sites-available/ssl && \
	ln -s /etc/nginx/sites-available/ssl /etc/nginx/sites-enabled/

EXPOSE 80 443

VOLUME ./srcs

CMD service mysql start && \
	service php7.3-fpm start && \
	nginx -g 'daemon off;'
