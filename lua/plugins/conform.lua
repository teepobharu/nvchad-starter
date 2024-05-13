local map = vim.keymap.set
-- enabled once explicit use the format keybinding

return { -- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/plugins/init.lua#L14
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "autopep8" },
		},
		format_on_save = function(bufnr)
			-- Disable with a global or buffer-local variable
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { timeout_ms = 500, lsp_fallback = true }
		end,
	},
	config = function(_, opts)
		require("conform").setup(opts)
		-- Enable toggling command for disabling autoformat => https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#command-to-toggle-format-on-save or https://github.com/stevearc/conform.nvim/issues/40
		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- FormatDisable! will disable formatting just for this buffer
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})

		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})
		--
		-- mappings
		map("n", "<leader>fM", function()
			if vim.b.disable_autoformat or vim.g.disable_autoformat then
				vim.cmd("FormatEnable")
				print("Autosave Format Enable")
			else
				vim.cmd("FormatDisable")
				print("Autosave Format Disable")
			end
		end, { desc = "Toggle [F]ormat" })

		map("", "<leader>fm", function()
			require("conform").format()
		end, { desc = "File Format with conform" })
	end,
}
