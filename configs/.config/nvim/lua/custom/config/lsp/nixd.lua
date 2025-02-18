local M = {}

function M.setup(capabilities)
  local lspconfig = require 'lspconfig'

  lspconfig.nixd.setup {
    capabilities = capabilities,
    cmd = { 'nixd' },
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
  }
end

return M
