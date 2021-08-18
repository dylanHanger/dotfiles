require "lsp.handlers"
require "lsp.formatting"

local utils = require "utils"

local M = {}

vim.lsp.protocol.CompletionItemKind = {
    " [text]",
    " [method]",
    " [function]",
    " [constructor]",
    "ﰠ [field]",
    " [variable]",
    " [class]",
    " [interface]",
    " [module]",
    " [property]",
    " [unit]",
    " [value]",
    " [enum]",
    " [key]",
    "﬌ [snippet]",
    " [color]",
    " [file]",
    " [reference]",
    " [folder]",
    " [enum member]",
    " [constant]",
    " [struct]",
    "⌘ [event]",
    " [operator]",
    " [type]"
}

M.symbol_kind_icons = {
    Function = "",
    Method = "",
    Variable = "",
    Constant = "",
    Interface = "",
    Field = "ﰠ",
    Property = "",
    Struct = "",
    Enum = "",
    Class = ""
}

M.symbol_kind_colors = {
    Function = "green",
    Method = "green",
    Variable = "blue",
    Constant = "red",
    Interface = "cyan",
    Field = "blue",
    Property = "blue",
    Struct = "cyan",
    Enum = "yellow",
    Class = "red"
}

vim.fn.sign_define("LspDiagnosticsSignError", {text = "", numhl = "LspDiagnosticsDefaultError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", numhl = "LspDiagnosticsDefaultWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "", numhl = "LspDiagnosticsDefaultInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", numhl = "LspDiagnosticsDefaultHint"})

local on_attach = function (client)
    -- TODO: Use lspsaga
    if client.resolved_capabilities.document_formatting then
        vim.cmd[[
        augroup Format
        autocmd! * <buffer>
        autocmd BufWritePost <buffer> lua require 'lsp.formatting'.format()
        augroup END
        ]]

        vim.cmd [[command! Format lua require 'lsp.formatting'.format()]]
    end
    if client.resolved_capabilities.goto_definition then
        utils.map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", {buffer = true})
    end
    -- if client.resolved_capabilities.completion then
    --     -- require 'completion'.on_attach()
    -- end
end

----------  Python  ---------------
local black  = require "efm/black"
local isort  = require "efm/isort"
local flake8 = require "efm/flake8"
local mypy   = require "efm/mypy"

-----------  Lua  -----------------
local luafmt = require "efm/luafmt"
-----------------------------------

local config = {
    efm = {
        init_options = {documentFormatting = true},
        root_dir = vim.loop.cwd,
        settings = {
            rootMarkers = {".git"},
            languages = {
                python = {black, isort, flake8, mypy},
                lua = {luafmt}
            }
        }
    },
    lua = {
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                    path = vim.split(package.path, ';')
                },
                diagnostics = {
                    globals = {
                        -- neovim
                        "vim",
                        -- packer
                        "use"
                    }
                },
                workspace = {
                    library = {
                        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
                    }
                }
            }
        }
    }
}

M.setup = function()
    local lspinstall = require "lspinstall"
    lspinstall.setup()

    local servers = lspinstall.installed_servers()

    for _, server in pairs(servers) do
        local cfg = config[server] or {}
        cfg.on_attach = cfg.on_attach or on_attach

        vim.schedule(function()
            local lsp = require "lspconfig"
            lsp[server].setup(cfg)
            -- require "packer".loader("coq_nvim coq.artifacts")
            -- lsp[server].setup(require "coq"().lsp_ensure_capabilities(cfg))
            end)
    end
end

require 'lspinstall'.post_install_hook = function()
    M.setup()
    vim.cmd [[bufdo e]]
end

return M
