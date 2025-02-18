local M = {}

function M.setup(capabilities)
  local lspconfig = require 'lspconfig'

  lspconfig.tailwindcss.setup { capabilities = capabilities }
end

return M
