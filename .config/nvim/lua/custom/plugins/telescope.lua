return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
  config = function()
    local telescope = require 'telescope'
    local builtin = require 'telescope.builtin'
    local themes = require 'telescope.themes'
    local actions = require 'telescope.actions'

    telescope.setup {
      defaults = {
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
            ['<esc>'] = actions.close,
          },
        },
      },
    }

    pcall(telescope.load_extension, 'fzf')

    vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = 'Find recently opened files' })
    vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = 'Find existing buffers' })
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Search help' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Search current word' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Search by grep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Search diagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'Search resume' })

    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(themes.get_dropdown { previewer = false })
    end, { desc = 'Fuzzily search in current buffer' })

    vim.keymap.set('n', '<leader>gf', function()
      builtin.git_files(themes.get_dropdown { previewer = false })
    end, { desc = 'Search git files' })

    vim.keymap.set('n', '<leader>sf', function()
      builtin.find_files(themes.get_dropdown { previewer = false })
    end, { desc = 'search files' })
  end,
}
