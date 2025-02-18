return {
  'stevearc/oil.nvim',
  config = function()
    require('oil').setup {
      keymaps = {
        ['<C-l>'] = false,
        ['<C-r>'] = 'actions.refresh',
        ['<C-h>'] = false,
        ['<M-h>'] = 'actions.select_split',
        ['<leader>e'] = 'actions.close',
      },
      columns = {
        'permissions',
        'size',
        'mtime',
        'icon',
      },
      default_file_explorer = true,
      delete_to_trash = true,
      view_options = {
        show_hidden = true,
        natural_order = 'fast',
      },
      win_options = {
        wrap = true,
      },
    }
    vim.keymap.set('n', '<leader>e', '<CMD>Oil<CR>', { desc = 'Open Explorer' })
  end,
}
