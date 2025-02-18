return {
  {
    'sainnhe/gruvbox-material',
    lazy = true,
    config = function()
      vim.g.gruvbox_material_foreground = 'material'
      vim.g.gruvbox_material_background = 'hard'
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_transparent_background = 2
      vim.g.gruvbox_material_diagnostic_text_highlight = 1
      vim.g.gruvbox_material_diagnostic_line_highlight = 1
      vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'
      vim.g.gruvbox_material_inlay_hints_background = 'none' -- 'none' 'dimmed'
    end,
  },
  -- {
  -- 'catppuccin/nvim',
  -- name = 'catppuccin',
  -- lazy = true,
  -- config = function()
  --   require('catppuccin').setup {
  --     flavour = 'mocha', -- latte, frappe, macchiato, mocha
  --     transparent_background = true, -- disables setting the background color.
  --     show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
  --     term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
  --     no_italic = false, -- Force no italic
  --     no_bold = false, -- Force no bold
  --     no_underline = false, -- Force no underline
  --     custom_highlights = function(colors)
  --       return {
  --         netrwTreeBar = { fg = colors.surface0 },
  --       }
  --     end,
  --   }
  -- end,
  -- },
  -- {
  --   'AlexvZyl/nordic.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     transparent = {
  --       bg = true,
  --       float = true,
  --     },
  --     telescope = {
  --       -- Available styles: `classic`, `flat`.
  --       style = 'classic',
  --     },
  --   },
  -- },
  -- {
  --   'vague2k/vague.nvim',
  --   config = function()
  --     require('vague').setup {
  --       transparent = true, -- don't set background
  --       style = {
  --         -- "none" is the same thing as default. But "italic" and "bold" are also valid options
  --         boolean = 'none',
  --         number = 'none',
  --         float = 'none',
  --         error = 'none',
  --         comments = 'italic',
  --         conditionals = 'none',
  --         functions = 'none',
  --         headings = 'bold',
  --         operators = 'none',
  --         strings = 'italic',
  --         variables = 'none',
  --
  --         -- keywords
  --         keywords = 'none',
  --         keyword_return = 'none',
  --         keywords_loop = 'none',
  --         keywords_label = 'none',
  --         keywords_exception = 'none',
  --
  --         -- builtin
  --         builtin_constants = 'none',
  --         builtin_functions = 'none',
  --         builtin_types = 'none',
  --         builtin_variables = 'none',
  --       },
  --     }
  --   end,
  -- },
}
