FROM debian:bookworm

RUN apt-get update && apt-get install -y \
	php-fpm \
	php-mysql \
	mariadb-client \
	curl \
	wget \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY tools/setup.sh /usr/local/bin/setup.sh

RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/setup.sh"]

#Différence entre RUN et ENTRYPOINT

#C’est très important de bien distinguer les deux.

#RUN

#exécuté pendant le build

#sert à construire l’image

#Exemple :

#installer des paquets

#copier des fichiers

#préparer l’environnement

#ENTRYPOINT

#exécuté quand le conteneur démarre

#sert à lancer le programme principal
