---Runs `hostname` to determine the name of the host.
---@return string|nil
local function hostname_init()
    local handle = io.popen('hostname')
    if not handle then return nil end

    local result = handle:read("*a") or ''
    handle:close()
    return result:gsub('%s+$', '')
end

---Returns a function that either retrieves the cached hostname or initialises it.
---May return nil.
---@return fun(): string|nil
local function hostname()
    local hostname_string

    return function()
        if hostname_string == nil then
            hostname_string = hostname_init()
        end

        return hostname_string
    end
end

---@return string|nil
return hostname()()
