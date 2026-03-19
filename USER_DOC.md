# USER_DOC.md

# User Documentation – Inception

This document explains in simple terms how to use and manage the Inception infrastructure.

It is intended for:

- End users
- Administrators
- Evaluators

---

# 1️⃣ Services Provided by the Stack

The infrastructure includes the following services:

## 🔐 NGINX (HTTPS Reverse Proxy)

- Handles secure HTTPS connections (TLSv1.2 / TLSv1.3 only)
- Exposes the website on port 443
- The only public entrypoint of the infrastructure

---

## 📝 WordPress (PHP-FPM)

- Hosts the website
- Handles dynamic content
- Connected internally to MariaDB

---

## 🗄 MariaDB

- Stores WordPress data:
  - Users
  - Posts
  - Settings
  - Database content

---

## 📦 Persistent Volumes

Two Docker named volumes ensure data persistence:

- WordPress website files
- WordPress database

Data is stored on the host machine inside:

```
/home/mlavry/data
```

Data remains intact even if containers are restarted.

---

## 🎁 (Optional Bonus Services)

If bonus is enabled, additional services may include:

- Redis (cache)
- FTP server
- Adminer (database management)
- Static website
- Additional custom service

---

# 2️⃣ How to Start and Stop the Project

All commands must be executed from the project root directory.

---

## ▶️ Start the project

```bash
make
```

This will:

- Build Docker images
- Create volumes
- Create network
- Start all containers

---

## ⏹ Stop the project

```bash
make down
```

This stops all containers without deleting data.

---

## 🧹 Remove everything (including volumes)

```bash
make fclean
```

⚠️ This removes containers and persistent data.

---

# 3️⃣ Accessing the Website and Admin Panel

## 🌐 Website Access

Open your browser and go to:

```
https://mlavry.42.fr
```

If it does not resolve, add this line to `/etc/hosts`:

```
127.0.0.1 mlavry.42.fr
```

---

## 🔧 WordPress Admin Panel

Access:

```
https://mlavry.42.fr/wp-admin
```

Log in using the administrator credentials defined during setup.

---

## 🗄 Adminer (Bonus)

If enabled:

```
http://localhost:8080
```

Used to manage the MariaDB database.

---

# 4️⃣ Locating and Managing Credentials

## 🔐 Environment Variables

Main configuration file:

```
srcs/.env
```

This file contains:

- Database name
- Database user
- Domain name
- Other environment variables

---

## 🔑 Docker Secrets

Sensitive data (passwords) are stored in:

```
secrets/
```

Examples:

- db_password.txt
- db_root_password.txt
- credentials.txt

These files are:

- Not committed to git
- Mounted securely inside containers

⚠️ Never store passwords directly inside Dockerfiles.

---

# 5️⃣ Checking That Services Are Running Correctly

## 📦 Check Running Containers

```bash
docker ps
```

You should see:

- nginx
- wordpress
- mariadb
- (bonus services if enabled)

---

## 📜 View Logs

To check logs:

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

## 🌐 Test HTTPS

Open:

```
https://mlavry.42.fr
```

You should see:

- A secure connection (HTTPS)
- A WordPress website

---

## 🔄 Restart Containers

If needed:

```bash
docker restart <container_name>
```

---

## 💾 Verify Data Persistence

1. Stop containers:
   ```bash
   make down
   ```

2. Start again:
   ```bash
   make
   ```

Your WordPress content should still be there.

This confirms volumes are working correctly.

---

# ✅ Summary

This infrastructure provides:

- Secure HTTPS website
- Isolated services
- Persistent storage
- Secure credential management
- Easy start/stop management via Makefile

The system is fully containerized and designed to be:

- Secure
- Modular
- Reproducible
- Maintainable

---

End of USER_DOC.md