local overrides = require("configs.overrides")
local vkey = vim.keymap
local utils = require("utils")
-- vim.g.maplocalleader = ","
local key_opts = { noremap = true, silent = true }
local map = vim.keymap.set

-- local function combined_dict(dict1, dict2)
--   return vim.tbl_extend("keep", dict1, dict2)
-- end

local mappingFunction = { }

mappingFunction.close_preview = function(prompt_bufnr)
  local telescope_state = require('telescope.actions.state')
  local current_picker = telescope_state.get_current_picker(prompt_bufnr)
  current_picker:close_preview()
end

mappingFunction.lcd_preview = function(prompt_bufnr)
  local telescope_state = require('telescope.actions.state')
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
    }
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
--   {
    -- "neovim/nvim-lspconfig",
    -- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/configs/lspconfig.lua
    -- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/plugins/init.lua#L59
--   },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = {
        -- ensure_installed will loop and assign in let g:mason_installed - the nwill get installed when use :MasonInstallAll
        ensure_installed = {
          "lua-language-server",
          "html-lsp",
          -- "prettier",
        --  "html-lsp",
        --   "stylua"
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
        
--         config.ensure_installed = utils.combineUniqueLists(config.ensure_installed, ensure_installed);
--         print(config)
--         return config
--     end,
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
  { 'alexghergh/nvim-tmux-navigation', lazy=false, config = function()
    local nvim_tmux_nav = require('nvim-tmux-navigation')

    nvim_tmux_nav.setup {
        disable_when_zoomed = true -- defaults to false
    }
  end
  },
  {
    "hrsh7th/nvim-cmp",

    -- https://github.com/NvChad/NvChad/issues/2332
    -- config = function()
    --   local cmp = require("cmp")
    --   mapping = {
    --
    --     ["<C-p>"] = cmp.mapping.select_prev_item(),
    --     ["<C-n>"] = cmp.mapping.select_next_item(),
    --     ["<C-e>"] = cmp.mapping.close(),
    --     ["<CR>"] = cmp.mapping.confirm({
    --       behavior = cmp.ConfirmBehavior.Replace,
    --       select = true,
    --     }),
    -- }
    -- end,
    -- broked the c-space
    opts = function()
      local cmp = require("cmp")
      local cmp_conf = require "nvchad.configs.cmp"
      -- table.insert(cmp_conf.sources, { name = "copilot"})
      --       table.insert(cmp_conf.mapping, {
      --         ["<C-j>"] = cmp.mapping.select_next_item(),
      --         ["<C-k>"] = cmp.mapping.select_prev_item(),
      --         ["<Esc>"] = cmp.mapping.abort(),
      -- })
      -- merge mapping deep by copiolt
      cmp_conf.mapping = utils.combine_dicts(cmp_conf.mapping, {
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<Esc>"] = cmp.mapping.abort(),
        ["<C-Space>"] = cmp.mapping.abort(), -- does not replace the original mapping
      })
      return cmp_conf
    end,
    --
  },
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g['copilot_no_tab_map'] = true
      vim.api.nvim_set_keymap('i', '<C-/>', 'copilot#Acceptt("\\<CR>")', {expr=true, silent=true})
    end,
    keys = {
      -- mapping source : https://www.reddit.com/r/neovim/comments/qsfvki/how_to_remap_copilotvim_accept_method_in_lua/
      --
      -- { "<leader>c.", { "", mode = "i"}, desc = "Copilot next" },
      -- { "<leader>c,", { "", mode = "i"}, desc = "Copilot prev" },
      -- { "<leader>c,", { 'copilot#Accept(“<CR>”)', mode = "i" } },
      -- { "<C-e>", { 'copilot#Accept(“<CR>”)', mode = "i" }, desc = "Copilot accept" },
      -- sample with mode settings => https://github.com/LazyVim/LazyVim/blob/566049aa4a26a86219dd1ad1624f9a1bf18831b6/lua/lazyvim/plugins/coding.lua#L28C44-L28C44
      --
      -- { "<C-/>", 'copilot#Accept("<CR>")', { mode = "i",  desc = "Copilot accept", silent = true, expr = true }},
      { "<C-E>",
        function()
          -- vim.fn("copilot#Accept(“<CR>”)")
          vim.fn["copilot#Accept"]("<CR>")
        end, mode = "i" ,  desc = "Copilot accept", expr = true, silent = true},
      -- { "<C-a>", { "<C-x>", mode = "n" } },
      { "<leader>ce", "<cmd>Copilot panel<cr>”)", desc = "Copilot suggest" }, 
    }
  },
  {
    "mhinz/vim-startify",
    lazy = false,
    config = function()
      require('configs.startify')
      vkey.set('n', "<localleader>,", "<cmd>Startify<cr>", utils.combine_dicts(key_opts, {desc = "Startify"}))
      vkey.set('n', "<leader>,", "<cmd>Startify<cr>", utils.combine_dicts(key_opts, {desc = "Startify"}))
    end,
  },

  {
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
        ["<leader>g"] = { "~Git"},
        ["<leader>m"] = { "m mapping" },
        ["<leader>n"] = {name = "MY custom commands"}
        --
        --   ["<leader>nn"] = {
        --     "<cmd>source $MYVIMRC<CR>",
        --     "Source Config"
        --   },
        --   ["<leader>ns"] = {
        --     "<cmd>set number!<CR>",
        --     "Toggle Line Numbers"
        --   },
        -- },
        -- ["<leader>s"] = {
        --   "<cmd>Telescope find_files<CR>",
        --   "Telescope - Find Files"
        -- },
        -- ["<leader>S"] = {
        --   "<cmd>Save<CR>",
        --   "Save Session"
        -- },
      })
    end,
    -- keys = { "<localleader>"},
    -- keys = {  "<localleader>", "<leader>", '"', "'", "`", "c", "v", "g" },
  },
  {
    "nvim-telescope/telescope-z.nvim",
    -- no output
    -- https://github.com/nvim-telescope/telescope-z.nvim
    -- alternative 1
    -- https://github.com/jvgrootveld/telescope-zoxide/blob/main/lua/telescope/_extensions/zoxide/list.lua
    lazy = true,
    config = function()
      require("telescope").load_extension "z"
    end,
    opts = {
      cmd = { vim.o.shell, "-c", "zoxide query -l" },
    }
  },
  {
    "nvim-telescope/telescope.nvim",

    opts = function()
      local opts = require "nvchad.configs.telescope"
      local defaultOverride = {
          pickers = {
              find_files = {
                  mappings = {
                      n = {
                          -- does not work not sure 
                          -- ref example recipe
                          -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#file-and-text-search-in-hidden-files-and-directories
                          -- source code
                          -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua#L97
                        }
                    }
                },
            },
            
            -- https://github.com/nvim-telescope/telescope.nvim#default-mappings
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
                    ['<C-d>'] = require('telescope.actions').results_scrolling_down,
                    ['<C-u>'] = require('telescope.actions').results_scrolling_up,
                    -- ['<c-d>'] = require('telescope.actions').delete_buffer,
                },
                -- When the search text is focused 
                n = {
                    -- name appear when hit ? but not exectuable
                    -- ["<esc>"] = mappingFunction.close_preview,
                    -- ["cd"] = mappingFunction.lcd_preview,
                    ['X'] = require('telescope.actions').delete_buffer,
                    ['J'] = require('telescope.actions').results_scrolling_down,
                    ['K'] = require('telescope.actions').results_scrolling_up,
                    ['<C-d>'] = require('telescope.actions').results_scrolling_down,
                    ['<C-u>'] = require('telescope.actions').results_scrolling_up,
                    
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
                    end
                },
            },
        }
        opts.defaults = vim.tbl_deep_extend('force', opts.defaults, defaultOverride)


      local custom_pickers = overrides.telescope.getPickers()
      -- " Custom pickers loadded in mymappings.lua
      -- Extensions 
      -- extension nvchad example: https://github.com/NvChad/ui/blob/5a910659cffebf9671d0df1f98fb159c13ee9152/lua/telescope/_extensions/themes.lua

        -- import ext: https://github.com/NvChad/NvChad/blob/2e54fce0281cee808c30ba309610abfcb69ee28a/lua/nvchad/configs/telescope.lua#L52
        -- import lazy: https://github.com/NvChad/NvChad/blob/2e54fce0281cee808c30ba309610abfcb69ee28a/lua/nvchad/plugins/init.lua#L147
      
      -- opts.extensions_list = utils.combineUniqueLists(opts.extensions_list, {'startify'})

        -- print(vim.inspect(opts))

        return opts
    end,
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
}

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

