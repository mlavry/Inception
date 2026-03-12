FROM debian:bookworm

RUN apt-get update && apt-get install -y \
	nginx \
	openssl \
	&& apt-get clean \
	&& rm -rf /var/lib/lists/*

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 \
	-newkey rsa:2048 \
	-keyout /etc/nginx/ssl/inception.key \
	-out /etc/nginx/ssl/inception.crt \
	-subj "/CN=mlavry.42.fr"

COPY tools/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
