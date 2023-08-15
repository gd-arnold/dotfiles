local tree = require("nvim-tree");
local api = require("nvim-tree.api");

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

local function edit_or_open()
  local node = api.tree.get_node_under_cursor()

  if node.nodes ~= nil then
    -- expand or collapse folder
    api.node.open.edit()
  else
    -- open file
    api.node.open.edit()
    -- Close the tree if file was opened
    api.tree.close()
  end
end

local function my_on_attach(bufnr)
    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    vim.keymap.set("n", "l", edit_or_open,          opts("Edit Or Open"))
    vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
end

vim.api.nvim_set_keymap("n", "<C-j>", ":NvimTreeToggle<cr>", {silent = true, noremap = true})

tree.setup({
    on_attach = my_on_attach
})
