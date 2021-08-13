-- Plugin Management
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    execute 'packadd packer.nvim'
end

-- vim.api.nvim_exec([[
--	augroup Packer
--	  autocmd!
--	  autocmd BufWritePost init.lua PackerCompile
--	augroup end
-- ]], false) ]]

local use = require('packer').use
require('packer').startup(function()
    -- Packer itself
    use 'wbthomason/packer.nvim'

    -- Git
    use 'tpope/vim-fugitive' -- Git commands
    use 'tpope/vim-rhubarb' -- Fugitive companion for GitHub
    use {
        -- Git related info in signs columns and popups
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function()
            require('gitsigns').setup {
                signs = {
                    add = {hl = 'GitGutterAdd', text = '+'},
                    change = {hl = 'GitGutterChange', text = '~'},
                    delete = {hl = 'GitGutterDelete', text = '_'},
                    topdelete = {hl = 'GitGutterDelete', text = '-'},
                    changedelete = {hl = 'GitGutterChange', text = '~'}
                },
                numhl = true,
                -- Put blame in the statusline current_line_blame = true,
                current_line_blame_delay = 300,
                current_line_blame_position = 'eol'
            }
        end
    }
    -- Tags
    use 'ludovicchabant/vim-gutentags'

    -- Debugging
    -- TODO: Set this up, but its hard so ehh
    use {
        'rcarriga/nvim-dap-ui',
        requires = {{'mfussenegger/nvim-dap'}, {'Pocco81/DAPInstall.nvim'}}
    }

    -- Vimwiki
    use {
        'chipsenkbeil/vimwiki.nvim',
        requires = {'vimwiki/vimwiki'}
    }

    -- UI
    use {
        -- Fuzzy finder
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
        config = function()
            require('telescope').setup {
                defaults = {
                    mappings = {i = {['<C-u>'] = false, ['<C-d>'] = false}}
                }
            }
            -- Keymaps
            vim.api.nvim_set_keymap('n', '<leader><space>',
                [[<cmd>lua require('telescope.builtin').buffers()<CR>]],
                {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<leader>sf',
                [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]],
                {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<leader>sb',
                [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]],
                {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<leader>sh',
                [[<cmd>lua require('telescope.builtin').help_tags()<CR>]],
                {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<leader>st',
                [[<cmd>lua require('telescope.builtin').tags()<CR>]],
                {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<leader>sd',
                [[<cmd>lua require('telescope.builtin').grep_string()<CR>]],
                {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<leader>sp',
                [[<cmd>lua require('telescope.builtin').live_grep()<CR>]],
                {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<leader>so',
                [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]],
                {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<leader>?',
                [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]],
                {noremap = true, silent = true})
        end
    }

    use {
        -- File tree
        'kyazdani42/nvim-tree.lua',
        requires = {'kyazdani42/nvim-web-devicons'},
        config = function()
            vim.api.nvim_set_keymap('n', 'bb', [[:NvimTreeToggle<CR>]],
                {noremap = true, silent = true})
        end
    }

    use 'famiu/bufdelete.nvim'
    use {
        -- Bufferline
        'akinsho/nvim-bufferline.lua',
        requires = {{'kyazdani42/nvim-web-devicons'}},
        config = function()
            vim.o.termguicolors = true
            require('bufferline').setup {
                options = {
                    diagnostics = 'nvim_lsp',
                    offsets = {
                        {
                            filetype = 'NvimTree',
                            text = 'EXPLORER',
                            highlight = 'Directory',
                            text_align = 'left'
                        }, {filetype = 'packer'}
                    },
                    separator_style = "thick",
                    always_show_bufferline = true,
                    close_command = function(bufnum)
                        require('bufdelete').bufdelete(bufnum, true)
                    end
                }
            }

            vim.api.nvim_set_keymap('n', 'gb', [[:BufferLinePick<CR>]], {silent = true, noremap = true})
            vim.api.nvim_set_keymap('n', 'qb', [[:Bdelete<CR>]], {silent = true, noremap = true})
            vim.api.nvim_set_keymap('n', ']b', [[:BufferLineCycleNext<CR>]], {silent = true, noremap = true})
            vim.api.nvim_set_keymap('n', '[b', [[:BufferLineCyclePrev<CR>]], {silent = true, noremap = true})
        end
    }

    use {
        'eddyekofo94/gruvbox-flat.nvim',
        config = function()
            vim.g.gruvbox_flat_style = "hard"
            vim.cmd [[colorscheme gruvbox-flat]]
        end
    }

    use {
        -- Statusline
        'hoob3rt/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true},
        config = function()
            local packer = {
                sections = {
                    lualine_a = {'Packer'},
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {},
                },
                filetypes = {'packer'}
            }
            require('lualine').setup {
                options = {theme = 'gruvbox-flat'},
                sections = {
                },
                extensions = {'nvim-tree', packer}
            }
            vim.o.showmode = false
        end
    }

    -- Useful things
    use 'tpope/vim-sleuth'
    use {
        -- TODO: Automatically record and restore sessions
        'tpope/vim-obsession'
    }
    use 'tpope/vim-surround'

    use {
        'lambdalisue/suda.vim',
        config = function()
            vim.cmd [[ let g:suda_smart_edit = 1 ]]
        end
    }

    use {
        -- Indentation guides
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require('indent_blankline').setup {
                char = '┊',
                filetype_exclude = {'help', 'NvimTree', 'packer'},
                buftype_exclide = {'terminal', 'nofile'},
                char_highlight = 'LineNr',
                show_trailing_blankline_indent = false,
                use_treesitter = true
            }
        end
    }

    use {
        -- Highlighting colours
        'norcalli/nvim-colorizer.lua',
        config = function()
            vim.o.termguicolors = true
            require('colorizer').setup {}
        end
    }

    use {
        -- Commenting
        'b3nj5m1n/kommentary',
        config = function()
            require('kommentary.config').configure_language('default', {
                prefer_single_line_comments = true
            })
        end
    }

    -- use {
    --     "folke/trouble.nvim",
    --     requires = {{'kyazdani42/nvim-web-devicons'}, {'folke/lsp-colors.nvim'}},
    --     config = function() require("trouble").setup {} end
    -- }

    -- Language Integrations
    use {
        -- Error checking etc
        'neovim/nvim-lspconfig',
        config = function()
            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp
                .diagnostic
                .on_publish_diagnostics,
                {
                    virtual_text = false,
                    signs = true,
                    underline = true,
                    update_in_insert = true,
                    severity_sort = true
                })
            -- TODO: Set formatting up
            -- vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
            --     if err ~= nil or result == nil then return end
            --     if not vim.api.nvim_buf_get_option(bufnr, "modified") then
            --         local view = vim.fn.winsaveview()
            --         vim.lsp.util.apply_text_edits(result, bufnr)
            --         vim.fn.winrestview(view)
            --         if bufnr == vim.api.nvim_get_current_buf() then
            --             vim.api.nvim_command("noautocmd :update")
            --         end
            --     end
            -- end

            -- local on_attach = function(client)
            --     if client.resolved_capabilities.document_formatting then
            --         vim.api.nvim_command [[augroup Format]]
            --         vim.api.nvim_command [[autocmd! * <buffer>]]
            --         vim.api
            --         .nvim_command [[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()]]

            --         vim.api.nvim_command [[augroup END]]
            --     end
            -- end

            -- require"lspconfig".efm.setup {on_attach = on_attach}
        end
    }

    use {
        'glepnir/lspsaga.nvim',
        config = function()
            require('lspsaga').init_lsp_saga {
                code_action_prompt = {sign = false},
                code_action_keys = {
                    quit = {'q','<Esc>','<C-c>'},
                    exec = '<CR>'
                },
                finder_action_keys = {
                    quit = {'q','<Esc>','<C-c>'},
                    open = {'<CR>', 'o'}
                },
                rename_action_keys = {
                    quit = {'q','<Esc>','<C-c>'}
                }
            }

            -- Scrolling
            vim.api.nvim_set_keymap('n', '<C-b>',
                ':lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>',
                {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<C-a>',
                ':lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>',
                {noremap = true, silent = true})

            -- Rename with <leader>r
            vim.api.nvim_set_keymap('n', '<leader>r',
                ':lua require("lspsaga.rename").rename()<CR>',
                {noremap = true, silent = true})

            vim.api.nvim_set_keymap('n', '<leader>h',
                ':lua require("lspsaga.provider").lsp_finder()<CR>',
                {noremap = true, silent = true})

            -- Code actions
            vim.api.nvim_set_keymap('n', '<leader>ca',
                ':lua require("lspsaga.codeaction").code_action()<CR>',
                {noremap = true, silent = true})
            vim.api.nvim_set_keymap('v', '<leader>ca',
                ':<C-U>lua require("lspsaga.codeaction").range_code_action()<CR>',
                {noremap = true, silent = true})

            -- Jumping between diagnostics
            vim.api.nvim_set_keymap('n', '[e',
                ':lua require("lspsaga.diagnostic").lsp_jump_diagnostic_prev()<CR>',
                {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', ']e',
                ':lua require("lspsaga.diagnostic").lsp_jump_diagnostic_next()<CR>',
                {noremap = true, silent = true})

            -- Open

            -- Show diagnostics on hover
            vim.api.nvim_exec([[
            augroup sig
            autocmd!
            autocmd CursorHold * lua require('lspsaga.diagnostic').show_line_diagnostics()
            augroup END
                ]], false)

            -- Show signature help on hover
            vim.api.nvim_exec([[
            augroup sig
            autocmd!
            autocmd CursorHoldI * silent! lua require('lspsaga.signaturehelp').signature_help()
            augroup END
                ]], false)
        end
    }

    use {
        'kabouzeid/nvim-lspinstall',
        config = function()
            -- TODO: Move this into a better place
            require('setupLspInstall')
        end
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            vim.o.foldmethod = 'expr'
            vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
            vim.o.foldenable = false

            require('nvim-treesitter.install').compilers = {'gcc'}
            require('nvim-treesitter.configs').setup {
                ensure_installed = 'maintained',
                highlight = {enable = true},
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = 'gnn',
                        node_incremental = 'grn',
                        scope_incremental = 'grc',
                        node_decremental = 'grm'
                    }
                },
                indent = {enable = true, disable = {"python"}},
            }
        end
    }

    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        config = function()
            require('nvim-treesitter.configs').setup {
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- automatically jump forward to textobj
                        keymaps = {
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@class.outer',
                            ['ic'] = '@class.inner'
                        }
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            [']m'] = '@function.outer',
                            [']]'] = '@class.outer'
                        },
                        goto_next_end = {
                            [']M'] = '@function.outer',
                            [']['] = '@class.outer'
                        },
                        goto_previous_start = {
                            ['[m'] = '@function.outer',
                            ['[['] = '@class.outer'
                        },
                        goto_previous_end = {
                            ['[M'] = '@function.outer',
                            ['[]'] = '@class.outer'
                        }
                    }
                }
            }
        end
    }

    -- Autocompletion
    use {
        'hrsh7th/nvim-compe',
        config = function()
            require('compe').setup {
                source = {path = true, nvim_lsp = true, treesitter = true}
            }

            local t = function(str)
                return vim.api.nvim_replace_termcodes(str, true, true, true)
            end

            local check_back_space = function()
                local col = vim.fn.col '.' - 1
                if col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' then
                    return true
                else
                    return false
                end
            end

            _G.tab_complete = function()
                if vim.fn.pumvisible() == 1 then
                    return t '<C-n>'
                elseif vim.fn['vsnip#available'](1) == 1 then
                    return t "<Plug>(vsnip-expand-or-jump)"
                elseif check_back_space() then
                    return t '<Tab>'
                else
                    return vim.fn['compe#complete']()
                end
            end

            _G.s_tab_complete = function()
                if vim.fn.pumvisible() == 1 then
                    return t '<C-p>'
                elseif vim.fn['vsnip#available'](1) == 1 then
                    return t "<Plug>(vsnip-jump-prev)"
                else
                    return t '<S-Tab>'
                end
            end

            -- Map tab to the above tab complete functiones
            vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()',
                {expr = true})
            vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()',
                {expr = true})
            vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()',
                {expr = true})
            vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()',
                {expr = true})

            -- Map compe confirm and complete functions
            vim.api.nvim_set_keymap('i', '<CR>',
                [[compe#confirm(luaeval("require('nvim-autopairs').autopairs_cr()"))]],
                {expr = true})
            vim.api.nvim_set_keymap('i', '<C-Space>', 'compe#complete()',
                {expr = true})
            vim.o.completeopt = 'menuone,noselect'
        end
    }

    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup {
                disable_filetype = {"TelescopePrompt"},
                check_ts = true,
                fastwrap = {}
            }
            require('nvim-treesitter.configs').setup {
                autopairs = {enable = true},
                autotag = {enable = true}
            }
            require('nvim-autopairs.completion.compe').setup {
                map_cr = true,
                map_complete = true,
                auto_select = false
            }
        end
    }

    use {
        'hrsh7th/vim-vsnip',
        requires = {
            {'hrsh7th/vim-vsnip-integ'}, {'rafamadriz/friendly-snippets'}
        }
    }
end)

-- Incremental live completion when substituting
vim.o.inccommand = 'nosplit'

-- Turn on line numbers
vim.o.number = true
vim.o.cursorline = true
vim.o.cursorlineopt = 'both'

-- Do not save while switching numbers
vim.o.hidden = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Use the system clipboard
vim.o.clipboard = "unnamedplus"

-- Allow moving one past the end of the line
vim.o.virtualedit = 'onemore'

-- Make line wrapping more readable
vim.o.breakindent = true

-- Save undo history
vim.cmd [[set undofile]]

-- Case insensitive searching
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time (?)
vim.o.timeoutlen = 500
vim.o.updatetime = 300
vim.wo.signcolumn = 'yes'

-- Rebinding space to leader
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', {noremap = true, silent = true})
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Dealing with word wrapping
vim.o.wrap = false
--[[ vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, silent = true }) ]]

-- Highlight on yank
vim.api.nvim_exec([[
augroup YankHighlight
autocmd!
autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end
    ]], false)

-- Yank to end of line
vim.api.nvim_set_keymap('n', 'Y', 'y$', {noremap = true})

-- Setting tab settings
-- vim.o.smarttab = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4


vim.cmd [[
    syntax on
    filetype plugin on
]]
