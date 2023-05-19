return {
  -- add latex to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "latex", "bibtex" })
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

  -- TODO: https://github.com/lervag/vimtex
  -- What does it offer over texlab?
  -- How do I integrate it with texlab?
  -- TODO: https://github.com/frabjous/knap?
  -- Is it necessary?

  -- null-ls custom config.
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      local nls_diagnostics = nls.builtins.diagnostics
      local nls_formatting = nls.builtins.formatting
      local diagnostics = {
        -- Linters
      }
      local formatting = {
        -- Formatters
      }
      if type(opts.sources) == "table" then
        opts.sources = vim.list_extend(opts.sources, diagnostics)
        opts.sources = vim.list_extend(opts.sources, formatting)
      end
      opts.debug = true
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "f3fora/nvim-texlabconfig",
        ft = { "tex", "bib" },
        -- run = 'go build -o ~/.bin/' if e.g. ~/.bin/ is in $PATH
        build = "go build",
        opts = {
          cache_activate = true,
          cache_filetypes = { "tex", "bib" },
          cache_root = vim.fn.stdpath("cache"),
          reverse_search_start_cmd = function()
            return true
          end,
          reverse_search_edit_cmd = vim.cmd.edit,
          reverse_search_end_cmd = function()
            return true
          end,
          file_permission_mode = 438,
        },
      },
    },
    opts = {
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        texlab = function(_, opts)
          local nvim_texlabconfig = require("texlabconfig").project_dir() .. "/nvim_texlabconfig"

          -- TODO: Find something that works nicely with WSL
          local executable = "sioyek"
          local args = {
            "--reuse-window",
            "--inverse-search",
            nvim_texlabconfig .. [[ -file %1 -line %2 -server ]] .. vim.v.servername,
            "--forward-search-file",
            "%f",
            "--forward-search-line",
            "%l",
            "%p",
          }

          require("lazyvim.util").on_attach(function(client, buffer)
            if client.name == "texlab" then
              vim.keymap.set("n", "<leader>cb", function()
                local params = vim.lsp.util.make_position_params()
                client.request("textDocument/build", params, function() end)
              end, { desc = "Build", buffer = buffer })
              vim.keymap.set("n", "gp", function()
                local params = vim.lsp.util.make_position_params()
                client.request("textDocument/forwardSearch", params, function() end)
              end, { desc = "Forward search", buffer = buffer })
            end
          end)

          require("lspconfig").texlab.setup({
            settings = {
              texlab = {
                build = {
                  onSave = true,
                  forwardSearchAfter = true,
                },
                forwardSearch = {
                  executable = executable,
                  args = args,
                },
              },
            },
          })
          return true
        end,
      },
    },
  },
}
