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
        if cbt_exists then temp = cbt_exists() end 
    
        if temp then this_val_msg = temp end
        if not temp then this_val_msg = tostring(v) end

        msg = msg .. this_val_msg
    end

    print(msg)
end

return API