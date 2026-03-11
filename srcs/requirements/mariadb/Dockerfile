FROM debian:bookworm

RUN apt update && apt install -y mariadb-server && \
	apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

COPY tools/99-network.cnf /etc/mysql/mariadb.conf.d/99-network.cnf

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
