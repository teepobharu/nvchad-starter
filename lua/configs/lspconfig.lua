-- original settings import from https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/configs/lspconfig.lua
--
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvchad/lsp/init.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/configs/lspconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/plugins/init.lua#L59
-- youtube config lesson : https://www.youtube.com/watch?v=NL8D8EkphUw&ab_channel=JoseanMartinez
--  Origin:   https://github.com/josean-dev/dev-environment-files/blob/main/.config/nvim/lua/josean/plugins/lsp/lspconfig.lua
--
local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities
local lspconfig = require("lspconfig")

-- main setup + config lua_ls
require("nvchad.configs.lspconfig").defaults()

local servers = {
	"html",
	"cssls",
	"tsserver",
	"clangd",
	-- "pylsp", -- python-lsp-server
	"pyright",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end
--
-- specfic language setup
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
lspconfig.omnisharp.setup({
	-- cmd = { "dotnet", "/path/to/omnisharp/OmniSharp.dll" },
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "/usr/bin/omnisharp", "--languageserver" },
	filetypes = { "cs" },
	root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", "Directory.Build.props"),
})

-- key map

local keymap = vim.keymap -- for conciseness
local opts = { noremap = true, silent = true }
opts.desc = "Telescope References"
keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

-- set keybinds
opts.desc = "LSP References"
keymap.set("n", "gr", "vim.lsp.buf.references", opts) -- show definition, references

opts.desc = "Go to declaration"
keymap.set("n", "gd", vim.lsp.buf.declaration, opts) -- go to declaration

opts.desc = "Show LSP definitions"
keymap.set("n", "gD", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

opts.desc = "Show LSP implementations"
keymap.set("n", "gI", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

opts.desc = "Show LSP type definitions"
keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

opts.desc = "Show buffer diagnostics"
keymap.set("n", "<leader>ld", "<cmd>Telescope diagnostics <CR>", opts) -- show  diagnostics for file

opts.desc = "Show line diagnostics"
keymap.set("n", "<leader>lD", vim.diagnostic.open_float, opts) -- show diagnostics for line
opts.desc = "Show file diagnostics"
keymap.set("n", "<leader>lD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show diagnostics for line

opts.desc = "Go to previous diagnostic"
keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

opts.desc = "Go to next diagnostic"
keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

opts.desc = "See available code actions"
keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

-- vim.api.nvim_del_keymap('n', '<leader>rn')
--  NVChad mappings: https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/configs/lspconfig.lua#L11
--  attach mapping to each buffer separately in opts
--  why NVCHAD keymaps not get overriden ??? 
local map = keymap.set -- for nvchad mappings / reuse - override

opts.desc = "LSP rename"
map("n", "<leader>ra", vim.lsp.buf.rename, opts) -- rename symbol under cursor
-- keymap.set("n", "<leader>ra")
-- wl - worklist folder list
-- wa add workfolder
-- sh show signature
-- K hover signature
-- gi go implementation

opts.desc = "Go Implementation"
map("n", "gi", vim.lsp.buf.implementation, opts)
opts.desc = "NvC Renamer"
map("n", "<leader>R", function()
	require("nvchad.lsp.renamer")()
end, opts)
