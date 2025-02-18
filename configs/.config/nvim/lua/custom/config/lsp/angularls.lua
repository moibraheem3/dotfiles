local M = {}

function M.setup(capabilities)
  local lspconfig = require 'lspconfig'

  lspconfig.angularls.setup {
    capabilities = capabilities,
  }
end

return M
