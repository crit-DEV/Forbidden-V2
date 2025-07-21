--[[
From prooheckcp_robloxstatemachine@1.1.7
    Deep copy of the object
]]
TablesLibrary = {}

TablesLibrary.DeepCopy = function <T>(object)
    local newObject = {} -- Clone metaData (@rman501, good that it does this.)

    for index: string, value: any in object do
        if typeof(value) == "table" then
            newObject[index] = TablesLibrary.DeepCopy(value)
            continue
        end

        newObject[index] = value
    end

	return setmetatable(newObject, getmetatable(object))
end

TablesLibrary.DeepCopyPaste = function(Overwriter, Target)
    for index, value in Overwriter do
        if typeof(value) == "table" then
            TablesLibrary.DeepCopyPaste(value, Target[index])
        else
            Target[index] = value
        end
    end

    setmetatable(Target, getmetatable(Overwriter))
end

TablesLibrary.LockKeyInTable = function <T>(Target, Key: string)
    -- Lock a key in the table, so it cannot be modified
    setmetatable(Target, {
        __index = Target,
        __newindex = function(tab, key, value)
            if key == Key and tab[key] ~= value then -- TODO:// should we keep the check if same val?
                error(`Attempt to modify read-only field '{key}' in Table`, 2)
            end
            rawset(tab, key, value)
        end,
    })
end

TablesLibrary.RemoveMetatable = function <T>(Target)
    -- Remove the lock on a key in the table
    setmetatable(Target, nil)
end


return TablesLibrary