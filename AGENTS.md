# Repository Guidelines

## Structure That Matters
- This is a modular Neovim config, not the upstream single-file kickstart layout.
- Startup order is `init.lua` -> `lua/config/options.lua` -> `lua/config/keymaps.lua` -> `lua/config/autocmds.lua` -> `lua/config/lsp.lua` -> `lua/plugins/init.lua`.
- Plugin specs live in `lua/plugins/*.lua`. `lua/plugins/init.lua` imports each module explicitly, so a new plugin file does nothing until it is added to that `spec` list.
- Repo-local LSP server configs live in `lsp/*.lua`; they are activated explicitly from `lua/config/lsp.lua` via Neovim 0.11 `vim.lsp.enable(...)`.

## Verification
- There is no automated test suite in this repo.
- The only CI check in `.github/workflows/stylua.yml` is `stylua --check .`.
- Formatting rules come from `.stylua.toml`: 2 spaces, 120 columns, `sort_requires.enabled = true`.
- For code changes, run `stylua --check .` or `stylua .`, then open `nvim` and verify startup plus the affected workflow.

## Tooling Gotchas
- `conform.nvim` is the formatter entrypoint. Current mappings/config format `lua` with `stylua`, `python` with `ruff_fix` + `ruff_format` + `ruff_organize_imports`, and `markdown` with `prettier`.
- `mason.nvim` auto-installs only `stylua`, `lua-language-server`, `pyright`, `ruff`, and `marksman`. `clangd` is enabled in `lua/config/lsp.lua` but is not in Mason's `ensure_installed` list.
- If you add a new LSP server, wire all three places when needed: `lsp/<server>.lua`, `vim.lsp.enable('<server>')` in `lua/config/lsp.lua`, and `ensure_installed` in `lua/plugins/lspconfig.lua` if Mason should manage it.

## Repo-Specific Behavior
- Python is intentionally split: Pyright handles analysis, Ruff handles formatting/import organization, and `lsp/ruff.lua` disables Ruff hover so Pyright owns hover.
- Python buffers prepend the project root to `PYTHONPATH` in both `lsp/pyright.lua` and `lua/plugins/code.lua`; avoid adding a conflicting third mechanism unless required.
- Saving a new file auto-creates parent directories via `lua/config/autocmds.lua`; do not add extra save helpers for that.
- `lua/plugins/code.lua` contains custom task/debug tooling (`overseer.nvim`, `sniprun`, `molten-nvim`, `venv-selector.nvim`), so changes there often need an in-editor smoke test instead of static inspection only.
