-- == Services == --
local rs = game:GetService("ReplicatedStorage")

-- == Libraies == --
local Forbidden = require(rs:WaitForChild("Forbidden"))

-- == Setup == --
local someNPC: Instance = workspace.NPC
local someTarget: Instance = workspace.Target

-- == Setup Config == --
local CFG = Forbidden.AI.GetConfig(someNPC)
CFG.Tracking.Enabled = true
CFG.Visualization.Enabled = true
CFG.Visualization.PathColor = Color3.new(1,0,1)
CFG:SavePreset("Tracking")

-- == Call AI
Forbidden.AI.InsertAntiLag(someNPC)
Forbidden.AI.SmartPathfind(someNPC, someTarget)
CFG.DirectMoveTo.Enabled = false -- i.e. some area is intense with spots the AI can fall (although the new sys should be very good at avoiding that)
CFG:ApplyNow() -- updates the current tracking call with new settings