require("compe").setup {
   enabled = true,

   autocomplete = true,
   debug = false,
   documentation = true,
   incomplete_delay = 400,
   max_abbr_width = 100,
   max_kind_width = 100,
   max_menu_width = 100,
   min_length = 1,
   preselect = "enable",
   source_timeout = 200,
   source = {
      path = true,
      buffer = { kind = "﬘", true },
      luasnip = { kind = "﬌", true },
      nvim_lsp = true,
      nvim_lua = true,
   },
   throttle_time = 80,
}
