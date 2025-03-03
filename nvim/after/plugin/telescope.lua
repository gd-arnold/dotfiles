require('telescope').setup{
    defaults = {
        file_ignore_patterns = {}, -- Reset if you have unwanted ignore patterns
        hidden = true, -- Show hidden files
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

