local M = {}

function M.setup(capabilities)
  local lspconfig = require 'lspconfig'

  lspconfig.gdscript.setup { capabilities = capabilities }
end

return M
