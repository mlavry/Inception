FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY conf/default.conf /etc/nginx/sites-available/default
COPY tools/site/ /var/www/html/

CMD ["nginx", "-g", "daemon off;"]