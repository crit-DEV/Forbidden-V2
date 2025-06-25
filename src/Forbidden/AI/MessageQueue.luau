-- == Libraries == --
local TablesLibrary = require(script.Parent.Parent.Libraries.Tables)

-- == Types == --
local AIT = require(script.Parent.Types)

-- == Forbidden Modules & Architecture == --
local Defaults = require(script.Parent.ConfigHandler.Defaults)

local myEnum = table.freeze({
    Testing1 = 1,
    NextWaypoint = 2,
})




type MQ_Singleton = {
    ["ActiveConfig"]: AIT.Config,
    ["NewestStartRequest"]: {
        ["RequestType"]: "Start",
        ["Target"]: any?, -- can be any type, but usually a Model or Instance or Location
        ["Yields"]: boolean,
        ["Time"]: number,
        ["Priority"]: AIT.RequestPriority, -- Compares with the EndRequest, if greater, it will be processed first (only matters if the time is the same)
        ["ProcessingState"]: AIT.ProcessingState,
    },
    ["NewestStopRequest"]: {
        ["RequestType"]: "Stop",
        ["Time"]: number,
        ["Yields"]: boolean, 
        ["Priority"]: AIT.RequestPriority, -- Compares with the StartRequest, if greater, it will be processed first. (only matters if the time is the same)
        ["ProcessingState"]: AIT.ProcessingState,
    }
}

type MQ = {
    [Instance]: MQ_Singleton
}

local Messages: MQ = {}

local API = {}


-- == Assisting Functions == --
local function InitializeMQ(NPC: Instance)
    
    -- If there is already a MQ_Singleton for this NPC, do not initialize again
    if Messages[NPC] then return end
    
    -- Create a new MQ_Singleton for the NPC
    Messages[NPC] = {
        ActiveConfig = TablesLibrary.DeepCopy(Defaults),
        NewestStartRequest = {
            RequestType = "Start",
            Target = nil,
            Yields = false,
            Time = os.clock(),
            Priority = AIT.RequestPriority.ConvertPriorityToNumber("DefaultStart"), -- default priority
            ProcessingState = "Requested"
        },
        NewestStopRequest = {
            RequestType = "Stop",
            Time = os.clock(),
            Yields = false,
            Priority = AIT.RequestPriority.ConvertPriorityToNumber("DefaultStop"), -- default priority
            ProcessingState = "Requested"
        },
        Processing = false
    }

    TablesLibrary.LockKeyInTable(Messages[NPC].NewestStartRequest, "RequestType")
    TablesLibrary.LockKeyInTable(Messages[NPC].NewestStopRequest, "RequestType")
end

local function GetMQSingleton(NPC: Instance): MQ_Singleton
    -- Get the MQ_Singleton for the NPC, if it does not exist, initialize it
    if not Messages[NPC] then
        InitializeMQ(NPC)
    end

    return Messages[NPC]
end

-- == API Functions == --
API.GetRequest = function(NPC: Instance) -- TODO:// determine type stuff
end
-- TODO:// both ? what should this func purpose be?

API.GetUntouchedRequest = function(NPC: Model)
    local MQ_Singleton = GetMQSingleton(NPC)

    -- assisting vars
    local startExists = MQ_Singleton.NewestStartRequest.ProcessingState == "Requested"
    local stopExists  = MQ_Singleton.NewestStopRequest.ProcessingState == "Requested"

    -- IF NEITHER EXISTS, RETURN NIL
    if not startExists and not stopExists then
        return nil
    end

    -- IF 1 EXISTS AND THE OTHER DOES NOT, RETURN THE ONE THAT EXISTS
    if startExists and not stopExists then
        return MQ_Singleton.NewestStartRequest
    end

    if stopExists and not startExists then
        return MQ_Singleton.NewestStopRequest
    end

    -- IF BOTH EXIST, RETURN THE ONE WITH THE HIGHEST PRIORITY
    -- IF SAME, PREFER NEW START
    local function GetPrioritizedRequest()
        -- Priorities
        local startPriority = MQ_Singleton.NewestStartRequest.Priority
        local stopPriority  = MQ_Singleton.NewestStopRequest.Priority
    
        if startPriority > stopPriority then
            return MQ_Singleton.NewestStartRequest
        end
    
        if stopPriority > startPriority then
            return MQ_Singleton.NewestStopRequest
        end

        -- if same prio, prefer start
        return MQ_Singleton.NewestStartRequest
    end

    -- IF BOTH EXIST, RETURN THE ONE WITH THE LATEST TIME
    -- IF SAME, PREFER NEW START
    local function GetLatestRequest()
        -- Priorities
        local startTime = MQ_Singleton.NewestStartRequest.Time
        local stopTime  = MQ_Singleton.NewestStopRequest.Time

        if startTime > stopTime then
            return MQ_Singleton.NewestStartRequest
        end
    
        if stopTime > startTime then
            return MQ_Singleton.NewestStopRequest
        end

        -- if same time, prefer start
        return MQ_Singleton.NewestStartRequest
    end

    -- Prefer a higher priority?
    if not MQ_Singleton.ActiveConfig.RequestPrioritization.PreferTimeOverPriority then
        return GetPrioritizedRequest()
    end

    -- Prefer a later time?
    if MQ_Singleton.ActiveConfig.RequestPrioritization.PreferTimeOverPriority then
        return GetLatestRequest()
    end


    error("this shouldn't be showing, if you can replicate contact @crit-dev")
    return nil
end


API.IsProcessingStartRequest = function(NPC: Model): boolean
    local MQ_Singleton = GetMQSingleton(NPC)
    return MQ_Singleton.NewestStartRequest.ProcessingState == "Processing"
end


API.IsProcessingEndRequest = function(NPC: Model): boolean
    local MQ_Singleton = GetMQSingleton(NPC)
    return MQ_Singleton.NewestStopRequest.ProcessingState == "Processing"
end

--[[
Returns true if the API is currently processing either a start or end request.
]]--
API.IsProcessing = function(NPC: Model): boolean
    return API.IsProcessingStartRequest(NPC) or API.IsProcessingEndRequest(NPC)
end

API.SendStartMessage = function(NPC: Model, Target: any, Yields: boolean?, Priority: AIT.RequestPriority | number)
    local MQ_Singleton = GetMQSingleton(NPC)

    local prio: number = AIT.RequestPriority.ConvertPriorityToNumber("DefaultStart")
    if Priority ~= nil then -- can be 0
        prio = AIT.RequestPriority.GetPriorityNumber(Priority)
    end

    MQ_Singleton.NewestStartRequest = {
        Time = os.clock(),
        Target = Target,
        Yields = Yields or false,
        Priority = prio,
        ProcessingState = "Requested"
    }

    return
end


API.SendStopMessage = function(NPC: Model, Yields: boolean?, Priority: AIT.RequestPriority? | number?)
    local MQ_Singleton = GetMQSingleton(NPC)

    local prio: number = AIT.RequestPriority.ConvertPriorityToNumber("DefaultStop")
    if Priority ~= nil then -- can be 0
        prio = AIT.RequestPriority.GetPriorityNumber(Priority)
    end

    MQ_Singleton.NewestEndRequest = {
        Time = os.clock(),
        Yields = Yields or false,
        Priority = prio,
        ProcessingState = "Requested"
    }

    return
end

return API