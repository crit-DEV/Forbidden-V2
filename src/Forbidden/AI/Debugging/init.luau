--[[ 6/27/25
Not attached to the Config that way people don't send logs with their info mixed in :/
    we can change in future if it would be convenient.

Developer History
    > @crit-dev (@rman501), initial commit
        o7 to future devs

]]--

-- == Forbidden Modules & Architecture == --
local ConfigHandler = require(script.Parent.ConfigHandler)


-- == Setup == --
local API = {}
local ConversionByType = {}
-- local scriptLogs = {}


-- == Convert Message By Type == --
ConversionByType.Instance = function(v: Instance)
    return v:GetFullName()
end

ConversionByType.CFrame = function(v: CFrame)
    return tostring(v.Position)
end

-- == API Functions == --
API.Log = function(NPC, ...)

    local ac = ConfigHandler.GetActiveConfig(NPC)
    if not ac.Debugging.Enabled then return end

    local callerName = debug.info(2, "s")

    local inputtedinfo = {...}
    local msg = "[" .. callerName .. "]: "

    for i, v: any in pairs(inputtedinfo) do
        local this_val_msg = "COULD NOT CONVERT VAL TYPE!" -- default
        
        local val_type = typeof(v)

        local temp = nil
        local cbt_exists = ConversionByType[val_type]
        if cbt_exists ~= nil then temp = cbt_exists(v) end 
    
        if temp then this_val_msg = temp end
        if not temp then this_val_msg = tostring(v) end

        msg = msg .. this_val_msg
    end

    print(msg)
end

API.LogWithVerbosity = function(NPC: Instance, Verbosity: number, ...)
    local ac = ConfigHandler.GetActiveConfig(NPC)
    if not ac.Debugging.Enabled then return end

    if ac.Debugging.Verbosity < Verbosity then return end
    API.Log(NPC, ...)
end

-- Saw this in a python function on a short, seemed really cool.
API.TimeIt = function(name: string, callback: () -> ())
    local startTime = os.clock()
    local success, result = pcall(callback)
    local endTime = os.clock()
    local elapsed = endTime - startTime

    if success then
        print(string.format(name .. " | Elapsed time: %.6f seconds", elapsed))
    else
        warn(string.format(name .. " | Callback failed after %.6f seconds: %s", elapsed, result))
    end

    return elapsed, success, result
end

return API