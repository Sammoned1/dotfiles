local M = {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    -- enabled = false,
    config = function()
        require("custom.plugins.lsp.null-ls")
    end,
}

return M
