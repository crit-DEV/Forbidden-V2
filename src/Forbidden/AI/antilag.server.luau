--[[
Developer History
    > @crit-dev (@rman501), initial commit
        o7 to future devs

]]--

-- forces server to run the AI physics sim preventing rubberbanding when transferring from server->client rendering
-- note: if any part of the NPC's assembly is anchored, it may result in
-- part:GetAutoNetworkOwnership() returning to its default state of true
-- therefore, this must be called everytime you do so.
--
-- this mainly serves as an entry level script to demonstrate how to stop that
-- annoying stuttering !
task.wait(1)
local hrt = script.Parent:FindFirstChild("HumanoidRootPart")
local t = script.Parent:FindFirstChild("Torso")
if t ~= nil and hrt == nil then hrt = t end
if hrt ~= nil then hrt:SetNetworkOwner(nil) end
if hrt == nil then warn("Unable to use anti-lag script.") return end

script:Destroy()

--[[
In depth explanation:

When using the humanoid.MoveToFinished event, it becomes
unsynchronized when the network ownership transfers.

This causes a noticable stutter when the AI reaches a waypoint,
before it continues to the next.

Also, the AI movement does appear to slightly stutter (when moving linearly)
as it gets close. This is just the noticable switch between client->server v.v.
happening.

As a developer, determine if it even matters that their is a slight ping
client and server. 
If not, just always make sure the Auto Ownership is disabled and owner is nil.
If it does, then monitor resource usage, and Auto Ownership.

Should you still have issues, you can try using a loop every heartbeat to check
Network Ownership and set it to nil if it is auto.

i.e.

```luau
-- I have not actually tested this function. (it should work I've written this before)
-- if you notice anything wrong or just want to help a little with development
-- test this and send a working commit message!
local run = game:GetService("RunService")
local hrt = script.Parent:WaitForChild("HumanoidRootPart")

local function onHeartbeat()
    if hrt:GetNetworkOwnershipAuto() then
        if hrt.Anchored then warn("Cannot reset ownership; the HRT is anchored!") return end

        local s, e = pcall(function() 
            hrt:SetNetworkOwnership(nil)
        end)

        if e then print("Could not set NetworkOwnership for the hrt!") print(e) return end
    
        print("Resetting auto ownership!")
    end
end

run.Heartbeat:Connect(onHeartbeat)

```

]]--