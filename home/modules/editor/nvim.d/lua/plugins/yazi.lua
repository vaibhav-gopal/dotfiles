return {
    "mikavilpas/yazi.nvim",
    enabled = true,
    version = "*", -- use the latest stable version
    event = "VeryLazy",
    dependencies = {
        { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
        -- 👇 in this section, choose your own keymappings!
        {
        "<leader>-",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
        },
        {
        -- Open in the current working directory
        "<leader>cw",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
        },
        {
        "<c-up>",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
        },
    },
    opts = {
        -- if you want to open yazi instead of netrw, see below for more info
        open_for_directories = true,
        change_neovim_cwd_on_close = false,
        keymaps = {
            show_help = "<f1>",
            open_file_in_vertical_split = "<c-v>",
            open_file_in_horizontal_split = "<c-x>",
            open_file_in_tab = "<c-t>",
            grep_in_directory = "<c-s>",
            replace_in_directory = "<c-g>",
            cycle_open_buffers = "<tab>",
            copy_relative_path_to_selected_files = "<c-y>",
            send_to_quickfix_list = "<c-q>",
            change_working_directory = "<c-\\>",
            open_and_pick_window = "<c-o>",
        },
    },
    -- 👇 if you use `open_for_directories=true`, this is recommended
    init = function()
        -- mark netrw as loaded so it's not loaded at all.
        -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
        vim.g.loaded_netrwPlugin = 1
    end,
}