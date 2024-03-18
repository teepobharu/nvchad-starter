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
  session_picker_ext = function()
    local conf = require("telescope.config").values
    local finders = require "telescope.finders"
    local pickers = require "telescope.pickers"

      local session_picker = function(opts)
        local session_dir = vim.g.startify_session_dir or '~/.config/session'
        -- Logic to handle session previews using the session directory
        -- You can customize this to display session information or previews
        -- Example: Display session files in the specified directory
        local results = {}
        for file in io.popen('ls ' .. session_dir):lines() do
            table.insert(results, { value = file })
        end

        local actions = require('telescope.actions')

        actions.select_default:replace(function(prompt_bufnr)
          local entry = actions.get_selected_entry(prompt_bufnr)
          if entry then
            vim.cmd('SSave ' .. entry.value)
          end
        end)

        -- Return the results for display in Telescope
        pickers.new(opts, {
          prompt_title = 'Startify Sessions',
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
        }):find()
      end

    return require("telescope").register_extension{
      exports = { startify = session_picker }
    }
  end,
}

return M
