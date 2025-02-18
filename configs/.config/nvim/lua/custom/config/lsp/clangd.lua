local M = {}

function M.setup(capabilities)
  local lspconfig = require 'lspconfig'

  lspconfig.clangd.setup { capabilities }
end

return M
