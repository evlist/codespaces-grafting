<!--
SPDX-FileCopyrightText: 2025 Eric van der Vlist <vdv@dyomedea.com>

SPDX-License-Identifier: GPL-3.0-or-later OR MIT
-->

# .devcontainer — technical notes

🛠️ This document explains the components, workflow and operational details of the devcontainer and installer/updater shipped in this template. It is aimed at maintainers who will copy `.devcontainer` and `.vscode` into their plugin repository and use the installer to keep them up to date.

## Contents
- `devcontainer.json` — container configuration for Codespaces and Remote‑Containers.
- `bin/install.sh` — installer/updater script that syncs the upstream template into a repo and helps with first‑run choices.
- `.vscode/` — optional editor configuration samples and baselines.

> Note: this template intentionally does not include an automated helper to materialize `.cs_env`. Creating `.cs_env` from `.cs_env.example` is an opt‑in, manual step (see "Environment files" below).

## 🔁 Installer vs Updater
- `bin/install.sh` is both the installer (first run) and the updater (subsequent runs).
- First installation:
  1. Download `install.sh` to your workstation (do not commit it).
  2. From an up‑to‑date clone of your plugin repo: `bash /path/to/install.sh`.
  3. Inspect changes, commit and push.
- Upgrades:
  Inside the Codespace use one of these two aliases for convenience:
  - `cs_install`.
  - `cs_update`.
- Both aliases are synonyms and point to the same script to make interactive upgrades easy.

## 🔍 Preflight & .gitignore checks
- Before copying files the installer builds a list of repo‑relative upstream destinations (directories and files) and runs:
  ```
  git check-ignore -v --stdin
  ```
  to detect which paths would be ignored by your repo `.gitignore`.
- Behavior:
  - Non‑dry‑run: abort if any required paths would be ignored (prevents accidentally omitting essential files).
  - Dry‑run: print problems and continue (no files written).
- This prevents common breakage such as missing `.env`/config files at Codespace creation.

## 🔄 Update semantics for `.vscode`
While `.devcontainer/` is considered as "belonging" to the `wp-plugin-codespace` and is overriden during
each upgrade (meaning that any local update will be lost), `.vscode/` may already exist in your repository
and you may want to tailor it to your needs.

To avoid silent overrides, we track local changes and let you decide what to do when we detect conflicts.

**Note: if you are familiar with Debian (or Ubuntu) this will look familiar to you**

- New upstream file → add and create `.orig` baseline.
- Identical to upstream → keep local and update baseline if needed.
- Upstream changed, local unmodified (matches baseline) → replace and update baseline.
- Local differs from baseline → interactive choices:
  - keep local, replace, backup+replace, save upstream sample (`.dist`), attempt 3‑way merge, or skip.

## 🔐 Environment files (manual)
- Rationale: many repositories use `.env` before any Codespace is installed; to avoid interfering with those workflows we keep Codespace-specific variables distinct.
- Default env values are defined in `.devcontainer/.cs_env` (overriden during each upgrade, see previous section)
- These values are overriden by `./.cs_env` ifthe file exists
- The installer/updater does not automatically create or modify `./.cs_env`; materializing is left to devs inside the codespace.
- The codespace will ignore `./.cs_env` if it doesn't exist.
- `.env` files are ignored.

## 🧾 Updater artifact conventions
- `.orig` — baseline copy next to local files (used as merge ancestor).
- `.dist` — upstream sample saved when keeping local changes but preserving upstream content.
- `.bak.*` — timestamped backups created before destructive changes.

## 🧰 Tools available inside the Codespace
- The Codespace image ships with useful CLI tools to simplify workflows:
  - `gh` — GitHub CLI (releases, PRs, issues).
  - `reuse` — SPDX/REUSE helper for licensing checks.
- These are installed so maintainers can run release and licensing commands within the Codespace.

## ⚙️ Dry‑run behavior
- `--dry-run` prints intended actions and preflight findings but never writes files. Use this in CI or to preview changes.

## 🧪 Troubleshooting
- Blank Markdown preview in Firefox: prefer a Chromium‑based browser or polyfill `AbortSignal.any` (Firefox compatibility issue with VS Code webviews).
- Codespace site returns 401: ensure required env keys are present (provided via `.cs_env` or Codespaces secrets) and that `.env` was not accidentally overwritten.

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
- Create a `.cs_env` manually from the example:
  ```bash
  cp .cs_env.example .cs_env
  ```

## License

This project is dual-licensed:

- GPL-3.0-or-later OR
- MIT

You may choose either license. See the [LICENSE](LICENSE) file and the full texts in the LICENSES/ directory.
