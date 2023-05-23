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

-- FIXME: I don't want to have to do this in an autocmd like this, why is it being overwritten?
-- fix format options
autocmd("FileType", { command = [[set formatoptions-=o]] })
