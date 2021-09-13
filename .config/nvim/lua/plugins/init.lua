-- Ensure Packer is downloaded
local install_path = vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
end

local packer = require("packer")

-- Setup Packer
vim.api.nvim_command [[packadd packer.nvim]]
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "single" }
        end,
        prompt_border = "single"
    },
    git = {
        clone_timeout = 600
    },
    auto_clean = true,
    compile_on_sync = true,
    auto_reload_compiled = true
}

-- Setup our own plugins
packer.startup(function(use)
    use "wbthomason/packer.nvim"

    ----------------------------------------
    --             INTERFACE              --
    ----------------------------------------

    -- Color Scheme
    use {
        "RRethy/nvim-base16",
    }

    -- Statusline
    use {
        "shadmansaleh/lualine.nvim",
        config = function()
            require("plugins.configs.statusline")
        end
    }
    -- Bufferline
    use {
        "akinsho/nvim-bufferline.lua",
        requires = {
            {"kyazdani42/nvim-web-devicons", opt=true},
            {"famiu/bufdelete.nvim"}
        },
        config = function()
            require("plugins.configs.bufferline")
        end,
    }

    -- File explorer
    use {
        "kyazdani42/nvim-tree.lua",
        requires = {
            {"kyazdani42/nvim-web-devicons", opt=true}
        },
        config = function()
            require("plugins.configs.nvimtree")
        end,
    }

    -- Dashboard
    use {
        "glepnir/dashboard-nvim",
        config = function()
            require("plugins.configs.dashboard")
        end,
    }

    -- Indentation guids
    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("plugins.configs.indentblankline")
        end,
    }

    -- Git integration
    use {
        "lewis6991/gitsigns.nvim",
        requires = {
            "nvim-lua/plenary.nvim"
        },
        config = function()
            require("plugins.configs.gitsigns")
        end,
    }

    -- Color previewing
    use {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("plugins.configs.colorizer")
        end,
    }

    -- Icons
    use {
        "kyazdani42/nvim-web-devicons",
    }


    ----------------------------------------
    --                CODE                --
    ----------------------------------------

    -- Language Servers
    use "neovim/nvim-lspconfig"
    use "kabouzeid/nvim-lspinstall"

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require("plugins.configs.treesitter")
        end,
    }

    use {
        "nvim-treesitter/nvim-treesitter-refactor",
        config = function()
            require("plugins.configs.treesitter.refactor")
        end
    }

    -- LSP UI
    use {
        "glepnir/lspsaga.nvim",
        config = function()
            require("plugins.configs.lspsaga")
        end
    }

    -- LSP Signature hints
    use {
        "ray-x/lsp_signature.nvim",
        config = function()
            require("plugins.configs.signature")
        end,
    }

    -- LSP Icons
    use {
        "onsails/lspkind-nvim",
        config = function()
            require("lspkind").init()
        end,
    }

    -- Completion
    use {
        "hrsh7th/nvim-compe",
        config = function()
            require("plugins.configs.compe")
        end,
        wants = "LuaSnip",
        requires = {
            {
                "L3MON4D3/LuaSnip",
                wants = "friendly-snippets",
                config = function()
                    require("plugins.configs.luasnip")
                end,
            },
            {
                "rafamadriz/friendly-snippets"
            }
        }
    }

    -- Automatically completing pairs
    use {
        "windwp/nvim-autopairs",
        config = function()
            require("plugins.configs.autopairs")
        end,
    }

    -- Formatting
    use {
        "sbdchd/neoformat",
    }

    -- LISP style parenthises
    use {
        "eraserhd/parinfer-rust",
        run = "cargo build --release"
    }

    ----------------------------------------
    --             DEBUGGING              --
    ----------------------------------------
    
    use {
        "nvim-treesitter/playground",
        config = function()
            require("plugins.configs.treesitter.playground")
        end
    }

    ----------------------------------------
    --              ACTIONS               --
    ----------------------------------------

    -- Commenting
    use {
        "b3nj5m1n/kommentary",
        config = function()
            require("plugins.configs.kommentary")
        end,
    }

    -- Surrounding
    use {
        "blackCauldron7/surround.nvim",
        config = function()
            require("plugins.configs.surround")
        end,
    }

    -- Finding
    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            {"nvim-lua/plenary.nvim"},
            {"nvim-lua/popup.nvim"},
            {"nvim-telescope/telescope-fzf-native.nvim", run = "make"},
            -- {"nvim-telescope/telescope-dap.nvim"},
        },
        config = function()
            require("plugins.configs.telescope")
        end,
    }


    ----------------------------------------
    --       TEXT OBJECTS / MOTION        --
    ----------------------------------------

    -- Treesitter objects
    use {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
            require("plugins.configs.treesitter.textobjects")
        end,
    }

    use {
        "michaeljsmith/vim-indent-object"
    }

    use {
        "chaoren/vim-wordmotion"
    }

    use {
        "wellle/targets.vim"
    }

    ----------------------------------------
    --              UTILITY               --
    ----------------------------------------

    use {
        "beauwilliams/focus.nvim",
        config = function()
            local focus = require("focus")

            focus.signcolumn = false
        end
    }

    -- Range highlighting when typing a command
    use {
        "winston0410/range-highlight.nvim",
        requires = {
            "winston0410/cmd-parser.nvim"
        },
        config = function()
            require("range-highlight").setup()
        end,
    }

    -- Autosave
    use {
        "Pocco81/AutoSave.nvim",
        cond = function() return vim.g.auto_save == true end
    }

    -- Automatically create folders when saving
    use {
        "jghauser/mkdir.nvim",
        config = function() require("mkdir") end
    }

    -- Smarter incrementation
    use {
        "monaqa/dial.nvim",
    }

    -- Write as sudo
    use {
        "lambdalisue/suda.vim"
    }

    -- Automatically detect tab style
    use {
        "tpope/vim-sleuth"
    }

    -- Better . (repeat)
    use {
        "tpope/vim-repeat"
    }

    -- Fix broken CursorHold autocmds
    use {
        "antoinemadec/FixCursorHold.nvim"
    }


    ----------------------------------------
    --             LANGUAGES              --
    ----------------------------------------
    
    use "elkowar/yuck.vim"

end)
