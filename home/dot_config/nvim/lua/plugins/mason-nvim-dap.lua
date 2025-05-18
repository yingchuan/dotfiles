return {
  "jay-babu/mason-nvim-dap.nvim",
  opts = {
    ensure_installed = {
      "codelldb", -- LLDB adapter
      "cpptools", -- GDB/LLDB (cppdbg) adapter
    },
    automatic_installation = true,
  },
}
