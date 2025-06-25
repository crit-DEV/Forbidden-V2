--[[ Development Notes:
@rman501, initial implementation - 6/23/25

Purpose of file:
    This file contains the configuration handler for the Forbidden AI system.
    This is like GL11's ConfigHandler, i.e. instead of sending a table of settings like the old AI you do:

        local ConfigHandler = require(script.Parent.ConfigHandler)
        local myConfig = ConfigHandler:GetConfig(myNPC)
        myConfig.SomeSetting = true -- or false, or whatever the setting is
        ...
        myConfig.RestoreDefaults() -- restores the config to the default values
        myConfig.SavePreset("MyPreset", false) -- saves the current config as a preset, the second argument is whether or not it is globally available, or just for the NPC.
        myConfig.LoadPreset("MyPreset") -- loads the preset, if it exists, if not, does nothing. 

        myConfig.Apply() -- applies the config to the NPC, this is done automatically when a new pathfind is requested, but can be used to apply the config immediately.


]]--

-- [Libraries] --
local AIT = require(script.Parent.Types)
local TablesLibrary = require(script.Parent.Parent.Libraries.Tables)
local Defaults = require(script.Defaults)

local ConfigHandler = {}
local ConfigInstances: {[Instance]: AIT.Config} = {}
local GlobalPresets: {[string]: AIT.Config} = {} -- Presets that are available globally, not just for the NPC


-- [Hooks] --
local BE_HFU = Instance.new("BindableEvent")
ConfigHandler.HookForceUpdate = function(func_to_hook: (AIT.Config) -> ())
    -- Since active pathfinds maintain their own deep copied config, this is used to update the config when it changes on the NPC end.
    BE_HFU.Event:Connect(func_to_hook)
end


-- [Internal Functions] --


local function RemoveMetatable(tbl)
    -- Remove the metatable from the table, this is used to allow the NPC field to be set again without causing an error
    TablesLibrary.RemoveMetatable(tbl)
end


local function AddMetatable(tbl)
    TablesLibrary.LockKeyInTable(tbl, "NPC") -- Lock the NPC field so it cannot be modified
end



-- for organization
local createConfig: (NPC: Instance) -> AIT.Config = nil -- defined down more.


local function InitializeConfig(NPC: Instance)
    -- If there is already a config for this NPC, do not initialize again
    if ConfigInstances[NPC] then return end
    
    -- Create a new config instance for the NPC
    ConfigInstances[NPC] = createConfig(NPC)
end



local function CreateCleanConfig(tbl: AIT.Config): AIT.Config
    -- Create a clean preset from the config, this will remove the NPC field and return a new table
    local newCfg = TablesLibrary.DeepCopy(tbl) :: AIT.Config
    RemoveMetatable(newCfg) -- this will allow the NPC field to be set again without causing an error
    newCfg.NPC = nil
    return newCfg
end


local function LoadCFGToMain(newCfg: AIT.Config)
    -- Validate
    if not newCfg.NPC then
        error("Cannot load config to NPC, NPC field is nil.")
    end
    
    -- Get the current config for the NPC, or initialize it if it doesn't exist
    local current = ConfigInstances[newCfg.NPC]
    if not current then
        InitializeConfig(newCfg.NPC)
        current = ConfigInstances[newCfg.NPC]
    end
    
    -- Deep copy the new config to the current config
    TablesLibrary.DeepCopyPaste(current, newCfg)
end
    
-- [Config Functions] --
function RestoreDefaults(self: AIT.Config)
    -- Restore the config to the default values
    TablesLibrary.DeepCopyPaste(self, Defaults)
end


function SavePreset(self: AIT.Config, PresetName: string, SaveGlobally: boolean?)
    
    -- Quick validation
    if PresetName == "" or PresetName == nil then
        warn("Preset name cannot be nil or empty.")
        return
    end
    
    -- Create a clean preset to save
    local preset = CreateCleanConfig(self)
    
    -- Global Save
    if SaveGlobally then
        ConfigHandler.SaveGlobalPreset(PresetName, preset)
    end
    
    -- Local Save
    if not SaveGlobally then
        self.Presets[PresetName] = preset
    end
end


function LoadPreset(self: AIT.Config, PresetName: string, UseGlobalIfBothFound: boolean?)
    -- Load a preset if it exists
    if PresetName == nil or PresetName == "" then
        warn("Preset name cannot be nil or empty.")
        return
    end
    
    -- Check if the preset exists locally
    local localPreset = self.Presets[PresetName]
    local globalPreset = GlobalPresets[PresetName]
    
    local presetToUse = localPreset
    
    -- Swap to global if available and we should
    if UseGlobalIfBothFound and globalPreset then presetToUse = globalPreset end
    
    -- Swap to global if no local preset (see check below as to why we don't care if we shou)
    if not localPreset then presetToUse = globalPreset end
    
    -- If no preset was found, warn and return
    if not presetToUse then
        warn(`Preset '{PresetName}' does not exist locally or globally.`)
        return
    end
    
    -- Read info to the config
    local newCfg = TablesLibrary.DeepCopy(presetToUse) :: AIT.Config
    newCfg.NPC = self.NPC -- keep the NPC reference (technically this is not needed, but it is good to have)
    newCfg.Presets = self.Presets -- keep the presets reference
    
    -- Apply the new config
    TablesLibrary.DeepCopyPaste(self, presetToUse)
    
    -- Do this down here so that it doesn't cause an error as the NPC field is not editable.
    AddMetatable(self)
end

-- Apply the config to the NPC, this is done automatically when a new pathfind is requested, but can be used to apply the config immediately.
function ApplyNow(self: AIT.Config)
    if not self.NPC then
        error("Cannot apply config to NPC, NPC field is nil.")
    end

    -- Load the config to the main NPC
    LoadCFGToMain(self)
end

-- Initialized the function above already.
createConfig = function (NPC: Instance): AIT.Config
    local newCfg = TablesLibrary.DeepCopy(Defaults)
    
    -- Attach the NPC to the config
    newCfg.NPC = NPC

    -- Functions
    function newCfg:SavePreset(PresetName: string, SaveGlobally: boolean?) SavePreset(self, PresetName, SaveGlobally) end
    function newCfg:LoadPreset(PresetName: string, UseGlobalIfBothFound: boolean?) LoadPreset(self, PresetName, UseGlobalIfBothFound) end
    function newCfg:RestoreDefaults() RestoreDefaults(self) end
    function newCfg:ApplyNow() ApplyNow(self) end

    AddMetatable(newCfg)
    return newCfg
end


-- [Global Functions] --

ConfigHandler.SaveGlobalPreset = function(PresetName: string, Config: AIT.Config)
   -- Quick validation
    if PresetName == "" or PresetName == nil then
        warn("Preset name cannot be nil or empty.")
        return
    end
    
    -- Create a clean preset to save
    local preset = CreateCleanConfig(Config)

    -- Save the preset globally
    GlobalPresets[PresetName] = preset
end


ConfigHandler.GetConfig = function(NPC: Instance): AIT.Config
    if not ConfigInstances[NPC] then
        InitializeConfig(NPC)
    end
    
    return ConfigInstances[NPC]
end