---@class HLX.BindHelpers
local M = {}

---@class HLX.BindOpts
---@field cmd? boolean
---@field passthru? HL.BindOptions
---@field media? boolean

---A helper to make a Hyprland bind.
---@param keys string The keys for the keybind
---@param dispatcher string|function|HL.Dispatcher What happens when the bind is activated
---@param opts? HLX.BindOpts Additional options
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

        local scale_factor = 0.75 -- Scale factor for floating size.
        local height = scale_factor * mon.height
        local width = height / 9 * 16
        hl.dispatch(hl.dsp.window.resize {
            x = width,
            y = height,
            relative = false,
        })

        hl.dispatch(hl.dsp.window.center())
    end
end

---Emulates minimising a window by moving it to a special workspace and back.
---@return nil
function M.toggle_minimised()
    local special_ws = 'special:minimised'
    local ws = hl.get_workspace(special_ws)

    if ws and ws.windows > 0 then
        hl.dispatch(hl.dsp.workspace.toggle_special('minimised'))
        hl.dispatch(hl.dsp.window.move {
            workspace = '+0',
        })
    else
        hl.dispatch(hl.dsp.window.move {
            workspace = special_ws,
            follow = false,
        })
    end
end

---@class HLX.BindHelpers
return M
