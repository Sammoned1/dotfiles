local map = vim.keymap.set

-- [[
-- BASIC KEYMAPS
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Map C-Tab autocompete to highest tab
local function isEmpty(s)
  return s == nil or s == ''
end

map({ 'i', 'n' }, '<F13>', function()
  if isEmpty(vim.api.nvim_get_current_line()) then
    vim.api.nvim_input('<Esc>cc')
  else
    vim.api.nvim_input('<Esc><S-i>')
  end
end)

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
--
-- better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')
--
-- paste over currently selected text without yanking it
map('v', 'p', '"_dp')
--
-- Tab Navigation
map('n', '<leader>tn', 'gt', { desc = '[N]ext [T]ab' })
map('n', '<leader>tc', '<cmd>tabclose<cr>', { desc = '[C]lose [T]ab' })
map('v', 'P', '"_dP')
--
if vim.lsp.inlay_hint then
  map('n', '<leader>ch', function()
    if vim.lsp.inlay_hint.is_enabled(0) then
      vim.lsp.inlay_hint.enable(0, false)
    else
      vim.lsp.inlay_hint.enable(0, true)
    end
  end, { desc = 'Inlay Hint' })
end

map('n', '<leader>ff', '<cmd>Format<cr>', { desc = '[F]ormat [F]ile' })
-- Buffer
map('n', '<leader>Ca', '<cmd>%bd|e#|bd#<cr>', { desc = '[C]lose [A]ll but the current buffer' })
map('n', '<leader>Cb', '<cmd>bp<bar>sp<bar>bn<bar>bd<CR>', { desc = '[C]lose [B]uffer' })
-- ]]
--
-- [[
-- TELESCOPE KEYMAPS
-- See `:help telescope.builtin`
map('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
map('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })

map('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
map('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
map('n', '<leader>st', require('telescope').extensions.tasks.tasks, { desc = '[S]earch [T]asks' })
map('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
map('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
map('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
map('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
map('n', '<leader>sp', '<cmd>Telescope live_grep<cr>', { desc = '[S]earch in [P]roject' })
-- ]]
--
--- Buffer Navigation
-- resizing splits
map('n', '<a-c-h>', require('smart-splits').resize_left)
map('n', '<a-c-j>', require('smart-splits').resize_down)
map('n', '<a-c-k>', require('smart-splits').resize_up)
map('n', '<a-c-l>', require('smart-splits').resize_right)
-- moving between splits
map('n', '<c-h>', require('smart-splits').move_cursor_left)
map('n', '<c-j>', require('smart-splits').move_cursor_down)
map('n', '<c-k>', require('smart-splits').move_cursor_up)
map('n', '<c-l>', require('smart-splits').move_cursor_right)
--
--
--
-- Neotree
map('n', '<leader>ft', '<CMD>Neotree toggle <CR>', { desc = 'Toggle [F]ile [T]ree' })
