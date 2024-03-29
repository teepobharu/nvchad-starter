local utils = require('utils')
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
vim.cmd('!open https://google.com')

print("============ UTILS Functions ===============")
-- local test1 = utils.combine_dicts('force', {'s': 3}, {'s': 1})
local test1 = utils.combine_dicts({behavior = 'force'} , {s= 3}, {s= 1})
print(vim.inspect(test1))

