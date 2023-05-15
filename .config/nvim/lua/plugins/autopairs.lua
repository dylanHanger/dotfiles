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
