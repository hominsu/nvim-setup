# Repository Guidelines

## Project Structure & Module Organization

This repository contains a Lua-based Neovim configuration, with optional Neovide integration.

- `init.lua` loads options and default keymaps, bootstraps lazy.nvim, and imports plugin specifications.
- `lua/config/options.lua` defines editor options and Neovide-specific behavior.
- `lua/config/keymaps.lua` centralizes default mappings by mode and plugin mappings by plugin name.
- `lua/plugins/` contains lazy.nvim specifications, currently `oil.lua` and `neov-ime.lua`.
- `lazy-lock.json` records plugin revisions; `stylua.toml` defines formatting.

There are no dedicated test or asset directories. Add plugin specifications under `lua/plugins/` rather than expanding `init.lua`.

## Development & Validation Commands

Run these commands from the repository root, with Neovim and StyLua installed:

- `nvim`: launch the configuration when installed at Neovim's standard configuration path.
- `nvim --headless '+qa'`: smoke-test startup after dependencies are installed; inspect output for errors.
- `stylua --check .`: check Lua formatting without modifying files.
- `stylua .`: format Lua files using `stylua.toml`.

There is no build step. Initial startup may clone lazy.nvim and install plugins, requiring Git and network access. Use `:Lazy` to inspect plugin status; review lockfile changes when intentionally updating dependencies.

## Coding Style & Naming Conventions

Use two-space indentation, Unix line endings, and double quotes where practical. StyLua sets a 180-column width, sorts requires, and omits optional call parentheses. Follow existing Lua module patterns: configuration modules apply settings, while plugin files return specification tables. Give mappings descriptive `desc` values and keep plugin shortcuts in `M.plugins` within `keymaps.lua`. Guard GUI-specific settings with `if vim.g.neovide then`.

## Testing Guidelines

No automated test framework or coverage threshold is configured. Run formatting checks and a startup smoke test for Lua changes. Manually exercise affected mappings, splits, tabs, and Oil navigation. Verify Neovide changes in Neovide itself, including IME transitions and clipboard shortcuts; headless startup cannot validate GUI behavior.

## Commit & Pull Request Guidelines

This checkout has no Git metadata, so existing commit conventions cannot be verified. Use concise imperative subjects, such as `Fix terminal window navigation`. Keep changes focused. Describe the behavior changed, validation performed, and any plugin revision updates. Link relevant issues and include screenshots only when visible behavior changes.
