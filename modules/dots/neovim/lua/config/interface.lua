-- Tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.list = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Search Config
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Default Split Options
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Scrolling Offset
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Text Wrapping
vim.opt.wrap = false

-- Set tabsize for *.nix
local nix_ft = vim.api.nvim_create_augroup('NixTabSettings', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    group = nix_ft,
    pattern = 'nix',
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
    end
})

-- Set tabsize for *.go
-- NOTE: this is the same as my default settings, Go just doesn't understand what consent is.
local go_ft = vim.api.nvim_create_augroup('GoTabSettings', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    group = go_ft,
    pattern = 'go',
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = true
        vim.opt_local.list = true
    end
})

-- Remember last place in buffer
local lastplace = vim.api.nvim_create_augroup("LastPlace", {})
vim.api.nvim_clear_autocmds({ group = lastplace })
vim.api.nvim_create_autocmd("BufReadPost", {
    group = lastplace,
    pattern = { "*" },
    desc = "remember last cursor place",
    callback = function()
        if vim.fn.expand('%:t') == 'COMMIT_EDITMSG' then
            return
        end

        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})
