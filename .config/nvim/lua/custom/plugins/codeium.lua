return {
  'Exafunction/codeium.vim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    vim.keymap.set('i', '<C-\\>', function()
      return vim.fn['codeium#Accept']()
    end, { expr = true, silent = true })
    vim.keymap.set('n', '<leader>ct', vim.cmd.CodeiumToggle, { desc = 'AI' })
  end,
}
