local M = {
  'fgheng/winbar.nvim',
  opts = {
    enabled = true,

    show_file_path = true,
    show_symbols = true,

    colors = {
      path = '', -- You can customize colors like #c946fd
      file_name = '',
      symbols = '',
    },

    icons = {
      file_icon_default = '',
      seperator = '>',
      editor_state = '●',
      lock_icon = '',
    },

    exclude_filetype = {
      'help',
      'startify',
      'dashboard',
      'packer',
      'neogitstatus',
      'NvimTree',
      'Trouble',
      'alpha',
      'lir',
      'Outline',
      'spectre_panel',
      'toggleterm',
      'qf',
    },
  },
  config = function(_ , opts)
    require('winbar').setup(opts)

  end,
}
return M
