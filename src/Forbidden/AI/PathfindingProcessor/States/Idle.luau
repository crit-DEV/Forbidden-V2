--[[ 6/26/25
Developer History
    > @crit-dev (@rman501), initial commit
        o7 to future devs


TODO: Trigger check for new op in this file?
]]--

-- == Services == --
local rs = game:GetService("ReplicatedStorage")


-- == Packages == --
local RBLXStateMachineLib = require(rs.Forbidden.Packages.robloxstatemachine)


-- == Forbidden Modules & Architecture == --
local ForbiddenDir = script.Parent.Parent.Parent
local AIT = require(ForbiddenDir.Types)
local ForbiddenDebugging = require(ForbiddenDir.Debugging)


-- == Setup == --
local Idle = RBLXStateMachineLib.State.new("Idle") -- The name of our state
local TransitionsDir = script.Parent.Parent.Transitions
local RelatedDir = TransitionsDir.LeavingIdle
Idle.Transitions = {RelatedDir.IdleToPathing, RelatedDir.IdleToTracking}

-- == Methods == --
function Idle:OnInit() -- This gets called as soon as the state machine is created
    -- state machine created
end

function Idle:OnEnter(data) -- Called whenever the state changes into "Blue"

    if not data.NPC then error("No NPC in data!") end

    print("Idle: " .. data.NPC:GetFullName())
    -- Could also write: self.Data.part.Color
end

function Idle:OnHeartbeat() -- Called every heartbeat
    local config = self.Data
end

function Idle:OnLeave() -- Called whenever the state is left even if target gets destroyed
    local config: AIT.Config = self.Data.Config
    ForbiddenDebugging.Log(config.NPC, "Leaving Idle State for ", config.NPC:GetFullName())
end

return Idle