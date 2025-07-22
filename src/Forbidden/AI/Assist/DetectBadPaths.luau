--[[
This file takes in a table of nodes & determines if it a path is possible from those nodes.
Optionally, provide an NPC to check with its config.

Developer History
    > @crit-dev (@rman501), initial commit
        o7 to future devs

]]--

-- == Services == --


-- == Libraries == --


-- == Forbidden Modules & Architecture == --
local root  = script.Parent.Parent.Parent
local AI    = root.AI
local AIT                   = require(AI.Types)
local ConfigHandler         = require(AI.ConfigHandler)
local Defaults              = require(AI.ConfigHandler.Defaults)
local PathfindingProcessor  = require(AI.PathfindingProcessor)


-- == Initialization == --
local API = {}


-- == Assisting Functions == --
API.NodeTableExpander = function(nodes: any): {BasePart}
    
    local final = {}

    local isAlreadyInTable = function(part: BasePart)
        for _, v in pairs(final) do
            if v == part then return true end
        end
        return false
    end

    local function searchInstance(instance: Instance)
        for i, descendant: Instance in pairs(instance:GetDescendants()) do
            if not descendant:IsA("BasePart") or descendant:IsA("Model") then continue end
            if isAlreadyInTable(descendant) then continue end
            table.insert(final, descendant)
        end
    end

    if typeof(nodes) == "Instance" then
        if nodes:IsA("BasePart") then table.insert(final, nodes) end
        searchInstance(nodes)
    end

    if typeof(nodes) == "table" then
        for i, v in pairs(nodes) do
            searchInstance(v)
        end
    end

    return final
end

API.CheckPath = function(NPC: Instance?, Node1: BasePart, Node2: BasePart): boolean
    local config: AIT.Config
    
    if NPC ~= nil then
        config = ConfigHandler.GetActiveConfig(NPC)
    end
    if NPC == nil then
        config = Defaults
    end

    return PathfindingProcessor.RawCompute(Node1.CFrame.Position, Node2.CFrame.Position, config.AgentInfo) ~= nil
end

-- == API Functions == --
API.DetectBadPaths = function(Nodes: {BasePart}, NPC: Instance?, CheckBothWays: boolean?): {{From: BasePart, To: BasePart, Omnidirectional: boolean?}}

    local config: AIT.Config = Defaults :: AIT.Config
    if NPC ~= nil then config = ConfigHandler.GetActiveConfig(NPC) end
    
    if config == nil then error("no cfg!, this is unusual!") end

    local BadPaths = {}
    local function InsertBadPath(node1: BasePart, node2: BasePart)
        table.insert(BadPaths, {From = node1, To = node2, Omnidirectional = false})
    end

    local tbl = API.NodeTableExpander(Nodes)
    local l = 1
    local r = #tbl

    while l < #tbl do
        for i=l,r,1 do
            local success1 = API.CheckPath(tbl[l], tbl[r])
            if not success1 then InsertBadPath(tbl[l], tbl[r]) end
            
            if not CheckBothWays then continue end 
                
            local success2 = API.CheckPath(tbl[r], tbl[l])
            if success2 then continue end
            if not success1 and not success2 then BadPaths[#BadPaths].Omnidirectional = true; continue end -- both failed
            
            InsertBadPath(tbl[r], tbl[l])
        end
    end

    return BadPaths

end