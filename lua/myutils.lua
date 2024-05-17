local M = {}

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
