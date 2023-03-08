-- // ----------------------------------------------------------------------------------------------
-- // Author: Sparrow
-- // DateCreated: 01/24/2019 2:27:04 PM
-- // ----------------------------------------------------------------------------------------------

local iPlayer;
local iCity;

-- // ----------------------------------------------------------------------------------------------
-- // Event Handlers
-- // ----------------------------------------------------------------------------------------------
function ChangeGold(playerID, pNewGold)
	print("ChangeGold called")
	GameEvents.GameplayChangeGold.Call(playerID, pNewGold)
end

function OnGameplayChangeGold(playerID, pNewGold)
	print("OnGameplayChangeGold called")
	OnChangeGold(playerID, pNewGold)
end
function OnChangeGold(playerID, pNewGold)
	print("OnChangeGold called")
	local pPlayer = Players[playerID]
    local pTreasury = pPlayer:GetTreasury()
    pTreasury:ChangeGoldBalance(pNewGold)
    print("Gold added to", playerID)
end

function CompleteProduction(playerID)
	print("CompleteProduction called")
	GameEvents.GameplayCompleteProduction.Call(playerID)
end

function OnGameplayCompleteProduction(playerID)
	print("OnGameplayCompleteProduction called")
	OnCompleteProduction(playerID)
end

function OnCompleteProduction(playerID)
	print("OnCompleteProduction called")
	local pPlayer = Players[playerID]
	local pCity = pPlayer:GetCities():FindID(iCity)	
	local pCityBuildQueue = pCity:GetBuildQueue();
	if iPlayer == playerID then
		pCityBuildQueue:FinishProgress()		
	end
	print("Production Completed for playerID in iCity", playerID, iCity)
end

function CompleteResearch(playerID, pResearchComplete)
	print("CompleteResearch called")
	GameEvents.GameplayCompleteResearch.Call(playerID, pResearchComplete)
end

function OnGameplayCompleteResearch(playerID, pResearchComplete)
	print("OnGameplayCompleteResearch called")
	OnCompleteResearch(playerID, pResearchComplete)
end

function OnCompleteResearch(playerID, pResearchComplete)
	print("OnCompleteResearch called")
    local pPlayer = Players[playerID]
    local pResearch = pPlayer:GetTechs()
    pResearch:ChangeCurrentResearchProgress(pResearchComplete)
    print("Research Completed for playerID", playerID)
end

function CompleteCivic(playerID, pCivicComplete)
	print("CompleteCivic called")
	GameEvents.GameplayCompleteCivic.Call(playerID, pCivicComplete)
end

function OnGameplayCompleteCivic(playerID, pCivicComplete)
	print("OnGameplayCompleteCivic called")
	OnCompleteCivic(playerID, pCivicComplete)
end

function OnCompleteCivic(playerID, pCivicComplete)
	print("OnCompleteCivic")
    local pPlayer = Players[playerID]
    local pCivics = pPlayer:GetCulture()
    pCivics:ChangeCurrentCulturalProgress(pCivicComplete)
    print("Civic completed for playerID", playerID)
end

function ChangeFaith(playerID, pNewReligion)
	print("ChangeFaith called")
	GameEvents.GameplayChangeFaith.Call(playerID, pNewReligion)
end

function OnGameplayChangeFaith(playerID, pNewReligion)
	print("OnGameplayChangeFaith called")
	OnChangeFaith(playerID, pNewReligion)
end

function OnChangeFaith(playerID, pNewReligion)
	print("OnChangeFaith called")
	local pPlayer = Players[playerID]
    local pReligion = pPlayer:GetReligion()
    pReligion:ChangeFaithBalance(pNewReligion)
    print("Faith added to playerID", playerID)
end

function ChangeEnvoy(playerID, pNewEnvoy)
	print("ChangeEnvoy called")
	GameEvents.GameplayChangeEnvoy.Call(playerID, pNewEnvoy)
end

function OnGameplayChangeEnvoy(playerID, pNewEnvoy)
	print("OnGameplayChangeEnvoy called")
	OnChangeEnvoy(playerID, pNewEnvoy)
end

function OnChangeEnvoy(playerID, pNewEnvoy)
	print("OnChangeEnvoy called")
	local pPlayer = Players[playerID]
    local pEnvoy = pPlayer:GetInfluence()
    pEnvoy:ChangeTokensToGive(pNewEnvoy)
    print("Envoys added to playerID", playerID)
end

function ChangeDiplomaticFavor(playerID, pNewFavor)
	print("ChangeDiplomaticFavor called")
	GameEvents.GameplayChangeDiplomaticFavor(playerID, pNewFavor)
end

function OnGameplayChangeDiplomaticFavor(playerID, pNewFavor)
	print("OnChangeDiplomaticFavor called")
	OnChangeDiplomaticFavor(playerID, pNewFavor)
end

function OnChangeDiplomaticFavor(playerID, pNewFavor)
	print("OnChangeDiplomaticFavor called")
	local pPlayer = Players[playerID]
    if pPlayer:GetDiplomacy().ChangeFavor ~= nil then
		pPlayer:GetDiplomacy():ChangeFavor(pNewFavor);
	end
	print("Diplo Favor added to playerID", playerID)
end

function ChangeGovPoints(playerID, pNewGP)
	print("ChangeGovernorPoints called")
	GameEvents.GameplayChangeGovPoints.Call(playerID, pNewGP)
end

function OnGameplayChangeGovPoints(playerID, pNewGP)
	print("OnGameplayChangeGovPoints called")
	OnChangeGovPoints(playerID, pNewGP)
end

function OnChangeGovPoints(playerID, pNewGP)
	print("OnChangeGovPoints called")
	local pPlayer = Players[playerID];
	pPlayer:GetGovernors():ChangeGovernorPoints(pNewGP);
	print("Gov Titles added to playerID", playerID)
end

function RevealAll(playerID)
	print("RevealAll called")
	GameEvents.GameplayRevealAll.Call(playerID)
end

function OnGameplayRevealAll(playerID)
	print("OnGameplayRevealAll called")
	OnRevealAll(playerID)
end

function OnRevealAll(playerID)
	print("OnRevealAll called")
	local eObserverID = Game.GetLocalObserver();
	if (eObserverID == PlayerTypes.OBSERVER) then
		PlayerManager.SetLocalObserverTo(playerID);
	else
		PlayerManager.SetLocalObserverTo(PlayerTypes.OBSERVER);
	end
	print("All Players and City-States revealed for playerID", playerID)
end

function SetValues(playerID, cityID)
	iPlayer = playerID
	iCity = cityID	
end

-- // ----------------------------------------------------------------------------------------------
-- // Lua Events
-- // ----------------------------------------------------------------------------------------------
function Initialize()

	Events.CitySelectionChanged.Add(SetValues)

	if ( not ExposedMembers.MOD_CheatMenu) then ExposedMembers.MOD_CheatMenu = {}; end
	GameEvents.GameplayChangeDiplomaticFavor.Add(OnGameplayChangeDiplomaticFavor)
	GameEvents.GameplayChangeGold.Add(OnGameplayChangeGold)
	GameEvents.GameplayChangeGovPoints.Add(OnGameplayChangeGovPoints)
	GameEvents.GameplayRevealAll.Add(OnGameplayRevealAll)
	GameEvents.GameplayChangeEnvoy.Add(OnGameplayChangeEnvoy)
	GameEvents.GameplayCompleteProduction.Add(OnGameplayCompleteProduction)
	GameEvents.GameplayCompleteResearch.Add(OnGameplayCompleteResearch)
	GameEvents.GameplayCompleteCivic.Add(OnGameplayCompleteCivic)
	GameEvents.GameplayChangeFaith.Add(OnGameplayChangeFaith)
	ExposedMembers.MOD_CheatMenu.ChangeDiplomaticFavor = ChangeDiplomaticFavor;
	ExposedMembers.MOD_CheatMenu.ChangeGold = ChangeGold;
	ExposedMembers.MOD_CheatMenu.ChangeGovPoints = ChangeGovPoints;
	ExposedMembers.MOD_CheatMenu.RevealAll = RevealAll;
	ExposedMembers.MOD_CheatMenu.ChangeEnvoy = ChangeEnvoy;
	ExposedMembers.MOD_CheatMenu.CompleteProduction = CompleteProduction;
	ExposedMembers.MOD_CheatMenu.CompleteResearch = CompleteResearch;
	ExposedMembers.MOD_CheatMenu.CompleteCivic = CompleteCivic;
	ExposedMembers.MOD_CheatMenu.ChangeFaith = ChangeFaith;
	ExposedMembers.MOD_CheatMenu_Initialized = true;
	print( "Cheat Menu Initialization Started" );
end

Initialize();
