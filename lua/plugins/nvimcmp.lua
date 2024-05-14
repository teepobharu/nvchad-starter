local myutils = require("myutils")


	return {
		"hrsh7th/nvim-cmp",
		-- https://github.com/NvChad/NvChad/issues/2332
		-- sample config : https://github.com/hrsh7th/nvim-cmp/issues/1142#issuecomment-1355279953
		opts = function()
			local cmp = require("cmp")
			local cmp_conf = require("nvchad.configs.cmp")

			-- table.insert(cmp_conf.sources, { name = "copilot"})
			--       table.insert(cmp_conf.mapping, {
			--         ["<C-j>"] = cmp.mapping.select_next_item(),
			--         ["<C-k>"] = cmp.mapping.select_prev_item(),
			--         ["<Esc>"] = cmp.mapping.abort(),
			-- })
			-- merge mapping deep by copilot
			cmp_conf.mapping = vim.tbl_deep_extend("force", cmp_conf.mapping, {
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-n>"] = cmp.mapping.scroll_docs(4),
				["<C-p>"] = cmp.mapping.scroll_docs(-4),
				["<Esc>"] = cmp.mapping.abort(),
				["<C-Space>"] = function()
					if cmp.visible() then
						cmp.abort()
					else
						cmp.complete({ reason = cmp.ContextReason.Auto })
					end
				end,
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif require("luasnip").expand_or_jumpable() then
						vim.fn.feedkeys(
							vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true),
							""
						)
					else
						fallback()
					end
				end, {
					"i",
					"s",
				}),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif require("luasnip").jumpable(-1) then
						vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
					else
						fallback()
					end
				end, {
					"i",
					"s",
				}),
			})
			return cmp_conf
		end,
	}

