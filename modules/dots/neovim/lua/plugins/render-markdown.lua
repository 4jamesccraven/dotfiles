return {
    owner = 'MeanderingProgrammer',
    repo = 'render-markdown.nvim',
    config = function()
        require 'render-markdown'.setup {
            -- avoids checkhealth warning
            latex = { enabled = false },
        }
    end
}
