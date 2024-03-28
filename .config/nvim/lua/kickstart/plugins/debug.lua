-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  event = 'VeryLazy',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    { 'rcarriga/nvim-dap-ui', dependencies = { 'nvim-neotest/nvim-nio' } },

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    -- 'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,

      -- NOTE: this is left here for future porting in case needed
      -- Whether adapters that are set up (via dap) should be automatically installed if they're not already installed.
      -- This setting has no relation with the `ensure_installed` setting.
      -- Can either be:
      --   - false: Daps are not automatically installed.
      --   - true: All adapters set up via dap are automatically installed.
      --   - { exclude: string[] }: All adapters set up via mason-nvim-dap, except the ones provided in the list, are automatically installed.
      --       Example: automatic_installation = { exclude = { "python", "delve" } }
      automatic_installation = false,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {
        function(config)
          -- all sources with no handler get passed here
          -- Keep original functionality
          require('mason-nvim-dap').default_setup(config)
        end,
        codelldb = function(config)
          config.filetypes = { 'c', 'cpp', 'rust', 'swift', 'zig', 'odin' }
          require('mason-nvim-dap').default_setup(config) -- don't forget this!
        end,
      },

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'codelldb',
        -- 'delve',
      },
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<leader>dr', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<leader>dj', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<leader>do', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>dB', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Map K to hover while session is active.
    local keymap_restore = {}
    dap.listeners.after['event_initialized']['me'] = function()
      for _, buf in pairs(vim.api.nvim_list_bufs()) do
        local keymaps = vim.api.nvim_buf_get_keymap(buf, 'n')
        for _, keymap in pairs(keymaps) do
          if keymap.lhs == 'K' then
            table.insert(keymap_restore, keymap)
            vim.api.nvim_buf_del_keymap(buf, 'n', 'K')
          end
        end
      end
      vim.api.nvim_set_keymap('n', 'K', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
    end

    dap.listeners.after['event_terminated']['me'] = function()
      for _, keymap in pairs(keymap_restore) do
        vim.api.nvim_buf_set_keymap(keymap.buffer, keymap.mode, keymap.lhs, keymap.rhs, { silent = keymap.silent == 1 })
      end
      keymap_restore = {}
    end

    -- Install golang specific config
    -- require('dap-go').setup()
  end,
}
