-- ~/.config/nvim/lua/plugins/snacks.lua
return {
  {
    "echasnovski/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      explorer = { enable = true },
      image = { enable = true },
      picker = {
        enabled = true,
        ui_select = true,
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)
      vim.ui.select = require("snacks.picker").select
    end,
  },
}
