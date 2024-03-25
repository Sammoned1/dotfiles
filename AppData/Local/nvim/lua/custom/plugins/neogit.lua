local M = {
    "NeogitOrg/neogit",
    cmd='Neogit',
    dependencies = {
        "nvim-lua/plenary.nvim",         -- required
        "sindrets/diffview.nvim",        -- optional
        "ibhagwan/fzf-lua",              -- optional
    },
    config = true
}
return M
