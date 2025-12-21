local function selectionCount()
  local isVisualMode = vim.fn.mode():find '[Vv]'
  if not isVisualMode then
    return ''
  end
  local starts = vim.fn.line 'v'
  local ends = vim.fn.line '.'
  local lines = starts <= ends and ends - starts + 1 or starts - ends + 1
  return tostring(lines) .. ' L ' .. tostring(vim.fn.wordcount().visual_chars) .. ' C'
end

return {
  'nvim-lualine/lualine.nvim',
  event = { 'BufReadPost', 'BufNewFile', 'VeryLazy' },
  opts = {
    options = {
      icons_enabled = true,
      -- theme = 'pywal',
      theme = 'auto',
      component_separators = '|',
      section_separators = '',
      globalstatus = true,
    },
    sections = {
      lualine_z = { 'location', { selectionCount } },
    },
  },
}
