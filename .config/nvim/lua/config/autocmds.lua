-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function autocmd(events, cmd)
  if type(events) ~= "table" then
    events = { events }
  end
  vim.api.nvim_create_autocmd(events, cmd)
end

-- Set wrap for LaTeX files
autocmd("FileType", {
  pattern = { "tex" },
  command = [[
    setlocal wrap
    setlocal linebreak
    setlocal breakindent
  ]],
})
