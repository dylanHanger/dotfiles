local map = require("mappings").map

map("", "w", "<Plug>WordMotion_w", {noremap = false}, "Next word")
map("", "b", "<Plug>WordMotion_b", {noremap = false}, "Previous word")
map("", "e", "<Plug>WordMotion_e", {noremap = false}, "Next end of word")
map("", "ge", "<Plug>WordMotion_ge", {noremap = false}, "Previous end of word")

-- map({"o", "x"}, "iw", "<Plug>WordMotion_iw", {noremap = false})
-- map({"o", "x"}, "ib", "<Plug>WordMotion_ib", {noremap = false})
-- map({"o", "x"}, "ie", "<Plug>WordMotion_ie", {noremap = false})

-- map("i", "<C-Left>", "<C-o><Plug>WordMotion_b", {noremap = false})
-- map("i", "<C-Right>", "<C-o><Plug>WordMotion_w", {noremap = false})
