return {
  'folke/snacks.nvim',
  opts = {
    bufdelete = {},
    picker = {
      layout = {
        preset = 'telescope',
      },
      win = {
        input = {
          keys = {
            ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
          },
        },
      },
      formatters = {
        file = {
          filename_first = true, -- display filename before the file path
          truncate = 80,
        },
      },
    },
  },
  keys = {
    {
      '<leader>/',
      function()
        Snacks.picker.lines()
      end,
      desc = 'Buffer Lines',
    },
    {
      '<leader>?',
      function()
        Snacks.picker.recent()
      end,
      desc = 'Recent',
    },
    {
      '<leader><space>',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'Buffers',
    },

    {
      '<leader>sr',
      function()
        Snacks.picker.resume()
      end,
      desc = 'Resume',
    },
    {
      '<leader>sf',
      function()
        Snacks.picker.files { layout = 'select' }
      end,
      desc = 'Smart Find Files',
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Grep',
    },
    {
      '<leader>sh',
      function()
        Snacks.picker.help()
      end,
      desc = 'Help Pages',
    },
    {
      '<leader>sd',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = 'Diagnostics',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = 'Keymaps',
    },

    {
      '<leader>gf',
      function()
        Snacks.picker.git_files { layout = 'select' }
      end,
      desc = 'Find Git Files',
    },
    {
      '<leader>ls',
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = 'LSP Workspace Symbols',
    },

    {
      '<leader>bD',
      function()
        Snacks.bufdelete.all()
      end,
      desc = 'Delete all buffers',
    },
    {
      '<leader>bd',
      function()
        Snacks.bufdelete.delete()
      end,
      desc = 'Delete buffer',
    },
    {
      '<leader>bo',
      function()
        Snacks.bufdelete.other()
      end,
      desc = 'Delete other buffer',
    },

    {
      '<leader>glf',
      function()
        Snacks.picker.git_log_file()
      end,
      desc = 'Git log file',
    },
    {
      '<leader>glc',
      function()
        Snacks.picker.git_log_line()
      end,
      desc = 'Git log current line',
    },
  },
}
