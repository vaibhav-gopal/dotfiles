-- Full reference sheet of default keymaps found here: https://vimhelp.org/quickref.txt.html

local opts = { noremap = true, silent = true }
if not table.unpack then
    table.unpack = unpack
end

vim.g.mapleader = " "  -- Set leader key to space
vim.g.maplocalleader = " "  -- Set local leader key to space

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines down in visual selection" , table.unpack(opts)} )  -- Move selected lines down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines up in visual selection" , table.unpack(opts)} )  -- Move selected lines up

vim.keymap.set("n", "<A-d>", "<C-d>zz", { desc = "Scroll down and center" , table.unpack(opts)} )  -- Scroll down and center
vim.keymap.set("n", "<A-u>", "<C-u>zz", { desc = "Scroll up and center" , table.unpack(opts)} )  -- Scroll up and center

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered" , table.unpack(opts)} )  -- Center screen on next search result
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result centered" , table.unpack(opts)} )  -- Center screen on previous search result

vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" , table.unpack(opts)} )  -- Indent left and reselect
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" , table.unpack(opts)} )  -- Indent right and reselect

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting clipboard" , table.unpack(opts)} )  -- Paste without overwriting clipboard
vim.keymap.set("v", "p", [["_dP]], { desc = "Paste without overwriting clipboard" , table.unpack(opts)} )  -- Paste without overwriting clipboard

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without overwriting clipboard" , table.unpack(opts)} )  -- Delete without overwriting clipboard

vim.keymap.set("n", "<Esc>", "<cmd>nohl<CR>", { desc = "Clear search highlighting" , table.unpack(opts)} )  -- Clear search highlighting

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format buffer" , table.unpack(opts)} )  -- Format buffer using LSP
vim.keymap.set("n", "Q", "<nop>", opts)  -- Disable Ex mode

vim.keymap.set("n", "x", '"_x', { desc = "Delete character without overwriting clipboard" , table.unpack(opts)} )  -- Delete character without overwriting clipboard

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute word under cursor" , table.unpack(opts)} )  -- Substitute word under cursor
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make current file executable" , table.unpack(opts)} )  -- Make current file executable

-- Highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight yanked text",
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
})

-- tab stuff
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" , table.unpack(opts)} )  -- Open new tab
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" , table.unpack(opts)} )  -- Close current tab
vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<CR>", { desc = "Go to next tab" , table.unpack(opts)} )  -- Go to next tab
vim.keymap.set("n", "<leader>tp", "<cmd>tabprevious<CR>", { desc = "Go to previous tab" , table.unpack(opts)} )  -- Go to previous tab
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current file in new tab" , table.unpack(opts)} )  -- Open current file in new tab

-- split
vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical split" , table.unpack(opts)} )  -- Vertical split
vim.keymap.set("n", "<leader>sh", "<cmd>split<CR>", { desc = "Horizontal split" , table.unpack(opts)} )  -- Horizontal split
vim.keymap.set("n", "<leader>se", "<cmd>equalize<CR>", { desc = "Equalize splits" , table.unpack(opts)} )  -- Equalize splits
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" , table.unpack(opts)} )  -- Close current split\

-- copy filepath to the clipboard
vim.keymap.set("n", "<leader>fp", function()
    local filePath = vim.fn.expand("%:p") -- Gets the full path of the current file
    vim.fn.setreg("+", filePath) -- Copies the file path to the system clipboard
    print("Copied file path to clipboard: " .. filePath)
end, { desc = "Copy file path to clipboard" , table.unpack(opts)} )

-- copy relative filepath (home) to the clipboard
vim.keymap.set("n", "<leader>fr", function()
    local filePath = vim.fn.expand("%:~") -- Gets the relative path of the current file
    vim.fn.setreg("+", filePath) -- Copies the file path to the system clipboard
    print("Copied relative file path to clipboard: " .. filePath)
end, { desc = "Copy relative file path to clipboard" , table.unpack(opts)} )
