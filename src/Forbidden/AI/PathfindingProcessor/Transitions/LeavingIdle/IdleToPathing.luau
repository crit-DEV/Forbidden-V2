-- == Services == --
local rs = game:GetService("ReplicatedStorage")


-- == Libraries == --
local RobloxStateMachine = require(rs.Forbidden.Packages.robloxstatemachine)


-- == Forbidden Modules & Architecture == --
local ForbiddenDir = script.Parent.Parent.Parent.Parent
local ForbiddenDebugger = require(ForbiddenDir.Debugging)
local AIT = require(ForbiddenDir.Types)
type Config = AIT.Config


-- == Setup == --
local IdleToPathing = RobloxStateMachine.Transition.new("IdleToPathing")


-- == Functionality == --

function IdleToPathing:OnDataChanged(data)
    local thisConfig: Config
end

return IdleToPathing