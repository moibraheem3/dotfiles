vim.pack.add {
    'https://github.com/tpope/vim-dispatch',
}

vim.g.dispatch_no_tmux_make = 1

vim.diagnostic.enable(false)
vim.cmd [[
    set makeprg=./nob
]]
