local Hydra = require 'hydra'
local gitsigns = require 'gitsigns'

-- local hint = [[
--  _J_: next hunk _K_: prev hunk
-- ^^^^
-- _q_: exit
-- ]]
local hint = [[
 _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
 _K_: prev hunk   _u_: undo last stage   _p_: preview hunk   _B_: blame show full
 ^ ^              _S_: stage buffer      _r_: discard hunk   _R_: discard buffer
 ^
 ^ ^              _<Enter>_: Neogit              _q_: exit
]]
local opts = { exit = true, nowait = true }

Hydra {
  hint = hint,
  config = {
    color = 'pink',
    invoke_on_body = true,
    hint = {
      position = 'bottom',
    },
  },
  mode = { 'n', 'x' },
  body = '<leader>gM',
  heads = {
    {
      'J',
      function()
        if vim.wo.diff then
          return ']c'
        end
        vim.schedule(function()
          gitsigns.next_hunk()
        end)
        return '<Ignore>'
      end,
      { expr = true },
    },
    {
      'K',
      function()
        if vim.wo.diff then
          return '[c'
        end
        vim.schedule(function()
          gitsigns.prev_hunk()
        end)
        return '<Ignore>'
      end,
      { expr = true },
    },
    {
      's',
      function()
        local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
        if mode == 'V' then -- visual-line mode
          local esc = vim.api.nvim_replace_termcodes('<Esc>', true, true, true)
          vim.api.nvim_feedkeys(esc, 'x', false) -- exit visual mode
          vim.cmd "'<,'>Gitsigns stage_hunk"
        else
          vim.cmd 'Gitsigns stage_hunk'
        end
      end,
      { desc = 'stage hunk' },
    },
    { 'u', gitsigns.undo_stage_hunk, { desc = 'undo last stage' } },
    { 'S', gitsigns.stage_buffer, { desc = 'stage buffer' } },
    { 'p', gitsigns.preview_hunk, { desc = 'preview hunk' } },
    { 'd', gitsigns.toggle_deleted, { nowait = true, desc = 'toggle deleted' } },
    { 'b', gitsigns.blame_line, { desc = 'blame' } },
    { 'r', gitsigns.reset_hunk, { desc = 'discard hunk' } },
    { 'R', gitsigns.reset_buffer, { desc = 'discard buffer' } },
    {
      'B',
      function()
        gitsigns.blame_line { full = true }
      end,
      { desc = 'blame show full' },
    },
    { '/', gitsigns.show, { exit = true, desc = 'show base file' } }, -- show the base of the file
    {
      '<Enter>',
      function()
        vim.cmd 'Neogit'
      end,
      { exit = true, desc = 'Neogit' },
    },
    { 'q', nil, opts },
  },
}
