local install_path = vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
    vim.api.nvim_command [[packadd packer.nvim]]
end

vim.g.loaded_netrwPlugin = false
vim.cmd [[packadd cfilter]]

require("packer").startup(function()
    use "wbthomason/packer.nvim"

    -- Keymaps
    use {
        "folke/which-key.nvim",
        config = function()
            require "which-key".setup()
        end
    }

    -- LSP
    use "neovim/nvim-lspconfig"
    use "kabouzeid/nvim-lspinstall"
    use {
        "hrsh7th/nvim-compe",
        config = function()
            require "compe".setup {
                enabled = true,
                autocomplete = true,
                min_length = 1,
                preselect = "enable",
                source = {
                    path = true,
                    buffer = true,
                    nvim_lsp = true,
                    nvim_lua = true,
                    vsnip = true,
                    calc = true,
                    treesitter = true
                },
                documentation = {
                    border = "single",
                    winhighlight = "NormalFloat:LspFloatWinNormal,FloatBorder:LspFloatWinBorder",
                    max_width = 120,
                }
            }
        end
    }

    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require "nvim-treesitter.configs".setup {
                ensure_installed = "all",
                highlight = {
                    enable = true,
                    language_tree = true
                },
                indent = {
                    enable = true,
                    disable = {"python"}
                },
                refactor = {
                    highlight_definitions = {
                        enable = true
                    }
                },
                textobjects = {
                    select = {
                        enable = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner"
                        }
                    }
                },
                autopairs = {
                    enable = true
                },
                rainbow = {
                    enable = true,
                    extended_mode = true
                },
                autotag = {
                    enable = true
                }
            }
        end
    }

    use "nvim-treesitter/playground"
    use "nvim-treesitter/nvim-treesitter-refactor"
    use "nvim-treesitter/nvim-treesitter-textobjects"
    use "windwp/nvim-ts-autotag"

    -- use {
    --     'glepnir/lspsaga.nvim',
    --     config = function()
    --         require "lspsaga".init_lsp_saga {
    --             code_action_prompt = {sign = false},
    --             code_action_keys = {
    --                 quit = {"q","<Esc>","<C-c>"},
    --                 exec = "<CR>"
    --             },
    --             finder_action_keys = {
    --                 quit = {"q","<Esc>","<C-c>"},
    --                 open = {"<CR>", "o"}
    --             },
    --             rename_action_keys = {
    --                 quit = {"q","<Esc>","<C-c>"}
    --             }
    --         }
    --     end
    -- }

    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup {
                disable_filetype = {"TelescopePrompt"},
                check_ts = true,
                fastwrap = {}
            }
            require('nvim-autopairs.completion.compe').setup {
                map_cr = true,
                map_complete = true,
                auto_select = true,
            }
        end
    }

    use "michaeljsmith/vim-indent-object"
    use "wellle/targets.vim"
    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require "indent_blankline".setup {
                filetype_exclude = {
                    "help",
                    "packer",
                    "man",
                    "lspinfo",
                    "diagnosticpopup"
                },
                buftype_exclude = {"terminal", "nofile"},
                space_char_blankline = " ",
                char = "┊",
                show_foldtext = false,
                strict_tabs = true,
                -- show_current_context = true,
                use_treesitter = true,
                context_patterns = {
                    "class",
                    "function",
                    "method",
                    "^if",
                    "while",
                    "for",
                    "with",
                    "func_literal",
                    "block",
                    "try",
                    "except",
                    "argument_list",
                    "object",
                    "dictionary",
                    "element"
                }
            }
        end
    }

    -- use {
    --     "junegunn/fzf.vim",
    --     requires = {
    --         {"junegunn/fzf"}
    --     },
    --     config = function()
    --         vim.g.fzf_buffers_jump = true
    --         vim.g.fzf_layout = {window = {width = 0.8, height = 0.4, yoffset = 0.2}}
    --         vim.cmd [[let $FZF_DEFAULT_OPTS-$FZF_DEFAULT_OPTS . ' --reverse --ansi']]
    --     end
    -- }
    -- use "vijaymarupudi/nvim-fzf"

    use {
        "kyazdani42/nvim-web-devicons",
        config = function()
            require "nvim-web-devicons".setup {
                default = true
            }
        end
    }

    use "tpope/vim-repeat"
    use "tpope/vim-surround"
    use "tpope/vim-sleuth"

    use {
        "lewis6991/gitsigns.nvim",
        requires = {"nvim-lua/plenary.nvim"},
        config = function()
            require('gitsigns').setup {
                signs = {
                    add          = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
                    change       = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
                    delete       = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
                    topdelete    = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
                    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
                },
            }
        end
    }

    use {
        "kyazdani42/nvim-tree.lua",
        requires = {"kyazdani42/nvim-web-devicons"},
        config = function()
            vim.g.nvim_tree_quit_on_open = 1
            vim.g.nvim_tree_auto_open = 1
            vim.g.nvim_tree_auto_close = 1
            vim.g.nvim_tree_update_cwd = 1
            vim.g.nvim_tree_respect_buf_cwd = 1
        end
    }

    use "famiu/bufdelete.nvim"
    use {
        "akinsho/nvim-bufferline.lua",
        requires = {"kyazdani42/nvim-web-devicons"},
        config = function()
            require("bufferline").setup {
                options = {
                    diagnostics = "nvim_lsp",
                    offsets = {
                        {
                            filetype = "NvimTree",
                            text = "Explorer",
                            highlight = "Directory",
                            text_align = "center",
                        },
                        {
                            filetype = "packer",
                            text = "Packer",
                            text_align = "center"
                        }
                    },
                    separator_style = "thin",
                    always_show_bufferline = true,
                    close_command = "Bdelete! %d",
                    right_mouse_command = "Bdelete! %d",

                    -- sort_by = 'tabs'
                    sort_by = function(buffer_a, buffer_b)
                        -- TODO: My own sorting here
                        local mod_a = vim.loop.fs_stat(buffer_a.path).mtime.sec
                        local mod_b = vim.loop.fs_stat(buffer_b.path).mtime.sec
                        return mod_a > mod_b
                    end
                }
            }
        end
    }

    use {
        "hrsh7th/vim-vsnip",
        requires = {
            {"hrsh7th/vim-vsnip-integ"}, {"rafamadriz/friendly-snippets"}
        }
    }

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

    -- use "bkad/camelCaseMotion"
    use {
        "chaoren/vim-wordmotion",
        config = function()
            vim.g.wordmotion_nomap = 1
        end
    }

    use "vim-scripts/ReplaceWithRegister"
    use "vim-scripts/ReplaceWithSameIndentRegister"

    use "arthurxavierx/vim-caser"
    use {
        "rhysd/clever-f.vim",
        config = function()
            vim.g.clever_f_smart_case = 1
        end
    }

    use {
        "b3nj5m1n/kommentary",
        config = function()
            require("kommentary.config").configure_language("default", {
                prefer_single_line_comments = true
            })
        end
    }

    use {
        "eddyekofo94/gruvbox-flat.nvim",
        config = function()
            vim.g.gruvbox_flat_style = "hard"
            vim.cmd[[colorscheme gruvbox-flat]]
        end
    }
    use "hoob3rt/lualine.nvim"

    use "antoinemadec/FixCursorHold.nvim"

    use "beauwilliams/focus.nvim"

    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            "nvim-lua/plenary.nvim"
        }
    }
    use {
        "RishabhRD/nvim-lsputils",
        requires = {
            "RishabhRD/popfix"
        }
    }

    use "monaqa/dial.nvim"

    use "Pocco81/AutoSave.nvim"
end)
