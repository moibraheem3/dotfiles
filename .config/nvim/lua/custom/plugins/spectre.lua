return {
  'nvim-pack/nvim-spectre',
  build = false,
  cmd = 'Spectre',
  opts = { open_cmd = 'noswapfile vnew' },
  -- stylua: ignore
  keys = {
    { "<leader>sa", function() require("spectre").open() end, desc = "[S]earch & Replace in [a]ll files (Spectre)" },
  },
}
