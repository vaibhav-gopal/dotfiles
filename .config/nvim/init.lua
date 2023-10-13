-- Source the vimrc.vim file for all mappings (cuz its easier there to keep)
local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"
vim.cmd.source(vimrc)
