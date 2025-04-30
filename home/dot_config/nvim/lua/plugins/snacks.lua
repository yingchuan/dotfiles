-- ~/.config/nvim/lua/plugins/snacks.lua
return {
  {
    "echasnovski/snacks.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      explorer = { enable = true }, -- 打開 Snacks.explorer
      image = { enable = true }, -- 打開 Snacks.image
    },
    config = function(_, opts)
      require("snacks").setup(opts)
    end,
  },
}
