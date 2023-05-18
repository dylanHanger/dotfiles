return {
  -- add latex to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "latex" })
    end,
  },

  -- correctly setup mason lsp extensions
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- TODO: consider Vale, chktex, latexindent (for use with null-ls)
      vim.list_extend(opts.ensure_installed, { "texlab" })
    end,
  },

  -- Install vimtex
  -- {
  --   "lervag/vimtex",
  --   init = function()
  --     vim.g.vimtex_compiler_latexmk = {
  --       build_dir = ".out",
  --       options = {
  --         "-shell-escape",
  --         "-verbose",
  --         "-file-line-error",
  --         "-interaction=nonstopmode",
  --         "-synctex=1",
  --       },
  --     }
  --     vim.g.vimtex_viewmethod = "sioyek"
  --
  --     vim.g.vimtex_quickfix_enabled = 1
  --     vim.g.vimtex_quickfix_mode = 0 -- I don't even know what this is
  --
  --     vim.g.vimtex_syntax_enabled = 0 -- I want treesitter to handle highlighting
  --
  --     -- TODO: Keybinds
  --   end,
  -- },
  -- TODO: https://github.com/frabjous/knap/

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- FIXME: Yucky vim plugins are so gross to use
      -- Get vimtex working (possibly with knap?)
      "frabjous/knap",
      init = function()
        vim.g.knap_settings = {
          texoutputext = "pdf",
          textopdf = "pdflatex -synctex=1 -halt-on-error -interaction=batchmode %docroot%",
          textopdfviewerlaunch = "mupdf %outputfile%",
          textopdfviewerrefresh = "kill -HUP %pid%",
        }
      end,
    },
    opts = {
      servers = {
        texlab = {
          on_attach = function(client, buffer)
            -- set shorter name for keymap function
            local map = vim.keymap.set

            map("n", "<leader>dR", function()
              require("knap").process_once()
            end, { desc = "Build and refresh preview", buffer = buffer })

            map("n", "<leader>dr", function()
              require("knap").toggle_autopreviewing()
            end)

            map("n", "gp", function()
              require("knap").forward_jump()
            end, { desc = "Jump in preview", buffer = buffer })
          end,
        },
      },
    },
  },
}
