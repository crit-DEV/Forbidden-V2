-- [External Types] --
local TConfig = require(script.TConfig)
local TRequestPriority = require(script.TRequestPriority)

-- [Exported Types] --
export type Config = TConfig.Config

-- local StopTypes = table.freeze({
--     CurrentPosition = 0,
--     NoStopLogic = 1, -- this means the NPC will stop at the next waypoint, i.e. forbidden let's the current MoveTo finish, and does not care about what happens in between.
-- })
export type StopType = TConfig.StopType

-- local ProcessingState = table.freeze({
--     Requested = 0, -- a request has been made, but not yet processed
--     Processing = 1, -- a request is being processed
--     Processed = 2, -- a request has been processed
-- })
export type ProcessingState = "Requested" | "Processing" | "Processed"

export type RequestPriority = TRequestPriority.RequestPriority

-- enums
return {
    -- StopType = StopTypes,
    RequestPriority = TRequestPriority,
    -- ProcessingState = ProcessingState,
}