-- // ----------------------------------------------------------------------------------------------
-- // Author: Sparrow, integrated for MP by FlashyFeeds
-- // DateCreated: 01/24/2019 2:27:04 PM
-- // ----------------------------------------------------------------------------------------------
ExposedMembers.LuaEvents = LuaEvents
local iLocPlayerID;
local iLocCityID;

-- // ----------------------------------------------------------------------------------------------
-- // Event Handlers
-- // ----------------------------------------------------------------------------------------------
--set local state
function OnUIPlayerCityUpdt(tPlayerSelections)
	print("OnUIPlayerCityUpdt called")
	GameEvents.GameplayPlayerCityUpdt(tPlayerSelections)
end

function OnGameplayPlayerCityUpdt(tPlayerSelections)
	print("GameplayPlayerCityUpdt called")
	Game.SetProperty("PLAYER_SELECTIONS", tPlayerSelections)
	iLocPlayerID = Game.GetLocalPlayer()
	iLocCityID = tPlayerSelections[iLocPlayerID]
	print("Local instnace variables set: iLocPlayerID, iLocCityID", iLocPlayerID, iLocCityID)
end
--gold
function OnUIChangeGold(iPlayerID, pNewGold)
	print("OnUIChangeGold called")
	GameEvents.GameplayChangeGold.Call(iPlayerID, pNewGold)
end

function OnGameplayChangeGold(iPlayerID, pNewGold)
	print("OnGameplayChangeGold called")
	OnChangeGold(iPlayerID, pNewGold)
end
function OnChangeGold(iPlayerID, pNewGold)
	print("OnChangeGold called")
	local pPlayer = Players[iPlayerID]
    local pTreasury = pPlayer:GetTreasury()
    pTreasury:ChangeGoldBalance(pNewGold)
    print("Gold added to", iPlayerID)
end
--faith
function OnUIChangeFaith(iPlayerID, pNewReligion)
	print("OnUIChangeFaith called")
	GameEvents.GameplayChangeFaith.Call(iPlayerID, pNewReligion)
end

function OnGameplayChangeFaith(iPlayerID, pNewReligion)
	print("OnGameplayChangeFaith called")
	OnChangeFaith(iPlayerID, pNewReligion)
end

function OnChangeFaith(iPlayerID, pNewReligion)
	print("OnChangeFaith called")
	local pPlayer = Players[iPlayerID]
    local pReligion = pPlayer:GetReligion()
    pReligion:ChangeFaithBalance(pNewReligion)
    print("Faith added to iPlayerID", iPlayerID)
end
--science current
function OnUICompleteResearch(iPlayerID, pResearchComplete)
	print("OnUICompleteResearch called")
	GameEvents.GameplayCompleteResearch.Call(iPlayerID, pResearchComplete)
end

function OnGameplayCompleteResearch(iPlayerID, pResearchComplete)
	print("OnGameplayCompleteResearch called")
	OnCompleteResearch(iPlayerID, pResearchComplete)
end

function OnCompleteResearch(iPlayerID, pResearchComplete)
	print("OnCompleteResearch called")
    local pPlayer = Players[iPlayerID]
    local pResearch = pPlayer:GetTechs()
    pResearch:ChangeCurrentResearchProgress(pResearchComplete)
    print("Research Completed for iPlayerID", iPlayerID)
end
--culture current
function OnUICompleteCivic(iPlayerID, pCivicComplete)
	print("CompleteCivic called")
	GameEvents.GameplayCompleteCivic.Call(iPlayerID, pCivicComplete)
end

function OnGameplayCompleteCivic(iPlayerID, pCivicComplete)
	print("OnGameplayCompleteCivic called")
	OnCompleteCivic(iPlayerID, pCivicComplete)
end

function OnCompleteCivic(iPlayerID, pCivicComplete)
	print("OnCompleteCivic")
    local pPlayer = Players[iPlayerID]
    local pCivics = pPlayer:GetCulture()
    pCivics:ChangeCurrentCulturalProgress(pCivicComplete)
    print("Civic completed for iPlayerID", iPlayerID)
end
--Production Current
function OnUICompleteProduction(iPlayerID)
	print("CompleteProduction called")
	GameEvents.GameplayCompleteProduction.Call(iPlayerID)
end

function OnGameplayCompleteProduction(iPlayerID)
	print("OnGameplayCompleteProduction called")
	OnCompleteProduction(iPlayerID)
end

function OnCompleteProduction(iPlayerID)
	print("OnCompleteProduction called")
	local pPlayer = Players[iPlayerID]
	local pCity = pPlayer:GetCities():FindID(iLocCityID)
	if pCity == nil then
		return print("Error: nil City")
	end
	local pCityBuildQueue = pCity:GetBuildQueue();
	if iLocPlayerID == iPlayerID then
		pCityBuildQueue:FinishProgress()		
	end
	print("Production Completed for iPlayerID in iLocCityID", iPlayerID, iLocCityID)
end
--gov titles
function OnUIChangeGovPoints(iPlayerID, pNewGP)
	print("ChangeGovernorPoints called")
	GameEvents.GameplayChangeGovPoints.Call(iPlayerID, pNewGP)
end

function OnGameplayChangeGovPoints(iPlayerID, pNewGP)
	print("OnGameplayChangeGovPoints called")
	OnChangeGovPoints(iPlayerID, pNewGP)
end

function OnChangeGovPoints(iPlayerID, pNewGP)
	print("OnChangeGovPoints called")
	local pPlayer = Players[iPlayerID];
	pPlayer:GetGovernors():ChangeGovernorPoints(pNewGP);
	print("Gov Titles added to iPlayerID", iPlayerID)
end
--envoys
function OnUIChangeEnvoy(iPlayerID, pNewEnvoy)
	print("ChangeEnvoy called")
	GameEvents.GameplayChangeEnvoy.Call(iPlayerID, pNewEnvoy)
end

function OnGameplayChangeEnvoy(iPlayerID, pNewEnvoy)
	print("OnGameplayChangeEnvoy called")
	OnChangeEnvoy(iPlayerID, pNewEnvoy)
end

function OnChangeEnvoy(iPlayerID, pNewEnvoy)
	print("OnChangeEnvoy called")
	local pPlayer = Players[iPlayerID]
    local pEnvoy = pPlayer:GetInfluence()
    pEnvoy:ChangeTokensToGive(pNewEnvoy)
    print("Envoys added to iPlayerID", iPlayerID)
end
--diplo favor
function OnUIChangeDiplomaticFavor(iPlayerID, pNewFavor)
	print("ChangeDiplomaticFavor called")
	GameEvents.GameplayChangeDiplomaticFavor(iPlayerID, pNewFavor)
end

function OnGameplayChangeDiplomaticFavor(iPlayerID, pNewFavor)
	print("OnChangeDiplomaticFavor called")
	OnChangeDiplomaticFavor(iPlayerID, pNewFavor)
end

function OnChangeDiplomaticFavor(iPlayerID, pNewFavor)
	print("OnChangeDiplomaticFavor called")
	local pPlayer = Players[iPlayerID]
    if pPlayer:GetDiplomacy().ChangeFavor ~= nil then
		pPlayer:GetDiplomacy():ChangeFavor(pNewFavor);
	end
	print("Diplo Favor added to iPlayerID", iPlayerID)
end
--reveal cs and players
function OnUIRevealAll(iPlayerID)
	print("RevealAll called")
	GameEvents.GameplayRevealAll.Call(iPlayerID)
end

function OnGameplayRevealAll(iPlayerID)
	print("OnGameplayRevealAll called")
	OnRevealAll(iPlayerID)
end

function OnRevealAll(iPlayerID)
	print("OnRevealAll called")
	local eObserverID = Game.GetLocalObserver();
	if (eObserverID == PlayerTypes.OBSERVER) then
		PlayerManager.SetLocalObserverTo(playerID);
	else
		PlayerManager.SetLocalObserverTo(PlayerTypes.OBSERVER);
	end
	print("All Players and City-States revealed for playerID", playerID)
end
-- // ----------------------------------------------------------------------------------------------
-- // Lua Events
-- // ----------------------------------------------------------------------------------------------
function Initialize()
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
	print( "Cheat Menu Initialization Started" );
end

Initialize();
