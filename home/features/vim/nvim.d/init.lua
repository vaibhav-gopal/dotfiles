-- Basic Neovim Configuration (init.lua)
-- This file will source init.vim for compatibility with your Vim-style config

-- Set the path to your init.vim (make sure it's symlinked by Home Manager)
local vimrc_path = vim.fn.stdpath("config") .. "/init.vim"

-- Source the init.vim
vim.cmd("source " .. vimrc_path)

-- NEW CONFIG
require("core")