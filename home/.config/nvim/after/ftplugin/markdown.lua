vim.opt_local.colorcolumn = '95'

vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.md',
    callback = function()
        local target_dir = vim.fn.expand '~/Documents/notes'
        local buf_dir = vim.fn.expand '%:p:h'

        if not buf_dir:find(target_dir, 1, true) then
            return
        end

        local datetime = os.date '%Y/%m/%d %H:%M'
        local cursor = vim.api.nvim_win_get_cursor(0)

        local lines = vim.api.nvim_buf_get_lines(0, 0, 4, false)
        for i, line in ipairs(lines) do
            if line:match '^updated:' then
                lines[i] = 'updated: ' .. datetime
                vim.api.nvim_buf_set_lines(0, i - 1, i, false, { lines[i] })
                break
            end
        end

        vim.api.nvim_win_set_cursor(0, cursor)
    end,
})
