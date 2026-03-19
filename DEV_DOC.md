# DEV_DOC.md

# Developer Documentation – Inception

This document explains how a developer can set up, build, run, and manage the Inception infrastructure from scratch.

It focuses on technical aspects of the project.

---

# 1️⃣ Environment Setup From Scratch

## 📋 Prerequisites

The project must be executed inside a Virtual Machine.

Required tools:

- Linux distribution (Debian recommended)
- Docker
- Docker Compose
- Make
- OpenSSL

Verify installation:

```bash
docker --version
docker compose version
make --version
```

---

## 📂 Project Structure

```
.
├── Makefile
├── secrets/
├── srcs/
│   ├── docker-compose.yml
│   ├── .env
│   └── requirements/
│       ├── nginx/
│       ├── mariadb/
│       ├── wordpress/
│       └── bonus/
```

---

## 🔐 Configure Environment Variables

Edit:

```
srcs/.env
```

Example:

```
DOMAIN_NAME=mlavry.42.fr

MYSQL_DATABASE=wordpress_db
MYSQL_USER=wp_user
MYSQL_PASSWORD=secure_password
MYSQL_ROOT_PASSWORD=root_password

WP_ADMIN_USER=wp_admin
WP_ADMIN_PASSWORD=admin_password
WP_ADMIN_EMAIL=admin@email.com
```

⚠️ The `.env` file must not be committed if it contains sensitive data.

---

## 🔑 Configure Docker Secrets

Secrets are stored inside:

```
secrets/
```

Examples:

- db_password.txt
- db_root_password.txt
- credentials.txt

Each file contains only the password value.

Secrets are mounted inside containers via Docker Compose.

---

## 🌐 Configure Domain Name

Edit `/etc/hosts`:

```
127.0.0.1 mlavry.42.fr
```

This maps the local IP to the required domain.

---

# 2️⃣ Build and Launch the Project

All commands must be executed from the project root directory.

---

## ▶️ Build and Start Containers

```bash
make
```

The Makefile:

- Calls docker-compose.yml
- Builds Docker images from custom Dockerfiles
- Creates Docker volumes
- Creates Docker network
- Starts containers

Equivalent manual command:

```bash
docker compose -f srcs/docker-compose.yml up --build -d
```

---

## ⏹ Stop Containers

```bash
make down
```

Equivalent:

```bash
docker compose -f srcs/docker-compose.yml down
```

---

## 🧹 Remove Containers and Volumes

```bash
make fclean
```

Equivalent:

```bash
docker compose -f srcs/docker-compose.yml down -v
```

⚠️ This deletes persistent data.

---

# 3️⃣ Managing Containers and Volumes

## 📦 List Running Containers

```bash
docker ps
```

---

## 📜 View Logs

```bash
docker logs <container_name>
```

Example:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

---

## 🔄 Restart a Container

```bash
docker restart <container_name>
```

---

## 🗑 Remove All Unused Resources

```bash
docker system prune -a
```

⚠️ Use carefully.

---

## 📦 List Volumes

```bash
docker volume ls
```

---

## 🔍 Inspect a Volume

```bash
docker volume inspect <volume_name>
```

---

# 4️⃣ Data Storage and Persistence

## 📁 Host Data Location

All persistent data is stored in:

```
/home/mlavry/data
```

This includes:

- WordPress files
- MariaDB database files

---

## 🔁 How Persistence Works

- Docker named volumes are defined in docker-compose.yml.
- They are mounted inside containers.
- Even if containers are removed, volumes remain.
- Data survives container rebuilds.

---

## 🧪 Test Persistence

1. Create a WordPress post.
2. Stop containers:
   ```bash
   make down
   ```
3. Restart:
   ```bash
   make
   ```
4. Verify the post still exists.

---

# 5️⃣ Networking

- A custom Docker bridge network connects all services.
- Only NGINX exposes port 443.
- Internal communication uses container names as hostnames.

Example:

WordPress connects to MariaDB using:

```
mariadb:3306
```

---

# 6️⃣ Security Considerations

- No `latest` image tags.
- No passwords inside Dockerfiles.
- TLSv1.2 or TLSv1.3 only.
- No host networking.
- No infinite loops in entrypoints.
- Containers restart automatically on crash.

---

# 7️⃣ Development Notes

- Each service has its own Dockerfile.
- Images are built locally (no prebuilt service images).
- Containers follow the “one process per container” principle.
- NGINX is the only public entrypoint.

Bonus services follow the same structure:
- One Dockerfile per service
- Dedicated container
- Dedicated volume if required

---

# ✅ Summary

A developer can:

- Configure environment and secrets
- Build the entire stack via Makefile
- Manage containers using Docker commands
- Inspect volumes and logs
- Understand where and how data persists
- Extend the infrastructure with additional services

The project ensures:

- Modular design
- Secure configuration
- Data persistence
- Reproducible builds
- Clear separation of services

---

End of DEV_DOC.md