local M = {}

local format_disabled_var = function()
    return string.format("format_disabled_%s", vim.bo.filetype)
end
local format_options_var = function()
    return string.format("format_options_%s", vim.bo.filetype)
end

local format_options_prettier = {
    tabWidth = 4,
    singleQuote = true,
    trailingComma = "all",
    configPrecedence = "prefer-file"
}
-- TODO: vim.g.format_options_X = format_options_prettier

M.formatToggle = function(value)
    local var = format_disabled_var()
    if value ~= nil then
        vim.g[var] = value
    else
        vim.g[var] = not vim.g[var]
    end
end
vim.cmd [[command! FormatDisable lua require'lsp.formatting'.formatToggle(true)]]
vim.cmd [[command! FormatEnable lua require'lsp.formatting'.formatToggle(false)]]

M.format = function()
    if not vim.g[format_disabled_var()] then
        vim.lsp.buf.formatting(vim.g[format_options_var()] or {})
    end
end
vim.cmd [[command! Format lua require'lsp.formatting'.format()]]

return M
