local modules = {
	"settings",
	"plugins",
	"autocmds",
	"lsp",
	"mappings"
}

for i = 1, #modules do
	if not pcall(require, modules[i]) then
		require("utils").error("Failed to load", modules[i])
	end
end
