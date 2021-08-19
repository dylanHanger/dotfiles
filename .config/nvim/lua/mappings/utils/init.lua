local utils = require ("utils")

M = {}

-- Expose this so we can register hotkey group names
M.register = require "which-key".register

M.default_options = {
    noremap = true,
    silent = true,
    expr = false,
    nowait = false
}

-- FIXME: This function could use work. Try use which-key to register the hotkey
-- as well as the description of it
M.map = function(modes, key, result, options, description)
    options = utils.merge(
        M.default_options,
        options or {}
    )
    local buffer = options.buffer
    options.buffer = nil

    if type(modes) ~= "table" then
        modes = {modes}
    end

    for i = 1, #modes do
        local mode = modes[i]

        if buffer then
            vim.api.nvim_buf_set_keymap(0, mode, key, result, options)
        else
            vim.api.nvim_set_keymap(mode, key, result, options)
        end

        if description ~= nil then
            local opts = {
                mode = mode,
                buffer = utils._if(buffer, vim.api.nvim_get_current_buf(), nil),
                silent = options.silent,
                noremap = options.noremap,
                nowait = options.nowait,
                expr = options.expr
            }
            M.register({
                [key] = description
            }, opts)
        end
    end
end

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.check_back_space = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

M.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    elseif vim.fn['vsnip#available'](1) == 1 then
        return t "<Plug>(vsnip-expand-or-jump)"
    elseif M.check_back_space() then
        return t "<Tab>"
    else
        return vim.fn['compe#complete']()
    end
    print("Tab complete")
end

M.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
    elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        return t "<Plug>(vsnip-jump-prev)"
    else
        return t "<S-Tab>"
    end
end

return M
