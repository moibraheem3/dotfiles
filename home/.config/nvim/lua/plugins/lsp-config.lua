return {
  -- -- LSP Configuration & Plugins
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
  },
  opts = {},
  config = function()
    require 'config.lsp'
    vim.lsp.config('nixd', {
      settings = {
        nixd = {
          nixpkgs = {
            expr = 'import <nixpkgs> { }',
          },
          formatting = {
            command = { 'alejandra' },
          },
          options = {
            nixos = {
              expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.laptop.options',
            },
            home_manager = {
              expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."mohamed@laptop".options',
            },
          },
        },
      },
    })
    vim.lsp.config('vtsls', {
      settings = {
        typescript = {
          updateImportsOnFileMove = 'always',
          inlayHints = {
            parameterNames = { enabled = 'literals' },
            parameterTypes = { enabled = true },
            variableTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            enumMemberValues = { enabled = true },
          },
        },
        javascript = {
          updateImportsOnFileMove = 'always',
          inlayHints = {
            parameterNames = { enabled = 'literals' },
            parameterTypes = { enabled = true },
            variableTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            enumMemberValues = { enabled = true },
          },
        },
        vtsls = {
          enableMoveToFileCodeAction = true,
        },
      },
    })
    vim.lsp.config('ols', {
      init_options = {
        enable_references = true,
      },
    })
  end,
}
