return {
	"folke/which-key.nvim",
	-- nvchad: https://github.com/NvChad/NvChad/blob/178bf21fdef6679ea70af3f6e45b1c1e6ed8e8a6/lua/nvchad/plugins/ui.lua#L76
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	-- opts = function(plugin)
	-- config = {
	--   default = config.mapping()
	-- }
	-- return config.mapping()
	-- end,
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.register({
			["<leader>g"] = { "~Git" },
			["<leader>m"] = { "m mapping" },
			["<leader>n"] = { name = "MY custom commands" },
		})
	end,
	-- keys = { "<localleader>"},
	-- keys = {  "<localleader>", "<leader>", '"', "'", "`", "c", "v", "g" },
}
