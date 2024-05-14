local overrides = require("configs.overrides")
local myutils = require("myutils")
-- vim.g.maplocalleader = ","
local map = vim.keymap.set

-- local function combined_dict(dict1, dict2)
--   return vim.tbl_extend("keep", dict1, dict2)
-- end

local mappingFunction = {}

mappingFunction.close_preview = function(prompt_bufnr)
	local telescope_state = require("telescope.actions.state")
	local current_picker = telescope_state.get_current_picker(prompt_bufnr)
	current_picker:close_preview()
end

mappingFunction.lcd_preview = function(prompt_bufnr)
	local telescope_state = require("telescope.actions.state")
	local current_picker = telescope_state.get_current_picker(prompt_bufnr)
	current_picker:lcd_preview()
end

---@type NvPluginSpec[]
local plugins = {
	-- Override plugin definition options
	{
		"tpope/vim-fugitive",
		lazy = false,
		-- maximum productivity with git and diff =  https://www.youtube.com/watch?v=57x4ZzzCr2Y&ab_channel=SeniorMars
		-- source code : https://github.com/SeniorMars/dotfiles/blob/master/.config/nvim/init.lua#L962
	},
	{},
	{},
	{
		"justinmk/vim-sneak",
		lazy = true,
		event = "InsertEnter",
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
		},
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = "User FilePost",
		-- event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("configs.lspconfig")
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = {
			-- ensure_installed will loop and assign in let g:mason_installed - the nwill get installed when use :MasonInstallAll
			ensure_installed = {
				"lua-language-server",
				"stylua",
				"html-lsp",
				"pyright",
				"typescript-language-server",
				"omnisharp",
				"autopep8",
				-- "prettier",
				--  "html-lsp",
			},
		},
		--    opts = function()
		--        config = require("nvchad.configs.mason")
		--        ensure_installed = {
		--            -- lua stuff
		--            "lua-language-server",
		--            "stylua",

		--            -- web dev stuff
		--            "css-lsp",
		--            "html-lsp",
		--            "typescript-language-server",
		--            "deno",
		--            "prettier",
		--        }
		--        -- merge ensure_install key

		--         config.ensure_installed = myutils.combineUniqueLists(config.ensure_installed, ensure_installed);
		--         print(config)
		--         return config
		--     end,
	},
	{
		"dhruvasagar/vim-table-mode",
		event = "VeryLazy",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
	},
	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},

	-- Install a plugin
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},
	-- https://github.com/alexghergh/nvim-tmux-navigation?tab=readme-ov-file#configuration
	{
		"alexghergh/nvim-tmux-navigation",
		lazy = false,
		config = function()
			local nvim_tmux_nav = require("nvim-tmux-navigation")

			nvim_tmux_nav.setup({
				disable_when_zoomed = true, -- defaults to false
			})
		end,
	},
	{
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
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			-- https://github.com/nvim-telescope/telescope-ui-select.nvim
			local t = require("telescope")
			t.setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})

			t.load_extension("ui-select")
		end,
	},
	{
		"jvgrootveld/telescope-zoxide",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local t = require("telescope")
			local z_utils = require("telescope._extensions.zoxide.utils")
			-- Configure telescope-zoxide
			t.setup({
				extensions = {
					zoxide = {
						prompt_title = "Zoxide ~ CD",
						mappings = {
							default = {
								after_action = function(selection)
									print("Update to (" .. selection.z_score .. ") " .. selection.path)
								end,
							},
							["<C-s>"] = {
								before_action = function(selection)
									-- print("before C-s")
								end,
								action = function(selection)
									vim.cmd.edit(selection.path)
								end,
							},
							["<C-q>"] = {
								action = z_utils.create_basic_command("split"),
							},
						},
					},
				},
				-- https://github.com/jvgrootveld/telescope-zoxide?tab=readme-ov-file
			})
			-- t.load_extension("zoxide") -- please add inside telescope instead
			map("n", "<leader>cd", t.extensions.zoxide.list, { desc = "Telescope Zoxide" })
		end,
	},
	-- {
	-- 	"nvim-telescope/telescope-z.nvim",
	-- 	-- no output
	-- 	-- https://github.com/nvim-telescope/telescope-z.nvim
	-- 	-- alternative 1
	-- 	-- https://github.com/jvgrootveld/telescope-zoxide/blob/main/lua/telescope/_extensions/zoxide/list.lua
	--
	-- 	lazy = true,
	-- 	config = function()
	-- 		require("telescope").load_extension("z")
	-- 	end,
	-- 	opts = {
	-- 		cmd = { vim.o.shell, "-c", "zoxide query -l" },
	-- 	},
	-- },
	{
		"nvim-telescope/telescope.nvim",
		-- import lazy: https://github.com/NvChad/NvChad/blob/2e54fce0281cee808c30ba309610abfcb69ee28a/lua/nvchad/plugins/init.lua#L147
		-- import ext: https://github.com/NvChad/NvChad/blob/2e54fce0281cee808c30ba309610abfcb69ee28a/lua/nvchad/configs/telescope.lua#L52
		opts = function()
			local opts = require("nvchad.configs.telescope")
			local defaultOverride = overrides.telescope.getOptions()
			opts.extensions_list = myutils.combineUniqueLists(opts.extensions_list, { "zoxide", "ui-select" })

			opts.defaults = vim.tbl_deep_extend("force", opts.defaults, defaultOverride)

			--  " Custom pickers loadded in mymappings.lua

			-- Extensions
			-- extension nvchad example: https://github.com/NvChad/ui/blob/5a910659cffebf9671d0df1f98fb159c13ee9152/lua/telescope/_extensions/themes.lua

			-- print(vim.inspect(opts))

			return opts
		end,
	},
}

-- To make a plugin not be loaded
-- {
--   "NvChad/nvim-colorizer.lua",
--   enabled = false
-- },

-- All NvChad plugins are lazy-loaded by default
-- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
-- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
-- {
--   "mg979/vim-visual-multi",
--   lazy = false,
-- }

-- call plug#begin('~/.config/nvim/autoload/plugged')

--   Plug 'github/copilot.vim'
--   " Change dates fast
--   Plug 'tpope/vim-speeddating'
--   " Convert binary, hex, etc..
--   Plug 'glts/vim-radical'
--   " Files
--   Plug 'tpope/vim-eunuch'
--   " Repeat stuff
--   Plug 'tpope/vim-repeat'
--   " Surround
--   Plug 'tpope/vim-surround'
--   " Better Comments
--   Plug 'tpope/vim-commentary'
--   " Key for faster navigationns [q
--   Plug 'tpope/vim-unimpaired'
--   " Plug 'preservim/nerdcommenter'
--   " Have the file system follow you around
--   Plug 'airblade/vim-rooter'
--   " auto set indent settings
--   Plug 'tpope/vim-sleuth'

--   if exists('g:vscode')
--     " Easy motion for VSCode
--     Plug 'asvetliakov/vim-easymotion'

--   else
--     " Text Navigation
--     Plug 'justinmk/vim-sneak'
--     " Plug 'unblevable/quick-scope'
--     Plug 'easymotion/vim-easymotion'
--     " Add some color
--     Plug 'norcalli/nvim-colorizer.lua'
--     Plug 'junegunn/rainbow_parentheses.vim'
--     " Better Syntax Support
--     Plug 'sheerun/vim-polyglot'
--     " Cool Icons
--     Plug 'ryanoasis/vim-devicons'
--     " Auto pairs for '(' '[' '{'
--     Plug 'jiangmiao/auto-pairs'
--     " Closetags
--     Plug 'alvan/vim-closetag'
--     " Themes
--     " Plug 'christianchiarulli/onedark.vim'
--     Plug 'joshdick/onedark.vim'
--     Plug 'kaicataldo/material.vim'
--     Plug 'NLKNguyen/papercolor-theme'
--     Plug 'tomasiser/vim-code-dark'
--     " Intellisense
--     Plug 'neoclide/coc.nvim', {'branch': 'release'}
--     " Status Line
--     Plug 'vim-airline/vim-airline'
--     Plug 'vim-airline/vim-airline-themes'
--     " Ranger
--     " Plug 'francoiscabrol/ranger.vim'
--     Plug 'rbgrouleff/bclose.vim'
--     " Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}
--     " FZF
--     Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
--     Plug 'junegunn/fzf.vim'
--     " Git
--     Plug 'mhinz/vim-signify'
--     Plug 'airblade/vim-gitgutter'
--     Plug 'tpope/vim-fugitive'
--     Plug 'idanarye/vim-merginal'
--     Plug 'tpope/vim-rhubarb'
--     Plug 'junegunn/gv.vim'
--     Plug 'stsewd/fzf-checkout.vim'
--     " Terminal
--     Plug 'voldikss/vim-floaterm'
--     " Start Screen
--     Plug 'mhinz/vim-startify'
--     " Vista
--     Plug 'liuchengxu/vista.vim'
--     " See what keys do like in emacs
--     Plug 'liuchengxu/vim-which-key'
--     " Zen mode
--     Plug 'junegunn/goyo.vim'
--     " Making stuff
--     Plug 'neomake/neomake'
--     " Snippets
--       " Plug 'honza/vim-snippets' " Disable on 2023-05-19  coc-snippets already worked
--       Plug 'mattn/emmet-vim'
--     " Better Comments
--     " Plug 'jbgutierrez/vim-better-comments'
--     " Echo doc
--     " Plug 'Shougo/echodoc.vim'
--     " Interactive code
--     " Plug 'ChristianChiarulli/codi.vim' " Not working anymore
--     Plug 'metakirby5/codi.vim'
--     " Vim Wiki
--     Plug 'https://github.com/vimwiki/vimwiki.git'

--     " == My extra ==
--     " Buffer Management
--     Plug 'vim-ctrlspace/vim-ctrlspace'
--     " Omni sharp
--     " Plug 'OmniSharp/omnisharp-vim
--     " Plug 'scrooloose/nerdtree'
--     Plug 'houtsnip/vim-emacscommandline'
--     " Tmux vim switch integration
--     Plug 'christoomey/vim-tmux-navigator'
--     "HTML EMMET
--     Plug 'mattn/emmet-vim'
--     Plug 'AndrewRadev/tagalong.vim'
--   endif

return plugins
