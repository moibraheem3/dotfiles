local M = {}

function M.setup(capabilities)
  local lspconfig = require 'lspconfig'

  lspconfig.templ.setup { capabilities = capabilities }
end

return M
