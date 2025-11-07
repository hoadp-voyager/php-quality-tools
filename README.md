# 🧭 Voyager PHP Quality Tools

A **standardized PHP coding quality toolkit** for all company projects — now fully driven by Composer scripts.

This package bundles PHP_CodeSniffer, PHPStan, GrumPHP and Yelp's Detect Secrets, installs git hooks automatically and exposes convenient Composer commands so teams get the same checks everywhere with a single `composer install`.

---

## 🚀 What's inside?

- ✅ Unified setup: **PHP_CodeSniffer**, **PHPStan**, **GrumPHP**, **detect-secrets**
- 🧰 Composer-first workflow that works on any machine with PHP and Python
- 🔐 Secret scanning with automatic virtualenv bootstrap
- 🔧 Auto-installed Git pre-commit hook that runs the full suite

---

## 📦 Installation

1. Add the repository to your project's `composer.json`:

   ```jsonc
   {
     "repositories": [
       {
         "type": "vcs",
         "url": "git@github.com:nntruong-voyager/php-quality-tools.git"
       }
     ],
     "require-dev": {
       "voyager/php-quality-tools": "^1.0"
     }
   }
   ```

2. Install the package (this also sets up the hook and detect-secrets virtualenv):

   ```bash
   composer require --dev voyager/php-quality-tools
   ```

> ℹ️  Requirements: PHP ≥ 8.2, Composer, Python 3 with `venv` support.

On every `composer install`/`composer update`, the toolkit will:

- Bootstrap a dedicated virtualenv under `vendor/voyager/php-quality-tools/bin/detect-secrets-venv`
- Expose `vendor/bin/detect-secrets` and `vendor/bin/quality-checks`
- Install/update the Git pre-commit hook calling the quality suite

---

## 🧪 Running checks manually

Composer scripts are provided for convenience:

```bash
composer quality:phpcs          # PSR-12 style check (configs/phpcs.xml)
composer quality:phpstan        # Static analysis (uses project phpstan.neon if present)
composer quality:grumphp        # Executes configured GrumPHP tasks
composer quality:detect-secrets # Scans repository for secrets (uses .secrets.baseline when available)
composer quality:run            # Runs the whole bundle (same as the Git hook)

# Or run the Composer scripts directly when working inside this package
composer run quality:phpcs
composer run quality:phpstan
composer run quality:grumphp
composer run quality:detect-secrets
composer run quality:run
```

You can also call the wrapper binaries directly:

```bash
vendor/bin/quality-checks
vendor/bin/detect-secrets --help
```

---

## 🔐 Working with detect-secrets

1. Generate an initial baseline and commit it:

   ```bash
   vendor/bin/detect-secrets scan --all-files > .secrets.baseline
   git add .secrets.baseline
   git commit -m "chore: add detect-secrets baseline"
   ```

2. During commits the Git hook scans **only the staged files** for newly introduced secrets. The Composer script `quality:detect-secrets` mirrors this behaviour so you can double-check before committing.

3. With `.secrets.baseline` checked in, the scan fails when a new secret is detected. Without a baseline the scan still runs, but you'll receive a reminder to create one.

---

## 🪝 Git hook behaviour

Running `composer install` (or `composer update`) installs/updates `.git/hooks/pre-commit` with a call to the toolkit. Commits are rejected when any check fails so problems are caught early.

If you maintain a custom hook already, the installer appends the Voyager block safely and keeps a timestamped backup alongside your original file.

---

## ⚙️ Configuration notes

- PHP_CodeSniffer ruleset lives in `configs/phpcs.xml` (PSR-12 by default).
- PHPStan baseline can be overridden by adding `phpstan.neon` in your project root.
- GrumPHP configuration is provided in `configs/grumphp.yml` and executes the same `quality:*` commands.
- Adjust the Composer scripts in your consuming project if you need different folders than `src/` and `tests/`.

---

## ❓ Troubleshooting

- **detect-secrets not found** – ensure Python 3 is installed and rerun `composer install`.
- **Hook missing** – run `bash vendor/voyager/php-quality-tools/scripts/setup-hooks.sh` to force reinstallation.

Enjoy consistent quality gates without extra setup! ✅
