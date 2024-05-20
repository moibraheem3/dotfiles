return {
  'stevearc/oil.nvim',
  -- Optional dependencies
  -- dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('oil').setup {
      columns = {
        -- 'icon',
        -- 'permissions',
        -- 'size',
        -- 'mtime',
      },
      keymaps = {
        ['<C-l>'] = false,
        ['<M-l>'] = 'actions.refresh',
        ['<C-h>'] = false,
        ['<M-h>'] = 'actions.select_split',
        ['<leader>e'] = 'actions.close',
      },
      view_options = {
        show_hidden = true,
      },
    }
    vim.keymap.set('n', '<leader>e', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
  end,
}
