-- // ----------------------------------------------------------------------------------------------
-- // Author: Sparrow, Integrated by FlashyFeeds
-- // DateCreated: 01/24/2019 2:27:04 PM
-- // ----------------------------------------------------------------------------------------------
UICheatEvents = ExposedMembers.LuaEvents

include("Civ6Common");
include("InstanceManager");
include("SupportFunctions");
include("PopupDialog");
include("AnimSidePanelSupport");
--include("Cheat_Menu_CityBannerManager");
include( "CitySupport" );
include("bbgts_debug.lua")

local iPlayerID 					= Game.GetLocalPlayer();
local bSpec                         = (PlayerConfigurations[iPlayerID]:GetLeaderTypeName() == "LEADER_SPECTATOR")
local iLocCityID                    = -1
local iLocUnitID                    = -1
local pPlayer 						= Players[iPlayerID];
local pTreasury 					= pPlayer:GetTreasury();
local pReligion 					= pPlayer:GetReligion();
local pEnvoy 						= pPlayer:GetInfluence();
local pVis 							= PlayersVisibility[iPlayerID];
local pNewGP 						= 1;
local pNewEnvoy 					= 5;
local pNewReligion 					= 10000;
local pNewFavor						= 100;
local pNewPopulation				= 1;
local m_hideCheatPanel				= false;
local m_IsLoading:boolean			= false;
local m_IsAttached:boolean			= false;
local tPlayerSelections             = {}
--turn processing variables
bCheatsActive = false
bTurnProcessing = true
-- // ----------------------------------------------------------------------------------------------
-- // MENU BUTTON FUNCTIONS
-- // ----------------------------------------------------------------------------------------------

function ChangeGold()
	if bCheatsActive == false or GameConfiguration.IsPaused() or bSpec then
		return
	end
	local pNewGold = 10000
	if pPlayer:IsHuman() then
		Debug("Called", "ChangeGold")
		local kParameters = {}
		kParameters.OnStart = "GameplayChangeGold"
		kParameters["iPlayerID"] = iPlayerID
		kParameters["pNewGold"] = pNewGold
		UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
		--UICheatEvents.UIChangeGold(iPlayerID, pNewGold); 
    end
end
function CompleteProduction()
	if bCheatsActive == false or GameConfiguration.IsPaused() or bSpec then
		return
	end
	if pPlayer:IsHuman() then
		Debug("Called", "CompleteProduction")
		local kParameters = {}
		kParameters.OnStart = "GameplayCompleteProduction"
		kParameters["iPlayerID"] = iPlayerID
		kParameters["iCityID"] =  iLocCityID
		UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
		--UICheatEvents.UICompleteProduction(iPlayerID);
	end
end
function CompleteResearch()
	if bCheatsActive == false or GameConfiguration.IsPaused() or bSpec then
		return
	end
	Debug("Called", "CompleteResearch")
 	local pTechs = pPlayer:GetTechs()
	local pRTech = pTechs:GetResearchingTech()	
	if pRTech >= 0 then
		local pCost = pTechs:GetResearchCost(pRTech)	
		local pProgress = pTechs:GetResearchProgress(pRTech)
		local pResearchComplete = (pCost - pProgress)
		if pPlayer:IsHuman() then
			local kParameters = {}
			kParameters.OnStart = "GameplayCompleteResearch"
			kParameters["iPlayerID"] = iPlayerID
			kParameters["pResearchComplete"] = pResearchComplete
			UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);		
			--UICheatEvents.UICompleteResearch(iPlayerID, pResearchComplete);				
		end		
	end
end
function CompleteCivic()
	if bCheatsActive == false or GameConfiguration.IsPaused() or bSpec then
		return
	end
	Debug("Called", "CompleteCivic")
 	local pCivics = pPlayer:GetCulture()
	local pRCivic = pCivics:GetProgressingCivic()
	if pRCivic >= 0 then		
		local pCost = pCivics:GetCultureCost(pRCivic)	
		local pProgress = pCivics:GetCulturalProgress(pRCivic)
		local pCivicComplete = (pCost - pProgress)
		if pPlayer:IsHuman() then			
			local kParameters = {}
			kParameters.OnStart = "GameplayCompleteCivic"
			kParameters["iPlayerID"] = iPlayerID
			kParameters["pCivicComplete"] = pCivicComplete
			UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);			
			--UICheatEvents.UICompleteCivic(iPlayerID, pCivicComplete);				
		end
	end	
end
function ChangeFaith()
	if bCheatsActive == false or GameConfiguration.IsPaused() or bSpec then
		return
	end
	Debug("Called", "ChangeFaith")
	if pPlayer:IsHuman() then
		local kParameters = {}
		kParameters.OnStart = "GameplayChangeFaith"
		kParameters["iPlayerID"] = iPlayerID
		kParameters["pNewReligion"] = pNewReligion
		UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);			
		--UICheatEvents.UIChangeFaith(iPlayerID, pNewReligion);
    end
end
function ChangeEnvoy()
	if bCheatsActive == false or GameConfiguration.IsPaused() or bSpec then
		return
	end
	Debug("Called", "ChangeEnvoy")
	if pPlayer:IsHuman() then
		local kParameters = {}
		kParameters.OnStart = "GameplayChangeEnvoy"
		kParameters["iPlayerID"] = iPlayerID
		kParameters["pNewEnvoy"] = pNewEnvoy
		UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);			
		--UICheatEvents.UIChangeEnvoy(iPlayerID, pNewEnvoy);
    end
end
function ChangeDiplomaticFavor()
	if bCheatsActive == false or GameConfiguration.IsPaused() or bSpec then
		return
	end
	Debug("Called", "ChangeDiplomaticFavor")
	if pPlayer:IsHuman() then
		local kParameters = {}
		kParameters.OnStart = "GameplayChangeDiplomaticFavor"
		kParameters["iPlayerID"] = iPlayerID
		kParameters["pNewFavor"] = pNewFavor
		UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
		--UICheatEvents.UIChangeDiplomaticFavor(iPlayerID, pNewFavor);
    end
end
function ChangeGovPoints()
	if bCheatsActive == false or GameConfiguration.IsPaused() or bSpec then
		return
	end
	Debug("Called", "ChangeGovPoints")
	if pPlayer:IsHuman() then
		local kParameters = {}
		kParameters.OnStart = "GameplayChangeGovPoints"
		kParameters["iPlayerID"] = iPlayerID
		kParameters["pNewFavor"] = pNewGP
		UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
		--UICheatEvents.UIChangeGovPoints(iPlayerID, pNewGP);
    end
end
function RevealAll()
	if bCheatsActive == false or GameConfiguration.IsPaused() or bSpec then
		return
	end
	Debug("Called", "RevealAll")
	if pPlayer:IsHuman() then
		local kParameters = {}
		kParameters.OnStart = "GameplayRevealAll"
		kParameters["iPlayerID"] = iPlayerID
		UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);		
		--LuaEvents.ChangeFOW(iPlayerID)	
		--UICheatEvents.UIRevealAll(iPlayerID);
	end		
end

function ChangeMS()
	if bCheatsActive == false or GameConfiguration.IsPaused() or bSpec then
		return
	end
	Debug("Called", "GiveMS")
	if pPlayer:IsHuman() then
		local kParameters = {}
		kParameters.OnStart = "GameplayGiveMS"
		kParameters["iPlayerID"] = iPlayerID
		kParameters["iUnitID"] = iLocUnitID
		UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
		--UICheatEvents.UIChangeGovPoints(iPlayerID, pNewGP);
    end
end

function RefreshActionPanel()
	if pPlayer:IsHuman() then
		local UPContextPtr :table = ContextPtr:LookUpControl("/InGame/ActionPanel");
		if UPContextPtr ~= nil then
			UPContextPtr:RequestRefresh(); 
		end
	end
	ContextPtr:RequestRefresh(); 
end

function OnCitySelectionChanged(iPlayerID, iCityID)
	Debug("Called", "OnCitySelectionChanged")
	Debug("iPlayerID, iCityID values "..tostring(iPlayerID)..", "..tostring(iCityID), "OnCitySelectionChanged")
	--local tPlayerSelections = Game.GetProperty("PLAYER_SELECTIONS")
	iLocCityID = iCityID
	--tPlayerSelections[iPlayerID] = iLocCityID
	--local kParameters = {}
	--kParameters.OnStart = "GameplayPlayerCityUpdt"
	--kParameters["tPlayerSelections"] = tPlayerSelections
	--UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
	--UICheatEvents.UIPlayerCityUpdt(tPlayerSelections)
	Debug("iPlayerID, iLocCityID values "..tostring(iPlayerID)..", "..tostring(iLocCityID), "OnCitySelectionChanged")
	--civ6tostring(tPlayerSelections)
end

function OnUnitSelectionChanged(iPlayerID, iUnitID)
	Debug("Called", "OnUnitSelectionChanged")
	iLocUnitID = iUnitID
	Debug("iPlayerID, iLocUnitID values "..tostring(iPlayerID)..", "..tostring(iLocUnitID), "OnCitySelectionChanged")
end

--ui hook to remove granted visibility next turn
function OnLocalPlayerTurnBegin()
	Debug("Called", "OnLocalPlayerTurnBegin")
	local iPlayerID = Game.GetLocalPlayer()
	local kParameters = {}
	if Game.GetCurrentGameTurn() == GameConfiguration.GetStartTurn() then
		kParameters.OnStart = "GameplayInitResource"
		kParameters["iPlayerID"] = iPlayerID
		UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters)
	end
	kParameters.OnStart = "GameplayLocalTurnBegin"
	kParameters["iPlayerID"] = iPlayerID
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
	--UICheatEvents.UILocalPlayerTurnBegin(iPlayerID)
end
--ui hook to remove a defeated player from the list
function OnPlayerDefeat(iPlayerID, iDefeatType, iEventID)
	Debug("Called", "OnPlayerDefeat")
	local kParameters = {}
	kParameters.OnStart = "GameplayPlayerDefeat"
	kParameters["iPlayerID"] = iPlayerID
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters)
	--UICheatEvents.UIPlayerDefeat(iPlayerID)
end
--ui hook when the player gets revived
function OnPlayerRevived()
	Debug("Called", "OnPlayerRevived")
	local kParameters = {}
	kParameters.OnStart = "GameplayPlayerRevived" 
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters)
	--UICheatEvents.UIPlayerRevived()
end

function ExposedMembers.ActivateTesterPanel()
	Debug("Called: Setting bCheatsActive", "ExposedMembers.ActivateTesterPanel")
	bCheatsActive = true
	Debug("bCheatsActive = "..tostring(bCheatsActive), "ExposedMembers.ActivateTesterPanel")
end

function ExposedMembers.DeactivateTesterPanelFun()
	Debug("Called: Setting bCheatsActive", "ExposedMembers.DeactivateTesterPanelFun")
	bCheatsActive = false
	Debug("bCheatsActive = "..tostring(bCheatsActive), "ExposedMembers.DeactivateTesterPanelFun")
end

function SwitchOnHumanLoaded(tPassParams)
	Debug("Called", "SwitchOnHumanLoaded")
	print(BuildRecursiveDataString(tPassParams))
	local kParameters = {}
	kParameters.OnStart = "GameplaySwitchOnHumanLoaded"
	kParameters["iPlayerID"] = iPlayerID
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters)	
end

function EndTimer(tPassParams)
	Debug("Called", "EndTimer")
	tPassParams = tPassParams or nil
	if tPassParams ~= nil then
		print(BuildRecursiveDataString(tPassParams))
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayEndTimer"
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters)
end

function BroadcastTimeDelta(nTimeDelta_Broadcast)
	Debug("Called", "BroadcastTimeDelta")
	local kParameters = {}
	kParameters.OnStart = "GameplaySetTurnEnd"
	kParameters.Delta = nTimeDelta_Broadcast
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters)
end

function ExposedMembers.SetTurnProcessing(bReturnVal)
	--print("SetTurnProcessing: Called")
	bTurnProcessing = bReturnVal
	--print("SetTurnProcessing: bReturnVal is set to "..tostring(bTurnProcessing))
end

--testing shift enters
function OnPlayerTurnActivated(iPlayerID)
	Debug("Called: Turn Activated for "..tostring(iPlayerID), "OnPlayerTurnActivated")
end

function OnPlayerTurnDeactivated(iPlayerID)
	Debug("Called: Turn Deactivated for "..tostring(iPlayerID), "OnPlayerTurnDeactivated")
	local kParameters = {}
	kParameters.OnStart = "GameplayPlayerTurnDeactivated"
	kParameters["iPlayerID"] = iPlayerID
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters)
end
function OnTurnEnd()
	Debug("Called:", "OnTurnEnd")
end
function OnLocalPlayerTurnEnd()
	Debug("Calld for "..tostring(iPlayerID), "OnLocalPlayerTurnEnd")
end
function OnLocalPlayerTurnUnready()
	Debug("Calld for "..tostring(iPlayerID), "OnLocalPlayerTurnUnready")
end
-- // ----------------------------------------------------------------------------------------------
-- // HOTKEYS (need to make an overlay and disable functions unless all players have time on the timer/loaded in)
-- // ----------------------------------------------------------------------------------------------
function OnInputActionTriggered( actionId )
	if ( actionId == Input.GetActionId("ToggleGold") ) then
		ChangeGold();
	end
	if ( actionId == Input.GetActionId("ToggleFaith") ) then
		ChangeFaith();
	end
	if ( actionId == Input.GetActionId("ToggleCProduction") ) then
		CompleteProduction();
	end
	if ( actionId == Input.GetActionId("ToggleCCivic") ) then
		CompleteCivic();
	end
	if ( actionId == Input.GetActionId("ToggleCResearch") ) then
		CompleteResearch();
	end
	if ( actionId == Input.GetActionId("ToggleEnvoy") ) then
		ChangeEnvoy();
	end
	if ( actionId == Input.GetActionId("ToggleObs") ) then
		RevealAll();
	end
	if ( actionId == Input.GetActionId("ToggleMenu") ) then
		OnMenuButtonToggle();
	end
	if ( actionId == Input.GetActionId("ToggleDiplomaticFavor") ) then
		ChangeDiplomaticFavor();
	end
	if ( actionId == Input.GetActionId("ToggleGiveMS") ) then
		ChangeMS();
	end
end
--========support functions========--


--====Events and Init====--
Events.CitySelectionChanged.Add(OnCitySelectionChanged) -- populates player/city table on change 
Events.UnitSelectionChanged.Add(OnUnitSelectionChanged) -- populates player/unit table on change
Events.LocalPlayerTurnBegin.Add(OnLocalPlayerTurnBegin) -- needed to remove visibility and turner functions (probably migrate)
Events.PlayerTurnActivated.Add(OnPlayerTurnActivated)
Events.PlayerTurnDeactivated.Add(OnPlayerTurnDeactivated) -- check the event loop here
Events.PlayerDefeat.Add(OnPlayerDefeat) --needed to repopulate alive table for visibility cheat (probably migrate)
Events.PlayerRevived.Add(OnPlayerRevived)
Events.TurnEnd.Add(OnTurnEnd)
Events.LocalPlayerTurnEnd.Add(OnLocalPlayerTurnEnd)
Events.LocalPlayerTurnUnready.Add(OnLocalPlayerTurnUnready)
--Events.PlotVisibilityChanged.Add(OnLocalPlayerVisibilityChanged) -- for Lenses
