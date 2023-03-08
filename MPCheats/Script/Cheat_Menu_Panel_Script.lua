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
	local pPlayer = Players[playerID]
    local pTreasury = pPlayer:GetTreasury()
    pTreasury:ChangeGoldBalance(pNewGold)
end
function CompleteProduction(playerID)
	local pPlayer = Players[playerID]
	local pCity = pPlayer:GetCities():FindID(iCity)	
	local pCityBuildQueue = pCity:GetBuildQueue();
	if iPlayer == playerID then
		pCityBuildQueue:FinishProgress()		
	end
end
function CompleteResearch(playerID, pResearchComplete)
    local pPlayer = Players[playerID]
    local pResearch = pPlayer:GetTechs()
    pResearch:ChangeCurrentResearchProgress(pResearchComplete)
end
function CompleteCivic(playerID, pCivicComplete)
    local pPlayer = Players[playerID]
    local pCivics = pPlayer:GetCulture()
    pCivics:ChangeCurrentCulturalProgress(pCivicComplete)
end
function ChangeFaith(playerID, pNewReligion)
	local pPlayer = Players[playerID]
    local pReligion = pPlayer:GetReligion()
    pReligion:ChangeFaithBalance(pNewReligion)
end
function ChangeEnvoy(playerID, pNewEnvoy)
	local pPlayer = Players[playerID]
    local pEnvoy = pPlayer:GetInfluence()
    pEnvoy:ChangeTokensToGive(pNewEnvoy)
end
function ChangeDiplomaticFavor(playerID, pNewFavor)
	local pPlayer = Players[playerID]
    if pPlayer:GetDiplomacy().ChangeFavor ~= nil then
		pPlayer:GetDiplomacy():ChangeFavor(pNewFavor);
	end	
end
function ChangeGovPoints(playerID, pNewGP)
	local pPlayer = Players[playerID];
	pPlayer:GetGovernors():ChangeGovernorPoints(pNewGP);
end
function RevealAll(playerID)
	local eObserverID = Game.GetLocalObserver();
	if (eObserverID == PlayerTypes.OBSERVER) then
		PlayerManager.SetLocalObserverTo(playerID);
	else
		PlayerManager.SetLocalObserverTo(PlayerTypes.OBSERVER);
	end
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
