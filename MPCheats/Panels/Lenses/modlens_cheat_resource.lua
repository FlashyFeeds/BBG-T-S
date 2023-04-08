local LENS_NAME = "ML_CHEAT_RESOURCE"
local ML_LENS_LAYER = UILens.CreateLensLayerHash("Hex_Coloring_Appeal_Level")

-- ===========================================================================
-- Event Functions
-- ===========================================================================

function OnLocalPlayerVisibilityChanged(iX, iY, hVisType)
    local iPlotID:number = GetPlotIndex(x, y);
    if iPlotID == -1 then
        return;
    end
    local pPlot = Map.GetPlot(iX, iY)
    local nResourceType = pPlot:GetResourceType()
    if iResourceType == -1 then
        return
    end
    local iResourceClassType = GameConfiguration.Resources[iResourceType].ResourceClassType
    if iResourceClassType ~= "RESOURCECLASS_STRATEGIC" then
        return
    end
    local kParameters = {}
    kParameters.OnStart = ""
end

-- ===========================================================================
-- Lense Function
-- ===========================================================================

local function OnGetColorPlotTable()
    print("Show Cheat Ressource Lens")
    local iLocPlayerID   :number = Game.GetLocalPlayer()
    local tColorPlot = PlayerConfigurations[iLocPlayerID]:GetValue("ML_CHEAT_RESOURCE_TABLE")
    if tColorPlot == nil then
        return print("Error Occured Populating Cheat Ressource Lens")
    end

    local nHorsesColor   :number = UI.GetColorValue("COLORS_CHEAT_LENSE_HORSES")
    local nIronColor: number = UI.GetColorValue("COLORS_CHEAT_LENSE_IRON")
    local nNiterColor   :number = UI.GetColorValue("COLORS_CHEAT_LENSE_NITER")
    local nCoalColor: number = UI.GetColorValue("COLORS_CHEAT_LENSE_COAL")
    local nOilColor   :number = UI.GetColorValue("COLORS_CHEAT_LENSE_OIL")
    local nAluminumColor: number = UI.GetColorValue("COLORS_CHEAT_LENSE_ALUMINUM")
    local nUraniumColor: number = UI.GetColorValue("COLORS_CHEAT_LENSE_URANIUM")

    local tLenseHorses = tColorPlot[nHorsesColor]
    local tLenseIron = tColorPlot[nIronColor]
    local tLenseNiter = tColorPlot[nNiterColor]
    local tLenseCoal = tColorPlot[nCoalColor]
    local tLenseOil = tColorPlot[nOilColor]
    local tLenseAluminum = tColorPlot[nAluminumColor]
    local tLenseUranium = tColorPlot[nUraniumColor]

    if table.count(tLenseHorses) > 0 then
        UILens.SetLayerHexesColoredArea( ML_LENS_LAYER, localPlayer, tLenseHorses, nHorsesColor )
    end
    if table.count(tLenseIron) > 0 then
        UILens.SetLayerHexesColoredArea( ML_LENS_LAYER, localPlayer, tLenseIron, nIronColor )
    end
    if table.count(tLenseNiter) > 0 then
        UILens.SetLayerHexesColoredArea( ML_LENS_LAYER, localPlayer, tLenseNiter, nNiterColor )
    end
    if table.count(tLenseCoal) > 0 then
        UILens.SetLayerHexesColoredArea( ML_LENS_LAYER, localPlayer, tLenseCoal, nCoalColor )
    end
    if table.count(tLenseOil) > 0 then
        UILens.SetLayerHexesColoredArea( ML_LENS_LAYER, localPlayer, tLenseOil, nOilColor )
    end
    if table.count(tLenseAluminum) > 0 then
        UILens.SetLayerHexesColoredArea( ML_LENS_LAYER, localPlayer, tLenseAluminum, nAluminumColor )
    end
    if table.count(tLenseUranium) > 0 then
        UILens.SetLayerHexesColoredArea( ML_LENS_LAYER, localPlayer, tLenseUranium, nUraniumColor )
    end
    
    return colorPlot
end


--defn
local function OnInitialize()
    Events.PlotVisibilityChanged.Add(OnLocalPlayerVisibilityChanged)
end

local CheatResourceLensEntry = {
    LensButtonText = "LOC_HUD_CHEAT_RESOURCE_LENS",
    LensButtonTooltip = "LOC_HUD_CHEAT_RESOURCE_TOOLTIP",
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