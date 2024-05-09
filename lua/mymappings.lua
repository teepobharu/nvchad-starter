-- " Mapping guide
-- " Mapping References"
-- : nvchad: https://github.com/NvChad/NvChad/blob/2e54fce0281cee808c30ba309610abfcb69ee28a/lua/nvchad/mappings.lua
-- ====================================

local opts = { noremap = true, silent = true }
-- local keymap = vim.api.nvim_set_keymap
local map = vim.keymap.set
local overrides = require("configs.overrides")

-- Setup keys
-- check using :letmapleader or :let maplocalleader
-- -> need to put inside plugins mapping also to make it work on those mapping
-- vim.g.maplocalleader = ","
-- Debug
map("n", "<leader>h", ":sp<CR>", { desc = "HSplit", silent = true })
map("n", "<leader>v", ":vs<CR>", { desc = "VSplit", silent = true })
map("n", "<M-Tab>", ":tabnext<CR>", { noremap = true, silent = true })

-- HANDLE tab cmp completion in lua : https://github.com/nanotee/nvim-lua-guide#tips-4
-- command completion
vim.cmd([[
  cnoremap <expr> <C-j> wildmenumode() ? "\<C-N>" : "\<C-j>"
  cnoremap <expr> <C-k> wildmenumode() ? "\<C-P>" : "\<C-k>"
]])

-- Resize with arrows
map("n", "<C-Up>", ":resize -2<CR>", opts)
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Resize with ESC keys - up down use for auto cmpl
map("n", "<Up>", ":resize -2<CR>", opts)
map("n", "<Down>", ":resize +2<CR>", opts)
map("n", "<Left>", "<cmd>vertical resize -2<CR>", opts)
map("n", "<Right>", "<cmd>vertical resize +2<CR>", opts)

local function toggle_fold_or_clear_highlight()
    if vim.fn.foldlevel('.') > 0 then
        vim.api.nvim_input('za')
    else
        vim.cmd('nohlsearch')
    end
end
map('n', '<Esc>', toggle_fold_or_clear_highlight, { expr = true, silent = true, noremap = true })

-- Duplicate line and preserve previous yank register
map('n', '<A-d>', function()
    local saved_unnamed = vim.fn.getreg('"')
    local saved_unnamedplus = vim.fn.getreg('+')
    local current_line = vim.fn.getline('.')
    -- Save previous yank registers in a safe place
    -- propmt inform to choose reg to save 
    -- print("Choose register to save")
    -- local temp_register = vim.fn.nr2char(vim.fn.getchar()) -- choose char 
    local temp_register = 'm'
    vim.fn.setreg(temp_register, saved_unnamed, 'a')
    vim.fn.setreg('"', current_line, 'a')
    vim.fn.setreg('+', current_line, 'a')
    -- Duplicate the current line
    -- vim.cmd('normal! yyp')
    vim.api.nvim_input('yyp')
    -- Restore previous yank registers
    vim.fn.setreg('"', saved_unnamed, 'a')
    vim.fn.setreg('+', saved_unnamedplus, 'a')
    vim.fn.setreg(temp_register, '', 'a')
end, { desc = 'Duplicate line and preserve yank register' })

vim.api.nvim_create_user_command("OpenTerminalInSplitWithCwd", function()
  local cwd = vim.fn.expand('%:p:h')

  vim.api.nvim_command('split | lcd ' .. cwd .. ' | terminal')
end, {})
map("n", "<Leader>t.", ":OpenTerminalInSplitWithCwd<CR>", { noremap = true, silent = true })


-- " Copy to system clipboard
-- vnoremap <leader>y "+y
-- nnoremap <leader>Y "+yg_
-- nnoremap <leader>y "+y
-- nnoremap <leader>yy "+yy
map("n", "Y", '"+y', { desc = "Copy to system clipboard" })
map("n", "YY", '"+yy', { desc = "Copy to system clipboard" })
map("v", "Y", '"+y', { desc = "Copy to system clipboard" })
map("v", "<C-c>", '"+y', { desc = "Copy to system clipboard" })

--
-- Tmux navigation - move to plugins config
--
map("n", "<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", opts)
map("n", "<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", opts)
map("n", "<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", opts)
map("n", "<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", opts)

map("t", "<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", opts)
map("t", "<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", opts)
map("t", "<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", opts)
map("t", "<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", opts)
-- nv2 config tmux - old function maper
-- keymap("nvt", "<C-l>", "<cmd>TmuxNavigateLeft<cr>", opts)
-- keymap("nv", "<C-j>", "<cmd>TmuxNavigateUp<cr>")
-- keymap("n", "<C-k>", "<cmd>TmuxNavigateDown<cr>")
-- keymap("t", "<C-k>", "<cmd>TmuxNavigateDown<cr>")
-- keymap("t", "<C-j>", "<cmd>TmuxNavigateDown<cr>")

-- map({"n" ,"t" ,"v"}, "<C-k>", "<cmd>TmuxNavigateUp<cr>")
-- map({"n" ,"t" ,"v"}, "<C-j>", "<cmd>TmuxNavigateDown<cr>")
-- map({"n" ,"t" ,"v"}, "<C-h>", "<cmd>TmuxNavigateLeft<cr>")
-- map({"n" ,"t" ,"v"}, "<C-l>", "<cmd>TmuxNavigateRight<cr>")
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

map("i", "jk", "<ESC>", { desc = "Escape insert mode" })
map("n", "<C-S-Left>", "<C-W>+", { desc = "Resize window up +2" })
map("n", "<C-S-Right>", "<C-W>-", { desc = "Resize window down -2" })
map("n", "<A-k>", ":m .-2<cr>==", { desc = "Move up" })
map("n", "<A-j>", ":m .+1<cr>==", { desc = "Move down" })
map("n", ",c", ":lcd%:p:h <CR>", { desc = "CD to current dir" })

map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })
map("v", ">", ">gv", { desc = "Better Indent right" })
map("v", "<", "<gv", { desc = "Better Indent left" })
map("v", "//", "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>", { desc = "Search selected visual" })

--==========================
-- TELESCOPE ---
--==========================
map("n", "<leader>ft", "<cmd>Telescope<CR>", { desc = "Telescope" })
map("n", "<leader>e", "<cmd>Telescope buffers<CR>", { desc = "Telescope Buffers" })
map("n", "<leader>fr", function()
	require("telescope.builtin").lsp_references()
end, { desc = "LSP Find References" })

map("n", "<leader>fg", function()
	local is_inside_work_tree = {}
	local opts = {} -- define here if you want to define something

	local cwd = vim.fn.getcwd()
	if is_inside_work_tree[cwd] == nil then
		vim.fn.system("git rev-parse --is-inside-work-tree")
		is_inside_work_tree[cwd] = vim.v.shell_error == 0
	end

	if is_inside_work_tree[cwd] then
		require("telescope.builtin").git_files(opts)
	else
		require("telescope.builtin").find_files(opts)
	end
end, { desc = "LSP Find Files Git" })

local custom_pickers = nil

local setCustomPickersAndRunPickers = function(cb)
	if not custom_pickers then
		print("Custom pickers not set")
		custom_pickers = overrides.telescope.getPickers()
	end
	custom_pickers[cb]()
end
--  =======================================
-- Other mappings for telescopes
-- =======================================
-- Telescope helper functions
local function is_git_repo()
    vim.fn.system("git rev-parse --is-inside-work-tree")

    return vim.v.shell_error == 0
end

local function get_git_root()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    return vim.fn.fnamemodify(dot_git_path, ":h")
end


function live_grep_from_project_git_root()
    local opts = {}
	if is_git_repo() then
		opts = {
			cwd = get_git_root(),
		}
	end
	require("telescope.builtin").live_grep(opts)
end

vim.api.nvim_create_user_command(
    'FindConfig',
    function ()
    -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#having-a-factory-like-function-based-on-a-dict - configure factory like dict differenet find cmds
    -- if current path is ~ only limit to depth = 1  with prompt = find HOME files include hidden files and folders 
        if vim.fn.getcwd() == vim.fn.expand("~") then
            require('telescope.builtin').find_files({prompt_title = "Find $HOME files", cwd="~", find_command = {'fd', '--type', 'f', '--hidden', '--max-depth', '1'}})
            return
        end
        require('telescope.builtin').find_files({prompt_title = "Find .Config files", cwd="~/.config"})
    end,
{})


-- Telescope custom pickers
map("n", "<leader>fs", function()
	setCustomPickersAndRunPickers("session_pickers")
end, { desc = "Startify Sessions" })
map("n", "<leader>nz", function()
	setCustomPickersAndRunPickers("test_pickers")
end, { desc = "Telescope Test Picker" })
map("n", "<leader>go", function()
	setCustomPickersAndRunPickers("open_git_pickers")
end, { desc = "Git Open remote" })
map("n", "<leader>fZ", "<cmd>FindConfig<CR>", { desc = "Find Config files" })
-- =============  GIT =============================
-- ===============================================
--
--  Sample workflow : https://www.youtube.com/watch?v=IyBAuDPzdFY&t=213s&ab_channel=DevOpsToolbox
--  gitsigns : https://github.com/lewis6991/gitsigns.nvim
--  fugitive :
--
-- ===============================
-- 1.  Git signs
-- ===============================
-- not work when inside tumx even no keys mapped ??
-- map('n', '<C-S-j>', function()
function gitsigns_jump_next_hunk()
	if vim.wo.diff then
		return "[c"
	end
	vim.schedule(function()
		require("gitsigns").next_hunk()
	end)
	return "<Ignore>"
end
function gitsigns_jump_prev_hunk()
	if vim.wo.diff then
		return "[c"
	end
	vim.schedule(function()
		require("gitsigns").prev_hunk()
	end)
	return "<Ignore>"
end
map("n", "<C-S-j>", gitsigns_jump_next_hunk, { desc = "Jump to next hunk", expr = true })
map("n", "<C-M-j>", gitsigns_jump_next_hunk, { desc = "Jump to next hunk", expr = true })
map("n", "<C-S-k>", gitsigns_jump_prev_hunk, { desc = "Jump to prev hunk", expr = true })
map("n", "<C-M-k>", gitsigns_jump_prev_hunk, { desc = "Jump to prev hunk", expr = true })

map("n", "<M-z>", function()
	require("gitsigns").reset_hunk()
end, { desc = "Reset hunk" })
map("v", "<M-z>", ":Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })

-- ===============================
-- 2. Fugitive
-- ===============================
vim.cmd([[
  " Support worktree bare repo: https://github.com/tpope/vim-fugitive/issues/1841
  function! s:SetGitDir() abort
  " Check if Fugitive is loaded
  if !exists(':Git')
  return
  endif

  let l:cwd = getcwd()
  let l:home = $HOME

  " Check if the current directory is the home directory
  if l:cwd ==# l:home
  let b:test = 1
  let l:git_dir = l:home . '/.cfg'
  call FugitiveDetect(l:git_dir, l:cwd)
  echom 'Set FugitiveDetect in ' . l:git_dir
  endif
  endfunction

  augroup SetGitDir
  autocmd!
  autocmd DirChanged * call s:SetGitDir()
  augroup END
]])
--
-- \ 'a' : [':Git add .'                        , '~Add all'],
-- \ 'A' : [':Git add %'                        , 'add current'],
-- \ 'b' : [':Git blame'                        , '~blame'],
-- \ 'B' : [':GBrowse'                          , 'browse'],
-- \ 'c' : [':Git commit'                       , 'commit'],
-- \ 'D' : [':Git diff'                         , 'Diff'],
-- \ 'd' : [':Gdiffsplit!'                       , '~Diffsplit3'],
-- \ ']' : [':Gdiffsplit'                       , 'Diffsplit'],
-- \ 'f' : [':Gfetch'                           , '~Fetch'],
-- \ 'M' : [':Gitmerge origin master'           , 'merge master'],
-- \ 'g' : [':GGrep'                            , 'git grep'],
-- \ 'o' : [':GitGutterLineHighlightsToggle'    , 'highlight hunks'],
-- \ ';' : [':GremoveConflictMarkers', 'Git Get (Both)'],
-- \ 'h' : [':diffget //2'                      , 'GetMergeCurr (L)'],
-- \ 'H' : ['<Plug>(GitGutterPreviewHunk)'      , 'preview hunk'],
-- \ 'j' : ['<Plug>(GitGutterNextHunk)'         , 'next hunk'],
-- \ 'k' : ['<Plug>(GitGutterPrevHunk)'         , 'prev hunk'],
-- \ 'l' : [':diffget //3'                      , '~GetMergeInc (R)'],
-- \ 'L' : [':Git log'                          , 'log'],
-- \ 'p' : [':Git push'                         , '~Push'],
-- \ 'P' : [':Git pull'                         , '~Pull'],
-- \ 'r' : [':GRemove'                          , 'remove'],
-- \ 's' : [':Git'                          , 'Status'],
-- \ 'S' : ['<Plug>(GitGutterStageHunk)'        , 'stage hunk'],
-- \ 't' : [':GitGutterSignsToggle'             , 'toggle signs'],
-- \ 'u' : ['<Plug>(GitGutterUndoHunk)'         , 'undo hunk'],
-- \ 'v' : [':GV'                               , 'view commits'],
-- \ 'V' : [':GV!'                              , 'view buffer commits'],
-- above convert from whichkey vim to lua  settings
map("n", "<leader>ga", ":Git add %:p<cr><cr>", { silent = true, desc = "Add current" })
map("n", "<leader>gd", ":Gdiff<cr>", { silent = true, desc = "Diff" })
map("n", "<leader>gd", ":Gitsigns preview_hunk_inline<cr>", { desc = "Preview Hunk inline" })
map("n", "<leader>gd.", ":Gitsigns preview_hunk_inline<cr>", { desc = "Preview Hunk inline" })
map("n", "<leader>gdv", ":Gvdiffsplit<CR>", { desc = "V Diff" })
map("n", "<leader>gds", ":Gdiffsplit<CR>", { desc = "S Diff" })
map("n", "<leader>gdm", ':Gitsigns diffthis "~"<CR>', { desc = "Diff master" })
map("n", "<leader>gbc", ":Telescope git_bcommits<cr>", { silent = true, desc = "Git BCommits" })
map("n", "<leader>gbr", ":Telescope git_branches<cr>", { silent = true, desc = "Git Branches" })
map("n", "<leader>gl", ":Git log<cr>", { silent = true, desc = "Git Log" })
map("n", "<leader>gp", ":Git push<cr>", { silent = true, desc = "Git Push" })
map("n", "<leader>gr", ":Gitsigns reset_hunk<cr>", { silent = true, desc = "Git Reset Hunk" })
map("v", "<leader>gr", ":Gitsigns reset_hunk<cr>", { silent = true, desc = "Git Reset Hunk" })
map("n", "<leader>gz", ":Git<cr>", { silent = true, desc = "Git Status" })
map("n", "<leader>gc", ":Git commit<cr>", { silent = true, desc = "Git Commit" })
map("n", "<leader>gw", ":Gwrite<cr>", { silent = true, desc = "Git Add-Write" })
map("n", "<leader>ge", ":Gedit<cr>", { silent = true, desc = "Git Edit" })
map("n", "<leader>gs", ":Gitsigns stage_hunk<cr>", { silent = true, desc = "Stage Hunk" })
map("v", "<leader>gs", ":Gitsigns stage_hunk<cr>", { silent = true, desc = "Stage Hunk" })
map("n", "<leader>gu", ":Gitsigns undo_stage_hunk<cr>", { silent = true, desc = "Stage Undo Hunk" })
map("n", "<leader>gf", ":Git fetch<cr>", { silent = true, desc = "Git Fetch" })
map("n", "[c", gitsigns_jump_prev_hunk, { silent = true, desc = "Next Hunk" })
map("n", "]c", gitsigns_jump_next_hunk, { silent = true, desc = "Prev Hunk" })
map("n", "<leader>gg", ":Git<cr>", { silent = true })
-- more git signs mapping here from NVCHAD : https://github.com/NvChad/NvChad/blob/2e54fce0281cee808c30ba309610abfcb69ee28a/lua/nvchad/configs/gitsigns.lua
-- map("n", "<leader>rh", gs.reset_hunk, opts "Reset Hunk")
-- map("n", "<leader>ph", gs.preview_hunk, opts "Preview Hunk")
-- map("n", "<leader>gb", gs.blame_line, opts "Blame Line")
map("n", "<leader>gbl", ":Gitsigns toggle_current_line_blame<cr>", { silent = true, desc = "Blame Inline Toggle" })
-- Gitsigns toggle_current_line_blame
map("n", "<leader>gbL", ":Git blame<cr>", { silent = true, desc = "Git Blame" })
map("n", "<leader>gbb", ":Git blame<cr>", { silent = true, desc = "Git Blame" })
-- Gitsigns diffthis
--
-- ====================
-- Custom commands
-- ====================

map("n", "<leader>n", "", { desc = "+CustomCommands" })
map("n", "<leader>nn", "<cmd>so $MYVIMRC<CR>", { desc = "Source Config" })
map("n", "<leader>S", "<cmd>SSave<CR>", { desc = "Save Session" })
-- map('n', '<Leader>nm', ':messages <CR>', { noremap = true, silent = true, desc = 'Show messages' })
-- map('n', '<Leader>nM', [[:redir @a<CR>:messages<CR>:redir END<CR>:put! a<CR>]], { noremap = true, silent = true, desc = 'Print messages' })
-- copy relative filepath name
map("n", "<leader>nf", ":let @+=@%<CR>", { desc = "Copy relative filepath name" })
-- copy absolute filepath
map("n", "<leader>nF", ':let @+=expand("%:p")<CR>', { desc = "Copy absolute filepath" })

local function show_messages_window()
	-- Create a new buffer
	local buf = vim.api.nvim_create_buf(false, true)

	-- Get the output of the :messages command
	local messages = vim.split(vim.fn.execute(":messages"), "\n")

	-- Set the buffer lines with the messages
	vim.api.nvim_buf_set_lines(buf, 0, -1, true, messages)

	-- Calculate the window dimensions and position
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	-- Create a new window to display the buffer
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "single",
	})

	-- Set some options for the window
	vim.wo[win].wrap = false
	vim.wo[win].number = false
	vim.wo[win].relativenumber = false
end

local open_command = "xdg-open"
if vim.fn.has("mac") == 1 then
	open_command = "open"
end

local function url_repo()
	local cursorword = vim.fn.expand("<cfile>")
	if string.find(cursorword, "^[a-zA-Z0-9-_.]*/[a-zA-Z0-9-_.]*$") then
		cursorword = "https://github.com/" .. cursorword
	end
	return cursorword or ""
end

map("n", "gx", function()
	-- fallback to send gx if not a link or file
	vim.fn.jobstart({ open_command, url_repo() }, { detach = true }) -- not work in tmux
  -- print("!" .. open_command .. " " .. url_repo())
	-- vim.cmd("!" .. open_command .. " " .. url_repo())

end, { silent = true, desc = "Open url" })

map("n", "<Leader>nx", function()
	show_messages_window()
end, { noremap = true, silent = true, desc = "Print float messages" })

----- LOCALLEADER ==========================
--   # which key migrate .nvim $HOME/.config/nvim/keys/which-key.vim
map("n", "<localleader>q", ":q<CR>", { desc = "Close", noremap = true, silent = true })
map("n", "<localleader>w", ":w<CR>", { desc = "Save file" })
map("n", "<localleader>X", ":qall!<CR>", { desc = "Close All" })
-- files
map("n", "<localleader>rl", ":luafile %<CR>", { desc = "Reload Lua file" })
-- map('n', 'localleader>rp', ':python3 %<CR>', { desc = "Run Python3" })
