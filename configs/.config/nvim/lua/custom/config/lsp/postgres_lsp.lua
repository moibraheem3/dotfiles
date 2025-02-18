local M = {}

function M.setup(capabilities)
  local lspconfig = require 'lspconfig'

  lspconfig.postgres_lsp.setup { capabilities = capabilities }
end

return M
