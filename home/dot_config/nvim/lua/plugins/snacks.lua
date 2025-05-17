-- ~/.config/nvim/lua/plugins/snacks.lua
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true, override_ui_select = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    lazygit = { enabled = true },
    dashboard = { enabled = true },
  },
  config = function(plugin, opts)
    local snacks = require("snacks")
    snacks.setup(opts)

    vim.ui.input = require("snacks.input")
  end,
}
