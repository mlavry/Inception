FROM debian:bookworm

RUN apt-get update && apt-get install -y \
	php \
	php-mysql \
	curl \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html

RUN curl -L https://www.adminer.org/latest.php -o /var/www/html/index.php

RUN rm -f /var/www/html/index.html

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]
