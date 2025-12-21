return {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  {
    'mbbill/undotree',
    lazy = true,
    cmd = 'UndotreeToggle',
  },
  -- {
  --   'lukas-reineke/indent-blankline.nvim',
  --   main = 'ibl',
  --   event = { 'BufReadPre', 'BufNewFile' },
  --   version = 'v3.8.2',
  --   opts = {
  --     indent = {
  --       -- char = '┊',
  --       char = '¦',
  --       -- char = '▏',
  --       -- char = '│',
  --     },
  --     scope = { enabled = false },
  --   },
  -- },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    event = 'VeryLazy',
    opts = {},
  },
}
