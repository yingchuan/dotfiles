return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "zls" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "zig" },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        zig = { "zigfmt" },
      },
      formatters = {
        zigfmt = {
          command = "zig",
          args = { "fmt", "-" },
          stdin = true,
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {},
    config = function()
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.zig",
        callback = function()
          require("conform").format({ async = false })
        end,
      })
    end,
  },
}
