return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "jay-babu/mason-nvim-dap.nvim",
  },
  config = function()
    local dap = require("dap")

    -- CodeLLDB adapter (uses the codelldb binary Mason installed)
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
        args = { "--port", "${port}" },
      },
    }
    dap.configurations.cpp = {
      {
        name = "Launch (LLDB)",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/a.out", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }
    dap.configurations.c = dap.configurations.cpp

    -- cppdbg adapter (Microsoft’s cpptools)
    dap.adapters.cppdbg = {
      id = "cppdbg",
      type = "executable",
      command = vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
    }
    table.insert(dap.configurations.cpp, {
      name = "Launch (GDB via cppdbg)",
      type = "cppdbg",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/a.out", "file")
      end,
      cwd = "${workspaceFolder}",
      stopAtEntry = true,
      MIMode = "gdb",
      setupCommands = {
        { text = "-enable-pretty-printing", description = "enable pretty printing", ignoreFailures = false },
      },
    })

    -- (optional) configure dap-ui
    require("dapui").setup()
  end,
}
