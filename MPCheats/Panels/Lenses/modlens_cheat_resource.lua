local LENS_NAME = "ML_CHEAT_RESOURCE"
local ML_LENS_LAYER = UILens.CreateLensLayerHash("Hex_Coloring_Appeal_Level")

print("Resource Lense Included")

-- ===========================================================================
-- Lense Function
-- ===========================================================================

local function OnGetColorPlotTable()
    print("OnGetColorPlotTable: Show Cheat Ressource Lens")
    local iLocPlayerID  = Game.GetLocalPlayer()
    local pPlayer = Players[iLocPlayerID]
    local tColorPlot = {}

    local nHorsesColor = UI.GetColorValue("COLORS_CHEAT_LENSE_HORSES")
    local nIronColor = UI.GetColorValue("COLORS_CHEAT_LENSE_IRON")
    local nNiterColor = UI.GetColorValue("COLORS_CHEAT_LENSE_NITER")
    local nCoalColor = UI.GetColorValue("COLORS_CHEAT_LENSE_COAL")
    local nOilColor  = UI.GetColorValue("COLORS_CHEAT_LENSE_OIL")
    local nAluminumColor = UI.GetColorValue("COLORS_CHEAT_LENSE_ALUMINUM")
    local nUraniumColor = UI.GetColorValue("COLORS_CHEAT_LENSE_URANIUM")

    local tLenseHorses = pPlayer:GetProperty("T_CHEAT_RESOURCE_LENSE_HORSES")
    if tLenseHorses == nil then tLenseHorses = {} end
    local tLenseIron = pPlayer:GetProperty("T_CHEAT_RESOURCE_LENSE_IRON")
    if tLenseIron == nil then tLenseIron = {} end
    local tLenseNiter = pPlayer:GetProperty("T_CHEAT_RESOURCE_LENSE_NITER")
    if tLenseNiter == nil then tLenseNiter = {} end
    local tLenseCoal = pPlayer:GetProperty("T_CHEAT_RESOURCE_LENSE_COAL")
    if tLenseCoal == nil then tLenseCoal = {} end
    local tLenseOil = pPlayer:GetProperty("T_CHEAT_RESOURCE_LENSE_OIL")
    if tLenseOil == nil then tLenseOil = {} end
    local tLenseAluminum = pPlayer:GetProperty("T_CHEAT_RESOURCE_LENSE_ALUMINUM")
    if tLenseAluminum == nil then tLenseAluminum = {} end
    local tLenseUranium = pPlayer:GetProperty("T_CHEAT_RESOURCE_LENSE_URANIUM")
    if tLenseUranium == nil then tLenseUranium = {} end

    if table.count(tLenseHorses) > 0 then
        tColorPlot[nHorsesColor] = tLenseHorses
        print("Horses Added")
    end
    if table.count(tLenseIron) > 0 then
        tColorPlot[nIronColor] = tLenseIron
        print("Iron Added")
    end
    if table.count(tLenseNiter) > 0 then
        tColorPlot[nNiterColor] = tLenseNiter
        print("Niter Added")
    end
    if table.count(tLenseCoal) > 0 then
        tColorPlot[nCoalColor] = tLenseCoal
        print("Coal Added")
    end
    if table.count(tLenseOil) > 0 then
        tColorPlot[nOilColor] = tLenseOil
        print("Oil Added")
    end
    if table.count(tLenseAluminum) > 0 then
        tColorPlot[nAluminumColor] = tLenseAluminum
        print("Aluminum Added")
    end
    if table.count(tLenseUranium) > 0 then
        tColorPlot[nUraniumColor] = tLenseUranium
        print("Uranium Added")
    end
    
    return tColorPlot
end
-- ===========================================================================
-- Event Functions for Lenses
-- ===========================================================================

function OnLocalPlayerVisibilityChanged(iX, iY, hVisType)
    print("OnLocalPlayerVisibilityChanged: Called", iX, iY, hVisType)
    local iPlotID = Map.GetPlotIndex(iX, iY);
    if iPlotID == -1 then
        print("Returns No Plot")
        return;
    end
    if hVisType == RevealedState.HIDDEN then
        print("Returns Hidden")
        return
    end
    local pPlot = Map.GetPlot(iX, iY)
    local iResourceType = pPlot:GetResourceType()
    if iResourceType == -1 then
        print("Returns No Resource")
        return
    end
    local iResourceClassType = GameInfo.Resources[iResourceType].ResourceClassType
    if iResourceClassType ~= "RESOURCECLASS_STRATEGIC" then
        print("Returns Not Strategic")
        return
    end
    local kParameters = {}
    kParameters.OnStart = "GameplayUpdatePlayerResources"
    kParameters.ResourceType = iResourceType
    kParameters["iPlotID"] = iPlotID
    print("OnLocalPlayerVisibilityChanged: Raising Gameplay Event", iResourceType, iPlotID)
    UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, kParameters)
end

--defn
local function OnInitialize()
    Events.PlotVisibilityChanged.Add(OnLocalPlayerVisibilityChanged)
end

local CheatResourceLensEntry = {
    LensButtonText = "LOC_HUD_CHEAT_RESOURCE_LENS",
    LensButtonTooltip = "LOC_HUD_CHEAT_RESOURCE_LENS_TOOLTIP",
    Initialize = OnInitialize,
    GetColorPlotTable = OnGetColorPlotTable
}

-- minimappanel.lua
if g_ModLenses ~= nil then
    g_ModLenses[LENS_NAME] = CheatResourceLensEntry
end

-- modallenspanel.lua
if g_ModLensModalPanel ~= nil then
    g_ModLensModalPanel[LENS_NAME] = {}
    g_ModLensModalPanel[LENS_NAME].LensTextKey = "LOC_HUD_CHEAT_RESOURCE_LENS"
    g_ModLensModalPanel[LENS_NAME].Legend = {
        {"LOC_TOOLTIP_CHEAT_LENS_HORSES", UI.GetColorValue("COLORS_CHEAT_LENSE_HORSES")},
        {"LOC_TOOLTIP_CHEAT_LENS_IRON", UI.GetColorValue("COLORS_CHEAT_LENSE_IRON")},
        {"LOC_TOOLTIP_CHEAT_LENS_NITER", UI.GetColorValue("COLORS_CHEAT_LENSE_NITER")},
        {"LOC_TOOLTIP_CHEAT_LENS_COAL", UI.GetColorValue("COLORS_CHEAT_LENSE_COAL")},
        {"LOC_TOOLTIP_CHEAT_LENS_OIL", UI.GetColorValue("COLORS_CHEAT_LENSE_OIL")},
        {"LOC_TOOLTIP_CHEAT_LENS_ALUMINUM", UI.GetColorValue("COLORS_CHEAT_LENSE_ALUMINUM")},
        {"LOC_TOOLTIP_CHEAT_LENS_URANIUM", UI.GetColorValue("COLORS_CHEAT_LENSE_URANIUM")}
    }
end