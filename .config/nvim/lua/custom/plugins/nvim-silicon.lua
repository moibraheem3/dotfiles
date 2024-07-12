return {
  'michaelrommel/nvim-silicon',
  lazy = true,
  cmd = 'Silicon',
  init = function()
    vim.keymap.set({ 'v' }, '<leader>cs', ':Silicon<CR>', { desc = 'Codeshot' })
  end,
  config = function()
    require('silicon').setup {
      -- Configuration here, or leave empty to use defaults
      font = 'FantasqueSansM Nerd Font=34;',
      theme = 'Dracula',
      window_title = function()
        return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ':t')
      end,
      output = function()
        return '~/Pictures/Screenshots/' .. os.date '!%Y-%m-%dT%H-%M-%S' .. '_code.png'
      end,
    }
  end,
}
