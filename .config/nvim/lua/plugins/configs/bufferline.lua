local bufferline = require("bufferline")

local colors = require("theme").colors
require("utils").highlight("BufferLineExplorer", colors.base07, colors.base00, "bold")

_G.addbuffer = function()
   local tabbuffers = vim.g.tabbuffers

   local tabnr = ""..vim.fn.tabpagenr()
   local bufnr = ""..vim.fn.bufnr()

   if tabbuffers[tabnr] == nil then
      tabbuffers[tabnr] = {}
   end

   tabbuffers[tabnr][bufnr] = true
   vim.g.tabbuffers = tabbuffers
end

_G.removebuffer = function()
   local tabbuffers = vim.g.tabbuffers

   local tabnr = ""..vim.fn.tabpagenr()
   local bufnr = ""..vim.fn.expand("<abuf>")

   if tabbuffers[tabnr] == nil then
      return
   end

   tabbuffers[tabnr][bufnr] = nil
   if #tabbuffers[tabnr] == 0 then
      tabbuffers[tabnr] = nil
   end
   
   vim.g.tabbuffers = tabbuffers
end

_G.removetab = function()
   local tabnr = ""..vim.fn.expand("<afile>")
   vim.cmd("unlet g:tabbuffers["..tabnr.."]")
end

vim.cmd [[
   let g:tabbuffers = {}

   augroup TabBuffers
   autocmd!

   autocmd BufEnter * lua addbuffer()
   autocmd BufDelete * lua removebuffer()

   autocmd TabClosed * lua removetab()

   augroup END
]]

bufferline.setup {
   options = {
      offsets = { { filetype = "NvimTree", text = "Explorer", highlight = "BufferLineExplorer" } },
      buffer_close_icon = "",
      modified_icon = "",
      close_icon = "",
      left_trunc_marker = "",
      right_trunc_marker = "",
      max_name_length = 14,
      max_prefix_length = 13,
      tab_size = 20,
      show_tab_indicators = true,
      enforce_regular_tabs = false,
      view = "multiwindow",
      show_buffer_close_icons = true,
      separator_style = "thin",
      always_show_bufferline = true,
      -- custom_filter = function(bufnr)
      --    local current_tab  = ""..vim.fn.tabpagenr()
      --    local open_buffers = vim.g.tabbuffers[current_tab];

      --    return open_buffers and open_buffers[""..bufnr] or false
      -- end,
      close_command = "Bdelete! %d",
      right_mouse_command = "Bdelete! %d"
   },
}
