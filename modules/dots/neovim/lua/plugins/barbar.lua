return {
    owner = 'romgrk',
    repo = 'barbar.nvim',
    immediate = true,
    deps = {
        { owner = 'nvim-tree', repo = 'nvim-web-devicons' },
    },
    config = function()
        local map = require 'config.map'
        map('n', '<S-Tab>', ':BufferNext<CR>')
        map('n', '<S-w>', ':BufferClose<CR>')
    end
}
