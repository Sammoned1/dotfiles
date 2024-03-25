local M = {
  'nvim-neo-tree/neo-tree.nvim',
  cmd = "Neotree",
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  opts = {
    close_if_last_window = true,
    window = {
      mappings = {
        ['S'] = 'split_with_window_picker',
        -- ["s"] = "open_vsplit",
        ['s'] = 'vsplit_with_window_picker',
        ['<cr>'] = 'open_with_window_picker',
      },
    },
  },
}

return M
