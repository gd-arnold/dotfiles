-- 1. Import required modules
local actions = require('telescope.actions')
local transform_mod = require('telescope.actions.mt').transform_mod

-- 2. Define a small module of Telescope actions
local my_actions = transform_mod {
  open_in_nvim_tree = function(prompt_bufnr)
    -- Remember current window so we can stay in the file buffer afterwards
    local cur_win = vim.api.nvim_get_current_win()
    -- Reveal the file in nvim-tree
    vim.cmd('NvimTreeFindFile')
    -- Go back to the file window
    vim.api.nvim_set_current_win(cur_win)
  end,
}

require('telescope').setup{
    defaults = {
        file_ignore_patterns = {}, -- Reset if you have unwanted ignore patterns
        hidden = true, -- Show hidden files
        mappings = {
            -- Insert mode mapping
            i = {
                -- Chain the default action (open file) with our custom one
                ["<CR>"] = actions.select_default + my_actions.open_in_nvim_tree,
            },
            -- Normal mode mapping (when using Telescope’s normal-mode)
            n = {
                ["<CR>"] = actions.select_default + my_actions.open_in_nvim_tree,
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,                    -- enable fuzzy matching
            override_generic_sorter = true,  -- use fzf for all generic pickers
            override_file_sorter = true,     -- use fzf for `find_files`
            case_mode = "smart_case",        -- smart case sensitivity
        }
    }
}

require('telescope').load_extension('fzf')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {});
vim.keymap.set('n', '<C-p>', builtin.git_files, {});
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end);

