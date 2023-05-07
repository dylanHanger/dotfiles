return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      -- Override default configurations with `launch.json`
      require("dap.ext.vscode").load_launchjs(".nvim/launch.json", { lldb = { "c", "cpp", "rust" } })
    end,
  },
}
