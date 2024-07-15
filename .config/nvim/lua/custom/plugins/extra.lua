return {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  {
    'mbbill/undotree',
    lazy = true,
    cmd = 'UndotreeToggle',
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      indent = {
        char = '┊',
        -- char = '▏',
        -- char = '│',
      },
      scope = { enabled = false },
    },
  },
}
