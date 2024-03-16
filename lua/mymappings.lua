local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

local keymap = vim.api.nvim_set_keymap
local map = vim.keymap.set

-- Setup keys 
-- check using :letmapleader or :let maplocalleader
-- -> need to put inside plugins mapping also to make it work on those mapping
-- vim.g.maplocalleader = ","
-- HANDLE TAB TIPS in lua : https://github.com/nanotee/nvim-lua-guide#tips-4
-- Debug

map('n', '<Leader>nm', [[:redir @a<CR>:messages<CR>:redir END<CR>:put! a<CR>]], { noremap = true, silent = true, desc = 'Print messages' })


-- Resize with arrows
map("n", "<C-Up>", ":resize -2<CR>", opts)
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Resize with ESC keys - up down use for auto cmpl
map({"n" }, "<Up>", ":resize -2<CR>", opts)
map({"n" }, "<Down>", ":resize +2<CR>", opts)
map({"n"}, "<Left>", "<cmd>vertical resize -2<CR>", opts)
map({"n"}, "<Right>", "<cmd>vertical resize +2<CR>", opts)

-- Tmux navigation
-- keymap("nvt", "<C-l>", "<cmd>TmuxNavigateLeft<cr>", opts)
-- keymap("nv", "<C-j>", "<cmd>TmuxNavigateUp<cr>")
-- keymap("n", "<C-k>", "<cmd>TmuxNavigateDown<cr>")
-- keymap("t", "<C-k>", "<cmd>TmuxNavigateDown<cr>")
-- keymap("t", "<C-j>", "<cmd>TmuxNavigateDown<cr>")

map({"n" ,"t" ,"v"}, "<C-k>", "<cmd>TmuxNavigateUp<cr>")
map({"n" ,"t" ,"v"}, "<C-j>", "<cmd>TmuxNavigateDown<cr>")
map({"n" ,"t" ,"v"}, "<C-h>", "<cmd>TmuxNavigateLeft<cr>")
map({"n" ,"t" ,"v"}, "<C-l>", "<cmd>TmuxNavigateRight<cr>")
-- map("t", "<C-k>", "<cmd>TmuxNavigateUp<cr>")
-- map("t", "<C-j>", "<cmd>TmuxNavigateDown<cr>")

-- ========================
-- TO BE MIGRATED ============
-- =====================
--
-- Menu navigation
-- Set the variable g:copilot_no_tab_map to true.
vim.g.copilot_no_tab_map = true
-- imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
-- let g:copilot_no_tab_map = v:true
-- same output as using vim but not able to complete ?
-- keymap('i', '<C-/>', 'copilot#Accept("\\<CR>")', {expr=true, silent=true, script=true, desc="copilot Accept" })
-- keymap('i', '<C-J>', 'copilot#Accept("\\<CR>")', {expr=true, silent=true, script=true, desc="Copilot Accept"})

-- " THE EXISTING Key bindings cannot be remap again"
-- C-J, C-E cannot be used to map again
-- vim cmd works but map will have some weird char after hit enter / accept 

vim.cmd([[
  " imap <silent><expr> <C-J> copilot#Accept("\<CR>")
  " imap <silent><expr> <C-e> copilot#Accept("\<CR>")
  " imap <silent><expr> <C-E> copilot#Accept("\<CR>")
  imap <silent><expr> <C-o> copilot#Accept("\<CR>")  " working
  " imap <silent><expr> <C-/> copilot#Accept("\<CR>")
  let g:copilot_no_tab_map = v:true
]])



-- map("i", "<C-j>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

-- map("i", "<C-o>", 'copilot#Accept()', { noremap = true, silent = true, expr = true })
-- keymap("c", "<C-j>",  'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } )
-- keymap("c", "<C-k>",  'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } )

-- My mappings from Chadv2

map('i', 'jk', '<ESC>', { desc = "Escape insert mode" })
map('n', '<C-S-Left>', '<C-W>+', { desc = "Resize window up +2" })
map('n', '<C-S-Right>', '<C-W>-', { desc = "Resize window down -2" })
map('n', '<A-k>', ':m .-2<cr>==', { desc = "Move up" })
map('n', '<A-j>', ':m .+1<cr>==', { desc = "Move down" })
map('n', ',c', ':lcd%:p:h <CR>', { desc = "CD to current dir" })

map('v', '<A-j>', ':m \'>+1<cr>gv=gv', { desc = "Move down" })
map('v', '<A-k>', ':m \'<-2<cr>gv=gv', { desc = "Move up" })
map('v', '>', '>gv', { desc = "Better Indent right" })
map('v', '<', '<gv', { desc = "Better Indent left" })
map('v', '//', 'y/\\V<C-R>=escape(@\",\'/\\\')<CR><CR>', { desc = "Search selected visual" })

map('n', '<leader>fr', function()
    require('telescope.builtin').lsp_references()
end, { desc = "LSP Find References" })

map('n', '<leader>fg', function()
    local is_inside_work_tree = {}
    local opts = {} -- define here if you want to define something

    local cwd = vim.fn.getcwd()
    if is_inside_work_tree[cwd] == nil then
        vim.fn.system("git rev-parse --is-inside-work-tree")
        is_inside_work_tree[cwd] = vim.v.shell_error == 0
    end

    if is_inside_work_tree[cwd] then
        require('telescope.builtin').git_files(opts)
    else
        require('telescope.builtin').find_files(opts)
    end
end, { desc = "LSP Find Files Git" })

map('n', '<leader>n', "", { desc = "+CustomCommands" })
map('n', '<leader>nn', "<cmd>so $MYVIMRC<CR>", { desc = "Source Config" })
map('n', '<leader>s', "<cmd>Telescope<CR>", { desc = "Telescope" })
map('n', '<leader>S', "<cmd>SSave<CR>", { desc = "Save Session" })

-- Git signs
  map('n', '<C-S-j>', function()
      if vim.wo.diff then
          return "]c"
      end
      vim.schedule(function()
          require("gitsigns").next_hunk()
      end)
      return "<Ignore>"
  end, { desc = "Jump to next hunk", expr = true })

  map('n', '<C-S-k>', function()
      if vim.wo.diff then
          return "[c"
      end
      vim.schedule(function()
          require("gitsigns").prev_hunk()
      end)
      return "<Ignore>"
  end, { desc = "Jump to prev hunk", expr = true })
  map('n', '<M-z>', function()
      require("gitsigns").reset_hunk()
  end, { desc = "Reset hunk" })

  map('n', '<leader>gr', function()
      require("gitsigns").reset_hunk()
  end, { desc = "Reset hunk" })

  map('n', '<leader>gd', function()
      require("gitsigns").diffthis()
  end, { desc = "Diff this" })

-- Fugitive
-- 
-- fugitive
  map("n", "<leader>gg", ":Git<cr>", {silent = true})
  map("n", "<leader>ga", ":Git add %:p<cr><cr>", {silent = true})
  map("n", "<leader>gd", ":Gdiff<cr>", {silent = true})
  map("n", "<leader>ge", ":Gedit<cr>", {silent = true})
  map("n", "<leader>gw", ":Gwrite<cr>", {silent = true})
  map("n", "<leader>gf", ":Commits<cr>", {silent = true})

    -- map('n', '<leader>gs', '<cmd>Git<cr>', { desc = "Git Status" })
    -- map('n', '<leader>gb', '<cmd>Git blame<cr>', { desc = "Git Blame" })
    -- map('n', '<leader>gc', '<cmd>Git commit<cr>', { desc = "Git Commit" })
    -- map('n', '<leader>gd', '<cmd>Git diff<cr>', { desc = "Git Diff" })
    -- map('n', '<leader>gl', '<cmd>Git log<cr>', { desc = "Git Log" })
    -- map('n', '<leader>gp', '<cmd>Git push<cr>', { desc = "Git Push" })
    -- map('n', '<leader>gr', '<cmd>Git rebase<cr>', { desc = "Git Rebase" })
