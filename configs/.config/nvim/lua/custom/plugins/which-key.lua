return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  lazy = true,
  opts = {
    ---@type false | "classic" | "modern" | "helix"
    preset = 'modern',
  },
  config = function(_, opts)
    local which_key = require 'which-key'
    which_key.setup(opts)
    which_key.add(require 'custom.config.which-key', {
      mode = 'n',
      prefix = '<leader>',
    })
  end,
}
