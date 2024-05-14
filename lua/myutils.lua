local M = {}

-- first key duplicate = take the first arg priority "keep"

---@class Opts
---@field behavior string The behavior to use when combining dictionaries. Must be "force" or "keep".

---@param opts Opts|any
M.combine_dicts = function(opts, ...)
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

M.combineUniqueLists = function(...)
	local combined = {}
	local seen = {}

	-- Merge the two lists
	for _, list in ipairs({ ... }) do
		for _, v in ipairs(list) do
			if not seen[v] then
				table.insert(combined, v)
				seen[v] = true
			end
		end
	end

	return combined
end

function table.contains(table, element)
	for _, value in ipairs(table) do
		if value == element then
			return true
		end
	end
	return false
end
-- -- Testing
-- -- Define two lists
-- local list2 = {3, 4, 5, 6}
-- local list1 = {1, 2, 3, 4}
-- local list3 = {4, 5, 6, 7}
-- --
-- -- -- Combine lists and get unique members
-- local combinedList = combineUniqueLists(list1, list2, list3)
-- -- Print the resulting list with unique members
-- print(vim.inspect(combinedList))

return M
