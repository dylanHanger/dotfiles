-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

--- DAP ---
local dap = require("dap")
map("n", "<leader>dr", dap.continue, { desc = "Run" })

--- BUFFERLINE ---
-- <leader>bj to enter buffer picking mode
local bufferline = require("bufferline")
map("n", "<leader>bj", function()
  bufferline.pick()
end, { desc = "Pick buffer to jump to" })

-- <leader>bJ to enter buffer picking delete mode
map("n", "<leader>bJ", function()
  bufferline.close_with_pick()
end, { desc = "Pick buffer to close" })

--- NOTIFY ---
map("n", "<leader>n", function()
  local telescope = require("telescope")
  telescope.extensions.notify.notify()
end, { desc = "Notification history" })

--- LAZYGIT ---
map("n", "<leader>gG", function()
  util.float_term({ "lazygit" }, { cwd = util.get_root(), esc_esc = false })
end, { desc = "Lazygit (root dir)" })

map("n", "<leader>gg", function()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  if path then
    util.float_term({ "lazygit" }, { cwd = vim.fn.fnamemodify(path, ":p:h"), esc_esc = false })
  else
    util.float_term({ "lazygit" }, { esc_esc = false })
  end
end, { desc = "Lazygit (cwd)" })
