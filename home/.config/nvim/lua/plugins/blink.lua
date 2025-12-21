return {
  'saghen/blink.cmp',
  dependencies = {
    'rafamadriz/friendly-snippets',
    {
      'folke/lazydev.nvim',
      ft = 'lua', -- only load on lua files
      opts = {},
    },
  },
  version = '*',
  opts = {
    keymap = {
      ['<Cr>'] = { 'select_and_accept', 'fallback' },
      ['<C-space>'] = { 'show', 'hide' },
      ['<C-e>'] = { 'show_documentation', 'hide_documentation' },

      ['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
      ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },

      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },

      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
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
        lsp = { fallbacks = {} },
      },
    },

    completion = {
      keyword = { range = 'full' },
      accept = {
        auto_brackets = {
          enabled = false,
        },
      },
      documentation = {
        auto_show = true,
      },
      menu = {
        auto_show = false,
        draw = {
          columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'kind' } },
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                return kind_icon
              end,
              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end,
            },
            kind = {
              -- (optional) use highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end,
            },
          },
        },
      },
      ghost_text = {
        enabled = false,
      },
      list = { selection = { preselect = false }, cycle = { from_top = false } },
    },
    fuzzy = { implementation = 'prefer_rust' },
    signature = { enabled = true },
  },
}
