local M = {}

M.treesitter = {
	ensure_installed = {
		"vim",
		"lua",
		"html",
		"css",
		"javascript",
		"typescript",
		"tsx",
		"c",
		"markdown",
		"markdown_inline",
		"python",
	},
	indent = {
		enable = true,
		-- disable = {
		--   "python"
		-- },
	},
}

-- git support in nvimtree
M.nvimtree = {
	git = {
		enable = true,
	},

	renderer = {
		highlight_git = true,
		icons = {
			show = {
				git = true,
			},
		},
	},
}

M.telescope = {
	getOptions = function()
		return {
			pickers = {
				find_files = {
					mappings = {
						n = {
							-- does not work not sure
							-- ref example recipe
							-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#file-and-text-search-in-hidden-files-and-directories
							-- source code
							-- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua#L97
						},
					},
				},
			},

			-- extensions = {
			-- 	zoxide = {
			-- 		prompt_title = "[ Walking on the shoulders of TJ ]",
			-- 		mappings = {
			-- 			default = {
			-- 				after_action = function(selection)
			-- 					print("Update to (" .. selection.z_score .. ") " .. selection.path)
			-- 				end,
			-- 			},
			-- 			["<C-s>"] = {
			-- 				before_action = function(selection)
			-- 					print("before C-s")
			-- 				end,
			-- 				action = function(selection)
			-- 					vim.cmd.edit(selection.path)
			-- 				end,
			-- 			},	
			-- 			["<C-q>"] = { action = z_utils.create_basic_command("split") },
			-- 		},
			-- 	},
			-- },
			-- https://github.com/nvim-telescope/telescope.nvim#default-mappings
      --

			mappings = {
				-- to get desc (extract from object ?): https://github.com/nvim-telescope/telescope.nvim/blob/dc192faceb2db64231ead71539761e055df66d73/lua/telescope/mappings.lua#L208
				i = {
					["<C-k>"] = function(...)
						require("telescope.actions").move_selection_previous(...)
					end,
					["<C-j>"] = function(...)
						require("telescope.actions").move_selection_next(...)
					end,
					["<C-h>"] = function(...)
						require("telescope.actions").results_scrolling_left(...)
					end,
					["<C-l>"] = function(...)
						require("telescope.actions").results_scrolling_right(...)
					end,
					["<C-d>"] = require("telescope.actions").results_scrolling_down,
					["<C-u>"] = require("telescope.actions").results_scrolling_up,
					-- ['<c-d>'] = require('telescope.actions').delete_buffer,
				},
				-- When the search text is focused
				n = {
					-- name appear when hit ? but not exectuable
					-- ["<esc>"] = mappingFunction.close_preview,
					-- ["cd"] = mappingFunction.lcd_preview,
					["X"] = require("telescope.actions").delete_buffer,
					["J"] = require("telescope.actions").results_scrolling_down,
					["K"] = require("telescope.actions").results_scrolling_up,
					["<C-d>"] = require("telescope.actions").results_scrolling_down,
					["<C-u>"] = require("telescope.actions").results_scrolling_up,

					-- See default mappings / fn name here: https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua#L154
					["<C-k>"] = function(...)
						require("telescope.actions").move_selection_previous(...)
					end,
					["<C-j>"] = function(...)
						require("telescope.actions").move_selection_next(...)
					end,
					["<C-h>"] = function(...)
						require("telescope.actions").results_scrolling_left(...)
					end,
					["<C-l>"] = function(...)
						require("telescope.actions").results_scrolling_right(...)
					end,
					["<esc>"] = function(...)
						require("telescope.actions").close(...)
					end,
					["cd"] = function(prompt_bufnr)
						local selection = require("telescope.actions.state").get_selected_entry()
						local dir = vim.fn.fnamemodify(selection.path, ":p:h")
						-- require("telescope.actions").close(prompt_bufnr)

						-- print("lcd to " .. dir)
						-- Depending on what you want put `cd`, `lcd`, `tcd`
						vim.cmd(string.format("silent lcd %s", dir))
					end,
				},
			},
		}
	end,
	getPickers = function(opts)
		local conf = require("telescope.config").values
		local finders = require("telescope.finders")
		local pickers = require("telescope.pickers")
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")
		local action_utils = require("telescope.actions.utils")

		local session_pickers = function()
			local session_dir = vim.g.startify_session_dir or "~/.config/session"
			-- Logic to handle session previews using the session directory
			-- You can customize this to display session information or previews
			-- Example: Display session files in the specified directory
			local results = {}
			--
			-- for file in io.popen('ls ' .. session_dir):lines() do
			-- find to format output as filename only not the full path
			--p[[:alnum:]_].*find $(pwd) -name '
			--for more format see man re_format
			for file in
				io.popen(
					"find "
						.. session_dir
						.. ' -maxdepth 1 -type f -name "[[:alpha:][:digit:]][[:alnum:]_]*" -exec basename {} +'
				):lines()
			do
				-- file that starts with alpahnumerical
				table.insert(results, { value = file })
			end

			-- add key map for loadding with SLoad when press C-enter
			-- actions.select_default:replace(function(prompt_bufnr)
			--  local entry = actions.get_selected_entry(prompt_bufnr)
			--  if entry this_offset_encoding
			--

			-- Return the results for display in Telescope
			return pickers
				.new(opts, {
					prompt_title = "Startify Sessions",
					attach_mappings = function(prompt_bufnr, map)
						actions.select_default:replace(function()
							local selection = action_state.get_selected_entry()

							if selection then
								vim.cmd("SLoad " .. selection.value)
							end
						end)
						map("i", "<C-CR>", function(_prompt_bufnr)
							local entry = action_state.get_selected_entry()
							if entry then
								vim.cmd("SLoad " .. entry.value)
							end
						end)

						local saveSession = function(_prompt_bufnr)
							local picker = action_state.get_current_picker(_prompt_bufnr)
							local firstMultiSelection = picker:get_multi_selection()[1]

							local current_line = action_state.get_current_line()
							-- trim right the current_line
							current_line = current_line:gsub("%s+$", "")

							local session_name = firstMultiselection or current_line

							if firstMultiSelection then
								print("Save session from first multi selected " .. firstMultiSelection.value)
							else
								print("Save session from input prompt .. " .. current_line)
							end

							if current_line ~= "" then
								vim.cmd("SSave! " .. session_name)
							end
						end

						map("i", "<C-s>", function()
							saveSession(prompt_bufnr)
						end)
						map("n", "<C-s>", function()
							saveSession(prompt_bufnr)
						end)
						map("n", "X", function()
							local entry = action_state.get_selected_entry()
							-- confirming

							local user_input = vim.fn.confirm("Confirm Delete Session" .. entry.value, "yesno", 2)
							if user_input == 1 then
								vim.cmd("SDelete! " .. entry.value)
								-- local picker = action_state.get_current_picker(_prompt_bufnr)
								-- picker.refresh()
							end
						end)

						--- end ---
						return true
					end,
					finder = finders.new_table({
						results = results,
						entry_maker = function(entry)
							return {
								display = entry.value,
								value = entry.value,
								ordinal = entry.value,
							}
						end,
					}),
					sorter = conf.generic_sorter(opts),
					-- })
				})
				:find()
			-- return require("telescope").register_extension{
			--   exports = { startify = session_picker }
			-- }
		end

		local test_pickers = function()
			local results = {
				{ value = "test1" },
				{ value = "test2" },
				{ value = "test3" },
				{ value = "start1" },
			}

			return pickers
				.new(opts, {
					prompt_title = "Test Picker",
					finder = finders.new_table({
						results = results,
						entry_maker = function(entry)
							return {
								display = entry.value,
								value = entry.value,
								ordinal = entry.value,
							}
						end,
					}),
					sorter = conf.generic_sorter(opts),
					attach_mappings = function(prompt_bufnr, map)
						actions.select_default:replace(function()
							local selection = action_state.get_selected_entry()

							if selection then
								print("Entered on : " .. selection.value)
							end
						end)
						map("i", "<C-s>", function(_prompt_bufnr)
							print("Saving")
							local entry = action_state.get_selected_entry()
							print("cursor entry = " .. entry.value)
							local picker = action_state.get_current_picker(_prompt_bufnr)
							print("===========DEBUG ===========")
							print("Get multi selection")
							local selections_multi = picker:get_multi_selection()
							local num_selections = table.getn(selections_multi)
							print(num_selections)
							print(vim.inspect(picker:get_multi_selection()))
							local firstMultiSelection = picker:get_multi_selection()[1]
							print(vim.inspect(firstMultiSelection))

							print("current line: " .. action_state.get_current_line())

							local prompt_bufnr2 = vim.api.nvim_get_current_buf()
							print(prompt_bufnr .. " _pbn: " .. _prompt_bufnr .. " pbuf2: " .. prompt_bufnr2)

							local current_line = action_state.get_current_line()
							-- trim right the current_line
							current_line = current_line:gsub("%s+$", "")

							print(" MAP SELECTION ")
							action_utils.map_selections(_prompt_bufnr, function(entry)
								print(entry.value)
							end)

							print(" MAP ENTRIES")
							action_utils.map_entries(prompt_bufnr2, function(entry, index, row)
								print(entry.value .. " idx:" .. index .. " row:" .. row)
							end)
						end)
						return true
					end,
				})
				:find()
		end
		return {
			session_pickers = session_pickers,
			test_pickers = test_pickers,
		}
	end,
}

return M
