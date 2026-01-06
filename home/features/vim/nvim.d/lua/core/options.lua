vim.cmd("let g:netrw_banner = 0")      -- Disable netrw banner

vim.opt.guicursor = "" -- Use block cursor in all modes
vim.opt.nu = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers

vim.opt.tabstop = 4 -- Number of spaces that a <Tab> counts for
vim.opt.softtabstop = 4 -- Number of spaces that a <Tab> counts for while editing
vim.opt.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.autoindent = true -- Copy indent from current line when starting a new line
vim.opt.smartindent = true -- Smart autoindenting for C-like programs
vim.opt.wrap = false -- Disable line wrapping

vim.opt.cursorline = true -- Highlight the current line
vim.opt.termguicolors = true -- Enable 24-bit RGB colors
vim.opt.background = "dark" -- Set background to dark
vim.opt.scrolloff = 8 -- Minimum number of screen lines to keep above/below the cursor
vim.opt.sidescrolloff = 8 -- Minimum number of screen columns to keep to the left/right of the cursor
vim.opt.signcolumn = "yes" -- Always show the sign column
vim.opt.colorcolumn = "none" -- Disable color column

vim.opt.mouse = "a" -- Enable mouse support in all modes
vim.opt.clipboard = "unnamedplus" -- Use system clipboard

vim.opt.swapfile = false -- Disable swap files
vim.opt.backup = false -- Disable backup files
vim.opt.writebackup = false -- Disable write backup files
vim.opt.undofile = true -- Enable persistent undo

vim.opt.incsearch = true -- Show search matches as you type
vim.opt.inccommand = true -- Show the effects of a command incrementally
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true -- Override 'ignorecase' if the search pattern contains uppercase letters
vim.opt.hlsearch = true -- Highlight all search matches
vim.opt.isfname:append("@-@") -- Allow "@" in file names

vim.opt.backspace = {"indent", "eol", "start"} -- Make backspace behave more intuitively

vim.opt.splitright = true -- Vertical splits will be to the right
vim.opt.splitbelow = true -- Horizontal splits will be below

vim.opt.updatetime = 50 -- Faster completion (default is 4000ms)

vim.g.editorconfig = true -- Enable EditorConfig support