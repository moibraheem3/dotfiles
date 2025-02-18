vim.keymap.set('n', '<leader>lk', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '<leader>lj', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    vim.keymap.set('n', 'K', function()
      vim.lsp.buf.hover { border = 'rounded' }
    end, { desc = 'Hover', buffer = event.buf })

    vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'Code action', buffer = event.buf })
    vim.keymap.set('x', '<leader>la', vim.lsp.buf.code_action, { desc = 'Code action', buffer = event.buf })
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { desc = 'Renames', buffer = event.buf })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go definition', buffer = event.buf })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go declaration', buffer = event.buf })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go implementation', buffer = event.buf })
    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, { desc = 'Type Definition', buffer = event.buf })
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Go references', buffer = event.buf })
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, { desc = 'Go signature', buffer = event.buf })

    -- inlay_hint
    vim.keymap.set('n', '<leader>lnt', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
    end, { desc = 'Toggle inlay hints', buffer = event.buf })
    -- if vim.lsp.inlay_hint then
    --   vim.lsp.inlay_hint.enable(true, {})
    -- end
  end,
})
