# Repository Guidelines

## Project Structure & Module Organization
- `init.lua` is the primary entry point for the Neovim configuration.
- `lua/config/` holds core settings: options, keymaps, and autocmds.
- `lua/plugins/` and `lua/kickstart/plugins/` define plugin specs and related setup.
- `doc/kickstart.txt` contains help documentation.
- `lazy-lock.json` pins plugin versions for reproducible setups.

## Build, Test, and Development Commands
- `nvim` launches Neovim and installs plugins via Lazy on first run.
- `:Lazy sync` in Neovim updates, installs, and cleans plugins.
- `:Lazy update` updates plugins without cleaning.
- `:Mason` opens the LSP/DAP/tool installer UI.
- `:checkhealth` validates dependencies and configuration health.

## Coding Style & Naming Conventions
- Lua files use 2-space indentation and `snake_case` for local vars.
- Use descriptive module names that match paths (e.g., `lua/config/options.lua`).
- Prefer small, focused plugin modules in `lua/plugins/` rather than large monoliths.
- Keep new settings close to similar ones (options with options, keymaps with keymaps).

## Testing Guidelines
- No automated test framework is configured in this repo.
- Validate changes by launching `nvim`, opening a file, and verifying plugin behavior.
- For plugin changes, run `:Lazy sync` and re-open Neovim to confirm startup stability.

## Commit & Pull Request Guidelines
- Recent commits use short, imperative summaries; optional prefixes appear (e.g., `fix: ...`, `README: ...`).
- Keep commit messages under 72 characters when possible.
- PRs should describe the change, list affected areas, and link any related issues.
- Include screenshots or short clips for UI or UX changes.

## Configuration Tips
- This repo is intended for `NVIM_APPNAME=nvim-kickstart nvim` usage to isolate data.
- Update pinned plugins with `:Lazy update` and commit `lazy-lock.json` if it changes.
