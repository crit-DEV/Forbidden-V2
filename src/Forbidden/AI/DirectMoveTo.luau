--[[
Handles the efficient pathfind bypassing of Forbidden. Instead of pathfinding, if decided, it will use th

Developer History
    > @crit-dev (@rman501), initial commit
        o7 to future devs

]]--


-- == Forbidden Modules & Architecture == --
local root = script.Parent.Parent
local ConfigHandler             = require(root.AI.ConfigHandler)
local Common                    = require(root.Common)
local MathModule                = require(root.Math)
local CMathRequests             = require(root.AI.CommonMathRequests)
local ForbiddenDebugging        = require(root.AI.Debugging)
local PositionalOptimization    = require(root.AI.PositionalOptimization)


-- == External Types == --
local AIT = require(script.Parent.Types)

-- == Setup == --
local API = {}
local TimedRequests: {[Instance]: {
    LastCheckFloorFailTime: number,
    JumpStuckTime: number,
    JumpDebounceTime: number
}} = {}

-- target has to be instance at this point.
-- which means computing fake point elsewhere.
-- needs to be fore raycast.
API.CanUseDirectMoveTo = function(NPC: Instance, Target: Instance): boolean
    
    local Config: AIT.Config = ConfigHandler.GetActiveConfig(NPC)
    
    -- Check if req is blocked
    -- outside getRes bc otherwise infinite loop of time getting updated.
    if not TimedRequests[NPC] then TimedRequests[NPC] = {LastCheckFloorFailTime = 0, JumpStuckTime = 0, JumpDebounceTime = 0} end
    if TimedRequests[NPC] then
        if os.clock() < TimedRequests[NPC].LastCheckFloorFailTime + Config.DirectMoveTo.CheckFloor.BlockDirectMoveToTimer then return false end
    end

    -- If not an instance, then it is a position, which means it is non-tracking, which means we do not need this setting.
    local function getRes(): boolean
        if typeof(Target) ~= "Instance" then return false end


        if Config.DirectMoveTo.TrackingOnly and not Config.Tracking.Enabled then return false end
        -- if not Config.Tracking.Enabled then return false end     -- maybe use this if path does not compute ?
            -- either way it would not be here.


        local npc_part: BasePart? = Common.GetBasePart(Target)
        if npc_part == nil then error("NO NPC BASE") end
        
        local target_part: BasePart? = Common.GetBasePart(Target, true, NPC)
        if target_part == nil then error("NO NPC BASE") end

        local npc_pos = npc_part.CFrame.Position
        local target_pos = target_part.CFrame.Position

        local dist = (npc_pos - target_pos).Magnitude
        if Config.DirectMoveTo.ActivationDistance < dist then return false end

        local yDist = npc_pos.Y - target_pos.Y
        if Config.DirectMoveTo.HeightLimit < yDist then return false end

        if Config.DirectMoveTo.DoRaycast then
            -- TODO:// update math module and settings to be config handler based ?
            -- TODO:// add check to arms & multiple raycast hitboxes.
            if not CMathRequests.CanMoveToRaycast(NPC, Target) then ForbiddenDebugging.Log(NPC, "Failed direct raycast check to target."); return false end
        end

        if Config.DirectMoveTo.CheckFloor.Enabled then
            if Common.GetDistanceFromNPCToTarget(NPC, Target) > Config.DirectMoveTo.CheckFloor.DisableIfDistanceIsLessThan then
                if not CMathRequests.CanCrossFloorRaycast(NPC, Target) then ForbiddenDebugging.Log(NPC, "Failed cross floor check to target."); return false end
            end
        end

        if Config.DirectMoveTo.AvoidUseHook() then
            ForbiddenDebugging.Log(NPC, "DirectMoveTo was avoided by the user hook.")
            return false
        end

        return true
    end

    local result = getRes()
    if not result then
        TimedRequests[NPC].LastCheckFloorFailTime = os.clock()
    end
    return result
end

API.GetDirectMoveToPosition = function(NPC: Instance, Target: Instance): Vector3
    
    -- validation
    local npc_part: BasePart? = Common.GetBasePart(NPC)
    if npc_part == nil then error("NO NPC BASE") end

    local target_part: BasePart? = Common.GetBasePart(Target, true, NPC)
    if target_part == nil then error("NO TARGET BASE") end

    -- get pos
    local npc_pos = npc_part.CFrame.Position
    local target_pos = target_part.CFrame.Position

    -- get the config
    local config: AIT.Config = ConfigHandler.GetActiveConfig(NPC)

    -- predict the movement with a magnitude as follows.
    if config.Tracking.Enabled and config.Tracking.PredictionMagnitude > 0 then
        target_pos = PositionalOptimization.PredictMovement(target_part, config.Tracking.PredictionMagnitude)
    end

    -- offset from the predicted point of the target toward the NPC
    local goToPos = PositionalOptimization.GetCollinearTargetPositionOffset(target_pos, npc_pos, config.Tracking.CollinearTargetPositionOffset)
    
    return goToPos
end

API.DoJumpTick = function(NPC: Instance, Target: any)
    if not TimedRequests[NPC] then TimedRequests[NPC] = {LastCheckFloorFailTime = 0, JumpStuckTime = 0, JumpDebounceTime = 0} end
    local config: AIT.Config = ConfigHandler.GetActiveConfig(NPC)
    if not config.AgentInfo.AgentCanJump then return end
    if not config.DirectMoveTo.TrackingOnly and config.Tracking.Enabled then return end
    if not config.DirectMoveTo.JumpHandler.Enabled then return end

    local NPCHuman: Humanoid? = NPC:FindFirstChildOfClass("Humanoid")
    if NPCHuman == nil then return end

    local NPCActual = Common.GetBasePart(NPC)
    local TargetActual = Common.GetBasePart(Target, true, NPC)
    if TargetActual == nil then error("This should not happen!") end

    -- TODO:// revamp this
        -- add settings
    local dist = (TargetActual.CFrame.Position - NPCActual.CFrame.Position).Magnitude 
    
    -- idea behind it: i.e. is stuck against something, we need to jump
        -- also, the AI's velo is not ~0 which means it is trying to move.
    -- local VeloMin = true -- NPCActual.AssemblyLinearVelocity.Magnitude > NPCHuman.WalkSpeed * .1
    local VeloMax = NPCActual.AssemblyLinearVelocity.Magnitude < NPCHuman.WalkSpeed * .5
    local AdditionalVeloCheck = (Vector3.new(NPCActual.AssemblyLinearVelocity.X, 0, NPCActual.AssemblyLinearVelocity.Z).Magnitude < NPCHuman.WalkSpeed * .33)
        local MoveToCheck = (NPCHuman.WalkToPoint - NPCActual.CFrame.Position).Magnitude > config.DirectMoveTo.JumpHandler.DistanceFromMoveToPoint
    local TooCloseToTarget = (not config.Tracking.Enabled) or (dist < config.Tracking.CollinearTargetPositionOffset + config.Tracking.DistanceMovedThreshold + 0.1)
    -- local TooFarFromTarget = false -- dist > math.clamp(config.AgentInfo.AgentRadius * 5, 10, 100)
    
    -- if not VeloMin then print("min") end
    -- if not VeloMax then print("max") end
    -- if not ((not AdditionalVeloCheck) and MoveToCheck) then print("additional velo check") end
    -- if TooCloseToTarget then print("too close to target") end

    -- if not VeloMin then
        -- ForbiddenDebugging.LogWithVerbosity(NPC, 5, "Did not reach velo min for JumpHandler: ", string.format("%.3f", NPCActual.AssemblyLinearVelocity.Magnitude))
    -- end

    -- if not VeloMax then
        -- ForbiddenDebugging.LogWithVerbosity(NPC, 5, "Exceeded velo max for JumpHandler: ", string.format("%.3f", NPCActual.AssemblyLinearVelocity.Magnitude))
    -- end

    -- if VeloMin and VeloMax and TooCloseToTarget then
    --     ForbiddenDebugging.LogWithVerbosity(NPC, 5, "JumpHandler success with velo: ", string.format("%.1f", NPCActual.AssemblyLinearVelocity.Magnitude))
    --     return false
    -- end

    if 
        -- VeloMin
            -- and
        VeloMax -- using MoveTo??
            and
        AdditionalVeloCheck
            and
        MoveToCheck -- prevent jump loop
            and
        not TooCloseToTarget
            -- and
        -- not TooFarFromTarget
    then 
        -- meets criterie
        
        if TimedRequests[NPC].JumpStuckTime + config.DirectMoveTo.JumpHandler.MinConditionReachedTime < os.clock() then -- stuck for the min amount of time
            if TimedRequests[NPC].JumpDebounceTime + config.DirectMoveTo.JumpHandler.NextJumpMinTime > os.clock() then return false end -- not blocked by debounce timer
            NPCHuman.Jump = true
            TimedRequests[NPC].JumpDebounceTime = os.clock()
            ForbiddenDebugging.Log(NPC, "Jumping")
            return true
        end
    else
        TimedRequests[NPC].JumpStuckTime = os.clock()
    end

    return false
end

API.TriggerCleanup = function(NPC: Instance)
    TimedRequests[NPC] = nil
end

return API