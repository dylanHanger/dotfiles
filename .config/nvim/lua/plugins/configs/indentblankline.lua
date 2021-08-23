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
   use_treesitter = true,
   show_first_indent_level = false
}
