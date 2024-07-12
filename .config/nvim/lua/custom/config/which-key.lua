return {
  { '<leader>q', ':q<CR>', desc = 'Quit' },
  { '<leader>W', ':wa<CR>', desc = 'Write all' },
  { '<leader>bD', ':bufdo bd<cr>', desc = 'Delete all buffers' },
  { '<leader>bd', ':bd<cr>', desc = 'Delete buffer' },
  { '<leader>sc', ':cdo s//', desc = 'Search quickfix selected', silent = false },
  { '<leader>u', '<CMD>UndotreeToggle<CR><CMD>UndotreeFocus<CR>', desc = 'Toggle undotree' },
  { '<leader>w', ':w<CR>', desc = 'Write' },
}
