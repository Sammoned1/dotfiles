M = {}
---notify
---@param message string
---@param level integer
---@param title string
local notify = function(message, level, title)
    local notify_options = {
        title = title,
        timeout = 2000,
    }
    vim.api.nvim_notify(message, level, notify_options)
end
-- TODO: refactor
-- must be global or the initial state is not working
VIRTUAL_TEXT_ACTIVE = true
-- toggle displaying virtual text
M.toggle_virtual_text = function()
    VIRTUAL_TEXT_ACTIVE = not VIRTUAL_TEXT_ACTIVE
    notify(
        string.format("Virtualtext %s", VIRTUAL_TEXT_ACTIVE and "on" or "off"),
        vim.log.levels.INFO,
        "lsp/utils.lua"
    )
    vim.diagnostic.show(nil, 0, nil, { virtual_text = VIRTUAL_TEXT_ACTIVE })
end

-- TODO: refactor
-- must be global or the initial state is not working
AUTOFORMAT_ACTIVE = false
-- toggle null-ls's autoformatting
M.toggle_autoformat = function()
    AUTOFORMAT_ACTIVE = not AUTOFORMAT_ACTIVE
    notify(
        string.format("Autoformatting %s", AUTOFORMAT_ACTIVE and "on" or "off"),
        vim.log.levels.INFO,
        "lsp.utils"
    )
end

-- detect python venv
-- https://github.com/neovim/nvim-lspconfig/issues/500#issuecomment-851247107
M.get_python_path = function(workspace)
    local lsp_util = require("lspconfig/util")
    local path = lsp_util.path
    -- Use activated virtualenv.
    if vim.env.VIRTUAL_ENV then
        return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
    end
    -- Find and use virtualenv in workspace directory.
    for _, pattern in ipairs({ "*", ".*" }) do
        local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
        if match ~= "" then
            return path.join(path.dirname(match), "bin", "python")
        end
    end
    -- Fallback to system Python.
    return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buffer)
        end,
    })
end

M.get_LSP_clients = function()
    return vim.lsp.buf_get_clients(0)
end

return M
