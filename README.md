# Voyager PHP Quality Tools

A **standardized PHP coding quality toolkit** for all company PHP projects.  
This repository provides a unified environment to **analyze, format, and validate code quality** automatically across different PHP versions (5.x, 7.x, 8.x).

---

## 🚀 Features

- ✅ Unified setup: **PHP_CodeSniffer**, **PHPStan**, **GrumPHP**
- 🐳 **Docker-ready** (PHP 8.2 - Debian Slim)
- 🧩 Compatible with projects using **PHP 5.x, 7.x, or 8.x**
- 🔧 Auto Git pre-commit hooks
- 📦 Easy integration into existing or new projects

---

## ⚙️ Usage Guide

You can use this toolkit in **two main ways** depending on your project setup.

---

### 🧱 1. For Projects Using Docker

If your project already runs inside Docker containers:

1. **Add this repo as a dev dependency**
   ```bash
   composer require --dev voyager/php-quality-tools
   ```
2. **Add an extra service** in your existing `docker-compose.override.yml` (no need to edit your main compose file):

   ```yaml
   services:
     php-quality-tools:
       image: voyager/php-quality-tools:latest
       container_name: php-quality-tools
       working_dir: /project
       volumes:
         - .:/project
       command: tail -f /dev/null
   ```

3. **Run and execute inside the container**

   ```bash
   docker-compose up -d php-quality-tools
   docker exec -it php-quality-tools bash
   ```

4. **Run quality checks**

   ```bash
   vendor/bin/phpcs
   vendor/bin/phpstan analyse
   vendor/bin/grumphp run
   ```

📘 See [`integration-example/`](integration-example) for a full sample setup.

---

### 💻 2. For Projects Without Docker

If your project runs directly on the local machine:

1. **Install via Composer**

   ```bash
   composer require --dev voyager/php-quality-tools
   ```

2. **Run quality tools manually**

   ```bash
   vendor/bin/phpcs
   vendor/bin/phpstan analyse
   vendor/bin/grumphp run
   ```

3. **Optional: Enable automatic checks before each commit**

   ```bash
   bash vendor/voyager/php-quality-tools/scripts/setup-hooks.sh
   ```

---

## 🧰 Tool Overview

| Tool                | Purpose                                          | Config File    |
| ------------------- | ------------------------------------------------ | -------------- |
| **PHP_CodeSniffer** | Code formatting & PSR-12 standard checking       | `phpcs.xml`    |
| **PHPStan**         | Static code analysis & type checking             | `phpstan.neon` |
| **GrumPHP**         | Runs all checks automatically on each Git commit | `grumphp.yml`  |

---

## 🧪 Local Development (Optional)

You can also run this repo standalone:

```bash
git clone https://github.com/voyager/php-quality-tools.git
cd php-quality-tools
docker-compose up -d
docker exec -it php-quality-tools bash
```

Then test with:

```bash
vendor/bin/phpcs
vendor/bin/phpstan analyse
vendor/bin/grumphp run
```

---

## 🏁 Summary

| Scenario                     | Recommended Setup                         |
| ---------------------------- | ----------------------------------------- |
| Project already using Docker | Add `docker-compose.override.yml` service |
| Project without Docker       | Run tools directly via Composer           |
| Need isolated environment    | Use Dockerfile from this repo             |

---
