require("lsp.handlers")

local lspinstall = require("lspinstall")

local function lspSymbol(name, icon)
    vim.fn.sign_define("LspDiagnosticsSign" .. name, { text = icon, numhl = "LspDiagnosticsDefault" .. name })
end

lspSymbol("Error", "")
lspSymbol("Warning", "")
lspSymbol("Information", "")
lspSymbol("Hint", "")

local map = require("utils").map
local function on_attach(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    if client.resolved_capabilities.document_formatting then
        -- Setup formatting mappings/autocmds
        vim.cmd [[
        augroup Format
        autocmd!
        autocmd BufWritePre  * undojoin | Neoformat
        augroup END
        ]]

        map("n", "<leader>f", ":lua vim.lsp.buf.formatting()<CR>", { buffer = true })
    end

    if client.resolved_capabilities.document_range_formatting then
        map("n", "<leader>f", ":lua vim.lsp.buf.range_formatting()<CR>", { buffer = true })
    end

    map("n", "gd", ":lua vim.lsp.buf.definition()", { buffer = true })
    map("n", "gD", ":lua vim.lsp.buf.declaration()", { buffer = true })
    map("n", "gi", ":lua vim.lsp.buf.implementation()", { buffer = true })

    map("n", "<leader>ca", ":Lspsaga code_action<CR>", { buffer = true })
    map("i", "<C-Space>", "<C-o>:Lspsaga code_action<CR>", { buffer = true })
    map("v", "<leader>ca", ":Lspsaga range_code_action<CR>", { buffer = true })

    map("n", "<leader>r", ":Lspsaga rename<CR>", { buffer = true })

    map("n", "Gd", ":Lspsaga preview_definition<CR>", { buffer = true })
    map("n", "Gh", ":Lspsaga lsp_finder<CR>", { buffer = true })
    map("n", "K", ":Lspsaga hover_doc<CR>", { buffer = true })

    map("n", "<leader>e", ":Lspsaga show_line_diagnostics<CR>", { buffer = true })
    map("n", "[e", ":Lspsaga diagnostic_jump_prev<CR>", { buffer = true })
    map("n", "]e", ":Lspsaga diagnostic_jump_next<CR>", { buffer = true })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local config = {
    lua = {
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                    path = vim.split(package.path, ';')
                },
                diagnostics = {
                    globals = {
                        -- Neovim
                        "vim",
                        -- Packer
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

local function setupServers()
    lspinstall.setup()

    local servers = lspinstall.installed_servers()

    for _, server in pairs(servers) do
        local cfg = config[server] or {}
        cfg.on_attach = cfg.on_attach or on_attach
        cfg.capabilities = cfg.capabilities or capabilities

        require("lspconfig")[server].setup(cfg)
    end
end

setupServers()
lspinstall.post_install_hook = function()
    setupServers()
    vim.cmd [[bufdo e]]
end
