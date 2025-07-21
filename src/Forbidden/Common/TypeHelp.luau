--[[
Stuff related to types, though it stretches that definition quite a bit.
Utilized to make sure the scripts in behavior 

Developer History
    > @crit-dev (@rman501), initial commit
        o7 to future devs

]]--

-- == Setup == --
local updateList: {[Instance]: BasePart} = {}
local API = {}

-- == Forbidden Modules & Architecture == --
local Storage = require(script.Parent.Parent.Common.Storage)

-- == Internal Functions == --
local nameseq = 0

local function GetNumberedName()
    nameseq += 1
    return "AUTO-NAMED " .. tostring(nameseq)
end

local function _MakePart(v3: Vector3, DoUpdateObject: Instance?): Part
    
    local part = nil
    if DoUpdateObject then
        part = updateList[DoUpdateObject]
    end


    if part == nil then
        part = Instance.new("Part")
        part.Transparency   = 1
        part.CanCollide     = false
        part.Anchored       = true
        part.CastShadow     = true
        part.Material       = Enum.Material.Neon
        part.Color          = Color3.fromHex("#FFFF00")
        part.Size           = Vector3.new(1,1,1)
        part.Name           = GetNumberedName()
        part.Parent         = Storage.GetForbiddenWSPartsFolder()

        if DoUpdateObject then
            updateList[DoUpdateObject] = part
        end
    end

    part.Position = v3
    
    return part
end


-- == API Functions == --
API.GetBasePart = function(Object: any, MakePart: boolean?, DoUpdateOwner: Instance?): BasePart?
    
    local ObjectType = typeof(Object)

    if ObjectType == "Instance" then
        if Object:IsA("BasePart") then
            return Object
        end

        if Object:IsA("Model") then
            if Object:FindFirstChildOfClass("Humanoid") then
                
                -- Return the HRT if available.
                local partToReturn = Object:FindFirstChild("HumanoidRootPart")
                    if partToReturn ~= nil then return partToReturn end
                
                -- Return the Torso if available.
                partToReturn = Object:FindFirstChild("Torso")
                    if partToReturn ~= nil then return partToReturn end
                
                -- Return the PrimaryPart if available.
                partToReturn = Object.PrimaryPart
                    if partToReturn ~= nil then return partToReturn end

                -- Return any part if available.
                partToReturn = Object:FindFirstChildOfClass("BasePart")
                    if partToReturn ~= nil then return partToReturn end
                
                -- No part in model
                return nil

            end
        end
    end

    if ObjectType == "CFrame" then
        if MakePart then
            return _MakePart(Object.Position, DoUpdateOwner)
        end
    end

    if ObjectType == "Vector3" then
        if MakePart then
            return _MakePart(Object, DoUpdateOwner)
        end
    end

    return nil
end

API.GetDistanceFromNPCToInstance = function(NPC: Instance, Target: Instance): number

    local NPCActual = API.GetBasePart(Target, true, NPC)
    local TargetActual = API.GetBasePart(Target, true, NPC)

    if NPCActual == nil then error("NPC Actual nil") end
    if TargetActual == nil then error("Target Actual nil") end

    return (NPCActual.CFrame.Position - TargetActual.CFrame.Position).Magnitude
end

return API