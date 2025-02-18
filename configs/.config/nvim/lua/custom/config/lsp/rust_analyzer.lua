local M = {}

function M.setup(capabilities)
  local lspconfig = require 'lspconfig'

  lspconfig.rust_analyzer.setup { capabilities = capabilities }
end

return M
