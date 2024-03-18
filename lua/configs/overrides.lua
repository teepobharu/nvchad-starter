local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "markdown",
    "markdown_inline",
    "python",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

M.telescope = {
      session_pickers = function(opts)
        local conf = require("telescope.config").values
        local finders = require "telescope.finders"
        local pickers = require "telescope.pickers"
        local action_state = require "telescope.actions.state"
        local session_dir = vim.g.startify_session_dir or '~/.config/session'
        -- Logic to handle session previews using the session directory
        -- You can customize this to display session information or previews
        -- Example: Display session files in the specified directory
        local results = {}
    --
        -- for file in io.popen('ls ' .. session_dir):lines() do
    -- find to format output as filename only not the full path
    --p[[:alnum:]_].*find $(pwd) -name '
    --for more format see man re_format
    for file in io.popen('find ' .. session_dir .. ' -maxdepth 1 -type f -name "[[:alpha:][:digit:]][[:alnum:]_]*" -exec basename {} +'):lines() do
      -- file that starts with alpahnumerical 
            table.insert(results, { value = file })
        end

        local actions = require('telescope.actions')

        actions.select_default:replace(function(prompt_bufnr)
          local entry = actions.get_selected_entry(prompt_bufnr)
          if entry then
            vim.cmd('SSave ' .. entry.value)
          end
        end)

        -- add key map for loadding with SLoad when press C-enter
        -- actions.select_default:replace(function(prompt_bufnr)
        --  local entry = actions.get_selected_entry(prompt_bufnr)
        --  if entry this_offset_encoding
        --

        -- Return the results for display in Telescope
        return pickers.new(opts, {
          prompt_title = 'Startify Sessions',
        attach_mappings = function(prompt_bufnr, map)

            -- map("i", "asdf", function(_prompt_bufnr)
            --   print "You typed asdf"
            -- end)
      --
          map('i', '<C-s>', function(_prompt_bufnr)
              print "Saving"
            local entry = action_state.get_selected_entry()
            if entry then
              vim.cmd('SSave ' .. entry.value)
              end
            end)

          map('i', '<C-CR>', function(_prompt_bufnr)
              print "typed c-enter "
            local entry = action_state.get_selected_entry()
            if entry then
              vim.cmd('SLoad ' .. entry.value)
              end
            end)

          map('i', '<C-d>', function(_prompt_bufnr)
            local entry = action_state.get_selected_entry()
            print("Deleting" .. entry.value)
            
            if entry then
              vim.cmd('SDelete ' .. entry.value)
              local picker = actions.get_current_picker(_prompt_bufnr)
              picker.refresh()
              end
            end)

            --- end ---
            return true

          end,
          finder = finders.new_table {
            results = results,
            entry_maker = function(entry)
              return {
                display = entry.value,
                value = entry.value,
                ordinal = entry.value,
              }
            end,
          },
          sorter = conf.generic_sorter(opts),
        -- })
        }):find()
        -- return require("telescope").register_extension{
        --   exports = { startify = session_picker }
        -- }
      end
}

return M
