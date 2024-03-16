-- ref = nvimChad2/nvim/mappings.lua
---@type MappingsTable
local M = {}

M.general = {
  i = { 
    [ "<A-j>" ] = { "<esc><cmd>m .+1<cr>==gi", "Move down" },
    [ "<A-k>" ] = { "<esc><cmd>m .-2<cr>==gi", "Move up" },
  },
  n = {
    -- move to custom map 
    -- [ "<Up>" ] =  { ":resize -10<CR>", opts = { silent = true }},
    -- [ "<Down>" ] =  { ":resize +10<CR>", opts = { silent = true }},
    -- [ "<Left>" ] =  { ":vertical resize -10<CR>", opts = { silent = true }},
    -- [ "<Right>" ] =  { ":vertical resize +10<CR>", opts = { silent = true }},
    -- [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<C-S-Left>"] = { "<C-W>+", "Resize window up +2" },
    ["<C-S-Right>"] = { "<C-W>-", "Resize window down -2" },
    [ "<A-k>" ] = { ":m .-2<cr>==", "Move up" },
    [ "<A-j>" ] = { ":m .+1<cr>==", "Move " },
    [",c"] = { ":lcd%:p:h <CR>", "CD to current dir"},
  },
  t = {
    -- ["<C-h>"] = { "<C-w>h", "Window left" },
    -- ["<C-l>"] = { "<C-w>l", "Window right" },
    -- ["<C-j>"] = { "<C-w>j", "Window down" },
    -- ["<C-k>"] = { "<C-w>k", "Window up" },
  },
  v = {
    [ "<A-j>" ] = { ":m '>+1<cr>gv=gv", "Move down" },
    [ "<A-k>" ] = { ":m '<-2<cr>gv=gv", "Move up" }, 
    [ ">" ] = { ">gv", "Better Indent right" },
    [ "<" ] = { "<gv", "Better Indent left" },
    ["//"] = { "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>", "Search selected visual" },
  },
  -- x = {

  -- }
}

-- more keybinds!

M.disabled = {
  n = {
    ["<leader>h"] = "",
    ["<A-h>"] = "",
    ["gx"] = "",
  }
}

M.nvimtree = {
  plugin = true,
  n = {
    ["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
  }
}

M.nvterm = {
  plugin = true,

  t = {
    -- toggle in terminal mode
    ["<A-i>"] = {
      ""
      -- function()
      -- require("nvterm.terminal").toggle "float"
      -- end,
      -- "Toggle floating term",
    },
    ["<F1>"]= {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "Toggle floating term",
    },
    ["<A-h>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle horizontal term",
    },

    ["<A-v>"] = {
      function()
        require("nvterm.terminal").toggle "vertical"
      end,
      "Toggle vertical term",
    },
  },

  n = {
    -- toggle in normal mode
    ["<F1>"]= {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "Toggle floating term",
    },
    ["<A-i>"] = {
      ""
      -- function()
      --   require("nvterm.terminal").toggle "float"
      -- end,
      -- "Toggle floating term",
    },

    ["<A-h>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle horizontal term",
    },

    ["<A-v>"] = {
      function()
        require("nvterm.terminal").toggle "vertical"
      end,
      "Toggle vertical term",
    },

    -- new
    ["<leader>th"] = {
      function()
        require("nvterm.terminal").new "horizontal"
      end,
      "New horizontal term",
    },

    ["<leader>tv"] = {
      function()
        require("nvterm.terminal").new "vertical"
      end,
      "New vertical term",
    },
  },
}


M.telescope = {
  plugin = true,

  n = {
    ["<leader>fr"] = { 
      function()
        require('telescope.builtin').lsp_references()
      end
      ,"LSP Find References" },

    ["<leader>fg"] = {
      function()
        local is_inside_work_tree = {}
        local opts = {} -- define here if you want to define something

        local cwd = vim.fn.getcwd()
        if is_inside_work_tree[cwd] == nil then
          vim.fn.system("git rev-parse --is-inside-work-tree")
          is_inside_work_tree[cwd] = vim.v.shell_error == 0
        end

        if is_inside_work_tree[cwd] then
          builtin.git_files(opts)
        else
          builtin.find_files(opts)
        end
      end
      ,"LSP Find Files Git"

    }
  }
}

M.whichkey = {
  plugin = true,
  n = {
    ["<leader>n"] = {
      "",
      "+CustomCommands"
    },
    ["<leader>nn"] = {
      "<cmd>so $MYVIMRC<CR>",
      "Source Config"
    },
    ["<leader>ns"] = {
      "",""
    },
    ["<leader>s"] = {
      "<cmd>Telescope<CR>",
      "Telescope"
    },
    ["<leader>S"] = {
      "<cmd>SSave<CR>",
      "Save Session"
    },
  }
}


M.gitsigns = {
  plugin = true,
  n = {
    -- Navigation through hunks
    ["<C-S-j>"] = {
      function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          require("gitsigns").next_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to next hunk",
      opts = { expr = true },
    },

    ["<C-S-k>"] = {
      function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          require("gitsigns").prev_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to prev hunk",
      opts = { expr = true },
    },

    -- Actions
    ["<M-z>"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "Reset hunk",
    },
    ["<leader>gr"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "Reset hunk",
    },
    ["<leader>gd"] = {
      function()
        require("gitsigns").diffthis()
      end,
      "Diff this"
    }
  }
}

return M
