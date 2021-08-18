-- Ensure Packer is downloaded
local install_path = vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
    vim.api.nvim_command [[packadd packer.nvim]]
end

vim.g.loaded_netrwPlugin = false
vim.cmd [[packadd cfilter]]

require("packer").startup(function()
    use "wbthomason/packer.nvim"

    ----------------------------------------
    --             INTERFACE              --
    ----------------------------------------

    -- Color Scheme
    use {
        "eddyekofo94/gruvbox-flat.nvim",
        config = function()
            vim.g.gruvbox_flat_style = "hard"
            vim.cmd [[colorscheme gruvbox-flat]]
        end
    }

    -- Dashboard
    use {
        "glepnir/dashboard-nvim",
        config = function()
            vim.g.dashboard_default_executive = "telescope"
        end
    }

    -- Statusline
    use {
        "hoob3rt/lualine.nvim",
        config = function()
            local colors = require "gruvbox.colors".setup()

            require "lualine".setup {
                options = {
                    theme = "gruvbox-flat"
                },
                sections = {
                    lualine_a = {"mode"},
                    lualine_b = {
                        "branch",
                        {
                            "diff",
                            colored = true,
                            color_added = colors.git.add,
                            color_removed = colors.git.delete,
                            color_modified = colors.git.change
                        }
                    },
                    lualine_c = {
                        "filename"
                    },

                    lualine_x = {
                        {"diagnostics", sources = {"nvim_lsp"}},
                        "encoding",
                        "fileformat",
                        "filetype"
                    },
                    lualine_y = {"progress"},
                    lualine_z = {"location"}
                }
            }
        end
    }

    -- Bufferline
    use {
        "akinsho/nvim-bufferline.lua",
        requires = {
            "kyazdani42/nvim-web-devicons",
            "famiu/bufdelete.nvim"
        },
        config = function()
            require "bufferline".setup {
                options = {
                    diagnostics = "nvim_lsp",
                    offsets = {
                        {
                            filetype = "packer",
                            text = "Packer",
                            highlight = "Normal",
                            text_align = "center"
                        },
                        {
                            filetype = "NvimTree",
                            text = "Explorer",
                            highlight = "Normal",
                            text_align = "center"
                        }
                    },
                    separator_style = "thin",
                    always_show_bufferline = true,
                    close_command = "Bdelete! %d",
                    right_mouse_command = "Bdelete! %d",

                    sort_by = function(buffer_a, buffer_b)
                        -- TODO: My own proper logic
                        local mod_a = vim.loop.fs_stat(buffer_a.path).mtime.sec
                        local mod_b = vim.loop.fs_stat(buffer_b.path).mtime.sec

                        return mod_a > mod_b
                    end
                }
            }
        end
    }

    -- File Explorer
    use {
        "kyazdani42/nvim-tree.lua",
        requires = {"kyazdani42/nvim-web-devicons"},
        config = function()
            vim.g.nvim_tree_auto_close = 1
            vim.g.nvim_tree_auto_ignore_ft = {"dashboard", "packer"}
            vim.g.nvim_tree_auto_open = 1
            vim.g.nvim_tree_gitingore = 1
            vim.g.nvim_tree_hijack_cursor = 0
            vim.g.nvim_tree_lsp_diagnostics = 1
            vim.g.nvim_tree_quit_on_open = 1
            vim.g.nvim_tree_respect_buf_cwd = 1
            vim.g.nvim_tree_update_cwd = 1
        end
    }

    -- Git integration
    use {
        "lewis6991/gitsigns.nvim",
        requires = {"nvim-lua/plenary.nvim"},
        config = function()
            require "gitsigns".setup {
                signs = {
                    add          = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
                    change       = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
                    delete       = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
                    topdelete    = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
                    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
                }
            }
        end
    }

    -- Indentation guides
    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require "indent_blankline".setup {
                filetype_exclude = {
                    "NvimTree",
                    "packer",
                    "help",
                    "dashboard"
                },
                buftype_exlude = {
                    "terminal",
                    "nofile"
                },
                char = "┊",
                show_current_context = true,
                use_treesitter = true
            }
        end
    }

    -- File finder
    use {
        "nvim-telescope/telescope.nvim",
        requires = {"nvim-lua/plenary.nvim"}
    }

    -- Colour previewing
    use {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require "colorizer".setup {
                "*",
                css = {
                    css = true
                },
                html = {
                    css = true
                }
            }
        end
    }

    -- Keymap help
    use {
        "folke/which-key.nvim",
        config = function()
            require "which-key".setup()
        end
    }

    use {
        "akinsho/nvim-toggleterm.lua",
        config = function()
            require "toggleterm".setup{
            }
        end
    }

    -- Automatically resize windows
    use "beauwilliams/focus.nvim"


    ----------------------------------------
    --                CODE                --
    ----------------------------------------

    -- Language Servers
    use "neovim/nvim-lspconfig"     -- Configurations for LSP servers
    use "kabouzeid/nvim-lspinstall" -- Automatic installation of LSP servers

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require "nvim-treesitter.configs".setup {
                ensure_installed = "all",
                highlight = {
                    enable = true
                },
                indent = {
                    enable = true
                }
            }

            vim.o.foldexpr = "nvim_treesitter#foldexpr()"
            vim.o.foldmethod = "expr"
        end
    }
    use {
        "nvim-treesitter/nvim-treesitter-refactor",
        config = function()
            require "nvim-treesitter.configs".setup {
                refactor = {
                    highlight_definitions = {
                        enable = true
                    }
                }
            }
        end
    }

    -- Completion
    use {
        "hrsh7th/nvim-compe",
        config = function()
            require "compe".setup {
                enabled = true;
                autocomplete = true;
                debug = false;
                min_length = 1;
                preselect = 'enable';
                throttle_time = 80;
                source_timeout = 200;
                resolve_timeout = 800;
                incomplete_delay = 400;
                max_abbr_width = 100;
                max_kind_width = 100;
                max_menu_width = 100;
                documentation = {
                    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
                    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
                    max_width = 120,
                    min_width = 60,
                    max_height = math.floor(vim.o.lines * 0.3),
                    min_height = 1,
                };

                source = {
                    path = true;
                    buffer = true;
                    calc = true;
                    nvim_lsp = true;
                    vsnip = true;
                };
            }
        end
    }

    -- Snippets
    use {
        "hrsh7th/vim-vsnip",
        requires = {
            "hrsh7th/vim-vsnip-integ",
            "rafamadriz/friendly-snippets"
        }
    }

    -- Auto-closing paired delimiters
    use {
        "windwp/nvim-autopairs",
        config = function()
            require "nvim-autopairs".setup {
                disable_filetype = {"TelescopePrompt"},
                fastwrap = {}
            }
            require "nvim-autopairs.completion.compe".setup {
                map_cr = true,
                map_complete = true,
                auto_select = true
            }
            require "nvim-treesitter.configs".setup {
                autopairs = {
                    enable = true
                }
            }
        end
    }

    -- Auto-closing and renaming tags
    use {
        "windwp/nvim-ts-autotag",
        config = function()
            require "nvim-treesitter.configs".setup {
                autotag = {
                    enable = true
                }
            }
        end
    }

    ----------------------------------------
    --             DEBUGGING              --
    ----------------------------------------

    -- TODO: DAP


    ----------------------------------------
    --              ACTIONS               --
    ----------------------------------------

    -- Commenting
    use {
        "b3nj5m1n/kommentary",
        config = function()
            require "kommentary.config".configure_language("default", {
                prefer_single_line_comments = true
            })
        end
    }

    -- Surround
    use {
        "blackCauldron7/surround.nvim",
        config = function()
            require "surround".setup {
                mappings_style = "surround",
            }
        end
    }


    ----------------------------------------
    --       TEXT OBJECTS / MOTION        --
    ----------------------------------------

    -- Treesitter objects
    use {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
            require "nvim-treesitter.configs".setup {
                textobjects = {
                    select = {
                        enable = true,

                        lookahead = true,

                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        }
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        }
                    }
                }
            }
        end
    }

    -- Indentation objects
    use "michaeljsmith/vim-indent-object"

    -- Camel case motions
    use "chaoren/vim-wordmotion"


    ----------------------------------------
    --              UTILITY               --
    ----------------------------------------

    -- Treesitter powered spellchecking
    use {
        "lewis6991/spellsitter.nvim",
        config = function()
            require "spellsitter".setup()
        end
    }

    -- Range highlighting when typing a command
    use {
        "winston0410/range-highlight.nvim",
        requires = {"winston0410/cmd-parser.nvim"},
        config = function()
            require "range-highlight".setup {
            }
        end
    }

    -- Automatically create directories when saving
    use {
        "jghauser/mkdir.nvim",
        config = function()
            require "mkdir "
        end
    }

    -- Smarter incrementation
    use "monaqa/dial.nvim"

    -- Write as sudo
    use "lambdalisue/suda.vim"

    -- Autosave
    use "Pocco81/AutoSave.nvim"

    -- Automatically detect tab style
    use "tpope/vim-sleuth"

    -- Fix broken CursorHold autocmds
    use "antoinemadec/FixCursorHold.nvim"

    -- Better . (repeat)
    use "tpope/vim-repeat"

end)
