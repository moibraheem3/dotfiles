local bufnr = -1
local main_winnr = -1
local main_bufnr = -1
local function scroll_to_bottom()
  local info = vim.api.nvim_get_mode()
  if info and (info.mode == 'n' or info.mode == 'nt') then
    vim.cmd 'normal! G'
  end
end

local function make_buf()
  main_winnr = vim.api.nvim_get_current_win()
  main_bufnr = vim.api.nvim_get_current_buf()
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end
  bufnr = vim.api.nvim_create_buf(false, false)
  local winnr = vim.api.nvim_open_win(bufnr, true, {
    split = 'right',
    win = main_winnr,
  })
  vim.api.nvim_win_set_buf(winnr, bufnr)
  vim.api.nvim_set_option_value('winfixwidth', true, { scope = 'local', win = winnr })
end

local function run_command(cmd)
  local function on_exit(_, _, _)
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.cmd('cgetb ' .. bufnr)
    end
  end

  local jobid = vim.fn.jobstart(cmd, {
    on_exit = on_exit,
    on_stdout = function()
      vim.api.nvim_buf_call(bufnr, scroll_to_bottom)
    end,
    term = true,
  })
  return jobid
end

local function close_job(jobid)
  vim.keymap.set('n', 'q', function()
    vim.fn.jobstop(jobid)
    vim.cmd 'bd!'
    bufnr = -1
    main_winnr = -1
  end, {
    buffer = bufnr,
    silent = true,
    desc = 'Quit buffer',
  })
  if vim.api.nvim_win_is_valid(main_winnr) then
    vim.api.nvim_set_current_win(main_winnr)
  end
end

local function root_dir()
  local util = require 'lspconfig.util'
  local get_root_dir = util.root_pattern 'build.sh'

  local bufname = vim.api.nvim_buf_get_name(main_bufnr)
  local root_dir_path
  if type(get_root_dir) == 'function' then
    root_dir_path = get_root_dir(vim.fs.normalize(bufname))
  elseif type(get_root_dir) == 'string' then
    root_dir_path = get_root_dir
  end
  return root_dir_path
end

vim.api.nvim_create_user_command('Build', function()
  make_buf()
  close_job(run_command(root_dir() .. '/build.sh'))
end, {})

vim.api.nvim_create_user_command('BuildRun', function()
  make_buf()
  close_job(run_command(root_dir() .. '/build.sh -r'))
end, {})

return {
  { '<leader>q', ':q<CR>', desc = 'Quit' },
  { '<leader>W', ':wa<CR>', desc = 'Write all' },
  -- { '<leader>bD', ':bufdo bd<cr>', desc = 'Delete all buffers' },
  -- { '<leader>bd', ':bd<cr>', desc = 'Delete buffer' },
  { '<leader>u', '<CMD>UndotreeToggle<CR><CMD>UndotreeFocus<CR>', desc = 'Toggle undotree' },
  { '<leader>w', ':w<CR>', desc = 'Write' },
  { '<leader>co', ':copen<cr>', desc = 'Qickfix open window', silent = true },
  { '<leader>cw', ':cw<cr>', desc = 'Qickfix open window If error', silent = true },
  { '<leader>cn', ':cn<cr>', desc = 'Qickfix next element', silent = true },
  { '<leader>cp', ':cp<cr>', desc = 'Qickfix prev element', silent = true },
  { '<leader>cs', ':cdo s///gc', desc = 'Search and Replace quickfix selected', silent = false },
  { '<F4>', ':Build<cr>', desc = 'Build', silent = true },
  { '<F5>', ':BuildRun<cr>', desc = 'Build and Run', silent = true },
}
