-- ==============================
-- Plugin Management with lazy.nvim
-- ==============================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)
vim.o.termguicolors = true


require("lazy").setup({
  -- Colorscheme
  { "bluz71/vim-nightfly-colors", name = "nightfly", lazy = false, priority = 1000 },

  -- File explorer
  { "preservim/nerdtree" },

  -- Fuzzy finder
  { "ctrlpvim/ctrlp.vim" },

  -- Syntax highlighting and language support
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Autocompletion
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },

  -- Snippets
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  -- Formatting and linting
  { "jose-elias-alvarez/null-ls.nvim" },
  { "jayp0521/mason-null-ls.nvim" },

  -- Color highlighter
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },

  -- Status line
  {
    "itchyny/lightline.vim",
    config = function()
      vim.g.lightline = {
        colorscheme = "nightfly",
        active = { left = { { "mode", "paste" }, { "gitbranch", "readonly", "filename", "modified" } } },
        component_function = { gitbranch = "fugitive#head" },
      }
    end,
  },

  -- Commenting
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Auto-pairing
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end,
},

  -- Indent guides
{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },  




{
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  opts = {
    suggestion = { enabled = false },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
    },
  },
}

})

-- ==============================
-- Colors and Appearance
-- ==============================
vim.cmd("colorscheme nightfly")
vim.o.background = "dark" -- Or use "light"
vim.cmd("syntax enable")
vim.wo.number = true

-- ==============================
-- Encoding and UI
-- ==============================
vim.o.encoding = "utf-8"
vim.o.cursorline = true
vim.o.ruler = true
vim.o.mouse = "a"

-- ==============================
-- Editing and Indentation
-- ==============================
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.softtabstop = 2
vim.o.showmatch = true
vim.o.clipboard = "unnamedplus"
vim.o.wrap = true

-- ==============================
-- Searching
-- ==============================
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- ==============================
-- Misc Settings
-- ==============================
vim.o.backspace = "indent,eol,start"
vim.g.ctrlp_working_path_mode = "r"
vim.g.ctrlp_show_hidden = 1
vim.o.wildignore = vim.o.wildignore .. "*/tmp/*,*.so,*.swp,*.zip,*/node_modules/*"
vim.cmd("autocmd BufEnter * if (winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()) | q | endif")
vim.o.swapfile = false
vim.g.jsx_ext_required = 0
