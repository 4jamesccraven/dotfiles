-- Experimental plugin loader, helps with performance
vim.loader.enable()

-- Generic Config
require 'config.interface'
require 'config.keybinds'

-- Plugins, see `/lua/yap.lua`
require 'yap'.setup()
