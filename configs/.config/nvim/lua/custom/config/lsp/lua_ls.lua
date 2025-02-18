local M = {}

function M.setup(capabilities)
  local lspconfig = require 'lspconfig'

  lspconfig.lua_ls.setup {
    capabilities = capabilities,
    settings = {
      Lua = {
        format = { enable = false },
        hint = { enable = true },
      },
    },
  }
end

return M
