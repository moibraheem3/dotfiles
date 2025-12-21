local yank_highlight = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = yank_highlight,
  pattern = '*',
})

local quit_q = vim.api.nvim_create_augroup('QuitQ', { clear = true })
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'qf', 'help', 'man', 'lspinfo', 'spectre_panel', 'lir' },
  group = quit_q,
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set('n', 'q', function()
        vim.cmd 'close'
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = 'Quit buffer',
      })
    end)
  end,
})

-- wrap words "softly" (no carriage return)
local wrap_softly = vim.api.nvim_create_augroup('WrapSoftly', { clear = true })
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'gitcommit', 'markdown' },
  group = wrap_softly,
  callback = function()
    vim.opt_local.textwidth = 0
    vim.opt_local.wrapmargin = 0
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
  end,
})

-- resize neovim split when terminal is resized
local resized = vim.api.nvim_create_augroup('Resized', { clear = true })
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = resized,
  callback = function()
    vim.cmd 'tabdo wincmd ='
  end,
})

local checktime = vim.api.nvim_create_augroup('CheckTime', { clear = true })
vim.api.nvim_create_autocmd({ 'FocusGained' }, {
  pattern = { '*' },
  group = checktime,
  callback = function()
    vim.cmd 'checktime'
  end,
})

-- go to last loc when opening a buffer
local last_loc = vim.api.nvim_create_augroup('LastLoc', { clear = true })
vim.api.nvim_create_autocmd('BufReadPost', {
  group = last_loc,
  callback = function(event)
    local exclude = { 'gitcommit' }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

local netrw = vim.api.nvim_create_augroup('Netrw', { clear = true })
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'netrw' },
  group = netrw,
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> <leader>q :bd<CR>
      nnoremap <silent> <buffer> <leader>e :bd<CR>
      set nobuflisted
    ]]
  end,
})

local highlight_group = vim.api.nvim_create_augroup('HighlightGroup', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  group = highlight_group,
  callback = function()
    local swap_hl = function(name)
      local hl = vim.api.nvim_get_hl(0, { name = name })
      hl.fg = hl.bg
      hl.bg = nil
      -- hl.cterm.underline = true
      -- hl.underline = true
      return hl
    end
    vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'LspInfoBorder', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
    vim.api.nvim_set_hl(0, '@comment.todo.comment', swap_hl 'Todo')
    vim.api.nvim_set_hl(0, '@comment.note.comment', swap_hl 'TSNote')
    vim.api.nvim_set_hl(0, '@comment.warning.comment', swap_hl 'TSWarning')
    vim.api.nvim_set_hl(0, '@comment.error.comment', swap_hl 'TSDanger')
  end,
})

local gdscript = vim.api.nvim_create_augroup('GDScript', { clear = true })
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'gdscript' },
  group = gdscript,
  callback = function()
    vim.cmd [[
    let &listchars = 'eol:↴,tab:▸ ,trail:.,nbsp:⎵'
    setlocal list noet tabstop=2
    ]]
  end,
})

-- vim.api.nvim_create_autocmd({ "LspDetach" }, {
--   group = vim.api.nvim_create_augroup("LspStopWithLastClient", {}),
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if not client or not client.attached_buffers then return end
--     for buf_id in pairs(client.attached_buffers) do
--       if buf_id ~= args.buf then return end
--     end
--     client:stop()
--   end,
--   desc = "Stop lsp client when no buffer is attached",
-- })
