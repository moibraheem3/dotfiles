local M = {}

function M.setup(capabilities)
  local lspconfig = require 'lspconfig'

  lspconfig.htmx.setup { capabilities = capabilities, autostart = false }
end

return M
