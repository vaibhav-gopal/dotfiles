return {
    "windwp/nvim-autopairs",
    enabled = true,
    event = {"InsertEnter"},
    dependencies = {
        "hrsh7th/nvim-cmp",
    },
    config = function()
        local autopairs = require("nvim-autopairs")

        autopairs.setup({
            check_ts = true,
            ts_config = {
                lua = {'string'},
                javascript = {'string', 'template_string'},
                java = false,
            },
        })

        -- If you want to use cmp (completion) with autopairs
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp = require("cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
}