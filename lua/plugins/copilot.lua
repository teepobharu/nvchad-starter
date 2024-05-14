return {
		"github/copilot.vim",
		event = "VeryLazy",
		config = function()
			vim.g["copilot_no_tab_map"] = true
			-- enable copilot for specific filetypes
			vim.g.copilot_filetypes = {
				["TelescopePrompt"] = false,
			}
			-- sample config: https://github.com/jellydn/lazy-nvim-ide/blob/main/lua/plugins/extras/copilot-vim.lua
			-- Setup keymaps
			local keymap = vim.keymap.set
			local opts = { silent = true }

			keymap("i", "<C-o>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
			-- Set <C-y> to accept copilot suggestion
			keymap("i", "<C-y>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })

			-- Set <C-i> to accept line
			keymap("i", "<C-i>", "<Plug>(copilot-accept-line)", opts)

			-- Set <C-j> to next suggestion, <C-k> to previous suggestion, <C-l> to suggest
			keymap("i", "<C-j>", "<Plug>(copilot-next)", opts)
			keymap("i", "<C-k>", "<Plug>(copilot-previous)", opts)
			keymap("i", "<C-l>", "<Plug>(copilot-suggest)", opts)

			-- Set <C-d> to dismiss suggestion
			keymap("i", "<C-d>", "<Plug>(copilot-dismiss)", opts)
		end,

		keys = {
			-- mapping source : https://www.reddit.com/r/neovim/comments/qsfvki/how_to_remap_copilotvim_accept_method_in_lua/
			{ "<leader>ce", "<cmd>Copilot panel<cr>”)", desc = "Copilot suggest" },
		},
	}

