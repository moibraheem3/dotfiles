local M = {}

function M.setup(capabilities)
  local lspconfig = require 'lspconfig'

  lspconfig.gopls.setup { capabilities = capabilities }
end

return M
