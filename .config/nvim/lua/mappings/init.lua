M = {}
M.register = require "which-key".register

local merge = function(t1, t2)
    for k, v in pairs(t2) do
        t1[k] = v
    end
    return t1
end

M.default_options = {
    noremap = true,
    silent = false,
    expr = false,
    nowait = false
}

M.map = function(modes, key, result, options, description)
    options = merge(
        M.default_options,
        options or {}
    )
    local buffer = options.buffer
    options.buffer = nil

    if type(modes) ~= "table" then
        modes = {modes}
    end

    for i = 1, #modes do
        if buffer then
            vim.api.nvim_buf_set_keymap(0, modes[i], key, result, options)
        else
            vim.api.nvim_set_keymap(modes[i], key, result, options)
        end
    end

    if description ~= nil then
        M.register({
            [key] = {result, description}
        })
    end
end

M.setup = function()
    M.map("", "<Space>", "<Nop>", {silent = true})
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '

    require "mappings.buffers"
    require "mappings.completion"
    require "mappings.motions"
end

return M
