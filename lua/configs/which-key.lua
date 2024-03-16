local config = {}


config.mapping = function(wkPlugin)
    return {
        -- wk.register({
        m = {
            name = "file",                                                                          -- optional group name

            f = { "<cmd>Telescope find_files<cr>", "Find File" },                                   -- create a binding with label
            r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap = false, buffer = 123 }, -- additional options for creating the keymap
            n = { "New File" },                                                                     -- just a label. don't create any mapping
            e = "Edit File",                                                                        -- same as above
            ["1"] = "which_key_ignore",                                                             -- special label to hide it in the popup
            b = { function() print("bar") end, "Foobar" }                                           -- you can also pass functions!
        }
        -- }, { prefix = "<leader>" })
    }
end

-- }
-- n = {
--     ["<leader>n"] = {
--       "",
--       "+CustomCommands"
--     },
--     ["<leader>nn"] = {
--       "<cmd>so $MYVIMRC<CR>",
--       "Source Config"
--     },
--     ["<leader>ns"] = {
--       "",""
--     },
--     ["<leader>s"] = {
--       "<cmd>Telescope<CR>",
--       "Telescope"
--     },
--     ["<leader>S"] = {
--       "<cmd>SSave<CR>",
--       "Save Session"
--     },
--   }

--   // convert above settings to wk.register format local wk = require("which-key")
-- As an example, we will create the following mappings:
--  * <leader>ff find files
--  * <leader>fr show recent files
--  * <leader>fb Foobar
-- we'll document:
--  * <leader>fn new file
--  * <leader>fe edit file
-- and hide <leader>1

-- wk.register({
--     f = {
--       name = "file", -- optional group name
--       f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- create a binding with label
--       r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap=false, buffer = 123 }, -- additional options for creating the keymap
--       n = { "New File" }, -- just a label. don't create any mapping
--       e = "Edit File", -- same as above
--       ["1"] = "which_key_ignore",  -- special label to hide it in the popup
--       b = { function() print("bar") end, "Foobar" } -- you can also pass functions!
--     },
--   }, { prefix = "<leader>" })

-- local wk = wk.register

return config
