local opts = { noremap = true, silent = true }

vim.g.mapleader = " "  -- Set leader key to space
vim.g.maplocalleader = " "  -- Set local leader key to space

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines down in visual selection" , table.unpack(opts)} )  -- Move selected lines down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines up in visual selection" , table.unpack(opts)} )  -- Move selected lines up

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered" , table.unpack(opts)} )  -- Center screen on next search result
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result centered" , table.unpack(opts)} )  -- Center screen on previous search result

vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" , table.unpack(opts)} )  -- Indent left and reselect
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" , table.unpack(opts)} )  -- Indent right and reselect

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting clipboard" , table.unpack(opts)} )  -- Paste without overwriting clipboard
vim.keymap.set("v", "p", [["_dP]], { desc = "Paste without overwriting clipboard" , table.unpack(opts)} )  -- Paste without overwriting clipboard

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without overwriting clipboard" , table.unpack(opts)} )  -- Delete without overwriting clipboard

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" , table.unpack(opts)} )  -- Clear search highlighting

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format buffer" , table.unpack(opts)} )  -- Format buffer using LSP
vim.keymap.set("n", "Q", "<nop>", opts)  -- Disable Ex mode

