-- A simple plugin manager based on vim.pack
-- Copyright (C) 2026  James C Craven
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
local M = {}

---@class Plug
---@field owner string        The owner of the git repo (username)
---@field repo string         The name of the git repo
---@field immediate? boolean  Whether a plugin should be started immediately (default false).
---@field site? string        The site that contains the git repo (default github).
---@field config? fun(): nil  Configuration that should run to configure the plugin.
---@field deps? Plug[]        A list of plugins that are dependencies of this one.

---Validates a plugin.
---@param plug Plug A plugin configuration.
local function validate_plugin(plug)
    vim.validate('plug', plug, 'table')

    vim.validate('owner', plug.owner, 'string')
    vim.validate('repo', plug.repo, 'string')
    vim.validate('immediate', plug.immediate, 'boolean', true)
    vim.validate('site', plug.site, 'string', true)
    vim.validate('config', plug.config, 'function', true)
    vim.validate('deps', plug.deps, 'table', true)
end

---Collects plugin configurations from a provided directory.
---@param dir string The directory with the config files.
---@return Plug[]
local function collect_plugs(dir)
    local scan = vim.uv.fs_scandir(dir)
    if not scan then return {} end

    local plugs = {}

    while true do
        local name, fs_type = vim.uv.fs_scandir_next(scan)
        if not name then break end

        if fs_type == 'file' and name:match("%.lua$") and name ~= "init.lua" then
            local module = 'plugins.' .. name:gsub("%.lua$", '')
            local ok, conf = pcall(require, module)
            if not ok then
                vim.notify(
                    'failed to load plugin config: ' .. module .. '\n' .. conf,
                    vim.log.levels.ERROR
                )
            end
            if ok and conf ~= nil then
                table.insert(plugs, conf)
            end
        end
    end

    return plugs
end

---Accumulates unique plugin specs into a list. Also ensures that plugins are valid.
---@param plug Plug A plugin configuration
---@param acc string[] An accumulator that contains the final list of specs.
---@param seen table<string, true> A set of already seen specs.
---@return nil
local function collect_specs(plug, acc, seen)
    validate_plugin(plug)

    local id = plug.owner .. '/' .. plug.repo
    if seen[id] then return end
    seen[id] = true

    table.insert(acc, (plug.site or 'https://github.com/') .. id)

    if plug.deps then
        for _, dep in ipairs(plug.deps) do
            collect_specs(dep, acc, seen)
        end
    end
end

---Runs configurations if something about them is true.
---@param plugs Plug[] A list of configurations to filter and potentially run.
---@param predicate fun(p: Plug): boolean A function that determins if a plugin's config should run.
local function run_configs_if(plugs, predicate)
    for _, plug in ipairs(plugs) do
        if plug.config ~= nil and predicate(plug) then
            local ok, conf = pcall(plug.config)
            if not ok then
                vim.notify(
                    'failed to load plugin: ' .. plug.owner .. '/' .. plug.repo .. '\n' .. conf,
                    vim.log.levels.ERROR
                )
            end
        end
    end
end

-- Collect user configuration.
local plugs = collect_plugs(vim.fn.stdpath('config') .. '/lua/plugins')
---@type string[]
local specs = {}
---@type table<string, true>
local seen = {}

if plugs ~= nil then
    -- Sort the list of plugins so that loading is deterministic
    table.sort(plugs, function(a, b)
        return (a.owner .. '/' .. a.repo) < (b.owner .. '/' .. b.repo)
    end)

    -- Ensure that all plugins are installed
    for _, plug in ipairs(plugs) do
        collect_specs(plug, specs, seen)
    end
    vim.pack.add(specs)

    -- Run plugins marked for immediate execution.
    run_configs_if(plugs, function(p) return p.immediate end)

    -- Wait until neovim has started to load the rest.
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            run_configs_if(plugs, function(p)
                return not p.immediate
            end)
        end
    })
end

-- Remove unused plugins (i.e., ones that have had their configuration deleted
-- since the previous startup).
local unused = vim.iter(vim.pack.get())
    :filter(function(x) return not x.active end)
    :map(function(x) return x.spec.name end)
    :totable()

if not vim.tbl_isempty(unused) then
    vim.pack.del(unused)
end

return M
