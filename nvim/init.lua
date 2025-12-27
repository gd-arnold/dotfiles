vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
-- disable netrw early (required for nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local api = require("nvim-tree.api")

      local function edit_or_open()
        local node = api.tree.get_node_under_cursor()

        if node.nodes ~= nil then
          -- expand or collapse folder
          api.node.open.edit()
        else
          -- open file
          api.node.open.edit()
          -- close the tree if file was opened
          api.tree.close()
        end
      end

      local function on_attach(bufnr)
        api.config.mappings.default_on_attach(bufnr)

        local function opts(desc)
          return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          }
        end

        vim.keymap.set("n", "l", edit_or_open, opts("Edit Or Open"))
        vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
      end

      require("nvim-tree").setup({
        on_attach = on_attach,
      })

      vim.keymap.set("n", "<leader>j", ":NvimTreeToggle<cr>", { silent = true, noremap = true })
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle);
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
      vim.keymap.set("n", "<leader>s", "<cmd>Gitsigns preview_hunk<CR>")
      vim.keymap.set("n", "<leader>p", "<cmd>Gitsigns stage_hunk<CR>")
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "v0.2.0",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
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
      vim.keymap.set('n', '<C-p>', builtin.find_files, {});
      vim.keymap.set('n', '<leader>pf', builtin.git_files, {});
      vim.keymap.set('n', '<leader>ps', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") });
      end);
    end,
  },
  {
    "christoomey/vim-tmux-navigator"
  },
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      local smart_splits = require("smart-splits")

      -- tmux prefix is <C-a>, mirror prefix + h/j/k/l in Neovim
      vim.keymap.set("n", "<C-a>h", smart_splits.resize_left)
      vim.keymap.set("n", "<C-a>j", smart_splits.resize_down)
      vim.keymap.set("n", "<C-a>k", smart_splits.resize_up)
      vim.keymap.set("n", "<C-a>l", smart_splits.resize_right)
    end,
  }
})

-- Keymaps --
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

-- Enable built-in LSP completion on attach (Neovim 0.11+)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })
  end,
})

-- Options --
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

-- WSL2: use Windows clipboard via win32yank
vim.opt.clipboard = "unnamedplus"
vim.g.clipboard = {
  name = "win32yank",
  copy = {
    ["+"] = "win32yank.exe -i --crlf",
    ["*"] = "win32yank.exe -i --crlf",
  },
  paste = {
    ["+"] = "win32yank.exe -o --lf",
    ["*"] = "win32yank.exe -o --lf",
  },
  cache_enabled = 0,
}
