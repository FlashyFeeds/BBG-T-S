ExposedMembers.LuaEvents = LuaEvents
include("bbgts_debug.lua")
include("SupportFunctions");
Debug("BBGTS extension of BBG Script loaded", "bbg_script_bbgts.lua")
-- ==========================================================================
-- Setting Up data to easily deal with tile yields (performance/convenience)
-- ==========================================================================
local TerrainYieldsLookup = {}
local ResourceYieldsLookup = {}
local FeatureYieldsLookup = {}
local RelevantBugWonders = {}
local tBaseGuaranteedYields = {}
tBaseGuaranteedYields[0] = 2
tBaseGuaranteedYields[1] = 1 
tBaseGuaranteedYields[2] = 0
tBaseGuaranteedYields[3] = 0
tBaseGuaranteedYields[4] = 0
tBaseGuaranteedYields[5] = 0

function PopulateTerrainYields()
	local tTerrainIDs = {0,1,3,4,6,7,9,10,12,13}
	local tCachedYieldChanges = DB.Query("SELECT * FROM Terrain_YieldChanges")
	for i, index in ipairs(tTerrainIDs) do
		--print("Terrain Index", index)
		local row = {}
		local tOccurrenceIDs = IDToPos(tCachedYieldChanges, GameInfo.Terrains[index].TerrainType, "TerrainType", true)
		if tOccurrenceIDs ~= false then
			for _, jndex in ipairs(tOccurrenceIDs) do
				row[YieldNameToID(tCachedYieldChanges[jndex].YieldType)] = tCachedYieldChanges[jndex].YieldChange
				--print(YieldNameToID(tCachedYieldChanges[jndex].YieldType), tCachedYieldChanges[jndex].YieldChange)
			end
			TerrainYieldsLookup[index] = row
		end
	end
end

function PopulateResourceYields()
	local tCachedResources = DB.Query("SELECT * FROM Resources")
	local tCachedYieldChanges = DB.Query("SELECT * FROM Resource_YieldChanges")
	for index, tResourceData in ipairs(tCachedResources) do
		--print("Ressource Index", index-1)
		if tResourceData.ResourceClassType~="RESOURCECLASS_ARTIFACT" then
			local row = {}
			local tOccurrenceIDs = IDToPos(tCachedYieldChanges, GameInfo.Resources[index-1].ResourceType, "ResourceType", true)
			if tOccurrenceIDs ~= false then
				for _, jndex in ipairs(tOccurrenceIDs) do
					row[YieldNameToID(tCachedYieldChanges[jndex].YieldType)] = tCachedYieldChanges[jndex].YieldChange
					--print(YieldNameToID(tCachedYieldChanges[jndex].YieldType), tCachedYieldChanges[jndex].YieldChange)
				end
				ResourceYieldsLookup[index-1] = row
			end
		end
	end
end

function PopulateFeatureYields()
	local tCachedFeatures = DB.Query("SELECT * FROM Features")
	local tCachedYieldChanges = DB.Query("SELECT * FROM Feature_YieldChanges")
	for index, tFeatureData in ipairs(tCachedFeatures) do
		--print("Ressource Index", index-1)
		if tFeatureData.Settlement==true and tFeatureData.Removable==false then
			local row = {}
			local tOccurrenceIDs = IDToPos(tCachedYieldChanges, GameInfo.Features[index-1].FeatureType, "FeatureType", true)
			if tOccurrenceIDs ~= false then
				for _, jndex in ipairs(tOccurrenceIDs) do
					row[YieldNameToID(tCachedYieldChanges[jndex].YieldType)] = tCachedYieldChanges[jndex].YieldChange
					--print(YieldNameToID(tCachedYieldChanges[jndex].YieldType), tCachedYieldChanges[jndex].YieldChange)
				end
				FeatureYieldsLookup[index-1] = row
			end
		end
	end
end

function PopulateBugWonders()
	local tCachedFeatures = DB.Query("SELECT * FROM Features")
	local tCachedYieldChanges = DB.Query("SELECT * FROM Feature_AdjacentYields")
	--print("Size", #tCachedYieldChanges)
	for index, tFeatureData in ipairs(tCachedFeatures) do
		if tFeatureData.NaturalWonder==true then
			--print("PopulateBugWonders evaluates:", index, GameInfo.Features[index-1].FeatureType)
			local tOccurrenceIDs = IDToPos(tCachedYieldChanges, GameInfo.Features[index-1].FeatureType, "FeatureType", true)
			if tOccurrenceIDs ~= false then
				local bControl = false
				for _, jndex in ipairs(tOccurrenceIDs) do
					if tCachedYieldChanges[jndex].YieldType == "YIELD_FOOD" or tCachedYieldChanges[jndex].YieldType == "YIELD_PRODUCTION" then
						bControl = true
					end
				end
				if bControl then
					RelevantBugWonders[index-1] = true
					--print("Added")
				end
			end
		end
	end
end

-- ===========================================================================
-- UIToGameplay Scripts
-- ===========================================================================
-- Inca
function OnUISetPlotProperty(iPlayerId, tParameters)
	--print("UISetPlotProperty triggered")
	GameEvents.GameplaySetPlotProperty.Call(iPlayerID, tParameters)
end

function OnGameplaySetPlotProperty(iPlayerID, tParameters)
	--print("OnGameplaySetPlotProperty started")
	local pPlot = Map.GetPlot(tParameters.iX, tParameters.iY)
	local tYields = tParameters.Yields
	for i=0, 5 do
		if tYields[i]>0 then
			pPlot:SetProperty(ExtraYieldPropertyDictionary(i), tYields[i])
			--print("Property for "..GameInfo.Yields[i].YieldType.." set to "..tostring(tYields[i]))
		end
	end
end
-- Communism Specialists
function OnUIBBGWorkersChanged(iPlayerID, iCityID, iX, iY)
	--print("UIBBGWorkersChanged Triggered")
	GameEvents.GameplayBBGWorkersChanged.Call(iPlayerID, iCityID, iX, iY)
end

function OnGameplayBBGWorkersChanged(iPlayerID, iCityID, iX, iY)
	--print("BBG - OnGameplayBBGWorkersChanged triggered")
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	pPlayer:SetProperty("HAS_COMMUNISM",true)
	local pCity = CityManager.GetCity(iPlayerID, iCityID)
	if pCity == nil then
		return
	end
	CityRecalculateSpecialistBuildings(pCity)
end

function OnUIBBGDestroyDummyBuildings(iPlayerID, iCityID, iX, iY)
	--print("UIBBGDestroyDummyBuildings Triggered")
	GameEvents.GameplayBBGDestroyDummyBuildings.Call(iPlayerID, iCityID, iX, iY)
end

--LuaEvents.UIBBGDestroyDummyBuildings.Add(OnUIBBGDestroyDummyBuildings)

function OnGameplayBBGDestroyDummyBuildings(iPlayerID, iCityID, iX, iY)
	--print("OnGameplayBBGDestroyDummyBuildings called")
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	pPlayer:SetProperty("HAS_COMMUNISM", false)
	local pCity = CityManager.GetCity(iPlayerID, iCityID)
	if pCity == nil then
		return
	end
	local pCityPlot = Map.GetPlot(iX, iY)
	for i=1,7 do
		local sPropertyStr = "BUILDING_"..WorkerDictionary(i)
		local nDummyVal = pCityPlot:GetProperty(sPropertyStr)
		if nDummyVal ~= nil then
			--print("Dummy With indicies detected", WorkerDictionary(i), nDummyVal)
			pCityPlot:SetProperty(sPropertyStr, nil)
			--print("Should be removed")
		end
	end
	--print("Dummy buildings removed")
end

function OnUIBBGGovChanged(iPlayerID, iGovID)
	--print("OnUIBBGGovChanged triggered")
	GameEvents.GameplayBBGGovChanged.Call(iPlayerID, iGovID)
end
--LuaEvents.UIBBGGovChanged.Add(OnUIBBGGovChanged)

function OnGameplayBBGGovChanged(iPlayerID, iGovID)
	--print("OnGameplayBBGGovChanged called")
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	local pPlayerCities = pPlayer:GetCities()
	if iGovID == 8 then
		for i, pCity in pPlayerCities:Members() do
			local iX = pCity:GetX()
			local iY = pCity:GetY()
			local iCityID = pCity:GetID()
			OnGameplayBBGWorkersChanged(iPlayerID, iCityID, iX, iY)
		end
	elseif pPlayer:GetProperty("HAS_COMMUNISM") then
		for i, pCity in pPlayerCities:Members() do
			local iX = pCity:GetX()
			local iY = pCity:GetY()
			local iCityID = pCity:GetID()
			OnGameplayBBGDestroyDummyBuildings(iPlayerID, iCityID, iX, iY)
		end
	end
end

function OnPolicyChanged(iPlayerID, iPolicyID, bEnacted)
	--print("Policy Changed Check for Communism")
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	if iPolicyID == 105 then
		--print("Communism Legacy Detected")
		local pPlayerCities = pPlayer:GetCities()
		for i, pCity in pPlayerCities:Members() do
			local iCityID = pCity:GetID()
			local iX = pCity:GetX()
			local iY = pCity:GetY()
			if bEnacted == true then
				OnGameplayBBGWorkersChanged(iPlayerID, iCityID, iX, iY)
			elseif bEnacted == false then
				OnGameplayBBGDestroyDummyBuildings(iPlayerID, iCityID, iX, iY)
			end
		end
	end
	--print("Communism Legacy Yields Readjusted")
end

function GetCitySpecialists(pCity: object)
	--print("BBG - fetching specialists")
	if pCity==nil then
		return print("Nil input")
	end
	local tWorkers = {}
	for i = 1,7 do -- setting initial values
 		tWorkers[i] = 0
	end
	local pStartPlot = Map.GetPlot(pCity:GetX(),pCity:GetY())
	for i = 0,35 do
		local pPlot = GetAdjacentTiles(pStartPlot, i)
		if pPlot~=nil then
			if Cities.GetPlotPurchaseCity(pPlot) == pCity then --plot owned by city
				local iDistrictID = pPlot:GetDistrictType()
				--print("District:", iDistrictID)
				if iDistrictID == 1 or iDistrictID == 17 then --holy site/lavra
					--print("HolySite found worker count", pPlot:GetWorkerCount())
					tWorkers[1] = pPlot:GetWorkerCount()
				elseif iDistrictID == 2 or iDistrictID == 22 or iDistrictID == 30 then --campus/seo/observatory
					--print("Campus found worker count", pPlot:GetWorkerCount())
					tWorkers[2] = pPlot:GetWorkerCount()
				elseif iDistrictID == 3 or iDistrictID == 21 or iDistrictID == 33 then -- encampmente/ikkanda/thanh
					--print("Encampment found worker count", pPlot:GetWorkerCount())
					tWorkers[3] = pPlot:GetWorkerCount()
				elseif iDistrictID == 4 or iDistrictID == 20 or iDistrictID == 28 then -- harbor/royal dockyard/cothon
					--print("Harbor found worker count", pPlot:GetWorkerCount())
					tWorkers[4] = pPlot:GetWorkerCount()
				elseif iDistrictID == 6 or iDistrictID == 29 then -- commercial/suguba
					--print("Commercial found worker count", pPlot:GetWorkerCount())
					tWorkers[5] = pPlot:GetWorkerCount()
				elseif iDistrictID == 8 or iDistrictID == 14 then --theater/acropolis
					--print("Theater found worker count", pPlot:GetWorkerCount())
					tWorkers[6] = pPlot:GetWorkerCount()
				elseif iDistrictID == 9 or iDistrictID == 16 or iDistrictID == 32 then -- IZ/Hansa/Opi
					--print("Industrial found worker count", pPlot:GetWorkerCount())
					tWorkers[7] = pPlot:GetWorkerCount()
				end
			end
		end
	end
	return tWorkers
end

function CityRecalculateSpecialistBuildings(pCity: object)
	--print("BBG - recalculating specialist yields")
	if pCity == nil then
		return
	end
	local tWorkers = GetCitySpecialists(pCity)
	--print("Workers:")
	for i = 1,7 do 
		--print(WorkerDictionary(i), tWorkers[i])
	end
	local pCityPlot = Map.GetPlot(pCity:GetX(), pCity:GetY())
	for i=1,7 do
		local nWorkers = tWorkers[i]
		local sPropertyStr = "BUILDING_"..WorkerDictionary(i)
		for j = 1,3 do
			if j<= nWorkers then
				--print("Doesn't have dummy building for j=", j)
				local nDummyVal = pCityPlot:GetProperty(sPropertyStr)
				if nDummyVal == nil then
					pCityPlot:SetProperty(sPropertyStr, j)
					--print("Dummy building added", sPropertyStr, j)
				elseif nDummyVal<=j then
					pCityPlot:SetProperty(sPropertyStr, j)
					--print("Dummy building added", sPropertyStr, j)
				end
			elseif j>nWorkers and pCityPlot:GetProperty(sPropertyStr) == j then
				--print("Dummy With indicies detected", WorkerDictionary(i), j)
				if nWorkers == 0 then
					pCityPlot:SetProperty(sPropertyStr, nil)
					--print("Should be removed, set to nil")
				elseif nWorkers>0 then
					pCityPlot:SetProperty(sPropertyStr, nWorkers)
					--print("Should be removed set to", nWorkers)
				end
			end
		end
	end
end

function WorkerDictionary(index: number)
	local tWorkerDict={"HOLY","CAMP","ENCA","HARB","COMM", "THEA","INDU"}
	return tWorkerDict[index]
end

--Amani
function OnUISetAmaniProperty(iGovernorOwnerID, tAmani)
	--print("OnUISetAmaniProperty called")
	GameEvents.GameplaySetAmaniProperty.Call(iGovernorOwnerID, tAmani)
end

--LuaEvents.UISetAmaniProperty.Add(OnUISetAmaniProperty)

function OnGameplaySetAmaniProperty(iGovernorOwnerID, tAmani)
	--print("OnGameplaySetAmaniProperty called")
	local pPlayer = Players[iGovernorOwnerID]
	if pPlayer == nil then
		return
	end
	pPlayer:SetProperty("AMANI", tAmani)
	Amani_RecalculatePlayer(pPlayer)
end

function OnUISetCSTrader(iOriginPlayerID, iOriginCityID, iTargetPlayerID)
	--print("OnUISetCSTrader called")
	GameEvents.GameplaySetCSTrader.Call(iOriginPlayerID, iOriginCityID, iTargetPlayerID)
end

--LuaEvents.UISetCSTrader.Add(OnUISetCSTrader)

function OnGameplaySetCSTrader(iOriginPlayerID, iOriginCityID, iTargetPlayerID)
	--print("OnGameplaySetCSTrader called")
	local pPlayer = Players[iOriginPlayerID]
	if pPlayer == nil then
		return
	end
	local pCity = CityManager.GetCity(iOriginPlayerID, iOriginCityID)
	if pCity == nil then
		return
	end
	local tCsTraders = pCity:GetProperty("CS_TRADERS")
	if tCsTraders == nil then
		tCsTraders = {}
	end
	--debug control
	--if tCsTraders~= nil or tCsTraders~={} then
		--for i, iMinorIDs in ipairs(tCsTraders) do
			--print(pCity, "trader to", iMinorIDs)
		--end
	--end
	if iTargetPlayerID > 0 then
		--print("Adding CS ID to trader list")
		table.insert(tCsTraders, iTargetPlayerID)
		--debug lines
		--if tCsTraders~= nil or tCsTraders~={} then
			--for i, iMinorIDs in ipairs(tCsTraders) do
				--print(pCity, "trader to", iMinorIDs)
			--end
		--end
	elseif iTargetPlayerID<0 then
		--print("Removing CS ID from trader list", 0-iTargetPlayerID)
		local iRemovePos = IDToPos(tCsTraders, 0-iTargetPlayerID)
		if iRemovePos~=false then
			table.remove(tCsTraders, iRemovePos)
		end
		--debug lines
		--if tCsTraders~= nil or tCsTraders~={} then
			--for i, iMinorIDs in ipairs(tCsTraders) do
				--print(pCity, "trader to", iMinorIDs)
			--end
		--end
	end
	pCity:SetProperty("CS_TRADERS", tCsTraders)
	Amani_RecalculateCity(pPlayer, pCity)
end

function Amani_RecalculateCity(pPlayer, pCity)
	--print("Amani_RecalculateCity called")
	local tAmani = pPlayer:GetProperty("AMANI")
	local tCsTraders = pCity:GetProperty("CS_TRADERS")
	local pPlot = Map.GetPlot(pCity:GetX(), pCity:GetY())
	local bAmaniCS = pPlot:GetProperty("AMANI_ESTABLISHED_CS")
	local bTraderToAmani = pPlot:GetProperty("TRADER_TO_AMANI_CS")
	if tAmani ~= nil then
		--print("Player AMANI Property Detected")
		local iMinorID = tAmani["iMinorID"]
		--print("Amani iMinorID", iMinorID)
		if tAmani.Status == 1 and bAmaniCS == nil then
			pPlot:SetProperty("AMANI_ESTABLISHED_CS", 1) -- assign amani modifier control property
			--print("Amani control Property assigned")
		elseif (tAmani.Status == 0 or tAmani.Status == -1) and bAmaniCS == 1 then
			pPlot:SetProperty("AMANI_ESTABLISHED_CS", nil) -- remove amani modifier control property
			--print("Amani control property removed")
		end
		if tCsTraders ~= nil then
			--print("City CS property Detected")
			local vSearchResult = IDToPos(tCsTraders, iMinorID)
			--debug lines
			if tCsTraders~= nil or tCsTraders~={} then
				for i, iMinorIDs in ipairs(tCsTraders) do
					--print(pCity, "trader to", iMinorIDs)
				end
			end
			--print("Search Result", vSearchResult)
			--print("bTraderToAmani", bTraderToAmani)
			if vSearchResult == false and bTraderToAmani == 1 then
				pPlot:SetProperty("TRADER_TO_AMANI_CS", nil) --remove trader modifier control property
				--print("trader control property removed")
			elseif vSearchResult~=false and bTraderToAmani == nil then
				pPlot:SetProperty("TRADER_TO_AMANI_CS", 1) -- assign trader modifier control property
				--print("trader control property assigned")
			end
		end
	end
end

function Amani_RecalculatePlayer(pPlayer)
	--print("Amani_RecalculatePlayer called")
	local pPlayerCities = pPlayer:GetCities()
	for i, pCity in pPlayerCities:Members() do
		Amani_RecalculateCity(pPlayer, pCity)
	end
end

--Unifier
function OnUIGPGeneralUnifierCreated(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
	--print("OnUIGPGeneralUnifierCreated called")
	GameEvents.GameplayGPGeneralUnifierCreated.Call(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
end

function OnGameplayGPGeneralUnifierCreated(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
	--print("OnGameplayGPGeneralUnifierCreated called")
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	local pUnit = UnitManager.GetUnit(iPlayerID, iUnitID)
	if pUnit == nil then
		return
	end
	--local pUnitAbilities = pUnit:GetAbility()
	--print("Extra charge", pUnitAbilities:GetAbilityCount("ABILITY_QIN_ALT_EXTRA_GENERAL_CHARGE"))
	--pUnitAbilities:ChangeAbilityCount("ABILITY_QIN_ALT_EXTRA_GENERAL_CHARGE", 1)
	--print("Extra charge", pUnitAbilities:GetAbilityCount("ABILITY_QIN_ALT_EXTRA_GENERAL_CHARGE"))

	--local pPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
	--pPlot:SetProperty('NOT_SUNTZU', 1);
	--pPlayer:AttachModifierByID("BBG_LEADER_QIN_ALT_GENERAL_CHARGES")
	--print("Charge added to iUnitID", iUnitID, "for player", iPlayerID, PlayerConfigurations[iPlayerID]:GetLeaderTypeName(), "General", GameInfo.GreatPersonIndividuals[iGPIndividualID].GreatPersonIndividualType)
	--pPlot:SetProperty('NOT_SUNTZU', nil)
	--print("Plot Property Removed")
	if iGPIndividualID == 176 or iGPIndividualID == 74 or iGPIndividualID == 67 then
		local tCoords = {}
		tCoords["iX"] = pUnit:GetX()
		tCoords["iY"] = pUnit:GetY()
		tCoords["Retired"] = false
		local sPropertyStr = "GENERAL_"..tostring(iGPIndividualID).."_COORDS"
		pPlayer:SetProperty(sPropertyStr, tCoords)
	end
end

function OnUINotUnifierDeleteSunTzu(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
	--print("OnUINotUnifierDeleteSunTzu called")
	GameEvents.GameplayNotUnifierDeleteSunTzu.Call(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
end

function OnGameplayNotUnifierDeleteSunTzu(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
	--print("OnGameplayNotUnifierDeleteSunTzu called")
	local pUnit = UnitManager.GetUnit(iPlayerID, iUnitID)
	if pUnit == nil then
		return
	end
	UnitManager.Kill(pUnit)
	--print("SunTzu removed for generic civ")
end

function OnUIUnifierTrackRelevantGenerals(iPlayerID, iGPIndividualID, iX, iY)
	--print("OnUIUnifierTrackRelevantGenerals called")
	GameEvents.GameplayUnifierTrackRelevantGenerals.Call(iPlayerID, iGPIndividualID, iX, iY)
end

function OnGameplayUnifierTrackRelevantGenerals(iPlayerID, iGPIndividualID, iX, iY)
	--print("OnGameplayUnifierTrackRelevantGenerals called")
	--print("iGPIndividualID, iX, iY", iGPIndividualID, iX, iY)
	local pPlayer = Players[iPlayerID]
	local sPropertyStr = "GENERAL_"..tostring(iGPIndividualID).."_COORDS"
	if iX ~=-9999 or iY ~= -9999 then
		local tCoords = {}
		tCoords["iX"] = iX
		tCoords["iY"] = iY
		tCoords["Retired"] = false
		pPlayer:SetProperty(sPropertyStr, tCoords)
	else
		local tCoords = pPlayer:GetProperty(sPropertyStr)
		tCoords["Retired"] = true
		pPlayer:SetProperty(sPropertyStr, tCoords)
	end
end

function OnUIUnifierSameUnitUniqueEffect(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
	--print("OnUIUnifierSameUnitUniqueEffect called")
	GameEvents.GameplayUnifierSameUnitUniqueEffect.Call(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
end

function OnGameplayUnifierSameUnitUniqueEffect(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
	--print("OnGameplayUnifierSameUnitUniqueEffect called")
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	local pUnit = UnitManager.GetUnit(iPlayerID, iUnitID)
	if pUnit == nil then 
		return
	end
	local sPropertyStr = "GENERAL_"..tostring(iGPIndividualID).."_COORDS"
	local tCoords = pPlayer:GetProperty(sPropertyStr)
	local pPlot = Map.GetPlot(tCoords.iX, tCoords.iY)
	for i, pUnit in ipairs(Units.GetUnitsInPlot(pPlot)) do
		if GameInfo.Units[pUnit:GetType()].FormationClass == "FORMATION_CLASS_LAND_COMBAT" then
			local pUnitAbilities = pUnit:GetAbility()
			if iGPIndividualID == 176 then
				if pUnitAbilities:GetAbilityCount("ABILITY_TIMUR_BONUS_EXPERIENCE") == 2 then
					pUnitAbilities:ChangeAbilityCount("ABILITY_TIMUR_BONUS_EXPERIENCE", -1)
					pUnitAbilities:ChangeAbilityCount("ABILITY_TIMUR_BONUS_EXPERIENCE_QIN_ALT", 1)
					--print("Timur extra set")
				end
			elseif iGPIndividualID == 67 then
				if pUnitAbilities:GetAbilityCount("ABILITY_JOHN_MONASH_BONUS_EXPERIENCE") == 2 then
					pUnitAbilities:ChangeAbilityCount("ABILITY_JOHN_MONASH_BONUS_EXPERIENCE", -1)
					pUnitAbilities:ChangeAbilityCount("ABILITY_JOHN_MONASH_BONUS_EXPERIENCE_QIN_ALT", 1)
					--print("Monash extra set")
				end
			elseif iGPIndividualID == 74 then
				if pUnitAbilities:GetAbilityCount("ABILITY_VIJAYA_WIMALARATNE_BONUS_EXPERIENCE") == 2 then
					pUnitAbilities:ChangeAbilityCount("ABILITY_VIJAYA_WIMALARATNE_BONUS_EXPERIENCE", -1)
					pUnitAbilities:ChangeAbilityCount("ABILITY_VIJAYA_WIMALARATNE_BONUS_EXPERIENCE_QIN_ALT", 1)
					--print("Vijaya Extra Set")
				end
			end
		end
	end
	if tCoords["Retired"] == true then
		pPlayer:SetProperty(sPropertyStr, nil)
	end
end

function OnUIUnifierSamePlayerUniqueEffect(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
	--print("OnUIUnifierSamePlayerUniqueEffect called")
	GameEvents.GameplayUnifierSamePlayerUniqueEffect.Call(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
end

function OnGameplayUnifierSamePlayerUniqueEffect(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
	--print("OnGameplayUnifierSamePlayerUniqueEffect called")
	local pPlayer = Players[iPlayerID]
	local nZhukovUsed = pPlayer:GetProperty("ZHUKOV_USED")
	if nZhukovUsed == nil then
		pPlayer:SetProperty("ZHUKOV_USED", 1)
		--print("Zhukov use 1 detected")
	elseif nZhukovUsed == 1 then
		pPlayer:AttachModifierByID("GREATPERSON_GEORGY_ZHUKOV_ACTIVE_QIN_ALT")
		pPlayer:SetProperty("ZHUKOV_USED", nil)
		--print("Zhukov use 2 detected")
	end
end

-- BCY
function OnUIBCYAdjustCityYield(playerID, kParameters)
	--print("BCY script called from UI event")
	GameEvents.GameplayBCYAdjustCityYield.Call(playerID, kParameters)
end

function OnGameplayBCYAdjustCityYield(playerID, kParameters)
	--print("Gameplay Script Called")
	BCY_RecalculateMapYield(kParameters.iX, kParameters.iY)
end

if GameConfiguration.GetValue("BBCC_SETTING_YIELD") == 1 then
	LuaEvents.UIBCYAdjustCityYield.Add(OnUIBCYAdjustCityYield)
end
-- ===========================================================================
--	Tools
-- ===========================================================================
function CalculateBaseYield(pPlot: object)
	local tCalculatedYields = {}
	local iTerrain = pPlot:GetTerrainType()
	local iResource = pPlot:GetResourceType()
	local iFeature = pPlot:GetFeatureType()
	for i =0, 5 do
		tCalculatedYields[i] = GetYield("TERRAIN", iTerrain, i) + GetYield("RESOURCE", iResource, i) + GetYield("FEATURE", iFeature, i)
	end
	return tCalculatedYields
end

function GetYield(sObjecType: string, iObjID: number, iYieldID: number)
	local yield = nil
	if sObjecType == "TERRAIN" then
		if TerrainYieldsLookup[iObjID] == nil then
			yield = nil
		else
			yield = TerrainYieldsLookup[iObjID][iYieldID]
		end
	elseif sObjecType == "RESOURCE" then
		if ResourceYieldsLookup[iObjID] == nil then
			yield = nil
		else 
			yield = ResourceYieldsLookup[iObjID][iYieldID]
		end
	elseif sObjecType == "FEATURE" then
		if FeatureYieldsLookup[iObjID] == nil then
			yield = nil
		else
			yield = FeatureYieldsLookup[iObjID][iYieldID]
		end
	else
		return print("ObjType Error")
	end
	if yield == nil then
		return 0
	else
		return yield
	end
end

function YieldNameToID(name: string)
	local dict = {}
	dict["YIELD_FOOD"] = 0
	dict["YIELD_PRODUCTION"] = 1
	dict["YIELD_GOLD"] = 2
	dict["YIELD_SCIENCE"] = 3
	dict["YIELD_CULTURE"] = 4
	dict["YIELD_FAITH"] = 5
	return dict[name]
end	

function ExtraYieldPropertyDictionary(iYieldId)
	local YieldDict = {}
	YieldDict[0] = "EXTRA_YIELD_FOOD"
	YieldDict[1] = "EXTRA_YIELD_PRODUCTION"
	YieldDict[2] = "EXTRA_YIELD_GOLD"
	YieldDict[5] = "EXTRA_YIELD_FAITH"
	YieldDict[4] = "EXTRA_YIELD_CULTURE"
	YieldDict[3] = "EXTRA_YIELD_SCIENCE"
	return YieldDict[iYieldId]
end

function FiraxisYieldPropertyDictionary(iYieldId)
	local YieldDict = {}
	YieldDict[0] = "FIRAXIS_YIELD_FOOD"
	YieldDict[1] = "FIRAXIS_YIELD_PRODUCTION"
	YieldDict[2] = "FIRAXIS_YIELD_GOLD"
	YieldDict[5] = "FIRAXIS_YIELD_FAITH"
	YieldDict[4] = "FIRAXIS_YIELD_CULTURE"
	YieldDict[3] = "FIRAXIS_YIELD_SCIENCE"
	return YieldDict[iYieldId]
end

function IDToPos(List, SearchItem, key, multi)
	--print(SearchItem)
	multi = multi or false
	--print(multi)
	key = key or nil
	--print(key)
	local results = {}
	if List == {} then
		return false
	end
    if SearchItem==nil then
        return print("Search Error")
    end
    for i, item in ipairs(List) do
    	if key == nil then
    		--print(item)
	        if item == SearchItem then
	        	if multi then
	        		table.insert(results, i)
	        	else
	            	return i;
	            end
	        end
	    else
	    	--print(item[key])
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
    	--print("IDtoPos Results:")
    	for _, item in ipairs(results) do
    		--print(item)
    	end
    	return results
    end
end

function GetAliveMajorTeamIDs()
	--print("GetAliveMajorTeamIDs()")
	local ti = 1;
	local result = {};
	local duplicate_team = {};
	for i,v in ipairs(PlayerManager.GetAliveMajors()) do
		local teamId = v:GetTeam();
		if(duplicate_team[teamId] == nil) then
			duplicate_team[teamId] = true;
			result[ti] = teamId;
			ti = ti + 1;
		end
	end

	return result;
end

function GetShuffledCopyOfTable(incoming_table)
	-- Designed to operate on tables with no gaps. Does not affect original table.
	local len = table.maxn(incoming_table);
	local copy = {};
	local shuffledVersion = {};
	-- Make copy of table.
	for loop = 1, len do
		copy[loop] = incoming_table[loop];
	end
	-- One at a time, choose a random index from Copy to insert in to final table, then remove it from the copy.
	local left_to_do = table.maxn(copy);
	for loop = 1, len do
		local random_index = 1 + TerrainBuilder.GetRandomNumber(left_to_do, "Shuffling table entry - Lua");
		table.insert(shuffledVersion, copy[random_index]);
		table.remove(copy, random_index);
		left_to_do = left_to_do - 1;
	end
	return shuffledVersion
end
--BCY no rng recalculation support
function BCY_RecalculateMapYield(iX, iY)
	--print("BCY: Recalculating for X,Y"..tostring(iX)..","..tostring(iY))
	local pCity = CityManager.GetCityAt(iX,iY)
	--print("Check 0")
	if pCity == nil then
		return
	end
	--print("Check 1")
	if GameConfiguration.GetValue("BBCC_SETTING") == 1 and Players[pCity:GetOwner()]:GetCities():GetCapitalCity()~=pCity then
		return
	end
	--print("BCY no RNG: Yield Recalculation Started")
	local pPlot = Map.GetPlot(iX, iY)
	local iTerrain = pPlot:GetTerrainType()
	local tBasePlotYields = CalculateBaseYield(pPlot)
	local sControllString = ""
	--flats
	if iTerrain==0 or iTerrain==3 or iTerrain==6 or iTerrain==9 or iTerrain==12 then
		sControllString = "Flat_CutOffYieldValues"
	elseif iTerrain==1 or iTerrain==4 or iTerrain==7 or iTerrain==10 or iTerrain==13 then
		sControllString = "Hill_CutOffYieldValues"
	else
		return
	end 
	for i=0,5 do
		--print("Evaluated yield: "..GameInfo.Yields[i].YieldType)
		--print("Base Plot Yield ", tBasePlotYields[i])
		local nYield = 0
		local nFiraxisFullTileYield  = pPlot:GetProperty(FiraxisYieldPropertyDictionary(i))
		local nExtraYield = pPlot:GetProperty(ExtraYieldPropertyDictionary(i))
		if nFiraxisFullTileYield == nil then
			nFiraxisFullTileYield = math.max(pPlot:GetYield(i), tBaseGuaranteedYields[i])
		else
			nFiraxisFullTileYield = math.max(pPlot:GetYield(i), nFiraxisFullTileYield)
		end
		--print("Firaxis yield "..tostring(nFiraxisFullTileYield))
		pPlot:SetProperty(FiraxisYieldPropertyDictionary(i), nFiraxisFullTileYield)
		if nExtraYield == nil then
			nExtraYield = 0
		end
		local nPreWDFiraxisYield = math.max(tBasePlotYields[i], tBaseGuaranteedYields[i])
		--print("Pre Wonder/Disaster Firaxis CC yield"..tostring(nPreWDFiraxisYield))
		local nExtraBCYYield = math.max(GameInfo[sControllString][i].Amount, nPreWDFiraxisYield) - nPreWDFiraxisYield
		--print("Extra BCY yield "..tostring(nExtraBCYYield))
		nYield = nFiraxisFullTileYield-nExtraYield + nExtraBCYYield
		local nYieldDiff = nYield - GameInfo[sControllString][i].Amount
		--print("yield: "..GameInfo.Yields[i].YieldType.." value: "..tostring(nYield).." difference: "..tostring(nYieldDiff))
		if nYieldDiff > 0 then
			pPlot:SetProperty(ExtraYieldPropertyDictionary(i), nYieldDiff + nExtraYield)
			--print("Property set: "..tostring(ExtraYieldPropertyDictionary(i)).." amount: "..tostring(nYieldDiff+nExtraYield))
		end
	end
end

function GetAdjacentTiles(plot, index)
	-- This is an extended version of Firaxis, moving like a clockwise snail on the hexagon grids
	local gridWidth, gridHeight = Map.GetGridSize();
	local count = 0;
	local k = 0;
	local adjacentPlot = nil;
	local adjacentPlot2 = nil;
	local adjacentPlot3 = nil;
	local adjacentPlot4 = nil;
	local adjacentPlot5 = nil;


	-- Return Spawn if index < 0
	if(plot ~= nil and index ~= nil) then
		if (index < 0) then
			return plot;
		end

		else

		__Debug("GetAdjacentTiles: Invalid Arguments");
		return nil;
	end

	

	-- Return Starting City Circle if index between #0 to #5 (like Firaxis' GetAdjacentPlot) 
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
			if (adjacentPlot ~= nil and index == i) then
				return adjacentPlot
			end
		end
	end

	-- Return Inner City Circle if index between #6 to #17

	count = 5;
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot2 = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
		end

		for j = i, i+1 do
			--__Debug(i, j)
			k = j;
			count = count + 1;

			if (k == 6) then
				k = 0;
			end

			if (adjacentPlot2 ~= nil) then
				if(adjacentPlot2:GetX() >= 0 and adjacentPlot2:GetY() < gridHeight) then
					adjacentPlot = Map.GetAdjacentPlot(adjacentPlot2:GetX(), adjacentPlot2:GetY(), k);

					else

					adjacentPlot = nil;
				end
			end
		

			if (adjacentPlot ~=nil) then
				if(index == count) then
					return adjacentPlot
				end
			end

		end
	end

	-- #18 to #35 Outer city circle
	count = 0;
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			else
			adjacentPlot = nil;
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
		end
		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i);
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i);
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 18 + i * 3;
			if(index == count) then
				return adjacentPlot2
			end
		end

		adjacentPlot2 = nil;

		if (adjacentPlot3 ~= nil) then
			if (i + 1) == 6 then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
				end
				else
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i +1);
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 18 + i * 3 + 1;
			if(index == count) then
				return adjacentPlot2
			end
		end

		adjacentPlot2 = nil;

		if (adjacentPlot ~= nil) then
			if (i+1 == 6) then
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
					end
				end
				else
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1);
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 18 + i * 3 + 2;
			if(index == count) then
				return adjacentPlot2;
			end
		end

	end

	--  #35 #59 These tiles are outside the workable radius of the city
	local count = 0
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
			else
			adjacentPlot = nil;
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
		end
		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i);
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i);
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i);
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			terrainType = adjacentPlot2:GetTerrainType();
			if (adjacentPlot2 ~=nil) then
				count = 36 + i * 4;
				if(index == count) then
					return adjacentPlot2;
				end
			end

		end

		if (adjacentPlot3 ~= nil) then
			if (i + 1) == 6 then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
				end
				else
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i +1);
				end
			end
		end

		if (adjacentPlot4 ~= nil) then
			if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
				adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i);
				if (adjacentPlot2 ~= nil) then
					count = 36 + i * 4 + 1;
					if(index == count) then
						return adjacentPlot2;
					end
				end
			end


		end

		adjacentPlot4 = nil;

		if (adjacentPlot ~= nil) then
			if (i+1 == 6) then
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
					end
				end
				else
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1);
					end
				end
			end
		end

		if (adjacentPlot4 ~= nil) then
			if (adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
				adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i);
				if (adjacentPlot2 ~= nil) then
					count = 36 + i * 4 + 2;
					if(index == count) then
						return adjacentPlot2;
					end

				end
			end

		end

		adjacentPlot4 = nil;

		if (adjacentPlot ~= nil) then
			if (i+1 == 6) then
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
					end
				end
				else
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1);
					end
				end
			end
		end

		if (adjacentPlot4 ~= nil) then
			if (adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
				if (i+1 == 6) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0);
					else
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1);
				end
				if (adjacentPlot2 ~= nil) then
					count = 36 + i * 4 + 3;
					if(index == count) then
						return adjacentPlot2;
					end

				end
			end

		end

	end

	--  > #60 to #90

local count = 0
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i); --first ring
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
			adjacentPlot5 = nil;
			else
			adjacentPlot = nil;
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
			adjacentPlot5 = nil;
		end
		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i); --2nd ring
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i); --3rd ring
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i); --4th ring
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i); --5th ring
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5;
			if(index == count) then
				return adjacentPlot2; --5th ring
			end
		end

		adjacentPlot2 = nil;

		if (adjacentPlot5 ~= nil) then
			if (i + 1) == 6 then
				if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), 0);
				end
				else
				if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i +1);
				end
			end
		end


		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 1;
			if(index == count) then
				return adjacentPlot2;
			end

		end

		adjacentPlot2 = nil;

		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i);
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i);
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							if (i+1 == 6) then
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0);
								else
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1);
							end
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									if (i+1 == 6) then
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), 0);
										else
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i+1);
									end
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 2;
			if(index == count) then
				return adjacentPlot2;
			end

		end

		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				if (i+1 == 6) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0); -- 2 ring
					else
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1); -- 2 ring
				end
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					if (i+1 == 6) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0); -- 3ring
						else
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1); -- 3ring

					end
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							if (i+1 == 6) then
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0); --4th ring
								else
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1); --4th ring
							end
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i); --5th ring
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 3;
			if(index == count) then
				return adjacentPlot2;
			end

		end
		
		adjacentPlot2 = nil

		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				if (i+1 == 6) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0); -- 2 ring
					else
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1); -- 2 ring
				end
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					if (i+1 == 6) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0); -- 3ring
						else
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1); -- 3ring

					end
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							if (i+1 == 6) then
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0); --4th ring
								else
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1); --4th ring
							end
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									if (i+1 == 6) then
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), 0); --5th ring
										else
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i+1); --5th ring
									end
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 4;
			if(index == count) then
				return adjacentPlot2;
			end

		end

	end

end



function Initialize()
	--removing bbg hooks
	GameEvents.CityBuilt.Remove(OnCitySettledAdjustYields)
	GameEvents.GameplayBCYAdjustCityYield.Remove(OnGameplayBCYAdjustCityYield)
	PopulateTerrainYields()
	print("BBG - terrain yields populated")
	PopulateResourceYields()
	print("BBG - ressource yields populated")
	PopulateFeatureYields()
	print("BBG - relevant feature yields populated")
	PopulateBugWonders()
	print("BBG - relevant Bug wonders populated")

		-- Extra Movement bugfix
	-- GameEvents.UnitInitialized.Add(OnUnitInitialized)
	print("BBG Movement bugfix hook added (ignored)")
	-- communism
	--GameEvents.GameplayBBGWorkersChanged.Add(OnGameplayBBGWorkersChanged)
	--GameEvents.GameplayBBGDestroyDummyBuildings.Add(OnGameplayBBGDestroyDummyBuildings)
	--GameEvents.PolicyChanged.Add(OnPolicyChanged)
	--GameEvents.GameplayBBGGovChanged.Add(OnGameplayBBGGovChanged)
	print("BBG Communism Hooks Added(Ignored)")
	--Amani
	--GameEvents.GameplaySetAmaniProperty.Add(OnGameplaySetAmaniProperty)
	--GameEvents.GameplaySetCSTrader.Add(OnGameplaySetCSTrader)
	print("BBG Amani Gameplay hooks added (ignored)")
	--Delete Suntzu for not-Unifier
	--LuaEvents.UINotUnifierDeleteSunTzu.Add(OnUINotUnifierDeleteSunTzu)
	--GameEvents.GameplayNotUnifierDeleteSunTzu.Add(OnGameplayNotUnifierDeleteSunTzu)
	print("BBG Suntzu Gameplay Deletion hooks added (ignored)")
	local tMajorIDs = PlayerManager.GetAliveMajorIDs()
	for i, iPlayerID in ipairs(tMajorIDs) do
		if PlayerConfigurations[iPlayerID]:GetLeaderTypeName()=="LEADER_BASIL" then
			--basil spread
			GameEvents.OnCombatOccurred.Add(OnBasilCombatOccurred)
			print("BBG Basil Hook Added")
		elseif PlayerConfigurations[iPlayerID]:GetLeaderTypeName()=="LEADER_GILGAMESH" then
			--gilga pillage
			GameEvents.OnPillage.Add(OnGilgaPillage)
			GameEvents.OnCombatOccurred.Add(OnGilgaCombatOccurred)
			print("BBG Gilga Hooks Added")
		elseif PlayerConfigurations[iPlayerID]:GetCivilizationTypeName() == "CIVILIZATION_INCA" then
			-- Inca Yields on non-mountain impassibles bugfix
			--LuaEvents.UISetPlotProperty.Add(OnUISetPlotProperty)
			--GameEvents.GameplaySetPlotProperty.Add(OnGameplaySetPlotProperty)
			--GameEvents.CityConquered.Add(OnIncaCityConquered)
			print("BBG Inca Hooks Added(Ignored)")
		elseif PlayerConfigurations[iPlayerID]:GetLeaderTypeName()=="LEADER_JULIUS_CAESAR" then
			-- Caesar wildcard
			GameEvents.CityBuilt.Add(OnCityBuilt);
			GameEvents.CityConquered.Add(OnCityConquered)
			print("BBG Caesar Hooks Added")
		elseif PlayerConfigurations[iPlayerID]:GetCivilizationTypeName() == "CIVILIZATION_MACEDON" then
			--Macedon 20%
			--GameEvents.CityConquered.Add(OnMacedonConqueredACity)
			--GameEvents.OnGameTurnStarted.Add(OnGameTurnStartedCheckMacedon)
			--GameEvents.CityBuilt.Add(OnMacedonCitySettled)
			print("BBG Macedon Hooks Added (ignored)")
		elseif PlayerConfigurations[iPlayerID]:GetLeaderTypeName() == "LEADER_QIN_ALT" then
			--Qin Unifier general bugfix
			--LuaEvents.UIGPGeneralUnifierCreated.Add(OnUIGPGeneralUnifierCreated)
			--LuaEvents.UIUnifierTrackRelevantGenerals.Add(OnUIUnifierTrackRelevantGenerals)
			--LuaEvents.UIUnifierSameUnitUniqueEffect.Add(OnUIUnifierSameUnitUniqueEffect)
			--LuaEvents.UIUnifierSamePlayerUniqueEffect.Add(OnUIUnifierSamePlayerUniqueEffect)
			--GameEvents.GameplayGPGeneralUnifierCreated.Add(OnGameplayGPGeneralUnifierCreated)
			--GameEvents.GameplayUnifierSameUnitUniqueEffect.Add(OnGameplayUnifierSameUnitUniqueEffect)
			--GameEvents.GameplayUnifierSamePlayerUniqueEffect.Add(OnGameplayUnifierSamePlayerUniqueEffect)
			--GameEvents.GameplayUnifierTrackRelevantGenerals.Add(OnGameplayUnifierTrackRelevantGenerals)
			print("BBG Unifier Hooks Added(Ignored)")
		end
	end
	if GameConfiguration.GetValue("BBCC_SETTING_YIELD") == 1 then
		GameEvents.GameplayBCYAdjustCityYield.Add(OnGameplayBCYAdjustCityYield)
	end
end

Initialize();