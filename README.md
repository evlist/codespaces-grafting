<!--
SPDX-FileCopyrightText: 2025 Eric van der Vlist <vdv@dyomedea.com>

SPDX-License-Identifier: GPL-3.0-or-later OR MIT
-->

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=evlist/wp-plugin-codespace)

# wp-plugin-codespace

🧰 A lightweight, shareable Codespaces / devcontainer scaffold for WordPress plugin authors.

This repository provides an easy way for WP plugin developers to ship a zero‑install, ready‑to‑use development environment — preconfigured with PHP, WP‑CLI, a webserver and common editor config — so contributors, contractors and reviewers can open a Codespace (or a local devcontainer) and start working immediately.

## 🔎 Why this repo exists
- Problem: onboarding WP plugin development often requires installing PHP, a webserver, DB, extensions and bootstrapping WordPress locally.
- Goal: remove that friction — clone, open a Codespace, and start coding.

## 👥 Who should use this
- WordPress plugin authors and maintainers who want:
  - A reproducible, shareable dev environment for contributors.
  - A quick way to demo a plugin without asking others to install and configure PHP/Apache/MySQL.
  - An easy updater to adopt improvements to the template.

## ✨ What this provides
- A compact `.devcontainer/` (and optional `.vscode/`) preconfigured for plugin development.
- A small installer/updater script to add or refresh the devcontainer & editor snippets in your plugin repo.
- A simple convention for Codespace-specific environment samples (`.cs_env.example`) while keeping project `.env` usage independent.
- Helpful CLI tools preinstalled in the Codespace: `gh` (GitHub CLI) and `reuse`.
- Interactive, conservative update semantics (baselines `.orig`, upstream samples `.dist`, backups `.bak.*`).

## ⚙️ Main principles
- Track only the minimal configuration needed for a reproducible dev environment.
- Keep secrets out of git; commit a safe example (`.cs_env.example`) and allow maintainers to provide runtime values via Codespaces secrets or by creating a local `.cs_env`.
- Provide a simple installer that doubles as an updater so plugin repos can stay in sync with improvements.
- Make updates explicit and reversible (baseline files, dist samples and backups).

## 🚀 Quick install (recommended, minimal)
1. Download the installer outside the repo (do not add it to your repo):
   ```bash
   curl -L -o ~/Downloads/install.sh https://raw.githubusercontent.com/evlist/wp-plugin-codespace/main/.devcontainer/bin/install.sh
   chmod +x ~/Downloads/install.sh
   ```
2. From a local, up‑to‑date clone of your plugin repository:
   ```bash
   cd /path/to/your-plugin-repo
   bash ~/Downloads/install.sh
   ```
   - On first run the script acts as an installer and will guide you through choices.
   - After first run the same script serves as the updater.
3. Commit and push:
   ```bash
   git add .
   git commit -m "Add Codespace/devcontainer"
   git push
   ```
4. Open your repository in a GitHub Codespace or locally with Remote - Containers.

## 🔁 Updater (inside Codespace)
- The Codespace image provides two convenience aliases to simplify updates:
  - `cs_install` — run the installer (initial setup).
  - `cs_update`  — run the updater (same script, named for clarity).
- Both aliases point to the same `bin/install.sh` helper so updating is easy and interactive.

## 📝 Environment files (manual approach)
- We deliberately keep Codespace-specific variables separate from project `.env` files.
- If you want a Codespace-specific env file, create it manually from the example:
  ```bash
  # optional: create a Codespace-specific env file
  cp .cs_env.example .cs_env
  ```
- Alternatively, supply required values via Codespaces secrets or create `.cs_env` interactively inside the Codespace.
- The installer/updater does not depend on any helper to materialize `.cs_env`; that remains an opt-in, manual step.

## 🧪 Dry-run and automation
- Preview changes without modifying files:
  ```bash
  bash ~/Downloads/install.sh --dry-run
  ```
- Use `--ref <branch-or-tag>` to pick an upstream ref (default: `stable`).
- Use `--yes` to accept defaults non‑interactively.
- Prefer running `--dry-run` in CI to detect `.gitignore` or other issues before merging.

## 📝 Recommended .gitignore hints
- Keep secrets out of git:
  ```
  .env
  .env.*
  ```
- Ignore updater artifacts (recommended):
  ```
  .vscode/*.dist
  .vscode/*.bak.*
  .devcontainer/tmp/
  .devcontainer/var/
  ```

## 📁 Project Structure

```
.
├── .cs_env                        # Local environment variables overriding .devcontainer/.cs_env
├── bootstrap-local.sh             # Local bootstrap script
├── .devcontainer/
│   ├── devcontainer.json          # VS Code devcontainer configuration
│   ├── docker-compose.yml         # Docker Compose services definition
│   ├── Dockerfile                 # WordPress container with WP-CLI
│   ├── README.md                  # Technical notes
│   ├── .cs_env                    # Environment variables (non customizable, use ./.cs_env instead)
│   └── bin/
│       ├── bootstrap-wp.sh        # Bootstrap: DB, Apache, WP core, symlinks, ends up calling the localbootstrap script
│       ├── install.sh             # Install and update script
│       └── merge-env.sh           # Merge .cs_env files
├── .vscode/
│   ├── launch.json                # Static PHP debug config (single mapping)
│   └── intelephense-stubs/
│       └── wp-cli.php             # Editor-only stub for WP-CLI
└── plugins-src/
    └── hello-world/               # Sample plugin directory
        ├── hello-world.php
        └── README.md
```

---

## Credits

This plugin was inspired by examples and guidance from:

- [WordPress Plugin Developer Handbook](https://developer.wordpress.org/plugins/)
- [WordPress REST API Handbook](https://developer.wordpress.org/rest-api/)
- [Admin Bar API (`admin_bar_menu` / `add_node`)](https://developer.wordpress.org/reference/hooks/admin_bar_menu/)
- [Admin Notices (`admin_notices`)](https://developer.wordpress.org/reference/hooks/admin_notices/)
- [WP‑CLI Handbook and Commands Cookbook](https://make.wordpress.org/cli/handbook/) · [Commands cookbook](https://make.wordpress.org/cli/handbook/commands-cookbook/)
- [Hello Dolly plugin](https://wordpress.org/plugins/hello-dolly/) for a minimal plugin structure
- [WordPress Coding Standards](https://github.com/WordPress/WordPress-Coding-Standards)

Developed in GitHub Codespaces with assistance from GitHub Copilot.

## License

This project is dual-licensed:

- GPL-3.0-or-later OR
- MIT

You may choose either license. See the [LICENSE](LICENSE) file and the full texts in the LICENSES/ directory.