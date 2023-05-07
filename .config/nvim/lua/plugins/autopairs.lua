return {
  -- Disable mini.pairs
  { "echasnovski/mini.pairs", enabled = true },
  -- Replace it with autopairs
  -- {
  --   "windwp/nvim-autopairs",
  --   config = function()
  --     -- Insert `(` after selecting function or method item
  --     local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  --     local cmp = require("cmp")
  --     cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  --   end,
  -- },
}
