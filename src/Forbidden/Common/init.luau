local storage = require(script.Storage)
local typehelp = require(script.TypeHelp)

return {
    GetForbiddenStorageFolder = storage.GetForbiddenStorageFolder,
    GetForbiddenTemporaryWorkspaceFolder = storage.GetForbiddenTemporaryWorkspaceFolder,
    GetForbiddenWSPartsFolder = storage.GetForbiddenWSPartsFolder,
    GetBasePart = typehelp.GetBasePart,
    GetDistanceFromNPCToTarget = typehelp.GetDistanceFromNPCToTarget,
    TriggerCleanupTypeHelp = typehelp.TriggerCleanup
}