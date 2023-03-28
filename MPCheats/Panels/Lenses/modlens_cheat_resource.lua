local LENS_NAME = "ML_CHEAT_RESOURCE"
local ML_LENS_LAYER = UILens.CreateLensLayerHash("Hex_Coloring_Appeal_Level")

-- ===========================================================================
-- Scout Lens Support
-- ===========================================================================

local function plotHasGoodyHut(plot)
    local improvementInfo = GameInfo.Improvements[plot:GetImprovementType()]
    if improvementInfo ~= nil and improvementInfo.ImprovementType == "IMPROVEMENT_GOODY_HUT" then
        return true
    end
    return false
end

-- ===========================================================================
-- Exported functions
-- ===========================================================================

local function OnGetColorPlotTable()
    -- print("Show scout lens")
    local mapWidth, mapHeight = Map.GetGridSize()
    local localPlayer   :number = Game.GetLocalPlayer()
    local localPlayerVis:table = PlayersVisibility[localPlayer]

    local nHorsesColor   :number = UI.GetColorValue("COLORS_CHEAT_LENSE_HORSES")
    local nIronColor: number = UI.GetColorValue("COLORS_CHEAT_LENSE_IRON")
    local nNiterColor   :number = UI.GetColorValue("COLORS_CHEAT_LENSE_NITER")
    local nCoalColor: number = UI.GetColorValue("COLORS_CHEAT_LENSE_COAL")
    local nOilColor   :number = UI.GetColorValue("COLORS_CHEAT_LENSE_OIL")
    local nAluminumColor: number = UI.GetColorValue("COLORS_CHEAT_LENSE_ALUMINUM")
    local nUraniumColor: number = UI.GetColorValue("COLORS_CHEAT_LENSE_URANIUM")
    local colorPlot = {}
    colorPlot[GoodyHutColor] = {}

    for i = 0, (mapWidth * mapHeight) - 1, 1 do
        local pPlot:table = Map.GetPlotByIndex(i)
        if localPlayerVis:IsRevealed(pPlot:GetX(), pPlot:GetY()) then
            if plotHasGoodyHut(pPlot) then
                table.insert(colorPlot[GoodyHutColor], i)
            end
        end
    end

    return colorPlot
end

-- Called when a scout is selected
local function ShowScoutLens()
    LuaEvents.MinimapPanel_SetActiveModLens(LENS_NAME)
    UILens.ToggleLayerOn(ML_LENS_LAYER)
end

local function ClearScoutLens()
    if UILens.IsLayerOn(ML_LENS_LAYER) then
        UILens.ToggleLayerOff(ML_LENS_LAYER)
    end
    LuaEvents.MinimapPanel_SetActiveModLens("NONE")
end

local function RefreshScoutLens()
    ClearScoutLens()
    ShowScoutLens()
end

local function OnInitialize()
    Events.UnitSelectionChanged.Add( OnUnitSelectionChanged )
    Events.UnitRemovedFromMap.Add( OnUnitRemovedFromMap )
    Events.UnitMoveComplete.Add( OnUnitMoveComplete )
    Events.GoodyHutReward.Add( OnGoodyHutReward )
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