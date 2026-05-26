---@class JCC.BindHelpers
local M = {}

---@class JCC.BindOpts
---@field cmd? boolean
---@field passthru? HL.BindOptions
---@field media? boolean

---A helper to make a Hyprland bind.
---@param keys string The keys for the keybind
---@param dispatcher string|function|HL.Dispatcher What happens when the bind is activated
---@param opts? JCC.BindOpts Additional options
---@return nil
function M.bind(keys, dispatcher, opts)
    opts = opts or {}
    local base = opts.passthru or {}

    if opts.media then
        base.locked = true
        base.repeating = true
    end

    if opts.cmd and type(dispatcher) == 'string' then
        dispatcher = hl.dsp.exec_cmd(dispatcher)
    end

    ---@cast dispatcher function|HL.Dispatcher
    hl.bind(keys, dispatcher, base)
end

---Reimplementation of the old-style cycle visible dispatcher.
---@return nil
function M.cycle_visible()
    local monitors = hl.get_monitors()
    local windows = hl.get_windows()
    local current = hl.get_active_window()
    if not windows or not current then return end

    -- Collect visible workspaces.
    local visible_wss = {}
    for _, m in ipairs(monitors) do
        visible_wss[m.active_workspace.id] = true
    end

    -- Collect windows that are on visible workspaces.
    local visible = {}
    for _, w in ipairs(windows) do
        if visible_wss[w.workspace.id] then
            table.insert(visible, w)
        end
    end
    if #visible == 0 then return end

    -- Find the next visible window.
    local next = nil
    for i, w in ipairs(visible) do
        if w.address == current.address then
            next = visible[(i % #visible) + 1]
            break
        end
    end

    -- Focus next.
    hl.dispatch(hl.dsp.focus({ window = next }))
end

---Toggles the floating status of the current Hyprland window.
---@return nil
function M.toggle_float()
    local win = hl.get_active_window()
    if not win then return end

    local was_floating = win.floating                      -- Get current floating state
    hl.dispatch(hl.dsp.window.float { action = 'toggle' }) -- toggle unconditionally

    -- Centre and resize if it wasn't floating before
    if not was_floating then
        local mon = hl.get_active_monitor()
        if not mon then return end

        local scale_factor = 0.65 -- Scale factor for floating size.
        hl.dispatch(hl.dsp.window.resize {
            x = mon.width * scale_factor,
            y = mon.height * scale_factor,
            relative = false,
        })

        hl.dispatch(hl.dsp.window.center())
    end
end

---@class JCC.BindHelpers
return M
