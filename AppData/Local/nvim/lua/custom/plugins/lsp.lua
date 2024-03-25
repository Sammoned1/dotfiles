local tools = {
    -- Formatter
    "prettier",
    "stylua",
    -- Linter
    -- "eslint_d",
    "yamllint",
}

local lsp_servers = {
    "bashls",
    "dockerls",
    "jsonls",
    -- TODO managed by go.nvim
    "pylsp",
    "lua_ls",
    -- "tsserver",
    "typst_lsp",
    "yamlls",
}
return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "onsails/lspkind-nvim" },
            { "folke/neodev.nvim",   config = true, lazy = true, ft = "lua" },
        },
        config = function()
            require("custom.plugins.lsp.lsp")
        end,
    },
    {
        "williamboman/mason.nvim",
        event = "VeryLazy",
        dependencies = {
            { "williamboman/mason-lspconfig.nvim", module = "mason" },
        },
        config = function()
            -- install_root_dir = path.concat({ vim.fn.stdpath("data"), "mason" }),
            require("mason").setup()

            -- ensure tools (except LSPs) are installed
            local mr = require("mason-registry")
            local function install_ensured()
                for _, tool in ipairs(tools) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(install_ensured)
            else
                install_ensured()
            end

            -- install LSPs
            require("mason-lspconfig").setup({ ensure_installed = lsp_servers })
        end,
    },
}
