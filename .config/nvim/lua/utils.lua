local M = {}

M.map = function(modes, key, action, options)
  local defaultOptions = {
    noremap = true,
    silent = true,
    expr = false,
    nowait = false
  }

  options = vim.tbl_extend("force", defaultOptions, options or {})

  local buffer = options.buffer
  options.buffer = nil

  if type(modes) ~= "table" then
    modes = {modes}
  end

  for i = 1, #modes do
    local mode = modes[i]

    if buffer then
      vim.api.nvim_buf_set_keymap(0, mode, key, action, options)
    else
      vim.api.nvim_set_keymap(mode, key, action, options)
    end
  end
end

function M.highlight(group, fg, bg, gui)
  local cmd = string.format("highlight %s guifg=%s guibg=%s", group, fg, bg)
  if gui ~= nil then
    cmd = cmd .. " gui=" .. gui
  end
  vim.cmd(cmd)
end

function M.log(msg, hl, name)
  name = name or "Neovim"
  hl = hl or "Todo"
  vim.api.nvim_echo({ { name .. ": ", hl }, { msg } }, true, {})
end

function M.warn(msg, name)
  M.log(msg, "LspDiagnosticsDefaultWarning", name)
end

function M.error(msg, name)
  M.log(msg, "LspDiagnosticsDefaultError", name)
end

function M.info(msg, name)
  M.log(msg, "LspDiagnosticsDefaultInformation", name)
end

return M


