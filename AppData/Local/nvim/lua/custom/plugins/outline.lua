local M = {
  "hedyhli/outline.nvim",
  cmd = { "Outline", "OutlineOpen" },
  opts = {
    symbol_folding = {
      -- Depth past which nodes will be folded by default
      autofold_depth = 2,
    },
  },
  keys = {
    { "<leader>tO", "<cmd>Outline<cr>", desc = "Toggle Outline" },
  },
}

return M
