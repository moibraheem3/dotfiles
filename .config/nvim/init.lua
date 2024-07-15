require 'custom.config.options'
require 'custom.config.keymaps'
-- require 'custom.config.netrw'
require 'custom.config.autocmds'
require 'custom.config.lazy'

vim.cmd.colorscheme 'catppuccin'

local project_dir = vim.fn.getcwd() .. '/project.godot'
if vim.fn.filereadable(project_dir) == 1 then
  vim.fn.serverstart './godothost'
end
