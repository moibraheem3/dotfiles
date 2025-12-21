local servers = {
  'lua_ls',
  'gopls',
  'nixd',
  'tailwindcss',
  'htmx',
  'templ',
  'gdscript',
  'gdshader_lsp',
  'basedpyright',
  'angularls',
  'postgres_lsp',
  'rust_analyzer',
  'clangd',
  'vtsls',
  'ols',
  'zls',
}

vim.lsp.enable(servers)

vim.diagnostic.config {
  -- virtual_lines = {
  --   -- Only show virtual line diagnostics for the current cursor line
  --   current_line = true,
  -- },
  virtual_text = false,
  underline = false,
}

-- Keymaps
vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'Code action' })
vim.keymap.set('x', '<leader>la', vim.lsp.buf.code_action, { desc = 'Code action' })
vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { desc = 'Renames' })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go definition' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go declaration' })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go implementation' })
vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, { desc = 'Type Definition' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Go references' })
vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, { desc = 'Go signature' })
-- vim.keymap.set('n', '<leader>lk', function()
--   vim.diagnostic.jump { count = -1, float = true }
-- end, { desc = 'Go to previous diagnostic message' })
--
-- vim.keymap.set('n', '<leader>lj', function()
--   vim.diagnostic.jump { count = 1, float = true }
-- end, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
-- inlay_hint
vim.keymap.set('n', '<leader>lnt', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
end, { desc = 'Toggle inlay hints' })
-- if vim.lsp.inlay_hint then
--   vim.lsp.inlay_hint.enable(true, {})
-- end
