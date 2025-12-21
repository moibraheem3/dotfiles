vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local options = {
  breakindent = true, -- Enable break indent
  completeopt = 'menu,menuone,noselect', -- Set completeopt to have a better completion experience
  hlsearch = false, -- highlight all matches on previous search pattern
  ignorecase = true, -- ignore case in search patterns
  termguicolors = true, -- set term gui colors (most terminals support this)
  undofile = true, -- enable persistent undo
  expandtab = true, -- convert tabs to spaces
  -- cursorline = true, -- highlight the current line
  number = false, -- set numbered lines
  relativenumber = false, -- set relative numbered lines
  scrolloff = 8, -- minimal number of screen lines to keep above and below the cursor.
  sidescrolloff = 8, -- minimal number of screen lines to keep left and right of the cursor.
  guicursor = 'n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175',
  foldmethod = 'expr',
  foldenable = false,
  foldlevel = 99,
  backup = false, -- creates a backup file
  cmdheight = 1, -- more space in the neovim command line for displaying messages
  conceallevel = 0, -- so that `` is visible in markdown files
  fileencoding = 'utf-8', -- the encoding written to a file
  -- foldexpr = 'v:lua.vim.treesitter.foldexpr()', -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
  guifont = 'monospace:h17', -- the font used in graphical neovim applications
  hidden = true, -- required to keep multiple buffers and open multiple buffers
  mouse = 'a', -- allow the mouse to be used in neovim
  pumheight = 10, -- pop up menu height
  showmode = false, -- we don't need to see things like -- INSERT -- anymore
  smartcase = true, -- smart case
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  swapfile = false, -- creates a swapfile
  timeoutlen = 300, -- time to wait for a mapped sequence to complete (in milliseconds)
  title = true, -- set the title of window to the value of the titlestring
  updatetime = 250, -- faster completion
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  shiftwidth = 2, -- the number of spaces inserted for each indentation
  tabstop = 2, -- insert 2 spaces for a tab
  numberwidth = 4, -- set number column width to 4 {default 4}
  signcolumn = 'auto', -- always show the sign column, otherwise it would shift the text each time
  wrap = false, -- display lines as one long line
  showcmd = false, -- Don't show the command in the last line
  ruler = false, -- Don't show the ruler
  laststatus = 3,
  -- colorcolumn = '80',
  inccommand = 'nosplit',
  -- list = true,
  -- fillchars = {
  --   fold = ' ',
  --   foldopen = '',
  --   foldclose = '',
  --   foldsep = '│',
  --   diff = '╱',
  --   eob = ' ',
  -- },
  -- foldtext = '',
  foldcolumn = '0',
  -- listchars = {
  --   tab = '» ',
  --   trail = '.',
  --   nbsp = '␣',
  --   eol = '↴',
  -- },
  jumpoptions = 'view',
  pumblend = 10, -- Popup blend
  shiftround = true, -- Round indent
  smartindent = true, -- Insert indents automatically
  splitkeep = 'screen',
  virtualedit = 'block', -- Allow cursor to move where there is no text in visual block mode
  wildmode = 'longest:full,full', -- Command-line completion mode
  winminwidth = 5, -- Minimum window width
  shada = { "'10", '<0', 's10', 'h' },
  winborder = 'none',
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.iskeyword:append '-'
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
