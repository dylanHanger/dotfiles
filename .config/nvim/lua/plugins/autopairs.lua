return {
  -- Disable mini.pairs
  { "echasnovski/mini.pairs", enabled = false },
  -- Replace it with autopairs
  {
    "windwp/nvim-autopairs",
    config = function(_, opts)
      -- Insert `(` after selecting function or method item
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      -- TODO: Any extra rules I want here
      --https://github.com/windwp/nvim-autopairs#treesitter
      vim.tbl_deep_extend("force", opts, {
        check_ts = true,
        ts_config = {
          lua = { "string" }, -- it will not add pair on that treesitter node
          javascript = { "template_string" },
        },
      })

      require("nvim-autopairs").setup(opts)
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = function(_, opts)
      require("nvim-treesitter.configs").setup({
        autotag = {
          enable = true,
        },
      })
    end,
  },
}
