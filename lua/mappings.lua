require("nvchad.mappings")

local map = vim.keymap.set
map("n", "<leader>fm", function()
	require("conform").format()
end, { desc = "File Format with conform" })

-- add yours here
require("mymappings")
