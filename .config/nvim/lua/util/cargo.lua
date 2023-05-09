local M = {}

local function handler(_, result)
  local test_result = {
    {
      args = {
        cargoArgs = { "run", "--package", "snakes", "--bin", "snakes", "--all-features" },
        cargoExtraArgs = {},
        executableArgs = {},
        workspaceRoot = "/home/dylan/snakes",
      },
      kind = "cargo",
      label = "run snakes",
      location = {
        targetRange = {
          ["end"] = {
            character = 1,
            line = 26,
          },
          start = {
            character = 0,
            line = 12,
          },
        },
        targetSelectionRange = {
          ["end"] = {
            character = 7,
            line = 12,
          },
          start = {
            character = 3,
            line = 12,
          },
        },
        targetUri = "file:///home/dylan/snakes/src/main.rs",
      },
    },
    {
      args = {
        cargoArgs = { "check", "--package", "snakes", "--all-targets" },
        cargoExtraArgs = {},
        executableArgs = {},
        workspaceRoot = "/home/dylan/snakes",
      },
      kind = "cargo",
      label = "cargo check -p snakes --all-targets",
    },
    {
      args = {
        cargoArgs = { "test", "--package", "snakes", "--all-targets" },
        cargoExtraArgs = {},
        executableArgs = {},
        workspaceRoot = "/home/dylan/snakes",
      },
      kind = "cargo",
      label = "cargo test -p snakes --all-targets",
    },
  }

  -- Take the `run` command and make it a `build` command.
end

function M.cargo_build()
  local rt = require("rust-tools")

  rt.utils.request(0, "experimental/runnables", {
    textDocument = vim.lsp.util.make_text_document_params(),
    position = nil,
  }, handler)
end

return M
