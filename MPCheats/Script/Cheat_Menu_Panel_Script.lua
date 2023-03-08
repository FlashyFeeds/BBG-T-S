-- // ----------------------------------------------------------------------------------------------
-- // Author: Sparrow, integrated for MP by FlashyFeeds
-- // DateCreated: 01/24/2019 2:27:04 PM
-- // ----------------------------------------------------------------------------------------------
ExposedMembers.LuaEvents = LuaEvents
include("bbgts_debug.lua")
local iLocPlayerID;
local iLocCityID;

-- // ----------------------------------------------------------------------------------------------
-- // Event Handlers
-- // ----------------------------------------------------------------------------------------------
--set local state
function OnUIPlayerCityUpdt(tPlayerSelections)
	Debug("Called", "OnUIPlayerCityUpdt")
	GameEvents.GameplayPlayerCityUpdt(tPlayerSelections)
end

function OnGameplayPlayerCityUpdt(tPlayerSelections)
	Debug("Called", "OnGameplayPlayerCityUpdt")
	Game.SetProperty("PLAYER_SELECTIONS", tPlayerSelections)
	Debug("Game Property PLAYER_SELECTIONS set with values")
	civ6tostring(tPlayerSelections)
	iLocPlayerID = Game.GetLocalPlayer()
	iLocCityID = tPlayerSelections[iLocPlayerID]
	Debug("Local instnace variables set: iLocPlayerID, iLocCityID: "..tostring(iLocPlayerID)..", "..tostring(iLocCityID), "OnGameplayPlayerCityUpdt")
end
--gold
function OnUIChangeGold(iPlayerID, pNewGold)
	Debug("Called", "OnUIChangeGold")
	GameEvents.GameplayChangeGold.Call(iPlayerID, pNewGold)
end

function OnGameplayChangeGold(iPlayerID, pNewGold)
	Debug("Called", "OnGameplayChangeGold")
	OnChangeGold(iPlayerID, pNewGold)
end
function OnChangeGold(iPlayerID, pNewGold)
	Debug("Called", "OnChangeGold")
	local pPlayer = Players[iPlayerID]
    local pTreasury = pPlayer:GetTreasury()
    pTreasury:ChangeGoldBalance(pNewGold)
    Debug("Gold added to iPlayerID "..tostring(iPlayerID), "OnChangeGold")
end
--faith
function OnUIChangeFaith(iPlayerID, pNewReligion)
	Debug("Called", "OnUIChangeFaith")
	GameEvents.GameplayChangeFaith.Call(iPlayerID, pNewReligion)
end

function OnGameplayChangeFaith(iPlayerID, pNewReligion)
	Debug("Called", "OnGameplayChangeFaith")
	OnChangeFaith(iPlayerID, pNewReligion)
end

function OnChangeFaith(iPlayerID, pNewReligion)
	Debug("Called", "OnChangeFaith")
	local pPlayer = Players[iPlayerID]
    local pReligion = pPlayer:GetReligion()
    pReligion:ChangeFaithBalance(pNewReligion)
    Debug("Faith added to iPlayerID "..tostring(iPlayerID), "OnChangeFaith")
end
--science current
function OnUICompleteResearch(iPlayerID, pResearchComplete)
	Debug("Called", "OnUICompleteResearch")
	GameEvents.GameplayCompleteResearch.Call(iPlayerID, pResearchComplete)
end

function OnGameplayCompleteResearch(iPlayerID, pResearchComplete)
	Debug("Called", "OnGameplayCompleteResearch")
	OnCompleteResearch(iPlayerID, pResearchComplete)
end

function OnCompleteResearch(iPlayerID, pResearchComplete)
	Debug("Called", "OnCompleteResearch")
    local pPlayer = Players[iPlayerID]
    local pResearch = pPlayer:GetTechs()
    pResearch:ChangeCurrentResearchProgress(pResearchComplete)
    Debug("Research Completed for iPlayerID "..tostring(iPlayerID), "OnCompleteResearch")
end
--culture current
function OnUICompleteCivic(iPlayerID, pCivicComplete)
	Debug("Called", "OnUICompleteCivic")
	GameEvents.GameplayCompleteCivic.Call(iPlayerID, pCivicComplete)
end

function OnGameplayCompleteCivic(iPlayerID, pCivicComplete)
	Debug("Called", "OnGameplayCompleteCivic")
	OnCompleteCivic(iPlayerID, pCivicComplete)
end

function OnCompleteCivic(iPlayerID, pCivicComplete)
	Debug("Called", "OnCompleteCivic")
    local pPlayer = Players[iPlayerID]
    local pCivics = pPlayer:GetCulture()
    pCivics:ChangeCurrentCulturalProgress(pCivicComplete)
    Debug("Civic completed for iPlayerID "..tostring(iPlayerID), "OnCompleteCivic")
end
--Production Current
function OnUICompleteProduction(iPlayerID)
	Debug("Called", "OnUICompleteProduction")
	GameEvents.GameplayCompleteProduction.Call(iPlayerID)
end

function OnGameplayCompleteProduction(iPlayerID)
	Debug("Called", "OnGameplayCompleteProduction")
	OnCompleteProduction(iPlayerID)
end

function OnCompleteProduction(iPlayerID)
	Debug("Called", "OnCompleteProduction")
	local pPlayer = Players[iPlayerID]
	local pCity = pPlayer:GetCities():FindID(iLocCityID)
	if pCity == nil then
		return print("Error: nil City")
	end
	local pCityBuildQueue = pCity:GetBuildQueue();
	if iLocPlayerID == iPlayerID then
		pCityBuildQueue:FinishProgress()		
	end
	Debug("Production Completed for iPlayerID in iLocCityID: "..tostring(iPlayerID)..", "..tostring(iLocCityID), "OnCompleteProduction")
end
--gov titles
function OnUIChangeGovPoints(iPlayerID, pNewGP)
	Debug("Called", "OnUIChangeGovernorPoints")
	GameEvents.GameplayChangeGovPoints.Call(iPlayerID, pNewGP)
end

function OnGameplayChangeGovPoints(iPlayerID, pNewGP)
	Debug("Called", "OnGameplayChangeGovPoints")
	OnChangeGovPoints(iPlayerID, pNewGP)
end

function OnChangeGovPoints(iPlayerID, pNewGP)
	Debug("Called", "OnChangeGovPoints")
	local pPlayer = Players[iPlayerID];
	pPlayer:GetGovernors():ChangeGovernorPoints(pNewGP);
	Debug("Gov Titles added to iPlayerID "..tostring(iPlayerID), "OnChangeGovPoints")
end
--envoys
function OnUIChangeEnvoy(iPlayerID, pNewEnvoy)
	Debug("Called", "OnUIChangeEnvoy")
	GameEvents.GameplayChangeEnvoy.Call(iPlayerID, pNewEnvoy)
end

function OnGameplayChangeEnvoy(iPlayerID, pNewEnvoy)
	Debug("Called", "OnGameplayChangeEnvoy")
	OnChangeEnvoy(iPlayerID, pNewEnvoy)
end

function OnChangeEnvoy(iPlayerID, pNewEnvoy)
	Debug("Called", "OnChangeEnvoy")
	local pPlayer = Players[iPlayerID]
    local pEnvoy = pPlayer:GetInfluence()
    pEnvoy:ChangeTokensToGive(pNewEnvoy)
    Debug("Envoys added to iPlayerID "..tostring(iPlayerID), "OnChangeEnvoy")
end
--diplo favor
function OnUIChangeDiplomaticFavor(iPlayerID, pNewFavor)
	Debug("Called", "OnUIChangeDiplomaticFavor")
	GameEvents.GameplayChangeDiplomaticFavor(iPlayerID, pNewFavor)
end

function OnGameplayChangeDiplomaticFavor(iPlayerID, pNewFavor)
	Debug("Called", "OnChangeDiplomaticFavor")
	OnChangeDiplomaticFavor(iPlayerID, pNewFavor)
end

function OnChangeDiplomaticFavor(iPlayerID, pNewFavor)
	Debug("Called", "OnChangeDiplomaticFavor")
	local pPlayer = Players[iPlayerID]
    if pPlayer:GetDiplomacy().ChangeFavor ~= nil then
		pPlayer:GetDiplomacy():ChangeFavor(pNewFavor);
	end
	Debug("Diplo Favor added to iPlayerID"..tostring(iPlayerID), "OnChangeDiplomaticFavor")
end
--reveal cs and players
function OnUIRevealAll(iPlayerID)
	Debug("Called", "OnUIRevealAll")
	GameEvents.GameplayRevealAll.Call(iPlayerID)
end

function OnGameplayRevealAll(iPlayerID)
	Debug("Called", "OnGameplayRevealAll")
	OnRevealAll(iPlayerID)
end

function OnRevealAll(iPlayerID)
	Debug("Called", "OnRevealAll")
	local eObserverID = Game.GetLocalObserver();
	if (eObserverID == PlayerTypes.OBSERVER) then
		PlayerManager.SetLocalObserverTo(playerID);
	else
		PlayerManager.SetLocalObserverTo(PlayerTypes.OBSERVER);
	end
	Debug("All Players and City-States revealed for playerID "..tostring(playerID), "OnRevealAll")
end
-- // ----------------------------------------------------------------------------------------------
-- // Lua Events
-- // ----------------------------------------------------------------------------------------------
function Initialize()
	Debug("Cheat Menu Initialization Started", "Initialize");
	--if ( not ExposedMembers.MOD_CheatMenu) then ExposedMembers.MOD_CheatMenu = {}; end
	--set local state values

	--gold
	LuaEvents.MOD_CheatMenu.UIChangeGold.Add(OnUIChangeGold);
	GameEvents.GameplayChangeGold.Add(OnGameplayChangeGold)
	--faith
	LuaEvents.MOD_CheatMenu.UIChangeFaith.Add(OnUIChangeFaith);
	GameEvents.GameplayChangeFaith.Add(OnGameplayChangeFaith)
	--science current
	LuaEvents.MOD_CheatMenu.UICompleteResearch.Add(OnUICompleteResearch);
	GameEvents.GameplayCompleteResearch.Add(OnGameplayCompleteResearch)
	--culture current
	LuaEvents.MOD_CheatMenu.UICompleteCivic.Add(OnUICompleteCivic);	
	GameEvents.GameplayCompleteCivic.Add(OnGameplayCompleteCivic)
	--production current
	LuaEvents.MOD_CheatMenu.UICompleteProduction.Add(OnUICompleteProduction);
	GameEvents.GameplayCompleteProduction.Add(OnGameplayCompleteProduction)
	--Gov titles
	LuaEvents.MOD_CheatMenu.UIChangeGovPoints.Add(OnUIChangeGovPoints);
	GameEvents.GameplayChangeGovPoints.Add(OnGameplayChangeGovPoints)
	--Envoys
	LuaEvents.MOD_CheatMenu.UIChangeEnvoy.Add(OnUIChangeEnvoy);
	GameEvents.GameplayChangeEnvoy.Add(OnGameplayChangeEnvoy)
	--Diplo Favor
	LuaEvents.UIChangeDiplomaticFavor.Add(OnUIChangeDiplomaticFavor);
	GameEvents.GameplayChangeDiplomaticFavor.Add(OnGameplayChangeDiplomaticFavor)
	--Reveal CS and Players
	LuaEvents.UIRevealAll.Add(OnUIRevealAll);
	GameEvents.GameplayRevealAll.Add(OnGameplayRevealAll)	
	--ExposedMembers.MOD_CheatMenu_Initialized = true;
	Debug("Cheat Menu Initialization Finished", "Initialize");
end

Initialize();
