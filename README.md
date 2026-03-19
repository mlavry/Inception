*This project has been created as part of the 42 curriculum by mlavry.*

# Inception

## 📌 Description

Inception is a system administration project focused on containerization using Docker and Docker Compose.

The goal of this project is to build a secure and modular infrastructure composed of multiple services running inside isolated Docker containers, all deployed within a Virtual Machine.

The mandatory infrastructure includes:

- 🔐 NGINX with TLS (TLSv1.2 or TLSv1.3 only)
- 📝 WordPress + PHP-FPM (without nginx)
- 🗄 MariaDB (without nginx)
- 📦 Two Docker named volumes:
  - WordPress database
  - WordPress website files
- 🌐 A dedicated Docker network connecting the containers

The entire stack is orchestrated using docker-compose and built manually through custom Dockerfiles (no prebuilt images except Alpine/Debian base images).

---

## 🐳 Why Docker?

Docker allows lightweight containerization of services with:

- Fast startup time
- Low resource usage
- Clear separation of concerns
- Reproducible environments
- Easy deployment and portability

Each service runs in its own container following the “one process per container” principle.

---

## ⚙️ Architecture Overview

        Internet
           │
        Port 443
           │
        NGINX (TLS)
           │
     ┌─────┴─────┐
     │           │
 WordPress    MariaDB
 (php-fpm)     Database

- Only NGINX is exposed to the outside (port 443).
- Containers communicate internally via a Docker network.
- Persistent data is stored in Docker named volumes located in:

/home/mlavry/data

---

## 🧠 Design Choices & Comparisons

### 🔹 Virtual Machines vs Docker

| Virtual Machines | Docker |
|------------------|--------|
| Full OS per instance | Shares host kernel |
| Heavy and slower | Lightweight and fast |
| Higher resource usage | Low resource usage |
| Strong isolation | Process-level isolation |

We use a Virtual Machine to comply with project requirements and Docker inside it for containerization.

---

### 🔹 Secrets vs Environment Variables

| Environment Variables | Docker Secrets |
|----------------------|----------------|
| Stored in .env | Stored in /run/secrets |
| Visible in container env | More secure |
| Easier to configure | Recommended for sensitive data |

Passwords are never hardcoded in Dockerfiles.
Sensitive credentials are stored in secrets and ignored by git.

---

### 🔹 Docker Network vs Host Network

| Docker Network | Host Network |
|---------------|-------------|
| Isolated network | Shares host network |
| Secure | Less secure |
| Controlled communication | Direct host access |

The project uses a custom Docker bridge network.
network: host is forbidden.

---

### 🔹 Docker Volumes vs Bind Mounts

| Named Volumes | Bind Mounts |
|--------------|-------------|
| Managed by Docker | Linked to host path |
| Portable | Host-dependent |
| Required by subject | Not allowed for mandatory part |

Two named volumes are used:

- WordPress database
- WordPress files

They store data inside /home/mlavry/data.

---

## 🚀 Instructions

### 1️⃣ Prerequisites

- Debian or similar Linux distribution
- Docker
- Docker Compose
- Make

### 2️⃣ Setup domain

Add to /etc/hosts:

127.0.0.1 mlavry.42.fr

### 3️⃣ Environment variables

Edit:

srcs/.env

Configure:

- DOMAIN_NAME
- MYSQL_USER
- MYSQL_PASSWORD
- MYSQL_DATABASE
- etc.

### 4️⃣ Build and launch

From project root:

make

This will:

- Build Docker images
- Create volumes
- Create network
- Launch containers

### 5️⃣ Stop containers

make down

To remove volumes:

make clean

---

## 🔐 Security Features

- TLSv1.2 / TLSv1.3 only
- No plaintext passwords in Dockerfiles
- No latest tags
- No infinite loops (sleep infinity, tail -f, etc.)
- Only port 443 exposed
- Custom Docker network

---

## 🎁 Bonus Part

Additional services implemented:

- ⚡ Redis cache for WordPress
- 📁 FTP server connected to the WordPress volume
- 📊 Adminer for database management
- 🌐 Static website (non-PHP)
- ➕ Additional service (justified during evaluation)

Each bonus service:

- Has its own Dockerfile
- Runs in a dedicated container
- Uses a dedicated volume if required

Bonus is evaluated only if the mandatory part is perfectly functional.

---

## 📂 Project Structure

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
│

---

## 📚 Resources

Docker Documentation  
https://docs.docker.com/

Docker Compose  
https://docs.docker.com/compose/

NGINX Documentation  
https://nginx.org/en/docs/

MariaDB Documentation  
https://mariadb.org/documentation/

WordPress Documentation  
https://wordpress.org/support/

---

## 🤖 AI Usage

AI was used to:

- Clarify Docker networking concepts
- Compare Docker vs VM architecture
- Improve documentation structure
- Refine security explanations

All generated content was:

- Reviewed
- Tested
- Understood
- Adapted manually

No AI-generated code was blindly copy-pasted without understanding.

---

## 👤 Author

mlavry  
42 School – System Administration Project