FROM debian:bookworm

RUN apt update && apt install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

CMD ["mysqld", "--user=mysql"]
