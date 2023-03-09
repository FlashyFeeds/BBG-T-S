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

-- // ----------------------------------------------------------------------------------------------
-- // MENU BUTTON FUNCTIONS
-- // ----------------------------------------------------------------------------------------------

function ChangeGold()
	local pNewGold = 10000
	if pPlayer:IsHuman() then
		UICheatEvents.UIChangeGold(iPlayerID, pNewGold); 
    end
end
function CompleteProduction()
	if pPlayer:IsHuman() then
		UICheatEvents.UICompleteProduction(iPlayerID);
	end
end
function CompleteResearch()
 	local pTechs = pPlayer:GetTechs()
	local pRTech = pTechs:GetResearchingTech()	
	if pRTech >= 0 then
		local pCost = pTechs:GetResearchCost(pRTech)	
		local pProgress = pTechs:GetResearchProgress(pRTech)
		local pResearchComplete = (pCost - pProgress)
		if pPlayer:IsHuman() then		
			UICheatEvents.UICompleteResearch(iPlayerID, pResearchComplete);				
		end		
	end
end
function CompleteCivic()
 	local pCivics = pPlayer:GetCulture()
	local pRCivic = pCivics:GetProgressingCivic()
	if pRCivic >= 0 then		
		local pCost = pCivics:GetCultureCost(pRCivic)	
		local pProgress = pCivics:GetCulturalProgress(pRCivic)
		local pCivicComplete = (pCost - pProgress)
		if pPlayer:IsHuman() then		
			UICheatEvents.UICompleteCivic(iPlayerID, pCivicComplete);				
		end
	end	
end
function ChangeFaith()
	if pPlayer:IsHuman() then
		UICheatEvents.UIChangeFaith(iPlayerID, pNewReligion);
    end
end
function ChangeEnvoy()
	if pPlayer:IsHuman() then
		UICheatEvents.UIChangeEnvoy(iPlayerID, pNewEnvoy);
    end
end
function ChangeDiplomaticFavor()
	if pPlayer:IsHuman() then
		UICheatEvents.UIChangeDiplomaticFavor(iPlayerID, pNewFavor);
    end
end
function ChangeGovPoints()
	if pPlayer:IsHuman() then
		UICheatEvents.UIChangeGovPoints(iPlayerID, pNewGP);
    end
end
function RevealAll()
	if pPlayer:IsHuman() then		
		--LuaEvents.ChangeFOW(iPlayerID)	
		UICheatEvents.UIRevealAll(iPlayerID);
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
	tPlayerSelections = Game.GetProperty("PLAYER_SELECTIONS")
	tPlayerSelections[iPlayerID] = iCityID
	UICheatEvents.UIPlayerCityUpdt(tPlayerSelections)
	Debug("Transmitted Values", "OnCitySelectionChanged")
	civ6tostring(tPlayerSelections)
end

--ui hook to remove granted visibility next turn
function OnLocalPlayerTurnBegin()
	Debug("Called", "OnLocalPlayerTurnBegin")
	local iPlayerID = Game.GetLocalPlayer()
	UICheatEvents.UILocalPlayerTurnBegin(iPlayerID)
end
--ui hook to remove a defeated player from the list
function OnPlayerDefeat(iPlayerID, iDefeatType, iEventID)
	Debug("Called", "OnPlayerDefeat")
	UICheatEvents.UIPlayerDefeat(iPlayerID)
end
--ui hook when the player gets revived
function OnPlayerRevived()
	Debug("Called", "OnPlayerRevived")
	UICheatEvents.UIPlayerRevived()
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
end
--========support functions========--
function InitPlayerSelection()
	local tAliveMajors = PlayerManager.GetAliveMajorIDs()
	local tPlayerCheatState = Game.GetProperty("PLAYER_SELECTIONS")
	if tPlayerCheatState ~= nil then return end
	
	for i, iPlayerID in ipairs(tAliveMajors) do
		tPlayerSelections[iPlayerID] = -1
	end
	UICheatEvents.UIPlayerCityUpdt(tPlayerSelections)
end
--====Events and Init====--
Events.CitySelectionChanged.Add(OnCitySelectionChanged) -- populates player/city table on change 
Events.LocalPlayerTurnBegin.Add(OnLocalPlayerTurnBegin) -- needed to remove visibility (probably migrate)
Events.PlayerDefeat.Add(OnPlayerDefeat) --needed to repopulate alive table for visibility cheat (probably migrate)
Events.PlayerRevived.Add(OnPlayerRevived)
InitPlayerSelection()

