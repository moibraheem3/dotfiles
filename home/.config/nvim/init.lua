-- Options
vim.opt.termguicolors = true
vim.opt.fileencoding = 'utf-8'
vim.opt.updatetime = 300
vim.opt.mouse = 'a'
vim.opt.undofile = true
vim.opt.swapfile = false
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)
vim.opt.confirm = true
vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'fuzzy', 'popup' }
vim.opt.complete = '.,w,b,u,o,F'
vim.opt.wildignorecase = true
vim.opt.path = { '.', '**' }
vim.opt.virtualedit = { 'block' }
-- Searching Behaviors
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'split'
vim.opt.hlsearch = false
vim.opt.wildmode = 'noselect:longest:lastused,full'
vim.opt.grepprg = "rg --vimgrep --smart-case --hidden -g '!.git/*'"
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
-- Splits
vim.opt.splitright = true
-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.autoindent = true
-- Lines
vim.opt.wrap = false
vim.opt.cursorline = false
-- Appearance
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.winborder = 'rounded'
-- Code Folding
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = 'indent'
-- Misc
vim.g.markdown_recommended_style = 0
vim.g.c_syntax_for_h = 1
vim.g.health = { style = 'float' }

-- Plugins
vim.pack.add {
    'https://github.com/stevearc/oil.nvim',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/dmtrKovalenko/fff.nvim',
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
    'https://github.com/stevearc/conform.nvim',
}

-- On-demand plugins, not loaded until ":packadd …".
vim.pack.add({
    'https://github.com/mbbill/undotree',
    'https://github.com/tpope/vim-dispatch',
}, {
    load = function() end,
})

-- Keymaps
vim.g.mapleader = ' '
vim.keymap.set('v', 'p', '"_dP')
vim.keymap.set('n', '<leader>o', ':so ~/dotfiles/home/.config/nvim/init.lua<cr>')
vim.keymap.set('n', '<leader>w', ':w<cr>')
vim.keymap.set('n', '<leader>q', ':q<cr>')
vim.keymap.set('n', '<leader>gp', ':GBlame<cr>')

vim.keymap.set('n', '<leader>e', ':Oil<cr>')
vim.keymap.set('n', '<leader>u', ':UndotreeToggle<cr> :UndotreeFocus<cr>')

vim.keymap.set('n', '<leader>sf', require('fff').find_files)
vim.keymap.set('n', '<leader>sg', ':Zgrep ')
vim.keymap.set('n', '<leader>su', ':grep <c-r><c-w><cr>')

vim.keymap.set('n', '<leader>lf', function()
    require('conform').format {}
end)
vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action)
vim.keymap.set('x', '<leader>la', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)
vim.keymap.set('n', 'go', vim.lsp.buf.type_definition)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help)
vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist)

-- user commands

vim.api.nvim_create_user_command('GBlame', function()
    local ln = vim.fn.line '.'
    local buf_name = vim.api.nvim_buf_get_name(0)
    local bufnr = vim.api.nvim_create_buf(false, true)

    local blame_cmd = 'git blame -L ' .. ln .. ',' .. ln .. ' ' .. buf_name
    local show_cmd = 'git log -1 --pretty=%s '

    local blame_out = vim.fn.system(blame_cmd)
    local out = { 'Not Committed Yet' }
    if not string.find(blame_out, 'fatal:') then
        local lb = string.find(blame_out, '%(') or 0
        local rb = string.find(blame_out, '%d +%d') or 0
        local fs = string.find(blame_out, ' ') or 0

        local hash = vim.fn.strpart(blame_out, 0, fs - 1)
        local auther = vim.fn.strpart(blame_out, lb, (rb - lb))

        if not string.match(hash, '00000000') then
            -- if string.len(hash) > 7 then hash = vim.fn.strpart(hash, 1, 7) end
            local msg = vim.fn.system(show_cmd .. hash)
            msg = string.gsub(msg, '\n', '')
            local first_line = string.format('%s %s: ', hash, auther)
            out = { first_line, msg }
        end
    end

    local width = string.len(out[1])
    local height = 1
    if out[2] ~= nil then
        local w = string.len(out[2])
        if width < w then
            width = w
        end
        height = 2
    end
    width = width + 8

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, out)
    vim.api.nvim_set_option_value('filetype', 'markdown', { buf = bufnr })
    vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
    vim.api.nvim_open_win(bufnr, true, {
        relative = 'cursor',
        width = width,
        height = height,
        border = 'rounded',
        row = 0,
        col = 0,
    })
end, {})

vim.cmd [[
command! -nargs=1 Cfuzzy call FuzzyFilterQf(<f-args>)

function! FuzzyFilterQf(...) abort
    call setqflist(matchfuzzy(getqflist(), join(a:000, " "), {'key': 'text'}))
endfunction

nnoremap <leader>z :Zgrep<space>
command! -nargs=+ -complete=file_in_path Zgrep call FuzzyFilterGrep(<f-args>)
function! FuzzyFilterGrep(query, path=".") abort
    exe "grep! '" .. a:query .. "' " .. a:path
    let sort_query = substitute(a:query, '\.\*', '', 'g')
    let sort_query = substitute(sort_query, '\\\(.\)', '\1', 'g')
    call FuzzyFilterQf(sort_query)
    cfirst
    copen
endfunction
]]

-- auto commands

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local lsp = vim.lsp
        local methods = lsp.protocol.Methods

        local bufnr = args.buf
        local client = lsp.get_client_by_id(args.data.client_id)

        ----------------------------------------------------------------------------
        ---@from https://gist.github.com/MariaSolOs/2e44a86f569323c478e5a078d0cf98cc
        --- with some modification and fixes
        ----------------------------------------------------------------------------
        if client and client:supports_method(methods.textDocument_completion) then
            local function keymap(lhs, rhs, opts, mode)
                opts = type(opts) == 'string' and { desc = opts } or vim.tbl_extend('error', opts --[[@as table]], { buffer = bufnr })
                mode = mode or 'n'
                vim.keymap.set(mode, lhs, rhs, opts)
            end

            local function feedkeys(keys)
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
            end

            local function pumvisible()
                return tonumber(vim.fn.pumvisible()) ~= 0
            end

            vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

            -- Use <Tab> to accept a Copilot suggestion, navigate between snippet tabstops,
            -- or select the next completion.
            -- Do something similar with <S-Tab>.
            keymap('<Tab>', function()
                -- local copilot = require 'copilot.suggestion'
                --
                -- if copilot.is_visible() then
                --     copilot.accept()
                -- elseif
                if pumvisible() then
                    feedkeys '<C-n>'
                elseif vim.snippet.active { direction = 1 } then
                    vim.snippet.jump(1)
                else
                    feedkeys '<Tab>'
                end
            end, {}, { 'i', 's' })
            keymap('<S-Tab>', function()
                if pumvisible() then
                    feedkeys '<C-p>'
                elseif vim.snippet.active { direction = -1 } then
                    vim.snippet.jump(-1)
                else
                    feedkeys '<S-Tab>'
                end
            end, {}, { 'i', 's' })

            -- Inside a snippet, use backspace to remove the placeholder.
            keymap('<BS>', '<C-o>s', {}, 's')
        end
    end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'typescript', 'typescriptreact', 'javascript', 'css', 'html', 'json', 'yaml', 'markdown', 'vue' },
    callback = function()
        vim.opt.iskeyword:append { '-', '#', '$' }
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c' },
    callback = function()
        vim.diagnostic.enable(false)
        vim.cmd [[ set makeprg=./nob ]]
    end,
})
vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'fff.nvim' and (kind == 'install' or kind == 'update') then
            if not ev.data.active then
                vim.cmd.packadd 'fff.nvim'
            end
            require('fff.download').download_or_build_binary()
        end
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'lua', 'c', 'typescript', 'typescriptreact', 'javascript', 'css', 'html', 'json', 'yaml', 'markdown', 'vue', 'prisma' },
    callback = function()
        vim.treesitter.start()
    end,
})

-- Plugins config
require('oil').setup {
    keymaps = {
        ['<C-l>'] = false,
        ['<C-r>'] = 'actions.refresh',
        ['<C-h>'] = false,
        ['<M-h>'] = 'actions.select_split',
        ['<leader>e'] = 'actions.close',
    },
    columns = {
        'permissions',
        'size',
        'mtime',
        'icon',
    },
    default_file_explorer = true,
    delete_to_trash = true,
    view_options = {
        show_hidden = true,
        natural_order = 'fast',
    },
    win_options = {
        wrap = true,
    },
}

vim.lsp.enable {
    'lua_ls',
    'gopls',
    'nixd',
    'tailwindcss',
    'htmx',
    'templ',
    'gdscript',
    'gdshader_lsp',
    'basedpyright',
    -- 'angularls',
    'postgres_lsp',
    'rust_analyzer',
    'clangd',
    'vtsls',
    'ols',
    'zls',
    'ccls',
    'vue_ls',
}
vim.lsp.config('nixd', {
    settings = {
        nixd = {
            nixpkgs = {
                expr = 'import <nixpkgs> { }',
            },
            formatting = {
                command = { 'alejandra' },
            },
            options = {
                nixos = {
                    expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.laptop.options',
                },
                home_manager = {
                    expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."mohamed@laptop".options',
                },
            },
        },
    },
})

local vue_plugin = {
    name = '@vue/typescript-plugin',
    location = vim.fn.expand '$VUE_LS_PATH',
    languages = { 'vue' },
    configNamespace = 'typescript',
}
vim.lsp.config('vtsls', {
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    settings = {
        vtsls = {
            tsserver = {
                maxTsServerMemory = 3072,
                globalPlugins = { vue_plugin },
            },
        },
    },
})
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
            },
        },
    },
})

vim.g.fff = {
    lazy_sync = true, -- start syncing only when the picker is open
    debug = {
        enabled = false,
        show_scores = false,
    },
}

require('fff').setup {
    prompt = '> ',
    title = 'Files',
    keymaps = {
        close = { '<C-c>', '<Esc>' },
    },
    preview = {
        enabled = false,
    },
    layout = {
        height = 0.5,
        width = 0.5,
        prompt_position = 'top',
    }
}

require('nvim-treesitter').install {
    'javascript',
    'typescript',
    'comment',
    'tsx',
    'jsx',
    'css',
    'html',
    'json',
    'yaml',
    'markdown',
    'vue',
}

require('conform').setup {
    formatters = {
        odinfmt = {
            command = 'odinfmt',
            args = { '-stdin' },
            stdin = true,
        },
    },
    default_format_opts = {
        timeout_ms = 3000,
        lsp_format = 'fallback',
    },
    formatters_by_ft = {
        javascript = { 'prettierd', 'prettier' },
        typescript = { 'prettierd', 'prettier' },
        javascriptreact = { 'prettierd', 'prettier' },
        typescriptreact = { 'prettierd', 'prettier' },
        vue = { 'prettierd', 'prettier' },
        htmlangular = { 'prettierd', 'prettier' },
        svelte = { 'prettierd', 'prettier' },
        css = { 'prettierd', 'prettier' },
        html = { 'prettierd', 'prettier' },
        json = { 'prettierd', 'prettier' },
        lua = { 'stylua' },
        cpp = { 'clang_format' },
        gdscript = { 'gdformat' },
        nix = { 'alejandra' },
        python = { 'black' },
        odin = { 'odinfmt' },
    },
}

local richblack = '#020202'
local lightbronze = '#b99468'
local charcoalgray = '#212121'
local charcoalgraylite = '#1e1e1e'
local gunmetalblue = '#303040'
local darkslate = '#222425'
local ambergold = '#fcaa05'
local mediumgray = '#404040'
local jetblack = '#121212'
local dimgray = '#666666'
local goldenrod = '#f0c674'
local brightorange = '#ffaa00'
local dustyrose = '#dc7575'
local sunfloweryellow = '#edb211'
local burntorange = '#de451f'
local skyblue = '#2895c7'
local skybluelite = '#2f2f38'
local brightred = '#ff0000'
local freshgreen = '#66bc11'
local limegreen = '#003939'
local vividvermilion = '#f0500c'
local goldenyellow = '#f0bb0c'
local pureblack = '#000000'
local aquaice = '#8ffff2'
local dustysage = '#9ba290'
local coffeebrown = '#63523d'
local olivedrab = '#6b8e23'

local function hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

hl('Normal', { fg = lightbronze, bg = richblack })
hl('NormalFloat', { fg = coffeebrown })
hl('FloatBorder', { fg = darkslate })
hl('Cursor', { fg = richblack, bg = freshgreen })
hl('Visual', { bg = charcoalgray })
hl('LineNr', { fg = charcoalgray })
hl('CursorLineNr', { fg = darkslate, bold = true })
hl('VertSplit', { fg = darkslate })
hl('StatusLine', { bg = darkslate })
hl('StatusLineNC', { bg = '#0a0a0a' })
hl('Pmenu', { bg = charcoalgray })
hl('PmenuSel', { fg = charcoalgray, bg = lightbronze })
hl('EndOfBuffer', { fg = richblack })
hl('Directory', { fg = goldenyellow })
hl('Title', { fg = lightbronze })
hl('MoreMsg', { fg = lightbronze })
hl('ModeMsg', { fg = lightbronze })
hl('WinSeparator', { fg = darkslate })
hl('ErrorMsg', { fg = brightred })
hl('Question', { fg = lightbronze })
hl('QuickFixLine', { fg = burntorange })

-- Syntax
hl('Comment', { fg = dimgray, italic = true })
hl('String', { fg = olivedrab })
hl('Number', { fg = dustyrose })
hl('Function', { fg = burntorange })
hl('Keyword', { fg = goldenrod })
hl('Identifier', { fg = lightbronze })
hl('Type', { fg = sunfloweryellow })
hl('Constant', { fg = brightorange })
hl('Operator', { fg = lightbronze })
hl('Todo', { fg = vividvermilion, bold = true })
hl('Statement', { fg = dustyrose })
hl('PreProc', { fg = dustyrose })
hl('Special', { fg = lightbronze })
hl('Delimiter', { fg = lightbronze })
hl('Ignore', { fg = skybluelite })

-- Treesitter
hl('@comment', { fg = dimgray, italic = true })
hl('@string', { fg = olivedrab })
hl('@number', { fg = dustyrose })
hl('@function', { fg = burntorange })
hl('@function.call', { fg = burntorange })
hl('@keyword', { fg = goldenrod })
hl('@conditional', { fg = dustyrose })
hl('@repeat', { fg = dustyrose })
hl('@type', { fg = sunfloweryellow })
hl('@type.builtin', { fg = sunfloweryellow })
hl('@constant', { fg = dustyrose })
hl('@variable', { fg = lightbronze })
hl('@variable.builtin', { fg = dustyrose })
hl('@field', { fg = lightbronze })
hl('@property', { fg = lightbronze })
hl('@operator', { fg = lightbronze })
hl('@keyword.import', { link = 'PreProc' })
hl('@keyword.directive.define', { link = 'PreProc' })
hl('@keyword.directive', { link = 'PreProc' })

-- LSP
hl('DiagnosticError', { fg = brightred, italic = true })
hl('DiagnosticWarn', { fg = goldenyellow, italic = true })
hl('DiagnosticInfo', { fg = skyblue, italic = true })
hl('DiagnosticHint', { fg = freshgreen, italic = true })
hl('DiagnosticUnderlineError', { undercurl = true, sp = brightred, italic = true })
hl('DiagnosticUnderlineWarn', { undercurl = true, sp = goldenyellow, italic = true })
hl('DiagnosticUnderlineInfo', { undercurl = true, sp = skyblue, italic = true })
hl('DiagnosticUnderlineHint', { undercurl = true, sp = freshgreen, italic = true })
hl('LspReferenceText', { bg = pureblack })
hl('LspReferenceRead', { bg = pureblack })
hl('LspReferenceWrite', { bg = pureblack })
hl('LspInlayHint', { fg = charcoalgray, bg = pureblack, italic = true })
hl('LspCodeLens', { fg = charcoalgray, italic = true })

-- Deff
hl('Removed', { fg = brightred, italic = true })
hl('Changed', { fg = skyblue, italic = true })
hl('Added', { fg = freshgreen, italic = true })
