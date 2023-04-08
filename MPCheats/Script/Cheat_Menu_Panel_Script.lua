-- // ----------------------------------------------------------------------------------------------
-- // Author: Sparrow, integrated for MP by FlashyFeeds
-- // DateCreated: 01/24/2019 2:27:04 PM
-- // ----------------------------------------------------------------------------------------------
ExposedMembers.LuaEvents = LuaEvents
include("bbgts_debug.lua")
--local iLocPlayerID;
--local iLocCityID;
local tAlivePlayers = {}
--Members: tAlivePlayers.AlivePlayers - alive player [i] - returns iAliveID, .Count returns total alive count for faster loops
--Associated Game Property: "ALIVE_PLAYERS"
local tHumanPlayers = {}
--Members
--tHumanPlayers.AliveHumans -- alive humans. [i] - returns individual data: 
	--["iPlayerID"] the ID
	-- .Loaded has 3 values: -1 not Loaded, 0 Local Player Turn Active, 1 -- Timer Dependent Interractions Active
--tHumanPlayer.Count -- returns count
--.LoadedCount currently loaded
--Associated Game Property "ALIVE_HUMANS"

--other vars
local g_nStartTurn = 0
local bTurnProcessing = true



-- // ----------------------------------------------------------------------------------------------
-- // Event Handlers
-- // ----------------------------------------------------------------------------------------------
--// set local state
--function InitPlayerSelection()
	--local tAliveMajors = PlayerManager.GetAliveMajorIDs()
	--local tPlayerCheatState = Game.GetProperty("PLAYER_SELECTIONS")
	--local tPlayerSelections = {}
	--if tPlayerCheatState ~= nil then return end
	
	--for i, iPlayerID in ipairs(tAliveMajors) do
		--tPlayerSelections[iPlayerID] = -1
	--end
	--Game.SetProperty("PLAYER_SELECTIONS", tPlayerSelections)
	--Debug("tPlayerSelections populated with values", "InitPlayerSelection")
	--civ6tostring(tPlayerSelections)
	--UICheatEvents.UIPlayerCityUpdt(tPlayerSelections)
--end

--function OnUIPlayerCityUpdt(tPlayerSelections)
	--Debug("Called", "OnUIPlayerCityUpdt")
	--GameEvents.GameplayPlayerCityUpdt.Call(tPlayerSelections)
--end

--function OnGameplayPlayerCityUpdt(tPlayerSelections)
	--Debug("Called", "OnGameplayPlayerCityUpdt")
	--Game.SetProperty("PLAYER_SELECTIONS", tPlayerSelections)
	--Debug("Game Property PLAYER_SELECTIONS set with values", "OnGameplayPlayerCityUpdt")
	--civ6tostring(tPlayerSelections)
	--iLocPlayerID = Game.GetLocalPlayer()
	--iLocCityID = tPlayerSelections[iLocPlayerID]
	--Debug("Local instnace variables set: iLocPlayerID, iLocCityID: "..tostring(iLocPlayerID)..", "..tostring(iLocCityID), "OnGameplayPlayerCityUpdt")
--end
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

function OnGameplayChangeFaith(iPlayerID, kParameters)
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

function OnGameplayCompleteCivic(iPlayerID, kParameters)
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
	local iCityID = kParameters["iCityID"]
	OnCompleteProduction(iPlayerID, iCityID)
end

function OnCompleteProduction(iPlayerID, iCityID)
	Debug("Called", "OnCompleteProduction")
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return print("Error: nil player")
	end
	local pCity = CityManager.GetCity(iPlayerID, iCityID)
	if pCity == nil then
		return print("Error: nil City")
	end
	local pCityBuildQueue = pCity:GetBuildQueue();
	
	pCityBuildQueue:FinishProgress()		
	Debug("Production Completed for iPlayerID in iLocCityID: "..tostring(iPlayerID)..", "..tostring(iCityID), "OnCompleteProduction")
end
--// gov titles
--function OnUIChangeGovPoints(iPlayerID, pNewGP)
	--Debug("Called", "OnUIChangeGovernorPoints")
	--GameEvents.GameplayChangeGovPoints.Call(iPlayerID, pNewGP)
--end

function OnGameplayChangeGovPoints(iPlayerID, kParameters)
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

function OnGameplayChangeEnvoy(iPlayerID, kParameters)
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

function OnGameplayChangeDiplomaticFavor(iPlayerID, kParameters)
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

function OnGameplayRevealAll(iPlayerID, kParameters)
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
			print("Diplo fetched sucka")
			if pAliveDiplo~=nil then
				pAliveDiplo:SetHasMet(iPlayerID)
			end
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

function OnGameplayLocalTurnBegin(iPlayerID, kParameters)
	Debug("Called", "OnGameplayLocalTurnBegin")
	local iPlayerID = kParameters["iPlayerID"]
	local pPlayer = Players[iPlayerID]

	--update human turn processing scripts controll
	local tHumanPlayers = Game.GetProperty("ALIVE_HUMANS")
	if tHumanPlayers == nil then
		return print("Error Occured while populating/retrieving human player data")
	end
	local nHumanCount = tHumanPlayers.Count
	local tHumanData = tHumanPlayers.AliveHumans
	local nLoadedCount = tHumanPlayers.LoadedCount
	for i = 1, nHumanCount do
		local iAliveID = tHumanData[i]["iPlayerID"]
		if iPlayerID == iAliveID then
			tHumanData[i].Loaded = 0
		end
		if tHumanData[i].Loaded ~= -1 then
			nLoadedCount = nLoadedCount + 1
		end
	end
	if bTurnProcessing then
		if nLoadedCount == 1 and g_nStartTurn < Game.GetCurrentGameTurn() then
			Debug("Setting First Player Out", "OnGameplayLocalTurnBegin")
			ExposedMembers.SetFirstOut()
		end
		if nLoadedCount == nHumanCount and g_nStartTurn < Game.GetCurrentGameTurn() then --we want to exclude turn 1 cheats
			Debug("Begining to Countdown for Panel Enable", "OnGameplayLocalTurnBegin")
			Game.SetProperty("TURN_DEPENDENT_ENABLED", 1)
			ExposedMembers.ActivateLocalTurnerEvent()
		end
	else
		ExposedMembers.ActivateTesterPanel()
		ExposedMembers.ActivateLocalTurnerEvent()
	end
	--remove the revealed visibility script
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
function PopulateAliveTable(nLoaded)
	nLoaded = nLoaded or -1
	local tPlayerIDs = {}
	local nAlivePlayerCount = 0
	local tHumanData = {}
	local nAliveHumanCount = 0
	local nLoadedCount = 0
	for i=0, 60 do
		local pTmpPlayer = Players[i]
		if pTmpPlayer~=nil then
			if pTmpPlayer:IsAlive() then
				table.insert(tPlayerIDs, i)
				nAlivePlayerCount = nAlivePlayerCount+1
				if pTmpPlayer:IsHuman() then
					nAliveHumanCount = nAliveHumanCount + 1
					local row = {}
					row["iPlayerID"] = i
					row.Loaded = nLoaded
					table.insert(tHumanData, row)
					Debug("Human player with ID "..tostring(i).." Added. nAliveHumanCount: "..tostring(nAliveHumanCount), "PopulateAliveTable")
					if nLoaded ~= -1 then
						nLoadedCount = nLoadedCount + 1
					end
				end  
			end
		end
	end
	tAlivePlayers.AlivePlayers = tPlayerIDs
	tAlivePlayers.Count = nAlivePlayerCount
	Game.SetProperty("ALIVE_PLAYERS", tAlivePlayers)
	Debug("ALIVE_PLAYERS populated with data:", "PopulateAliveTable")
	print(BuildRecursiveDataString(tAlivePlayers))
	tHumanPlayers.AliveHumans = tHumanData
	tHumanPlayers.Count = nAliveHumanCount
	tHumanPlayers.LoadedCount = nLoadedCount
	Game.SetProperty("ALIVE_HUMANS", tHumanPlayers)
	Debug("ALIVE_HUMANS populated with data:", "PopulateAliveTable")
	print(BuildRecursiveDataString(tHumanPlayers))
end
--player defeated
--function OnUIPlayerDefeat(iPlayerID)
	--Debug("Called", "OnUIPlayerDefeat")
	--GameEvents.GameplayPlayerDefeat.Call(iPlayerID)
--end

function OnGameplayPlayerDefeat(iPlayerID, kParameters)
	--General Defeat
	local iPlayerID = kParameters["iPlayerID"]
	Debug("Called", "OnGameplayPlayerDefeat")
	local tGAlivePlayers = Game.GetProperty("ALIVE_PLAYERS")
	local tPlayerIDs = tGAlivePlayers.AlivePlayers
	local nCount = tGAlivePlayers.Count
	local iPos = IDToPos(tPlayerIDs, iPlayerID)
	if iPos~=false then
		table.remove(tPlayerIDs, iPos)
		nCount = nCount - 1
		tGAlivePlayers.AlivePlayers = tPlayerIDs
		tGAlivePlayers.Count = nCount
		tAlivePlayers = tGAlivePlayers
		Game.SetProperty("ALIVE_PLAYERS", tGAlivePlayers)
		Debug("ALIVE_PLAYERS populated with data:", "OnGameplayPlayerDefeat")
		civ6tostring(tAlivePlayers)
	end
	--Human Defeat
	local tGHumanPlayers = Game.GetProperty("ALIVE_HUMANS")
	local tHumanData = tGHumanPlayers.AliveHumans
	local nHumanCount = tGHumanPlayers.Count
	local nLoadedCount = tGHumanPlayers.LoadedCount
	local iHumanPos = IDToPos(tHumanData, iPlayerID, "iPlayerID")
	if iHumanPos~=false then
		table.remove(tHumanData, iHumanPos)
		nHumanCount = nHumanCount - 1
		nLoadedCount = nLoadedCount - 1
		tGHumanPlayers.AliveHumans = tHumanData
		tGHumanPlayers.Count = nHumanCount
		tGHumanPlayers.LoadedCount = nLoadedCount
		tHumanPlayers = tGHumanPlayers
		Game.SetProperty("ALIVE_HUMANS", tGHumanPlayers)
		Debug("ALIVE_HUMANS populated with data:", "OnGameplayPlayerDefeat")
		civ6tostring(tHumanPlayers)
	end
end
--player revived
--function OnUIPlayerRevived(iPlayerID, kParameters)
	--Debug("Called", "OnUIPlayerRevived")
	--GameEvents.GameplayPlayerRevived.Call()
--end

function OnGameplayPlayerRevived(iPlayerID, kParameters)
	Debug("Called", "OnGameplayPlayerRevived")
	local nLoaded = Game.GetProperty("TURN_DEPENDENT_ENABLED")
	if nLoaded==nil then
		nLoaded = -1
	end
	PopulateAliveTable(nLoaded)
end

function OnGameplaySwitchOnHumanLoaded(iPlayerID, kParameters)
	Debug("Called", "OnGameplaySwitchOnHumanLoaded")
	local tGHumanPlayers = Game.GetProperty("ALIVE_HUMANS")
	if tGHumanPlayers == nil then
		return print("Error: tHumanPlayers was incorrectly populated")
	end
	local iPlayerID = kParameters["iPlayerID"]
	local tHumanData = tGHumanPlayers.AliveHumans
	local iHumanPos = IDToPos(tHumanData, iPlayerID, "iPlayerID")
	if iHumanPos == false then
		return print("Error: passing the iPlayerID was done wrong")
	end
	tHumanData[iHumanPos].Loaded = 1
	tGHumanPlayers.AliveHumans = tHumanData
	tHumanPlayers = tGHumanPlayers
	Game.SetProperty("ALIVE_HUMANS", tGHumanPlayers)
	Debug("ALIVE_HUMANS was updated. Current Values", "OnGameplaySwitchOnHumanLoaded")
	civ6tostring(tHumanPlayers)
	Debug("Activating Tester Panel on Local Machine", "OnGameplaySwitchOnHumanLoaded")
	ExposedMembers.ActivateTesterPanel()
end

function OnGameplayEndTimer(iPlayerID, kParameters)
	Debug("Called", "OnGameplayEndTimer")
	local tGHumanPlayers = Game.GetProperty("ALIVE_HUMANS")
	if tGHumanPlayers == nil then
		return print("Error: tHumanPlayers was incorrectly populated")
	end
	local tHumanData = tGHumanPlayers.AliveHumans
	local nHumanCount = tGHumanPlayers.Count
	for i=1, nHumanCount do
		tHumanData[i].Loaded = -1
	end
	tGHumanPlayers.AliveHumans = tHumanData
	tHumanPlayers = tGHumanPlayers
	Game.SetProperty("ALIVE_HUMANS", tGHumanPlayers)
	Debug("ALIVE_HUMANS was updated. Current Values", "OnGameplayEndTimer")
	civ6tostring(tHumanPlayers)
	Debug("Deactivating Tester Panel on Local Machine", "OnGameplayEndTimer")
	ExposedMembers.DeactivateTesterPanelWT()
	ExposedMembers.DeactivateTesterPanelFun()
end

function OnGameplaySetTurnEnd(iPlayerID, kParameters)
	Debug("Called", "OnGameplaySetTurnEnd")
	ExposedMembers.SetTurnEnd(kParameters.Delta)
end

function OnGameplayPlayerTurnDeactivated(iPlayerID, kParameters)
	Debug("Called", "OnGameplayPlayerTurnDeactivated")
	local iPlayerID = kParameters["iPlayerID"]
	local tGHumanPlayers = Game.GetProperty("ALIVE_HUMANS")
	if tGHumanPlayers == nil then
		return print("Error: tHumanPlayers was incorrectly populated")
	end
	local iPlayerID = kParameters["iPlayerID"]
	local tHumanData = tGHumanPlayers.AliveHumans
	local nLoadedCount = tGHumanPlayers.LoadedCount
	local iHumanPos = IDToPos(tHumanData, iPlayerID, "iPlayerID")
	if iHumanPos == false then
		return print("Error: passing the iPlayerID was done wrong")
	end
	tHumanData[iHumanPos].Loaded = -1
	tGHumanPlayers.AliveHumans = tHumanData
	nLoadedCount = nLoadedCount - 1
	tHumanPlayers = tGHumanPlayers
	Game.SetProperty("ALIVE_HUMANS", tGHumanPlayers)
	Debug("ALIVE_HUMANS was updated. Current Values", "OnGameplayPlayerTurnDeactivated")
	civ6tostring(tHumanPlayers)
	if bTurnProcessing then
		if nLoadedCount == 0 then
			Debug("Deactivating Tester Panel on Local Machine", "OnGameplayPlayerTurnDeactivated")
			ExposedMembers.DeactivateTesterPanelWT()
			ExposedMembers.DeactivateTesterPanelFun()
		end
	else
		ExposedMembers.DeactivateTesterPanelWT()
		ExposedMembers.DeactivateTesterPanelFun()
	end
end

-- // ----------------------------------------------------------------------------------------------
-- // Lense
-- // ----------------------------------------------------------------------------------------------
function OnGameplayUpdatePlayerResources(iPlayerID, kParameters)
	Debug("Called", "OnGameplayUpdatePlayerResources")
	local iResourceType = kParameters.ResourceType
	local iPlotID = kParameters["iPlotID"]
	
	--horses
	if GameInfo.Resources[iResourceType].ResourceType == "RESOURCE_HORSES" then
		Debug("RESOURCE_HORSES","OnGameplayUpdatePlayerResources")
		local tLenseHorses = pLocConfig:GetValue("T_CHEAT_RESOURCE_LENSE_HORSES")
		if tLenseHorses == nil then tLenseHorses = {} end
		local iSearchPos = IDToPos(tLenseHorses, iPlotID)
		if iSearchPos == false then
			table.insert(tLenseHorses,iPlotID)
			PlayerConfigurations[iPlayerID]:SetValue("T_CHEAT_RESOURCE_LENSE_HORSES", tLenseHorses)
			Debug("HORSES CONFIG Updated for iPlayerID "..tostring(iPlayerID), "OnGameplayUpdatePlayerResources")
		end
	
	--iron
	elseif GameInfo.Resources[iResourceType].ResourceType == "RESOURCE_IRON" then
		Debug("RESOURCE_IRON","OnGameplayUpdatePlayerResources")
		local tLenseIron = pLocConfig:GetValue("T_CHEAT_RESOURCE_LENSE_IRON")
		if tLenseIron == nil then tLenseIron = {} end
		local iSearchPos = IDToPos(tLenseIron, iPlotID)
		if iSearchPos == false then
			table.insert(tLenseIron,iPlotID)
			PlayerConfigurations[iPlayerID]:SetValue("T_CHEAT_RESOURCE_LENSE_IRON", tLenseIron)
			Debug("IRON CONFIG Updated for iPlayerID "..tostring(iPlayerID), "OnGameplayUpdatePlayerResources")
		end
	
	--niter
	elseif GameInfo.Resources[iResourceType].ResourceType == "RESOURCE_NITER" then
		Debug("RESOURCE_NITER","OnGameplayUpdatePlayerResources")
		local tLenseNiter = pLocConfig:GetValue("T_CHEAT_RESOURCE_LENSE_NITER")
		if tLenseNiter == nil then tLenseNiter = {} end
		local iSearchPos = IDToPos(tLenseNiter, iPlotID)
		if iSearchPos == false then
			table.insert(tLenseNiter,iPlotID)
			PlayerConfigurations[iPlayerID]:SetValue("T_CHEAT_RESOURCE_LENSE_NITER", tLenseNiter)
			Debug("NITER CONFIG Updated for iPlayerID "..tostring(iPlayerID), "OnGameplayUpdatePlayerResources")
		end
	
	--coal
	elseif GameInfo.Resources[iResourceType].ResourceType == "RESOURCE_COAL" then
		Debug("RESOURCE_COAL","OnGameplayUpdatePlayerResources")
		local tLenseCoal = pLocConfig:GetValue("T_CHEAT_RESOURCE_LENSE_COAL")
		if tLenseCoal == nil then tLenseCoal = {} end
		local iSearchPos = IDToPos(tLenseCoal, iPlotID)
		if iSearchPos == false then
			table.insert(tLenseCoal,iPlotID)
			PlayerConfigurations[iPlayerID]:SetValue("T_CHEAT_RESOURCE_LENSE_COAL", tLenseCoal)
			Debug("COAL CONFIG Updated for iPlayerID "..tostring(iPlayerID), "OnGameplayUpdatePlayerResources")
		end
	
	--oil
	elseif GameInfo.Resources[iResourceType].ResourceType == "RESOURCE_OIL" then
		Debug("RESOURCE_OIL","OnGameplayUpdatePlayerResources")
		local tLenseOil = pLocConfig:GetValue("T_CHEAT_RESOURCE_LENSE_OIL")
		if tLenseOil == nil then tLenseOil = {} end
		local iSearchPos = IDToPos(tLenseOil, iPlotID)
		if iSearchPos == false then
			table.insert(tLenseOil,iPlotID)
			PlayerConfigurations[iPlayerID]:SetValue("T_CHEAT_RESOURCE_LENSE_OIL", tLenseOil)
			Debug("OIL CONFIG Updated for iPlayerID "..tostring(iPlayerID), "OnGameplayUpdatePlayerResources")
		end
	
	--aluminum
	elseif GameInfo.Resources[iResourceType].ResourceType == "RESOURCE_ALUMINUM" then
		Debug("RESOURCE_ALUMINUM","OnGameplayUpdatePlayerResources")
		local tLenseAluminum = pLocConfig:GetValue("T_CHEAT_RESOURCE_LENSE_ALUMINUM")
		if tLenseAluminum == nil then tLenseAluminum = {} end
		local iSearchPos = IDToPos(tLenseAluminum, iPlotID)
		if iSearchPos == false then
			table.insert(tLenseAluminum,iPlotID)
			PlayerConfigurations[iPlayerID]:SetValue("T_CHEAT_RESOURCE_LENSE_ALUMINUM", tLenseAluminum)
			Debug("ALUMINUM CONFIG Updated for iPlayerID "..tostring(iPlayerID), "OnGameplayUpdatePlayerResources")
		end
	
	--uranium
	elseif GameInfo.Resources[iResourceType].ResourceType == "RESOURCE_URANIUM" then
		Debug("RESOURCE_URANIUM","OnGameplayUpdatePlayerResources")
		local tLenseUranium = pLocConfig:GetValue("T_CHEAT_RESOURCE_LENSE_URANIUM")
		if tLenseUranium == nil then tLenseUranium = {} end
		local iSearchPos = IDToPos(tLenseUranium, iPlotID)
		if iSearchPos == false then
			table.insert(tLenseUranium,iPlotID)
			PlayerConfigurations[iPlayerID]:SetValue("T_CHEAT_RESOURCE_LENSE_URANIUM", tLenseUranium)
			Debug("URANIUM CONFIG Updated for iPlayerID "..tostring(iPlayerID), "OnGameplayUpdatePlayerResources")
		end
	end
end
-- // ----------------------------------------------------------------------------------------------
-- // Support Functions
-- // ----------------------------------------------------------------------------------------------
function IsTurnProcessing()
	local bReturnVal = true
	if Game.IsNetworkMultiplayer() == false then
		print("Not MP")
		bReturnVal = false
	end
	if Game.IsPlayByCloud() == true then
		print("Is PBC")
		bReturnVal = false
	end
	if GameConfiguration.GetValue("TURN_PHASE_TYPE") ~= DB.MakeHash("TURNPHASE_SIMULTANEOUS") then
		print("Result Hash"..tostring(GameConfiguration.GetValue("TURN_PHASE_TYPE")), "Not Simultaneous")
		bReturnVal = false
	end
	if GameConfiguration.GetValue("TURN_TIMER_TYPE") ~= DB.MakeHash("TURNTIMER_NONE") then
		print("Result Hash"..tostring(GameConfiguration.GetValue("TURN_TIMER_TYPE")), "No Timer")
		bReturnVal = false
	end
	ExposedMembers.SetTurnProcessing(bReturnVal)
	return bReturnVal
end

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
	bTurnProcessing = IsTurnProcessing()
	Game.SetProperty("TURN_PROCESSING", bTurnProcessing)
	--if ( not ExposedMembers.MOD_CheatMenu) then ExposedMembers.MOD_CheatMenu = {}; end
	--set local alive values (probably migrate to bbg script)
	PopulateAliveTable(nLoaded)
	g_nStartTurn = GameConfiguration.GetStartTurn()
	--InitPlayerSelection()
	--update city selection
	--LuaEvents.UIPlayerCityUpdt.Add(OnUIPlayerCityUpdt)
	--GameEvents.GameplayPlayerCityUpdt.Add(OnGameplayPlayerCityUpdt)
	--repopulate alive values (probably migrate to bbg script)
	--LuaEvents.UIPlayerDefeat.Add(OnUIPlayerDefeat)
	--LuaEvents.UIPlayerRevived.Add(OnUIPlayerRevived)
	GameEvents.GameplayPlayerDefeat.Add(OnGameplayPlayerDefeat)
	GameEvents.GameplayPlayerRevived.Add(OnGameplayPlayerRevived)
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
	--LuaEvents.UILocalPlayerTurnBegin.Add(OnUILocalPlayerTurnBegin)
	--turn processing events
	GameEvents.GameplayLocalTurnBegin.Add(OnGameplayLocalTurnBegin)
	GameEvents.GameplaySwitchOnHumanLoaded.Add(OnGameplaySwitchOnHumanLoaded)
	GameEvents.GameplayEndTimer.Add(OnGameplayEndTimer)
	GameEvents.GameplaySetTurnEnd.Add(OnGameplaySetTurnEnd)
	GameEvents.GameplayPlayerTurnDeactivated.Add(OnGameplayPlayerTurnDeactivated)
	--ExposedMembers.MOD_CheatMenu_Initialized = true;
	--Lense support:
	GameEvents.GameplayUpdatePlayerResources.Add(OnGameplayUpdatePlayerResources)

	Debug("Cheat Menu Initialization Finished", "Initialize");
end

Initialize();
