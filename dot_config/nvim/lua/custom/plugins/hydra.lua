local M = {
  "nvimtools/hydra.nvim",
  event = "VeryLazy",
  config = function()
    require("custom.plugins.hydra.hydra")
  end,
}

return M
