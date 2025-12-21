return {
  'stevearc/conform.nvim',
  lazy = true,
  cmd = 'ConformInfo',
  keys = {
    {
      '<leader>lf',
      function()
        require('conform').format {}
      end,
      mode = '',
      desc = 'Format buffer',
    },
  },
  opts = {
    formatters = {
      odinfmt = {
        command = 'odinfmt',
        args = { '-stdin' },
        stdin = true,
      },
    },
    --
    default_format_opts = {
      timeout_ms = 3000,
      async = false, -- not recommended to change
      quiet = false, -- not recommended to change
      lsp_format = 'fallback', -- not recommended to change
    },
    formatters_by_ft = {
      javascript = { 'prettierd', 'prettier' },
      typescript = { 'prettierd', 'prettier' },
      javascriptreact = { 'prettierd', 'prettier' },
      typescriptreact = { 'prettierd', 'prettier' },
      htmlangular = { 'prettierd', 'prettier' },
      svelte = { 'prettierd', 'prettier' },
      css = { 'prettierd', 'prettier' },
      html = { 'prettierd', 'prettier' },
      json = { 'prettierd', 'prettier' },
      lua = { 'stylua' },
      cpp = { 'clang_format' },
      gdscript = { 'gdformat' },
      nix = { 'alejandra' },
      python = { 'black' },
      odin = { 'odinfmt' },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
