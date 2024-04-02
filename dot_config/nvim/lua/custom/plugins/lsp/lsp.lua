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
local nvim_lsp = require("lspconfig")
local utils = require("custom.plugins.lsp.utils")
local lsp_settings = require("custom.plugins.lsp.settings")

local capabilities = vim.lsp.protocol.make_client_capabilities()
local vlsp = vim.lsp
-- enable autocompletion via nvim-cmp
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

require("custom.plugins.lsp.utils").on_attach(function(client, buffer)
    require("custom.plugins.lsp.keys").on_attach(client, buffer)
end)

for _, lsp in ipairs(lsp_servers) do
    nvim_lsp[lsp].setup({
        beforeinit = function(_, config)
            if lsp == "pyright" then
                config.settings.python.pythonPath = utils.get_python_path(config.root_dir)
            end
        end,
        capabilities = capabilities,
        flags = { debounce_text_changes = 150 },
        settings = {
            json = lsp_settings.json,
            Lua = lsp_settings.lua,
            ltex = lsp_settings.ltex,
            redhat = { telemetry = { enabled = false } },
            texlab = lsp_settings.tex,
            yaml = lsp_settings.yaml,
            -- tsserver = lsp_settings.tsserver, 
        },
    })
end

vlsp.handlers["textDocument/publishDiagnostics"] = vlsp.with(vlsp.diagnostic.on_publish_diagnostics, {
    underline = false,
})
