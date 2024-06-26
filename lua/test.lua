-- first key duplicate = take the first arg priority "keep"

---@class Opts
---@field behavior string The behavior to use when combining dictionaries. Must be "force" or "keep".
local utils = {}
---@param opts Opts|any
utils.combine_dicts = function(opts, ...)
	local combined_dict = {}
	local dicts = { ... }
	-- if behavior is not set or emptry default = force
	local behavior = opts.behavior

	if not behavior or behavior == "" then
		behavior = "force"
	end

	for _, dict in ipairs(dicts) do
		combined_dict = vim.tbl_extend(behavior, combined_dict, dict)
	end

	return combined_dict
end

-- -- Testing
-- sample input output  for combine dicts
-- local a = { a = 1, b = 2 }
-- local b = { c = 3, d = 4 }
-- local c = { a = 5, f = 6 }
--
-- local d = M.listUniqOnly(a, b, c)
-- print(vim.inspect(d))
-- -- { a = 1, b = 2, c = 3, d = 4, e = 5, f = 6 }

local function rename_buffer()
	local old_name = vim.fn.expand("%")
	local new_name = vim.fn.input("Enter new buffer name: ", old_name)

	-- If user provided a new name and it's different from the old name
	if new_name ~= "" and new_name ~= old_name then
		-- Rename the buffer
		vim.api.nvim_buf_set_name(0, new_name)
		print("Buffer renamed to " .. new_name)
	else
		print("Buffer not renamed.")
	end
end

local map = vim.keymap.set
-- Bind a key to invoke the renaming function
map("n", "<localleader>rr", rename_buffer, { noremap = true, silent = true })

local utils = require("utils")
print("loading tests ...")
print(("asdasd"):gsub("d", "X"))

local function remove_remote_prefix(ref)
	local sanitized_ref = ref:gsub("^%s*(.-)%s*$", "%1")
	sanitized_ref = sanitized_ref:gsub("^remotes/[%w%p]+/", "")
	-- Remove the first asterisk (if present)
	sanitized_ref = sanitized_ref:gsub("^*", "")
	-- remote_path needs to remove prefix remotes/<any remote name>/
	return sanitized_ref
end

local sanitized_branch = remove_remote_prefix(" remotes/origin/CARTWEB-123")

print(vim.inspect(sanitized_branch))

print("" > "" or "asadasdassd")
-- Vim options
print("============ VIM Functions ===============")

-- nothing
-- vim.fn.jobstart({'open', '.'}) -- not work in tmux
-- vim.fn.jobstart({ "/bin/sh", "-c", "open https://google.com" }) -- nothing
-- vim.fn.system('echo 123')

-- run open command
-- run in silence
vim.cmd("!open https://google.com")

print("============ UTILS Functions ===============")
-- local test1 = utils.combine_dicts('force', {'s': 3}, {'s': 1})
local test1 = utils.combine_dicts({ behavior = "force" }, { s = 3 }, { s = 1 })
print(vim.inspect(test1))
