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
> 🔐 When prompted, allow the `voyager/php-quality-tools` Composer plugin so the `quality:*` commands are registered.

On every `composer install`/`composer update`, the toolkit will:

- Bootstrap a dedicated virtualenv under `vendor/voyager/php-quality-tools/bin/detect-secrets-venv`
- Expose `vendor/bin/detect-secrets` and `vendor/bin/quality-checks`
- Install/update the Git pre-commit hook calling the quality suite

---

## 🧪 Running checks manually

Once installed, the Composer plugin exposes dedicated commands:

```bash
composer quality:phpcs           # PSR-12 style check (configs/phpcs.xml)
composer quality:phpstan         # Static analysis (uses project phpstan.neon if present)
composer quality:grumphp         # Executes configured GrumPHP tasks
composer quality:detect-secrets  # Scans repository for secrets (uses .secrets.baseline when available)
composer quality:run             # Runs the whole bundle (same as the Git hook)
composer run quality:phpcs       # Identical to the command above (via Composer scripts)
```

> ✅ If Composer prompts to allow the plugin, answer “yes” so the commands become available automatically.

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

2. The Composer scripts and Git hook will use `.secrets.baseline` automatically and fail when new secrets are detected. Without a baseline the scan still runs, but you'll receive a reminder to create one. When using older versions of `detect-secrets` that lack `--fail-on-secrets`, the toolkit parses the scan results and exits non-zero if any findings remain.

---

## 🪝 Git hook behaviour

Running `composer install` (or `composer update`) installs/updates `.git/hooks/pre-commit` with a call to the toolkit. Commits are rejected when any check fails so problems are caught early.

If you maintain a custom hook already, the installer appends the Voyager block safely and keeps a timestamped backup alongside your original file.

---

## ⚙️ Configuration notes

- During installation the toolkit publishes `.php-cs-fixer.dist.php` (Laravel-optimised finder and rules) and `grumphp.yml` into your project if they don't exist so you can tweak them freely.
- PHP_CodeSniffer ruleset lives in `vendor/voyager/php-quality-tools/configs/phpcs.xml` by default, but `scripts/run-phpcs.sh` will prefer a local `phpcs.xml` or `phpcs.xml.dist` if you add one.
- PHPStan baseline can be overridden by adding `phpstan.neon` in your project root.
- GrumPHP reads the generated `grumphp.yml`; adjust its task configuration to point at your preferred rulesets or extra checks.
- Adjust the Composer scripts in your consuming project if you need different folders than `src/` and `tests/`.

---

## ❓ Troubleshooting

- **detect-secrets not found** – ensure Python 3 is installed and rerun `composer install`.
- **Hook missing** – run `bash vendor/voyager/php-quality-tools/scripts/setup-hooks.sh` to force reinstallation.

Enjoy consistent quality gates without extra setup! ✅
