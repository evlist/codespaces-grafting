<!--
SPDX-FileCopyrightText: 2025, 2026 Eric van der Vlist <vdv@dyomedea.com>

SPDX-License-Identifier: GPL-3.0-or-later OR MIT
-->

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=evlist/codespaces-grafting)
[![Release](https://img.shields.io/github/v/release/evlist/codespaces-grafting?color=blue)](https://github.com/evlist/codespaces-grafting/releases)
[![License: GPL-3.0-or-later](https://img.shields.io/badge/license-GPL--3.0--or--later-blue)](LICENSES/GPL-3.0-or-later.txt)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue)](LICENSES/MIT.txt)
[![Uses cs-grafting](.devcontainer/assets/graft-badge.svg)](https://github.com/evlist/codespaces-grafting)

<img src=".devcontainer/assets/icon.svg" alt="codespaces-grafting logo" title="codespaces-grafting" width="256" style="float:right;max-width:256px;height:auto" />

# codespaces-grafting (aka cs-grafting)

A lightweight, shareable "live Codespace" / devcontainer scaffold. Graft this Codespace into an existing repository to give it an instant, reproducible development environment.

🌱 Quick metaphor (attention)  
This project is to Codespaces what grafting is to gardening: you graft this Codespace template (the scion) into an existing repository (the stock) to add a ready-to-run development environment.

Who this is for
- Primary: WordPress plugin and theme authors (current templates and examples target WP).
- Secondary: Any project that wants a small, repeatable Codespace/devcontainer setup — the approach is intentionally generic.

Why use this
- ✨ Live Codespace: click the badge to create a Codespace from this template and export the scion into your repo (fastest path).
- ⚙️ Minimal & conservative: provides PHP, WP‑CLI and common tooling while preserving your project/editor settings.
- 🔁 Simple updater: graft.sh grafts the scion into your repo and helps you adopt template improvements safely.

Development tools included
- **Web stack**: Apache, MariaDB, PHP (with Xdebug)
- **WordPress**: WP-CLI for command-line WordPress management
- **Code quality**: Composer, PHP_CodeSniffer (phpcs) with WordPress Coding Standards
- **DevOps**: GitHub CLI (gh), REUSE tool for license compliance
- **Common utilities**: curl, jq, less, unzip

Terminology (short)
- scion — the Codespace/devcontainer template (.devcontainer/.vscode)
- stock — your repository getting the scion grafted
- graft — the act of applying the scion (graft.sh)

Quick start
- Easiest (live Codespace): click the Codespaces badge → create a Codespace → export the scion into your repository via the Codespace UI.
- From a workstation:
  ```bash
  curl -L -o ~/Downloads/graft.sh \
    https://raw.githubusercontent.com/evlist/codespaces-grafting/stable/.devcontainer/bin/graft.sh
  chmod +x ~/Downloads/graft.sh
  cd /path/to/your-repo
  bash ~/Downloads/graft.sh
  ```
  Inspect the changes, commit and push the files you want to keep.

Docs and maintainers
- Short maintainer docs ship with the scion at `.devcontainer/docs/` so detailed guidance travels with the template and does not pollute stock repos.
- Current examples target WordPress; the pattern is reusable for other ecosystems.

Project structure (high level)
```
.
├── README.md
├── .devcontainer/                # scion (grafted into stock)
│   ├── README.md                 # scion maintainer notes
│   ├── docs/                     # extended scion docs (maintainers)
│   ├── assets/                   # icons, images used in scion docs
│   ├── devcontainer.json
│   ├── Dockerfile
│   ├── .cs_env                   # base environment variables
│   ├── .cs_env.d/                # additional env files (Debian .d style)
│   ├── bin/
│   │   └── graft.sh              # installer/updater (graft)
│   ├── sbin/
│   │   ├── bootstrap.sh          # container startup script
│   │   ├── bootstrap.sh.d/       # modular bootstrap hooks (Debian .d style)
│   │   └── merge-env.sh          # merges .cs_env and .cs_env.d/*
│   ├── tmp/                      # temporary files (gitignored)
│   ├── var/                      # runtime data (gitignored)
│   └── wp-content/               # WordPress content customizations
├── .vscode/                      # editor templates & stubs (managed)
└── plugins-src/                  # example/sample plugin(s) (WP-focused examples)
```

The scion uses **Debian-style `.d` directories** for modular configuration:
- **`.cs_env.d/`**: Environment variable overrides loaded in alphabetical order
- **`bootstrap.sh.d/`**: Startup hooks (10-aliases.sh, 20-plugins.sh, etc.) sourced sequentially

This makes customization easy: create `.local.sh` hooks (e.g., `25-themes.local.sh` for themes, `40-import.local.sh` for WP-CLI commands) that won't be overwritten during upgrades. See the [FAQ](.devcontainer/docs/FAQ.md#8-customization) for examples.

Want more?
- Maintainers: see [.devcontainer/README.md](.devcontainer/README.md) for upgrade semantics and structure
- [FAQ](.devcontainer/docs/FAQ.md) — frequently asked questions
- [MAINTAINER.md](.devcontainer/docs/MAINTAINER.md) — detailed procedures

📝 Note: This root `README.md` is **not copied** when grafting. Your stock repository keeps its own README. Only `.devcontainer/` and managed `.vscode/` files are grafted.

## Support & Community

- **Questions?** Check the [FAQ](.devcontainer/docs/FAQ.md)
- **Report bugs** or suggest features via [GitHub Issues](https://github.com/evlist/codespaces-grafting/issues)
- **Contribute**: See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines
- **Discussions**: Open a [GitHub Discussion](https://github.com/evlist/codespaces-grafting/discussions) for ideas and feedback

## License

This project is dual-licensed:

- GPL-3.0-or-later OR
- MIT

You may choose either license. See the LICENSE file and LICENSES/ directory for full texts.