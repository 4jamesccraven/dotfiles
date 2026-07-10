return {
    owner = 'neovim',
    repo = 'nvim-lspconfig',
    config = function()
        local map = require 'config.map'
        local servers = {
            -- Always Installed
            bashls = true,
            clangd = true,
            pyright = true,
            rust_analyzer = true,
            nixd = {
                settings = {
                    formatting = {
                        command = { "nixfmt" },
                    },
                }
            },
            tinymist = {
                settings = {
                    formatterMode = 'typstyle',
                }
            },
            lua_ls = {
                on_init = function(client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if
                            path ~= vim.fn.stdpath('config')
                            and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
                        then
                            return
                        end
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                        runtime = {
                            version = 'LuaJIT',
                            path = {
                                'lua/?.lua',
                                'lua/?/init.lua',
                            },
                        },
                        -- Make the server aware of Neovim runtime files
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME,
                            },
                        },
                    })
                end,
                settings = {
                    Lua = {},
                },
            },

            -- Shell Only
            chsharp_ls = true,
            cmake = true,
            cssls = true,
            gopls = true,
            hls = true,
            jdtls = true,
            perlls = true,
            ts_ls = true,
        }

        -- Enable all servers, apply config if provided
        for name, config in pairs(servers) do
            if config ~= true then
                vim.lsp.config(name, config)
            end
            vim.lsp.enable(name)
        end

        -- Keybinds
        map('n', '<leader>lk', function() vim.lsp.buf.hover() end)
        map('n', '<leader>lf', function() vim.lsp.buf.definition() end)
        map('n', '<leader>d', function() vim.diagnostic.open_float() end)
        map('n', '<leader>lr', function() vim.lsp.buf.rename() end)
        map('n', '<leader>ln', function() vim.diagnostic.jump({ forward = true, count = 1 }) end)
        map('n', '<leader>lp', function() vim.diagnostic.jump({ forward = false, count = 1 }) end)
        map('n', '<leader>lb', function() vim.lsp.buf.format() end)

        -- Autocommands
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client == nil then
                    return
                end
                -- Format on save if supported
                if client:supports_method('textDocument/formatting') then
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        buffer = args.buf,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                        end,
                    })
                end
            end,
        })

        -- Fix for rust analyzer stuttering
        for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
            local default_diagnostic_handler = vim.lsp.handlers[method]
            vim.lsp.handlers[method] = function(err, result, context, config)
                if err ~= nil and err.code == -32802 then
                    return
                end
                return default_diagnostic_handler(err, result, context, config)
            end
        end
    end
}
