-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_picker = "snacks"
vim.g.clipboard = "osc52"
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })
-- LSP Server to use for Python.
-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "ruff"
-- Set to "ruff_lsp" to use the old LSP implementation version.
vim.g.lazyvim_python_ruff = "ruff"
vim.g.snacks_animate = false
vim.g.python3_host_prog = os.getenv("HOME") .. "/.config/nvim/nvim-venv/bin/python3"
