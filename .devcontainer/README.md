<!--
SPDX-FileCopyrightText: 2025 Eric van der Vlist <vdv@dyomedea.com>

SPDX-License-Identifier: GPL-3.0-or-later OR MIT
-->

# .devcontainer — technical notes

🛠️ This document explains the components, workflow and operational details of the devcontainer and installer/updater shipped in this template. It is aimed at maintainers who will copy `.devcontainer` (and the required `.vscode/` configuration) into their plugin repository and use the installer to keep them up to date.

## Contents
- `devcontainer.json` — container configuration for Codespaces and Remote‑Containers.
- `bin/install.sh` — installer/updater script that syncs the upstream template into a repo and helps with first‑run choices.
- `.vscode/` — required editor configuration and stubs (treated like template-level configuration).

> Note: this template intentionally does not automatically create `./.cs_env`. If you want Codespace-specific values, copy `.devcontainer/.cs_env` to the workspace root and edit it manually (see "Environment files" below).

## 🔁 Installer vs Updater
- `bin/install.sh` is both the installer (first run) and the updater (subsequent runs).
- First installation:
  1. Download `install.sh` to your workstation (do not commit it).
  2. From an up‑to‑date clone of your plugin repo: `bash /path/to/install.sh`.
  3. Inspect changes, commit and push.
- Upgrades:
  - Inside the Codespace use one of these two aliases for convenience:
    - `cs_install`
    - `cs_update`
  - Both aliases are synonyms and point to the same script to make interactive upgrades easy.

## 🔍 Preflight & .gitignore checks
- Before copying files the installer builds a list of repo‑relative upstream destinations (directories and files) and runs:
  ```
  git check-ignore -v --stdin
  ```
  to detect which paths would be ignored by your repo `.gitignore`.
- Behavior:
  - Non‑dry‑run: abort if any required paths would be ignored (prevents accidentally omitting template files).
  - Dry‑run: print problems and continue (no files written).

## 🔄 Update semantics for `.vscode`
`.devcontainer/` is considered part of the `wp-plugin-codespace` template and is overwritten during each upgrade (local edits will be lost). `.vscode/` is template-level configuration that repositories typically customize; to avoid silently overriding local changes the updater tracks edits and prompts you when it finds conflicts.

(The workflow is similar to how Debian/Ubuntu package upgrades handle local configuration files.)

- New upstream file → add it and create a `.orig` baseline.
- Identical to upstream → keep local and update baseline if needed.
- Upstream changed, local unmodified (matches baseline) → replace and update baseline.
- Local differs from baseline → interactive choices:
  - keep local, replace, backup+replace, save upstream sample (`.dist`), attempt a 3‑way merge, or skip.

## 🔐 Environment files (manual)
- Rationale: many projects already use `.env` before a Codespace is installed; to avoid interfering we keep Codespace-specific variables separate.
- Template defaults live in `.devcontainer/.cs_env`. If you want to supply workspace-specific values, copy that file to the workspace root and edit `./.cs_env` as needed:
  ```bash
  cp .devcontainer/.cs_env ./.cs_env
  ```
- The installer/updater does not create or modify `./.cs_env`; materialization is explicitly manual and opt‑in.
- If `./.cs_env` is absent the Codespace will proceed using template defaults where applicable.
- `.env` files are intentionally left alone.

## 🧾 Updater artifact conventions
- `.orig` — baseline copy next to local files (used as a merge ancestor).
- `.dist` — upstream sample saved when keeping local changes while preserving the upstream content.
- `.bak.*` — timestamped backups created before destructive changes.

## 🧰 Tools available inside the Codespace
- The Codespace image ships with useful CLI tools to simplify workflows:
  - `gh` — GitHub CLI (releases, PRs, issues).
  - `reuse` — SPDX/REUSE helper for licensing checks.
- These tools let maintainers run release and licensing commands without extra setup.

## ⚙️ Dry‑run behavior
- `--dry-run` prints intended actions and preflight findings but never writes files. Use this in CI or to preview changes.

## 🧪 Troubleshooting
- Blank Markdown preview in Firefox: prefer a Chromium‑based browser or polyfill `AbortSignal.any` (Firefox compatibility issue with VS Code webviews).
- Codespace site returns 401: ensure required env keys are present (provided via `./.cs_env` or Codespaces secrets) and that `.env` was not accidentally overwritten.

## 📌 Common commands
- Preview installer actions:
  ```bash
  bash ~/Downloads/install.sh --ref stable --dry-run
  ```
- Run installer/updater:
  ```bash
  bash ~/Downloads/install.sh --ref stable
  ```
- From inside a Codespace:
  ```bash
  cs_install    # run installer
  cs_update     # run updater (same script)
  ```
- Create a `./.cs_env` manually from the template:
  ```bash
  cp .devcontainer/.cs_env ./.cs_env
  ```

## License

This project is dual-licensed:

- GPL-3.0-or-later OR
- MIT

You may choose either license. See the [LICENSE](LICENSE) file and the full texts in the LICENSES/ directory.