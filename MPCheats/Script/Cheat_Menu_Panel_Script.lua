-- // ----------------------------------------------------------------------------------------------
-- // Author: Sparrow, integrated for MP by FlashyFeeds
-- // DateCreated: 01/24/2019 2:27:04 PM
-- // ----------------------------------------------------------------------------------------------
ExposedMembers.LuaEvents = LuaEvents
include("bbgts_debug.lua")
local iLocPlayerID;
local iLocCityID;
local tAlivePlayers = {}

-- // ----------------------------------------------------------------------------------------------
-- // Event Handlers
-- // ----------------------------------------------------------------------------------------------
--// set local state
function InitPlayerSelection()
	local tAliveMajors = PlayerManager.GetAliveMajorIDs()
	local tPlayerCheatState = Game.GetProperty("PLAYER_SELECTIONS")
	local tPlayerSelections = {}
	if tPlayerCheatState ~= nil then return end
	
	for i, iPlayerID in ipairs(tAliveMajors) do
		tPlayerSelections[iPlayerID] = -1
	end
	Game.SetProperty("PLAYER_SELECTIONS", tPlayerSelections)
	Debug("tPlayerSelections populated with values", "InitPlayerSelection")
	civ6tostring(tPlayerSelections)
	--UICheatEvents.UIPlayerCityUpdt(tPlayerSelections)
end

function OnUIPlayerCityUpdt(tPlayerSelections)
	Debug("Called", "OnUIPlayerCityUpdt")
	GameEvents.GameplayPlayerCityUpdt.Call(tPlayerSelections)
end

function OnGameplayPlayerCityUpdt(tPlayerSelections)
	Debug("Called", "OnGameplayPlayerCityUpdt")
	Game.SetProperty("PLAYER_SELECTIONS", tPlayerSelections)
	Debug("Game Property PLAYER_SELECTIONS set with values", "OnGameplayPlayerCityUpdt")
	civ6tostring(tPlayerSelections)
	iLocPlayerID = Game.GetLocalPlayer()
	iLocCityID = tPlayerSelections[iLocPlayerID]
	Debug("Local instnace variables set: iLocPlayerID, iLocCityID: "..tostring(iLocPlayerID)..", "..tostring(iLocCityID), "OnGameplayPlayerCityUpdt")
end
--// gold
--function OnUIChangeGold(iPlayerID, pNewGold)
	--Debug("Called", "OnUIChangeGold")
	--GameEvents.GameplayChangeGold.Call(iPlayerID, pNewGold)
--end

function OnGameplayChangeGold(iPlayerID, kParameters)
	Debug("Called", "OnGameplayChangeGold")
	--if kParameters.Type~="ChangeGold" then return end
	local iPlayerID = kParameters["iPlayerID"]
	local pNewGold = kParameters["pNewGold"]
	OnChangeGold(iPlayerID, pNewGold)
end
function OnChangeGold(iPlayerID, pNewGold)
	Debug("Called", "OnChangeGold")
	local pPlayer = Players[iPlayerID]
    local pTreasury = pPlayer:GetTreasury()
    pTreasury:ChangeGoldBalance(pNewGold)
    Debug("Gold added to iPlayerID "..tostring(iPlayerID), "OnChangeGold")
end
--// faith
--function OnUIChangeFaith(iPlayerID, pNewReligion)
	--Debug("Called", "OnUIChangeFaith")
	--GameEvents.GameplayChangeFaith.Call(iPlayerID, pNewReligion)
--end

function OnGameplayChangeFaith(iPlayerID, pNewReligion)
	Debug("Called", "OnGameplayChangeFaith")
	local iPlayerID = kParameters["iPlayerID"]
	local pNewReligion = kParameters["pNewReligion"]
	OnChangeFaith(iPlayerID, pNewReligion)
end

function OnChangeFaith(iPlayerID, pNewReligion)
	Debug("Called", "OnChangeFaith")
	local pPlayer = Players[iPlayerID]
    local pReligion = pPlayer:GetReligion()
    pReligion:ChangeFaithBalance(pNewReligion)
    Debug("Faith added to iPlayerID "..tostring(iPlayerID), "OnChangeFaith")
end
--// science current
--function OnUICompleteResearch(iPlayerID, pResearchComplete)
	--Debug("Called", "OnUICompleteResearch")
	--GameEvents.GameplayCompleteResearch.Call(iPlayerID, pResearchComplete)
--end

function OnGameplayCompleteResearch(iPlayerID, kParameters)
	Debug("Called", "OnGameplayCompleteResearch")
	local iPlayerID = kParameters["iPlayerID"]
	local pResearchComplete = kParameters["pResearchComplete"]
	OnCompleteResearch(iPlayerID, pResearchComplete)
end

function OnCompleteResearch(iPlayerID, pResearchComplete)
	Debug("Called", "OnCompleteResearch")
    local pPlayer = Players[iPlayerID]
    local pResearch = pPlayer:GetTechs()
    pResearch:ChangeCurrentResearchProgress(pResearchComplete)
    Debug("Research Completed for iPlayerID "..tostring(iPlayerID), "OnCompleteResearch")
end
--// culture current
--function OnUICompleteCivic(iPlayerID, pCivicComplete)
	--Debug("Called", "OnUICompleteCivic")
	--GameEvents.GameplayCompleteCivic.Call(iPlayerID, pCivicComplete)
--end

function OnGameplayCompleteCivic(iPlayerID, pCivicComplete)
	Debug("Called", "OnGameplayCompleteCivic")
	iPlayerID = kParameters["iPlayerID"]
	pCivicComplete = kParameters["pCivicComplete"]
	OnCompleteCivic(iPlayerID, pCivicComplete)
end

function OnCompleteCivic(iPlayerID, pCivicComplete)
	Debug("Called", "OnCompleteCivic")
    local pPlayer = Players[iPlayerID]
    local pCivics = pPlayer:GetCulture()
    pCivics:ChangeCurrentCulturalProgress(pCivicComplete)
    Debug("Civic completed for iPlayerID "..tostring(iPlayerID), "OnCompleteCivic")
end
--// Production Current
--function OnUICompleteProduction(iPlayerID)
	--Debug("Called", "OnUICompleteProduction")
	--GameEvents.GameplayCompleteProduction.Call(iPlayerID)
--end

function OnGameplayCompleteProduction(iPlayerID, kParameters)
	Debug("Called", "OnGameplayCompleteProduction")
	local iPlayerID = kParameters["iPlayerID"]
	OnCompleteProduction(iPlayerID)
end

function OnCompleteProduction(iPlayerID)
	Debug("Called", "OnCompleteProduction")
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return print("Error: nil player")
	end
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
--// gov titles
--function OnUIChangeGovPoints(iPlayerID, pNewGP)
	--Debug("Called", "OnUIChangeGovernorPoints")
	--GameEvents.GameplayChangeGovPoints.Call(iPlayerID, pNewGP)
--end

function OnGameplayChangeGovPoints(iPlayerID, pNewGP)
	Debug("Called", "OnGameplayChangeGovPoints")
	local iPlayerID = kParameters["iPlayerID"]
	local pNewGP = kParameters["pNewFavor"]
	OnChangeGovPoints(iPlayerID, pNewGP)
end

function OnChangeGovPoints(iPlayerID, pNewGP)
	Debug("Called", "OnChangeGovPoints")
	local pPlayer = Players[iPlayerID];
	pPlayer:GetGovernors():ChangeGovernorPoints(pNewGP);
	Debug("Gov Titles added to iPlayerID "..tostring(iPlayerID), "OnChangeGovPoints")
end
--// envoys
--function OnUIChangeEnvoy(iPlayerID, pNewEnvoy)
	--Debug("Called", "OnUIChangeEnvoy")
	--GameEvents.GameplayChangeEnvoy.Call(iPlayerID, pNewEnvoy)
--end

function OnGameplayChangeEnvoy(iPlayerID, pNewEnvoy)
	Debug("Called", "OnGameplayChangeEnvoy")
	local iPlayerID = kParameters["iPlayerID"]
	local pNewEnvoy = kParameters["pNewEnvoy"]
	OnChangeEnvoy(iPlayerID, pNewEnvoy)
end

function OnChangeEnvoy(iPlayerID, pNewEnvoy)
	Debug("Called", "OnChangeEnvoy")
	local pPlayer = Players[iPlayerID]
    local pEnvoy = pPlayer:GetInfluence()
    pEnvoy:ChangeTokensToGive(pNewEnvoy)
    Debug("Envoys added to iPlayerID "..tostring(iPlayerID), "OnChangeEnvoy")
end
--// diplo favor
--function OnUIChangeDiplomaticFavor(iPlayerID, pNewFavor)
	--Debug("Called", "OnUIChangeDiplomaticFavor")
	--GameEvents.GameplayChangeDiplomaticFavor.Call(iPlayerID, pNewFavor)
--end

function OnGameplayChangeDiplomaticFavor(iPlayerID, pNewFavor)
	Debug("Called", "OnGameplayChangeDiplomaticFavor")
	local iPlayerID = kParameters["iPlayerID"]
	local pNewFavor = kParameters["pNewFavor"]
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
--function OnUIRevealAll(iPlayerID)
	--Debug("Called", "OnUIRevealAll")
	--GameEvents.GameplayRevealAll.Call(iPlayerID)
--end

function OnGameplayRevealAll(iPlayerID)
	Debug("Called", "OnGameplayRevealAll")
	local iPlayerID = kParameters["iPlayerID"]
	OnRevealAll(iPlayerID)
end

function OnRevealAll(iPlayerID)
	Debug("Called", "OnRevealAll")
	local tAlivePlayers = Game.GetProperty("ALIVE_PLAYERS")
	if tAlivePlayers == nil then
		return print("Error Occured while populating/retrieving alive players")
	end
	local nCount = tAlivePlayers.Count
	local tAliveIDs = tAlivePlayers.AlivePlayers
	for i=1, nCount do
		local iAliveID = tAliveIDs[i]
		if iPlayerID~=iAliveID then
			local pAliveVis = PlayersVisibility[iAliveID]
			pAliveVis:AddOutgoingVisibility(iPlayerID)
			local pAliveDiplo = Players[iAliveID]:GetDiplomacy()
			pAliveDiplo:HasMet(iPlayerID)
			Debug("Visibility added from iAliveID "..tostring(iAliveID).." to iPlayerID "..tostring(iPlayerID), "OnRevealAll")
		end
	end
	local pPlayer = Players[iPlayerID]
	local nVisRemoveTurn = Game.GetCurrentGameTurn() + 1
	pPlayer:SetProperty("VISIBILITY_END_TURN", nVisRemoveTurn)
	Debug("All Players and City-States revealed for playerID "..tostring(playerID), "OnRevealAll")
end

function OnUILocalPlayerTurnBegin(iPlayerID)
	Debug("Called", "OnUILocalPlayerTurnBegin")
	GameEvents.GameplayLocalTurnBegin.Call(iPlayerID)
end

function OnGameplayLocalTurnBegin(iPlayerID)
	Debug("Called", "OnGameplayLocalTurnBegin")
	local pPlayer = Players[iPlayerID]
	if pPlayer:GetProperty("VISIBILITY_END_TURN")==nil then return end

	local tAlivePlayers = Game.GetProperty("ALIVE_PLAYERS")
	if tAlivePlayers == nil then
		return print("Error Occured while populating/retrieving alive players")
	end
	local nCount = tAlivePlayers.Count
	local tAliveIDs = tAlivePlayers.AlivePlayers
	for i=1, nCount do
		local iAliveID = tAliveIDs[i]
		if iPlayerID~=iAliveID then
			local pAliveVis = PlayersVisibility[iAliveID]
			pAliveVis:RemoveOutgoingVisibility(iPlayerID)
			Debug("Visibility removed from iAliveID "..tostring(iAliveID).." to iPlayerID "..tostring(iPlayerID), "OnGameplayLocalTurnBegin")
		end
	end
	
	pPlayer:SetProperty("VISIBILITY_END_TURN", nil)
	Debug("All Players and City-States visibility removed for playerID "..tostring(playerID), "OnGameplayLocalTurnBegin")
end
--alive table (will probably migrate to bbg script)
function PopulateAliveTable()
	local tPlayerIDs = {}
	local nAlivePlayerCount = 0
	for i=0, 60 do
		local tmp_civ = Players[i]
		if tmp_civ~=nil then
			table.insert(tPlayerIDs, i)
			nAlivePlayerCount = nAlivePlayerCount+1
		end
	end
	tAlivePlayers.AlivePlayers = tPlayerIDs
	tAlivePlayers.Count = nAlivePlayerCount
	Game.SetProperty("ALIVE_PLAYERS", tAlivePlayers)
	Debug("ALIVE_PLAYERS populated with data:", "PopulateAliveTable")
	civ6tostring(tAlivePlayers)
end
--player defeated
function OnUIPlayerDefeat(iPlayerID)
	Debug("Called", "OnUIPlayerDefeat")
	GameEvents.GameplayPlayerDefeat.Call(iPlayerID)
end

function OnGameplayPlayerDefeat(iPlayerID)
	Debug("Called", "OnGameplayPlayerDefeat")
	local tGAlivePlayers = Game.GetProperty("ALIVE_PLAYERS")
	local tPlayerIDs = tGAlivePlayers.AlivePlayers
	local nCount = tGAlivePlayers.Count
	local iPos = IDToPos(tPlayerIDs, iPlayerID)
	table.remove(tPlayerIDs, iPos)
	nCount = nCount - 1
	tGAlivePlayers.AlivePlayers = tPlayerIDs
	tGAlivePlayers.Count = nCount
	tAlivePlayers = tGAlivePlayers
	Game.SetProperty("ALIVE_PLAYERS", tGAlivePlayers)
	Debug("ALIVE_PLAYERS populated with data:", "OnGameplayPlayerDefeat")
	civ6tostring(tAlivePlayers)
end
--player revived
function OnUIPlayerRevived()
	Debug("Called", "OnUIPlayerRevived")
	GameEvents.GameplayPlayerRevived.Call()
end

function OnGameplayPlayerRevived()
	Debug("Called", "OnGameplayPlayerRevived")
	PopulateAliveTable()
end

-- // ----------------------------------------------------------------------------------------------
-- // Support Functions
-- // ----------------------------------------------------------------------------------------------
function IDToPos(List, SearchItem, key, multi)
	Debug("Search Item "..tostring(SearchItem), "IDToPos")
	multi = multi or false
	Debug("multi "..tostring(multi), "IDToPos")
	key = key or nil
	Debug("key "..tostring(key), "IDToPos")
	local results = {}
	if List == {} then
		return false
	end
    if SearchItem==nil then
        return print("Search Error")
    end
    for i, item in ipairs(List) do
    	if key == nil then
    		Debug("nil key, item "..tostring(item), "IDToPos")
	        if item == SearchItem then
	        	if multi then
	        		table.insert(results, i)
	        	else
	            	return i;
	            end
	        end
	    else
	    	Debug("not nil key, item[key] "..tostring(item[key]), "IDToPos")
	    	if item[key] == SearchItem then
	        	if multi then
	        		table.insert(results, i)
	        	else
	            	return i;
	            end
	    	end
	    end
    end
    if results == {} or #results==0 or results==nil then
    	return false
    else
    	Debug("Results:", "IDToPos")
    	for _, item in ipairs(results) do
    		print(item)
    	end
    	return results
    end
end

-- // ----------------------------------------------------------------------------------------------
-- // Lua Events
-- // ----------------------------------------------------------------------------------------------
function Initialize()
	Debug("Cheat Menu Initialization Started", "Initialize");
	--if ( not ExposedMembers.MOD_CheatMenu) then ExposedMembers.MOD_CheatMenu = {}; end
	--set local alive values (probably migrate to bbg script)
	PopulateAliveTable()
	InitPlayerSelection()
	--update city selection
	LuaEvents.UIPlayerCityUpdt.Add(OnUIPlayerCityUpdt)
	GameEvents.GameplayPlayerCityUpdt.Add(OnGameplayPlayerCityUpdt)
	--repopulate alive values (probably migrate to bbg script)
	LuaEvents.UIPlayerDefeat.Add(OnUIPlayerDefeat)
	LuaEvents.UIPlayerRevived.Add(OnUIPlayerRevived)
	GameEvents.GameplayPlayerDefeat.Add(OnGameplayPlayerDefeat)
	--gold
	--LuaEvents.UIChangeGold.Add(OnUIChangeGold);
	GameEvents.GameplayChangeGold.Add(OnGameplayChangeGold)
	--GameEvents.OnPlayerCommandSetObjectState.Add(OnGameplayChangeGold)
	--faith
	--LuaEvents.UIChangeFaith.Add(OnUIChangeFaith);
	GameEvents.GameplayChangeFaith.Add(OnGameplayChangeFaith)
	--science current
	--LuaEvents.UICompleteResearch.Add(OnUICompleteResearch);
	GameEvents.GameplayCompleteResearch.Add(OnGameplayCompleteResearch)
	--culture current
	--LuaEvents.UICompleteCivic.Add(OnUICompleteCivic);	
	GameEvents.GameplayCompleteCivic.Add(OnGameplayCompleteCivic)
	--production current
	--LuaEvents.UICompleteProduction.Add(OnUICompleteProduction);
	GameEvents.GameplayCompleteProduction.Add(OnGameplayCompleteProduction)
	--Gov titles
	--LuaEvents.UIChangeGovPoints.Add(OnUIChangeGovPoints);
	GameEvents.GameplayChangeGovPoints.Add(OnGameplayChangeGovPoints)
	--Envoys
	--LuaEvents.UIChangeEnvoy.Add(OnUIChangeEnvoy);
	GameEvents.GameplayChangeEnvoy.Add(OnGameplayChangeEnvoy)
	--Diplo Favor
	--LuaEvents.UIChangeDiplomaticFavor.Add(OnUIChangeDiplomaticFavor);
	GameEvents.GameplayChangeDiplomaticFavor.Add(OnGameplayChangeDiplomaticFavor)
	--Reveal CS and Players
	--LuaEvents.UIRevealAll.Add(OnUIRevealAll);
	GameEvents.GameplayRevealAll.Add(OnGameplayRevealAll)
	LuaEvents.UILocalPlayerTurnBegin.Add(OnUILocalPlayerTurnBegin)
	GameEvents.GameplayLocalTurnBegin.Add(OnGameplayLocalTurnBegin)	
	--ExposedMembers.MOD_CheatMenu_Initialized = true;
	Debug("Cheat Menu Initialization Finished", "Initialize");
end

Initialize();
