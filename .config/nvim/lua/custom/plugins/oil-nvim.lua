return {
  'stevearc/oil.nvim',
  config = function()
    require('oil').setup {
      keymaps = {
        ['<C-l>'] = false,
        ['<M-l>'] = 'actions.refresh',
        ['<C-h>'] = false,
        ['<M-h>'] = 'actions.select_split',
      },
      view_options = {
        show_hidden = true,
      },
    }
    vim.keymap.set('n', '<leader>e', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
  end,
}
