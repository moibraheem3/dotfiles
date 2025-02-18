local M = {}

function M.setup(capabilities)
  local lspconfig = require 'lspconfig'

  lspconfig.gdshader_lsp.setup { capabilities = capabilities }
end

return M
