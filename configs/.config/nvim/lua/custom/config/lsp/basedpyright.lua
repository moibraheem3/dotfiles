local M = {}

function M.setup(capabilities)
  local lspconfig = require 'lspconfig'

  lspconfig.basedpyright.setup { capabilities }
end

return M
