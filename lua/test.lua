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
 
