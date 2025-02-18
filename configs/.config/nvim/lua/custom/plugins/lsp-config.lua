return {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    {
      'j-hui/fidget.nvim',
      lazy = true,
      opts = {
        notification = {
          window = {
            relative = 'editor', -- where to anchor, either "win" or "editor"
            winblend = 0, -- &winblend for the window
            zindex = nil, -- the zindex value for the window
            border = '', -- style of border for the fidget window
          },
        },
      },
    },

    -- {
    --   'ray-x/lsp_signature.nvim',
    --   lazy = true,
    --   opts = {},
    -- },
    -- Autocompletion
    -- 'hrsh7th/nvim-cmp',
    -- 'hrsh7th/cmp-buffer',
    -- 'hrsh7th/cmp-path',
    -- 'hrsh7th/cmp-nvim-lsp',
    {
      'saghen/blink.cmp',
      dependencies = {
        'rafamadriz/friendly-snippets',
      },
      version = '*',
      opts = {
        keymap = {
          ['<cr>'] = { 'select_and_accept', 'fallback' },
          ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
          ['<C-e>'] = { 'show', 'show_documentation', 'hide_documentation' },

          ['<Tab>'] = { 'select_next', 'fallback' },
          ['<S-Tab>'] = { 'select_prev', 'fallback' },

          ['<Up>'] = { 'select_prev', 'fallback' },
          ['<Down>'] = { 'select_next', 'fallback' },

          ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
          ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        },
        cmdline = {
          keymap = {
            ['<cr>'] = { 'select_and_accept', 'fallback' },
            ['<Tab>'] = { 'show', 'select_next', 'fallback' },
            ['<S-Tab>'] = { 'show', 'select_prev', 'fallback' },
            ['<C-n>'] = { 'select_next', 'fallback' },
            ['<C-p>'] = { 'select_prev', 'fallback' },
          },
        },
        appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = 'mono',
        },
        sources = {
          -- add lazydev to your completion providers
          default = {
            'lazydev',
            'buffer',
            'lsp',
            'path',
            'snippets',
          },
          providers = {
            lazydev = {
              name = 'LazyDev',
              module = 'lazydev.integrations.blink',
              -- make lazydev completions top priority (see `:h blink.cmp`)
              score_offset = 100,
            },
          },
        },
        completion = {
          accept = {
            auto_brackets = {
              enabled = false,
            },
          },
          documentation = {
            auto_show = true,
          },
          menu = {
            draw = {
              columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind', gap = 1 } },
              components = {
                kind_icon = {
                  ellipsis = false,
                  text = function(ctx)
                    local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                    return kind_icon
                  end,
                },
              },
            },
            auto_show = function(ctx)
              return ctx.mode ~= 'cmdline'
            end,
          },
        },
        signature = { enabled = true },
      },
    },

    -- Additional lua configuration, makes nvim stuff amazing!
    {
      'folke/lazydev.nvim',
      ft = 'lua', -- only load on lua files
      opts = {},
    },
  },
  config = function()
    vim.diagnostic.config {
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = 'rounded',
      },
    }

    require 'custom.config.lsp.keys'
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- LSPs config
    local servers = {
      'lua_ls',
      'gopls',
      'nixd',
      'tailwindcss',
      'htmx',
      'templ',
      'gdscript',
      'gdshader_lsp',
      'basedpyright',
      'angularls',
      'postgres_lsp',
      'rust_analyzer',
      'clangd',
    }

    local lspconfig = require 'lspconfig'
    for _, server in pairs(servers) do
      local cmd = lspconfig[server].config_def.default_config.cmd
      local cmd_type = type(cmd)

      if cmd_type == 'table' then
        if vim.fn.executable(cmd[1]) == 1 then
          require('custom.config.lsp.' .. server).setup(capabilities)
        end
      else
        require('custom.config.lsp.' .. server).setup(capabilities)
      end
    end
  end,
}
