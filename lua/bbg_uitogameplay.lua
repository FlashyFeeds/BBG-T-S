------------------------------------------------------------------------------
--	FILE:	 bbg_uitogameplay.lua
--	AUTHOR:  FlashyFeeds
--	PURPOSE: UI to Gameplay script. Raises synchronized GameEvents from Events
------------------------------------------------------------------------------
--UIEvents = ExposedMembers.LuaEvents
include("bbgts_debug.lua")
print("BBG UI to Gameplay Script (BBGTS) started")
--- Inca Scrits
-- Constants: populating the table of features from which we remove inca bug yields
tRemoveIncaYieldsFromFeatures = {}
if GameConfiguration.GetValue("BBGTS_INCA_WONDERS") then
	local qQuery = "SELECT WonderType FROM WonderTerrainFeature_BBG WHERE TerrainClassType<>'TERRAIN_CLASS_MOUNTAIN' OR TerrainClassType IS NULL"
	tRemoveIncaYieldsFromFeatures=DB.Query(qQuery)
end

--map support enables fast custom lenses and so on
local tMapResources = {}
local tMapWonders = {}

function OnResourceAddedToMap(iX, iY, iResourceID)
	Debug("Called", "OnResourceAddedToMap")
	Debug("iX, iX, iResourceID "..tostring(iX)..", "..tostring(iY)..", "..tostring(iResourceID), "OnResourceAddedToMap")
	local iPlotID = Map.GetPlotIndex(iX, iY)
	if tMapResources[iResourceID] == nil then
		tMapResources[iResourceID] = {}
	end
	table.insert(tMapResources[iResourceID], iPlotID)
	Debug("iResourceID "..tostring(iResourceID).." detected at iPlotID "..tostring(iPlotID),"OnResourceAddedToMap")
end

function OnFeatureAddedToMap(iX, iY, arg)
	Debug("Called", "OnFeatureAddedToMap")
	Debug("iX, iX, arg "..tostring(iX)..", "..tostring(iY)..", "..tostring(arg), "OnResourceAddedToMap")
	local pPlot = Map.GetPlot(iX, iY)
	if pPlot == nil then
		return
	end
	local iFeatureID = pPlot:GetFeatureType()
	if GameInfo.Features[iFeatureID].NaturalWonder then
		local iPlotID = Map.GetPlotIndex(pPlot)
		local tSearchFuns = {}
		tSearchFuns.InitFilter = function(pPlot)
			if pPlot~=nil then
				if pPlot:GetFeatureType() == iFeatureID then
					return true
				end
			else
				return false
			end
		end
		local tComponent = FindConnectedComponent(tSearchFuns, iPlotID)[1]
		if #tComponent>0 then
			Debug("Wonder with index iFeatureID = "..tostring(iFeatureID).." and type "..tostring(GameInfo.Features[iFeatureID].FeatureType).." Has Plots:","OnFeatureAddedToMap")
			tMapWonders[iFeatureID] = tComponent
			print(BuildRecursiveDataString(tComponent))
		end
	end
end

function OnLocalHostMapBroadcast()
	Debug("Called", "OnLocalHostMapBroadcast")
	local iPlayerID = Game.GetLocalPlayer()
	local kParameters = {}
	kParameters = "GameplayHostBroadcastMapElements"
	kParameters["tMapResources"] = tMapResources
	kParameters["tMapWonders"] = tMapWonders
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters)
end

function ExposedMembers.RemoveHostPreloadPopulate()
	Debug("Called", "ExposedMembers.RemoveHostPreloadPopulate")
	Events.ResourceAddedToMap.Remove(OnResourceAddedToMap)
	Events.FeatureAddedToMap.Remove(OnFeatureAddedToMap)
	Events.LocalPlayerTurnBegin.Remove(OnLocalHostMapBroadcast)
	Debug("Events Removed", "ExposedMembers.RemoveHostPreloadPopulate")
end

--for i, row in ipairs(tRemoveIncaYieldsFromFeatures) do
	--print(i, row.WonderType)
--end
--Exp bug
function OnPromotionFixExp(iUnitPlayerID: number, iUnitID : number)
	local kParameters = {}
	kParameters.OnStart = "GameplayPromotionFixExp"
	kParameters["iUnitPlayerID"] = iUnitPlayerID
	kParameters["iUnitID"] = iUnitID
	UI.RequestPlayerOperation(iUnitPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
	--UIEvents.UIPromotionFixExp(iUnitPlayerID, iUnitID)
end

function OnUnitAddedToMap(iPlayerID, iUnitID)
	print("OnUnitAddedToMap called", iPlayerID, iUnitID)
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return print("nil player")
	end
	local pUnit = UnitManager.GetUnit(iPlayerID, iUnitID)
	if pUnit == nil then
		return print("nil unit")
	end
	print(pUnit)
	print("Get Moves Remaining",  pUnit:GetMovesRemaining())
	print("GetMovementMovesRemaining", pUnit:GetMovementMovesRemaining())
	print("GetMaxMoves", pUnit:GetMaxMoves())
	print("IsReadyToMove", pUnit:IsReadyToMove())
	--if pUnit:GetMovesRemaining()>0 then
		--print("has moves => restore if incomplete")
		local kParameters = {}
		kParameters.OnStart = "GameplayMovementBugFix"
		kParameters["iPlayerID"] = iPlayerID
		kParameters["iUnitID"] = iUnitID
		UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
	--end
end

function OnUnitUpgraded(iPlayerID, iUnitID)
	print("OnUnitUpgraded called", iPlayerID, iUnitID)
	local kParameters = {}
	kParameters.OnStart = "GameplayMovementBugFixUpgrade"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iUnitID"] = iUnitID
	local pUnit = UnitManager.GetUnit(iPlayerID, iUnitID)
	print(pUnit:GetMaxMoves())
	kParameters["nBaseMoves"] = pUnit:GetMaxMoves() 
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end
--Inca bug
function OnIncaPlotYieldChanged(iX, iY)
	--print("OnIncaPlotYieldChanged started for", iX, iY)
	local pPlot = Map.GetPlot(iX, iY)
	if pPlot == nil then
		return
	end
	local iOwnerId = pPlot:GetOwner()
	--do nothing if unowned
	if iOwnerId == -1 or iOwnerId == nil then
		--print("No Owner -> Exit")
		return
	end
	local sCivilizationType = PlayerConfigurations[iOwnerId]:GetCivilizationTypeName()
	--do nothing if not inca
	if sCivilizationType ~= "CIVILIZATION_INCA" then
		--print("Not Owned by Inca -> Exit")
		return
	end
	--do nothing if not impassible
	if not pPlot:IsImpassable() then
		return
	end

	local iFeatureId = pPlot:GetFeatureType()
	if iFeatureId ~= -1 then
		--print(GameInfo.Features[iFeatureId].FeatureType)
		if IDToPos(tRemoveIncaYieldsFromFeatures, GameInfo.Features[iFeatureId].FeatureType, "WonderType")==false then
			--print("No Match -> Exit")
			return
		end
		--print(GameInfo.Features[iFeatureId].FeatureType.." feature detected at: ", iX, iY)
		local kParameters = {}
		kParameters.OnStart = "GameplayFixIncaBug"
		kParameters["iOwnerId"] = iOwnerId
		kParameters["iX"] = iX
		kParameters["iY"] = iY
		kParameters.Yields = {}
		for i =0,5 do
			local nControlProp = pPlot:GetProperty(ExtraYieldPropertyDictionary(i))
			if nControlProp == nil then
				kParameters.Yields[i] = pPlot:GetYield(i)
			else
				kParameters.Yields[i] = nControlProp + pPlot:GetYield(i)
			end
			--kParameters.Yields[i] = pPlot:GetYield(i)
		end
		UI.RequestPlayerOperation(iOwnerId, PlayerOperations.EXECUTE_SCRIPT, kParameters);
		--UIEvents.UISetPlotProperty(iOwnerId, kParameters)	
	end
end
--BCY no rng remove disaster yields
function OnBCYPlotYieldChanged(iX, iY)
	local pPlot = Map.GetPlot(iX, iY)
	if pPlot == nil then
		return
	end
	local iOwnerId = pPlot:GetOwner()
	--do nothing if unowned
	if iOwnerId == -1 or iOwnerId == nil then
		return
	end
	local pCity = CityManager.GetCityAt(iX, iY)
	if pCity == nil then
		return
	end
	if CityManager.GetCity(iOwnerId, pCity:GetID()) == nil then
		return
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayBCYAdjustCityYield"
	kParameters["iOwnerId"] = iOwnerId
	kParameters["iX"] = iX
	kParameters["iY"] = iY
	UI.RequestPlayerOperation(iOwnerId, PlayerOperations.EXECUTE_SCRIPT, kParameters);	
	--kParameters.Yields = {}
	--for i =0,5 do
		--local nControlProp = pPlot:GetProperty(ExtraYieldPropertyDictionary(i))
		--if nControlProp == nil then
			--kParameters.Yields[i] = pPlot:GetYield(i) -- food
		--else
			--kParameters.Yields[i] = nControlProp + pPlot:GetYield(i)
		--end
	--end
	--UIEvents.UIBCYAdjustCityYield(iOwnerId, kParameters)
end
--Communism
function OnCityWorkerChanged(iPlayerID, iCityID, iX, iY)
	local pPlayer = Players[iPlayerID]
	--print("OnCityWorkerChanged: Citizen Changed")
	--print("parameters", iPlayerID, iCityID, iX, iY)
	local pPlayerCulture = pPlayer:GetCulture()
	local iGovID = pPlayerCulture:GetCurrentGovernment()
	if iGovID == 8 or pPlayerCulture:IsPolicyActive(105) then
		local kParameters = {}
		kParameters.OnStart = "GameplayBBGWorkersChanged"
		kParameters["iPlayerID"] = iPlayerID
		kParameters["iCityID"] = iCityID
		kParameters["iX"] = iX
		kParameters["iY"] = iY
		UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);	
		--UIEvents.UIBBGWorkersChanged(iPlayerID, iCityID, iX, iY)
	end
end

function OnGovernmentChanged(iPlayerID, iGovID)
	local kParameters = {}
	kParameters.OnStart = "GameplayBBGGovChanged"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iGovID"] = iGovID 
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end
--//-------------------------
-- Communism (build)
--//-------------------------
function OnGovernmentChanged_Build(iPlayerID, iGovID)
	Debug("Called", "OnGameplayBBGGovChanged_Build")
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	local pPlayerCities = pPlayer:GetCities()
	if iGovID == 8 then
		Debug("Communism Gov Adopted => Refresh Dummy Buildings", "OnGameplayBBGGovChanged_Build")
		for i, pCity in pPlayerCities:Members() do
			local iCityID = pCity:GetID()
			GrantCommunismBuildings(iPlayerID, iCityID)
		end
		RefreshCommunismProp(iPlayerID, true)
	elseif pPlayer:GetProperty("HAS_COMMUNISM") then
		Debug("Communism Gov Dropped => Remove Dummy Buildings", "OnGameplayBBGGovChanged_Build")
		for i, pCity in pPlayerCities:Members() do
			local iCityID = pCity:GetID()
			DestroyCommunismBuildings(iPlayerID, iCityID)
		end
		RefreshCommunismProp(iPlayerID, nil)
	end
end

function ExposedMembers.OnPolicyChanged_Build(iPlayerID, iPolicyID, bEnacted)
	Debug("Called", "ExposedMembers.OnPolicyChanged_Build")
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	if iPolicyID == 105 then
		Debug("Communism Legacy Card Status Changed", "OnPolicyChanged_Build")
		local pPlayerCities = pPlayer:GetCities()
		if bEnacted == true then
			Debug("Card In => Refresh Dummy Buildings", "OnPolicyChanged_Build")
			for i, pCity in pPlayerCities:Members() do
				local iCityID = pCity:GetID()
				GrantCommunismBuildings(iPlayerID, iCityID)
			end
			RefreshCommunismProp(pPlayer, true)
		elseif bEnacted == false then
			Debug("Card Out => Remove Dummy Buildings", "OnPolicyChanged_Build")
			for i, pCity in pPlayerCities:Members() do
				DestroyCommunismBuildings(iPlayerID, iCityID)
			end
			RefreshCommunismProp(iPlayerID, nil)
		end
	end
end

function RefreshCommunismProp(iPlayerID, bVal)
	Debug("Called","RefreshCommunismProp")
	local kParameters = {}
	kParameters.OnStart = "OnGameplayRefreshCommunismProp"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["bVal"] = bVal
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

function GrantCommunismBuildings(iPlayerID, iCityID)
	Debug("Called", "GrantCommunismBuildings")
	local pCity = CityManager.GetCity(iPlayerID, iCityID)
	if pCity == nil then
		return
	end
	Debug("iPlayerID, iCityID "..tostring(iPlayerID)..", "..tostring(iCityID), "GrantCommunismBuildings")
	local pCityDistricts = pCity:GetDistricts()
	local tCommModifierIndexes = {}
	for i, pDistrict in pCityDistricts:Members() do
		local iDistrictType = pDistrict:GetType()
		Debug("District with id "..tostring(pDistrict).." and type "..tostring(iDistrictType)..tostring(" Detected"), "GrantCommunismBuildings")
		if (iDistrictType == 1) or (iDistrictType == 17) then
			table.insert(tCommModifierIndexes, 1)
			Debug("Holy Inserted", "GrantCommunismBuildings")
		elseif (iDistrictType == 2) or (iDistrictType == 22) or (iDistrictType == 30) then
			table.insert(tCommModifierIndexes, 2)
			Debug("Campus Inserted", "GrantCommunismBuildings")
		elseif (iDistrictType == 3) or (iDistrictType == 21) or (iDistrictType == 33) then
			table.insert(tCommModifierIndexes, 3)
			Debug("Encampment Inserted", "GrantCommunismBuildings")
		elseif (iDistrictType == 4) or (iDistrictType == 20) or (iDistrictType == 28) then
			table.insert(tCommModifierIndexes, 4)
			Debug("Harbor Inserted", "GrantCommunismBuildings")
		elseif (iDistrictType == 6) or (iDistrictType == 29) then
			table.insert(tCommModifierIndexes, 5)
			Debug("Commercial Inserted", "GrantCommunismBuildings")
		elseif (iDistrictType == 8) or (iDistrictType == 14) then
			table.insert(tCommModifierIndexes, 6)
			Debug("Theater Inserted", "GrantCommunismBuildings")
		elseif (iDistrictType == 9) or (iDistrictType == 16) or (iDistrictType == 32) then
			table.insert(tCommModifierIndexes, 7)
			Debug("Industrial Inserted", "GrantCommunismBuildings")
		end
	end
	if #tCommModifierIndexes ~= 0 and tCommModifierIndexes~= {} then
		Debug("Sending to Gameplay", "GrantCommunismBuildings")
		local kParameters = {}
		kParameters.OnStart = "GameplayAddCommBuildings"
		kParameters["iPlayerID"] = iPlayerID
		kParameters["iCityID"] = iCityID
		kParameters["tCommModifierIndexes"] = tCommModifierIndexes
		UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters)
	end
end

function DestroyCommunismBuildings(iPlayerID, iCityID)
	Debug("Called", "DestroyCommunismBuildings")
	local pCity = CityManager.GetCity(iPlayerID, iCityID)
	if pCity == nil then
		return
	end
	Debug("iPlayerID, iCityID "..tostring(iPlayerID)..", "..tostring(iCityID), "DestroyCommunismBuildings")
	local pCityDistricts = pCity:GetDistricts()
	local tCommModifierIndexes = {}
	for i, pDistrict in pCityDistricts:Members() do
		local iDistrictType = pDistrict:GetType()
		Debug("District with id "..tostring(pDistrict).." and type "..tostring(iDistrictType)..tostring(" Detected"), "DestroyCommunismBuildings")
		if (iDistrictType == 1) or (iDistrictType == 17) then
			table.insert(tCommModifierIndexes, 1)
			Debug("Holy Inserted", "DestroyCommunismBuildings")
		elseif (iDistrictType == 2) or (iDistrictType == 22) or (iDistrictType == 30) then
			table.insert(tCommModifierIndexes, 2)
			Debug("Campus Inserted", "DestroyCommunismBuildings")
		elseif (iDistrictType == 3) or (iDistrictType == 21) or (iDistrictType == 33) then
			table.insert(tCommModifierIndexes, 3)
			Debug("Encampment Inserted", "DestroyCommunismBuildings")
		elseif (iDistrictType == 4) or (iDistrictType == 20) or (iDistrictType == 28) then
			table.insert(tCommModifierIndexes, 4)
			Debug("Harbor Inserted", "DestroyCommunismBuildings")
		elseif (iDistrictType == 6) or (iDistrictType == 29) then
			table.insert(tCommModifierIndexes, 5)
			Debug("Commercial Inserted", "DestroyCommunismBuildings")
		elseif (iDistrictType == 8) or (iDistrictType == 14) then
			table.insert(tCommModifierIndexes, 6)
			Debug("Theater Inserted", "DestroyCommunismBuildings")
		elseif (iDistrictType == 9) or (iDistrictType == 16) or (iDistrictType == 32) then
			table.insert(tCommModifierIndexes, 7)
			Debug("Industrial Inserted", "DestroyCommunismBuildings")
		end
	end
	if #tCommModifierIndexes ~= 0 and tCommModifierIndexes~= {} then
		Debug("Sending to Gameplay", "DestroyCommunismBuildings")
		local kParameters = {}
		kParameters.OnStart = "GameplayRemoveCommBuildings"
		kParameters["iPlayerID"] = iPlayerID
		kParameters["iCityID"] = iCityID
		kParameters["tCommModifierIndexes"] = tCommModifierIndexes
		UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters)
	end
end

function OnDistrictProgressChanged(iPlayerID: number, iDistrictID : number, iCityID: number, iX : number, iY : number, iDistrictType:number, hEra: number, unknown, nPercentComplete:number)
	Debug("Started","OnDistrictProgressChanged")
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	local pPlayerCulture = pPlayer:GetCulture()
	local iGovID = pPlayerCulture:GetCurrentGovernment()
	print("iGovID", iGovID)
	if iGovID ~= 8 and (pPlayerCulture:IsPolicyActive(105) == false) then
		return print("No Trace of Communism => Exit")
	end
	if nPercentComplete < 100 then
		return print("Communism District Incomplete")
	end
	local iCommBuildIndex = -1
	Debug("District with id "..tostring(iDistrictID).." and type "..tostring(iDistrictType)..tostring(" Detected"), "DestroyCommunismBuildings")
	if (iDistrictType == 1) or (iDistrictType == 17) then
		iCommBuildIndex = 1
		Debug("Holy Inserted", "DestroyCommunismBuildings")
	elseif (iDistrictType == 2) or (iDistrictType == 22) or (iDistrictType == 30) then
		iCommBuildIndex = 2
		Debug("Campus Inserted", "DestroyCommunismBuildings")
	elseif (iDistrictType == 3) or (iDistrictType == 21) or (iDistrictType == 33) then
		iCommBuildIndex = 3
		Debug("Encampment Inserted", "DestroyCommunismBuildings")
	elseif (iDistrictType == 4) or (iDistrictType == 20) or (iDistrictType == 28) then
		iCommBuildIndex = 4
		Debug("Harbor Inserted", "DestroyCommunismBuildings")
	elseif (iDistrictType == 6) or (iDistrictType == 29) then
		iCommBuildIndex = 5
		Debug("Commercial Inserted", "DestroyCommunismBuildings")
	elseif (iDistrictType == 8) or (iDistrictType == 14) then
		iCommBuildIndex = 6
		Debug("Theater Inserted", "DestroyCommunismBuildings")
	elseif (iDistrictType == 9) or (iDistrictType == 16) or (iDistrictType == 32) then
		iCommBuildIndex = 7
		Debug("Industrial Inserted", "DestroyCommunismBuildings")
	else
		return print("No Relevant District Detected")
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayCommDistrictComplete"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iCityID"] = iCityID
	kParameters["iCommBuildIndex"] = iCommBuildIndex
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters)
end
--Amani
function OnGovernorAssigned(iCityOwnerID, iCityID, iGovernorOwnerID, iGovernorType)
	print("OnGovernorAssigned")
	print(iCityOwnerID, iCityID, iGovernorOwnerID, iGovernorType)
	if iGovernorType ~= 1 then -- not amani
		return
	end
	local pPlayer = Players[iGovernorOwnerID]
	if pPlayer == nil then
		return
	end
	local pTargetCity = CityManager.GetCity(iCityOwnerID, iCityID)
	if pTargetCity == nil then
		return
	end
	--above all mandatory checks that amani is assigned
	--set player property
	local tAmani = {}
	tAmani["iCityID"] = iCityID
	tAmani["iMinorID"] = iCityOwnerID
	tAmani["Status"] = 0 
	--0: establishing, 1: established, -1 not assigned
	local kParameters = {}
	kParameters.OnStart = "GameplaySetAmaniProperty"
	kParameters["iGovernorOwnerID"] = iGovernorOwnerID
	kParameters["tAmani"] = tAmani
	UI.RequestPlayerOperation(iGovernorOwnerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
	--UIEvents.UISetAmaniProperty(iGovernorOwnerID, tAmani)
end

function OnTradeRouteActivityChanged(iPlayerID, iOriginPlayerID, iOriginCityID, iTargetPlayerID, iTargetCityID)
	print("OnTradeRouteActivityChanged")
	print(iPlayerID, iOriginPlayerID, iOriginCityID, iTargetPlayerID, iTargetCityID)
	local pOriginPlayer = Players[iOriginPlayerID]
	if pOriginPlayer == nil then
		return
	end
	local pTargetPlayer = Players[iTargetPlayerID]
	if pTargetPlayer == nil then
		return
	end
	local pOriginCity = CityManager.GetCity(iOriginPlayerID, iOriginCityID)
	if pOriginCity == nil then
		return
	end
	local pTargetCity = CityManager.GetCity(iTargetPlayerID, iTargetCityID)
	if pTargetCity == nil then
		return
	end
	--above mandatory checks
	if pTargetPlayer:IsMajor() then -- script only works for CS
		return
	end
	--recalculate trade plot properties
	local pCityOutTrade = pOriginCity:GetTrade():GetOutgoingRoutes()
	local bControl = false
	if pCityOutTrade ~= nil then
		for _, route in ipairs(pCityOutTrade) do
			if route.DestinationCityPlayer == iTargetPlayerID then
				bControl = true
			end
		end
	end
	local kParameters = {}
	kParameters.OnStart = "GameplaySetCSTrader"
	kParameters["iOriginPlayerID"] = iOriginPlayerID
	kParameters["iOriginCityID"] = iOriginCityID
	if bControl == true then
		print("Sending Add trader req")
		kParameters["iTargetPlayerID"] = iTargetPlayerID
		UI.RequestPlayerOperation(iOriginPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
		--UIEvents.UISetCSTrader(iOriginPlayerID, iOriginCityID, iTargetPlayerID)
	else
		print("Sending Remove trader req")
		kParameters["iTargetPlayerID"] = 0 - iTargetPlayerID
		UI.RequestPlayerOperation(iOriginPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
		--UIEvents.UISetCSTrader(iOriginPlayerID, iOriginCityID, 0-iTargetPlayerID)
	end
end

function OnGovernorChanged(iGovernorOwnerID, iGovernorID)
	print("OnGovernorChanged")
	print(iGovernorOwnerID, iGovernorID)
	local pPlayer = Players[iGovernorOwnerID]
	if pPlayer==nil then
		return
	end
	if iGovernorID ~= 1 then --not amani
		return
	end
	local tAmani = pPlayer:GetProperty("AMANI")
	if tAmani == nil then
		return
	end
	local pPlayerGovernors = pPlayer:GetGovernors()
	local pPlayerGovernor = GetAppointedGovernor(iGovernorOwnerID, iGovernorID)
	local kParameters = {}
	kParameters.OnStart = "GameplaySetAmaniProperty"
	kParameters["iGovernorOwnerID"] = iGovernorOwnerID
	if pPlayerGovernor:IsEstablished(1) and tAmani~=nil then
		print("Amani Established")
		local pCity = CityManager.GetCity(tAmani.iMinorID, tAmani.iCityID)
		if pPlayerGovernor:GetAssignedCity() == pCity then
			print("amani established -> recalculate amani yields and plot properties")
			tAmani.Status = 1
			kParameters["tAmani"] = tAmani
			UI.RequestPlayerOperation(iGovernorOwnerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
			--UIEvents.UISetAmaniProperty(iPlayerID, tAmani)
		end
	elseif pPlayerGovernor:IsEstablished(1) == false and tAmani.iCityID ~= nil then
		print("amani removed -> recalculate amani yields and plot properties, player properties as well")
		tAmani.Status = -1
		kParameters["tAmani"] = tAmani
		UI.RequestPlayerOperation(iGovernorOwnerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
		--UIEvents.UISetAmaniProperty(iPlayerID, tAmani)
	end
end

function OnUnitGreatPersonCreated(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	--print("Class ID", iGPClassID, "Individual ID", iGPIndividualID)
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() ~= "LEADER_QIN_ALT" then
		return
	end
	--iGPClassID:
	--0 = General
	--1 = Admiral
	--2 = Engineer
	--3 = Merchant
	--4 = Prophet
	--5 = Scientist
	--6 = Writer
	--7 = Artist
	--8 = Musician
	--9 = Comandante
	if iGPClassID ~= 0 then
		return
	end
	if iGPIndividualID == 58 then
		return
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayGPGeneralUnifierCreated"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iUnitID"] = iUnitID
	kParameters["iGPClassID"] = iGPClassID
	kParameters["iGPIndividualID"] = iGPIndividualID
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
	--UIEvents.UIGPGeneralUnifierCreated(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
end

function OnUnitGreatPersonActivatedQinUnifier(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	if iGPClassID ~= 0 then
		return
	end
	local kParameters = {}
	kParameters.OnStart = ""
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iUnitID"] = iUnitID
	kParameters["iGPClassID"] = iGPClassID
	kParameters["iGPIndividualID"] = iGPIndividualID
	--print("Class ID", iGPClassID, "Individual ID", iGPIndividualID)
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() == "LEADER_QIN_ALT" then
		if iGPIndividualID == 176 or iGPIndividualID == 67 or iGPIndividualID == 74 then --timur, sudirman (177 bbg changed him), monash. vijaya
			kParameters.OnStart = "GameplayUnifierSameUnitUniqueEffect"
			UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
			--UIEvents.UIUnifierSameUnitUniqueEffect(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
		elseif iGPIndividualID == 71 then -- zhukov
			kParameters.OnStart = "GameplayUnifierSamePlayerUniqueEffect"
			UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
			--UIEvents.UIUnifierSamePlayerUniqueEffect(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
		end
	end
end

function OnUnitGreatPersonActivatedNotQinUnifier(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	if iGPClassID ~= 0 then
		return
	end
	--print("Track suntzu")
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() ~= "LEADER_QIN_ALT" and iGPIndividualID == 58 then
		local kParameters = {}
		kParameters.OnStart = "GameplayNotUnifierDeleteSunTzu"
		kParameters["iPlayerID"] = iPlayerID
		kParameters["iUnitID"] = iUnitID
		kParameters["iGPClassID"] = iGPClassID
		kParameters["iGPIndividualID"] = iGPIndividualID
		UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
		--UIEvents.UINotUnifierDeleteSunTzu(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
	end
end

function OnUnitMoved(iPlayerID, iUnitID, iX, iY, bVis, bStateChange)
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName()~= 'LEADER_QIN_ALT' then
		return
	end
	local pUnit = UnitManager.GetUnit(iPlayerID, iUnitID)
	if pUnit == nil then
		return
	end
	local pGreatPerson = pUnit:GetGreatPerson()
	local iGPClassID = pGreatPerson:GetClass()
	local iGPIndividualID = pGreatPerson:GetIndividual()
	--print(pGreatPerson, iGPClassID, iGPIndividualID)
	if iGPClassID~=0 and (iGPIndividualID~=176 or iGPIndividualID~=67 or iGPIndividualID~=74) then
		return
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayUnifierTrackRelevantGenerals"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iGPIndividualID"] = iGPIndividualID
	kParameters["iX"] = iX
	kParameters["iY"] = iY
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
	--UIEvents.UIUnifierTrackRelevantGenerals(iPlayerID, iGPIndividualID, iX, iY)
end

--Ludwig
function OnLudwigWonderPlaced(iX, iY, iBuildingID, iPlayerID, iCityID, nPercentComplete, bPillaged)
	print("OnLudwigWonderPlaced: Started")
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName()~="LEADER_LUDWIG" then
		return print("OnLudwigWonderPlaced: Owner not Ludwig => Exit")
	end
	local pCity = CityManager.GetCity(iPlayerID, iCityID)
	if pCity == nil then
		return
	end
	if GameInfo.Buildings[iBuildingID].IsWonder == false then
		return print("OnLudwigWonderPlaced: Not a Wonder")
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayLudwigWonderPlaced"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iBuildingID"] = iBuildingID
	kParameters["iCityID"] = iCityID
	kParameters["iX"] = iX
	kParameters["iY"] = iY
	kParameters["nPercentComplete"] = nPercentComplete
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

function OnLudwigWonderRemoved(iX, iY)
	print("OnWonderRemoved: Started")
	local pPlot = Map.GetPlot(iX, iY)
	if pPlot == nil then
		return
	end
	local iPlayerID = pPlot:GetOwner()
	if iPlayerID == -1 then
		return
	end
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName()~="LEADER_LUDWIG" then
		return print("OnWonderRemoved: Owner not Ludwig => Exit")
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayLudwigWonderRemoved"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iX"] = iX
	kParameters["iY"] = iY
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

function OnLudwigWonderCompleted(iX, iY, iBuildingID, iPlayerID, iCityID, nPercentComplete, unknown)
	print("OnLudwigWonderCompleted: Started")
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName()~="LEADER_LUDWIG" then
		return print("GameplayLudwigWonderCompleted: Owner not Ludwig => Exit")
	end
	local pCity = CityManager.GetCity(iPlayerID, iCityID)
	if pCity == nil then
		return
	end
	if GameInfo.Buildings[iBuildingID].IsWonder == false then
		return print("OnLudwigWonderPlaced: Not a Wonder")
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayLudwigWonderCompleted"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iBuildingID"] = iBuildingID
	kParameters["iCityID"] = iCityID
	kParameters["iX"] = iX
	kParameters["iY"] = iY
	kParameters["nPercentComplete"] = nPercentComplete
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

--Religion (and Mvemba) 5.4
function OnReligionFounded(iPlayerID, iReligionID)
	print("OnReligionFounded: Called")
	local kParameters = {}
	kParameters.OnStart = "GameplayReligionFounded"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iReligionID"] = iReligionID
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

function OnBeliefAdded(iPlayerID, iBeliefID)
	print("OnBeliefAdded: Called")
	local kParameters = {}
	kParameters.OnStart = "GameplayBeliefAdded"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iBeliefID"] = iBeliefID
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

function OnCapitalCityChanged(iPlayerID, iCityID)
	print("OnCapitalCityChanged: Called")
	local pPlayer = Players[iPlayerID]
	if pPlayer==nil then
		return
	end
	local pCity = CityManager.GetCity(iPlayerID, iCityID)
	if pCity == nil then
		return
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayCapitalCityChanged"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iCityID"] = iCityID
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

function OnPlayerDefeat(iPlayerID, iDefeatID, iEventID)
	print("OnPlayerDefeat: Called for iPlayerID", iPlayerID)
	local kParameters = {}
	kParameters.OnStart = "GameplayPlayerDefeat"
	kParameters["iPlayerID"] = iPlayerID
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

function OnMvembaCityReligionChanged(iPlayerID, iCityID, iUnknown1, iUnknown2)
	print("OnMvembaCityReligionChanged: Called")
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() ~= "LEADER_MVEMBA" then
		return
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayMvembaCityReligionChanged"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iCityID"] = iCityID
	kParameters["iUnknown1"] = iUnknown1
	kParameters["iUnknown2"] = iUnknown2
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

function OnMvembaCityAddedToMap(iPlayerID, iCityID, iX, iY)
	print("OnMvembaCityAddedToMap: Called")
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName()~= "LEADER_MVEMBA" then
		return
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayMvembaCityAddedToMap"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iCityID"] = iCityID
	kParameters["iX"] = iX
	kParameters["iY"] = iY
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

function OnMvembaCityRemovedFromMap(iPlayerID, iCityID)
	print("OnMvembaCityRemovedFromMap: Called")
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() ~= "LEADER_MVEMBA" then
		return
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayMvembaCityRemovedFromMap"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iCityID"] = iCityID
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

function OnMvembaCityTransfered(iNewOwnerID, iCityID, iOldOwnerID, nTransferType)
	print("OnMvembaCityRemovedFromMap: Called")
	if PlayerConfigurations[iNewOwnerID]:GetLeaderTypeName() ~= "LEADER_MVEMBA" and PlayerConfigurations[iOldOwnerID]:GetLeaderTypeName() == "LEADER_MVEMBA" then
		return
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayMvembaGiftCity"
	kParameters["iNewOwnerID"] = iNewOwnerID
	kParameters["iOldOwnerID"] = iOldOwnerID
	kParameters["iCityID"] = iCityID
	UI.RequestPlayerOperation(iNewOwnerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

--Support
function GetAppointedGovernor(playerID:number, governorTypeIndex:number)
	-- Make sure we're looking for a valid governor
	if playerID < 0 or governorTypeIndex < 0 then
		return nil;
	end

	-- Get the player governor list
	local pGovernorDef = GameInfo.Governors[governorTypeIndex];
	local pPlayer:table = Players[playerID];
	local pPlayerGovernors:table = pPlayer:GetGovernors();
	local bHasGovernors, tGovernorList = pPlayerGovernors:GetGovernorList();

	-- Find and return the governor from the governor list
	if pPlayerGovernors:HasGovernor(pGovernorDef.Hash) then
		for i,governor in ipairs(tGovernorList) do
			if governor:GetType() == governorTypeIndex then
				return governor;
			end
		end
	end

	-- Return nil if this player has not appointed that governor
	return nil;
end

function IDToPos(List, SearchItem, key, multi)
	--print(SearchItem)
	multi = multi or false
	--print(multi)
	key = key or nil
	--print(key)
	local results = {}
	if List == {} or #List==0 or List==nil then
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

function BuildRecursiveDataString(data: table)
	local str: string = ""
	for k,v in pairs(data) do
		if type(v)=="table" then
			--print("BuildRecursiveDataString: Table Detected")
			local deeper_data = v
			local new_string = BuildRecursiveDataString(deeper_data)
			--print("NewString ="..new_string)
			str = str.."table: "..new_string.."; "
		else
			str = str..tostring(k)..": "..tostring(v).." "
		end
	end
	return str
end

function ReflectDirection(iDirID)
	local tDir = {}
	tDir[0] = 3
	tDir[1] = 4
	tDir[2] = 5
	tDir[3] = 0
	tDir[4] = 1
	tDir[5] = 2
	return tDir[iDirID]
end

function fmod_map(x, base)
	local tmp_x = math.fmod(x,base)
	if tmp_x >= 0 then
		return tmp_x
	else
		return base + tmp_X
	end
end

function Component_Producer(tSearchFuns, iStartPlotID, iDir) --coroutine
	return coroutine.create(
		function()
			--presetup
			iDir = iDir or nil
			local fInitFilter = tSearchFuns.InitFilter --initial filter that is used for itteration
			if fInitFilter == nil then
				return print("FindMapConnectedComponent_Producer: Error: No Initial Filter => Exit")
			elseif type(fInitFilter)~= "function" then
				return print("FindMapConnectedComponent_Producer: Error: Initial Filter is NOT a function => Exit")
			end
			--local tComponent = {}
			--basic functionality
			local pPlot = Map.GetPlotByIndex(iStartPlotID)
			local iX = pPlot:GetX()
			local iY = pPlot:GetY()
			--extended functionality
			local bMarked = false
			local fMarkSpecial = tSearchFuns.Marker -- marker for special points
			if fMarkSpecial ~= nil then 
				bMarked = fMarkSpecial(pPlot)
				send(bMarked) 
			end
			--local tExtra : table
			local fExtra = tSearchFuns.Extra -- extra component generator, based on the marked points
			if iDir ~= nil and (not bMarked) then
				for i, val in ipairs({-1,0,1}) do
					--map Search fInitFilter as a function of fmod_map(iDir + val, 6)
					local iInvDir = fmod_map(iDir + val, 6)
					local pInvPlot = Map.GetAdjacentPlot(iX, iY, iInvDir)
					if fInitFilter(pInvPlot) == true then
						local iInvPlotID = Map.GetPlotIndex(pInvPlot)
						--table.insert(tComponent, iInvPlotID)
						send(iInvPlotID, nil, iInvDir)
					end
				end 
			elseif iDir ~= nil and bMarked then
				for i, val in ipairs({-1,0,1}) do
					--map Search fInitFilter and fExtra as a function of fmod_map(iDir + val, 6)
					local iInvDir = fmod_map(iDir + val, 6)
					local pInvPlot = Map.GetAdjacentPlot(iX, iY, iInvDir)
					local bInitFilter = fInitFilter(pInvPlot)
					local bExtra = fExtra(pInvPlot)
					if bInitFilter and bExtra then
						local iInvPlotID = Map.GetPlotIndex(pInvPlot)
						--table.insert(tComponent, iInvPlotID)
						--table.insert(tExtra, iInvPlotID)
						send(iInvPlotID, iInvPlotID, iInvDir)
					elseif bInitFilter and (not bExtra) then
						local iInvPlotID = Map.GetPlotIndex(pInvPlot)
						--table.insert(tComponent, iInvPlotID)
						send(iInvPlotID, nil, iInvDir)
					elseif (not bInitFilter) and bExtra then
						local iInvPlotID = Map.GetPlotIndex(pInvPlot)
						--table.insert(tExtra, iInvPlotID)
						send(nil, iInvPlotID, nil)
					end
				end
				for i, val in ipairs({2,3,4}) do
					--map search fExtra as a function of fmod_map(iDir + val, 6)
					local iInvDir = fmod_map(iDir + val, 6)
					local pInvPlot = Map.GetAdjacentPlot(iX, iY, iInvDir)
					if fExtra(pInvPlot) then
						local iInvPlotID = Map.GetPlotIndex(pInvPlot)
						--table.insert(tExtra, iInvPlotID)
						send(nil, iInvPlotID, nil)
					end
				end
			else
				for i = 0,5 do
					--map Search fInitFilter
					local iInvDir = fmod_map(iDir + val, 6)
					local pInvPlot = Map.GetAdjacentPlot(iX, iY, iInvDir)
					if fInitFilter(pInvPlot) == true then
						local iInvPlotID = Map.GetPlotIndex(pInvPlot)
						--table.insert(tComponent, iInvPlotID)
						send(iInvPlotID, nil, iInvDir)
					end
				end
			end
		end)
end

function Component_Director(tSearchFuns, iStartPlotID)
	return coroutine.create(
		function()
			--mandatory
			local tGeneration = {}
			local row = {}
			row["iPlotID"] = iStartPlotID
			row["iDir"] = nil
			table.insert(tGeneration, row)
			local bStarted = false
			--optional
			local tMarkedGeneration = {}
			local fMarker = tSearchFuns.Marker
			local tExtraGeneration = {}
			local fExtra = tSearchFuns.Extra
			if fMarker == nil then
				tMarkedGeneration = nil
			elseif fExtra == nil then
				tExtraGeneration = nil
			end
			while (not bStarted) and #tGeneration>0 do
				--mandatory			
				local tNextGeneration = {}
				--optional
				local tNextMarkedGeneration = {}
				local tNextExtraGeneration = {}
				if fMarker == nil then
					tNextMarkedGeneration = nil
				elseif fExtra == nil then
					tNextExtraGeneration = nil
				end

				for i, tEntry in ipairs(tGeneration) do
					local bStatus = true
					local iPlotID = tEntry["iPlotID"]
					local iDir = tEntry["iDir"]
					local coroProd = Component_Producer(tSearchFuns, iPlotID, iDir)
					if tSearchFuns.Marker ~= nil then
						bMarked = receive(coroProd, true)
						if bMarked == true then
							table.insert(tNextMarkedGeneration, iPlotID)
							send(1, iPlotID)
						end
					end
					while bStatus do
						local bNewStatus, iNewPlotID, iNewExtraID, iNewDir = receive(coroProd)
						if bNewStatus then
							if iNewPlotID ~=nil then
								vPos1 = IDToPos(tNextGeneration, iNewPlotID, "iPlotID")
								vPos2 = IDToPos(tGeneration, iNewPlotID, "iPlotID")
								if (vPos1 == false) and (vPos2 == false) then
									local row = {}
									row["iPlotID"] = iNewPlotID
									row["iDir"] = iDir
									table.insert(tNextGeneration, row)
									send(0, iPlotID)
								end
							end
							if iNewExtraID~=nil and tNextExtraGeneration~=nil then
								vPos1 = IDToPos(tNextGeneration, iNewPlotID, "iPlotID")
								vPos2 = IDToPos(tGeneration, iNewPlotID, "iPlotID")
								if (vPos1 == false) and (vPos2 == false) then
									local row = {}
									row["iPlotID"] = iNewExtraID
									row["iDir"] = iDir
									table.insert(tNextExtraGeneration, row)
									send(2, iPlotID)
								end
							end
						end
						bStatus = bNewStatus
					end
				end
				tGeneration = tNextGeneration
				tMarkedGeneration = tNextMarkedGeneration
				tExtraGeneration = tNextExtraGeneration
			end
		end)
end

function FindConnectedComponent(tSearchFuns, iStartPlotID)
	Debug("Started", "FindConnectedComponent")
	local tComponent = {iStartPlotID}
	local tMarked = {}
	local tExtra = {}
	local bStatus = true
	local coroDirector = Component_Director(tSearchFuns, iStartPlotID)
	Debug("Director Coroutine Initialized", "FindConnectedComponent")
	while bStatus do
		local bNewStatus, iMode, iPlotID = receive(coroDirector)
		Debug("Received values from director: bNewStatus = "..tostring(bNewStatus).." , iMode = "..tostring(iMode).." , iPlotID = "..tostring(iPlotID), "FindConnectedComponent")
		if bNewStatus then
			if iMode == 0 then -- write to tComponent
				table.insert(tComponent, iPlotID)
				Debug("Added to tComponent", "FindConnectedComponent")
			elseif iMode == 1 then -- write to tMarked
				table.insert(tMarked, iPlotID)
				Debug("Added to tMarked", "FindConnectedComponent")
			elseif iMode == 2 then -- write to tExtra
				table.insert(tExtra, iPlotID)
				Debug("Added to tExtra", "FindConnectedComponent")
			end
		end
		bStatus = bNewStatus
	end
	if #tMarked == 0 then
		tMarked = nil
	end
	if #tExtra == 0 then
		tExtra = nil
	end
	if tSearchFuns.InitFilter == nil then
		return print("FindConnectedComponent: Error: No Initial Filter => Exit")
	elseif tSearchFuns.Marker == nil then
		return tComponent
	elseif tSearchFuns.Extra == nil then
		return tComponent, tMarked
	end
	return tComponent, tMarked, tExtra
end

function send(...)
	coroutine.yield(...)
end

function receive(prod, bSwitch)
	bSwitch = bSwitch or false
	if not bSwitch then
		return coroutine.resume(prod)
	end 
    return coroutine.resume(prod)[1]
end

--Spy test function--
function OnSpyAdded(iPlayerID, iUnitID)
	Debug("Called", "OnSpyAdded")
	local kParameters = {}
	kParameters.OnStart = "GameplaySpyAdded"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iUnitID"] = iUnitID
	UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, kParameters)
end

function OnSpyMissionCompleted(iPlayerID, iMissionID)
	Debug("Called  "..tostring(iPlayerID), "OnSpyMissionCompleted")
	local tMission:table = nil;
	if iPlayerID ~= Game.GetLocalPlayer() then
		return print("Mission Completed Raised not on Owner")
	end
	local pPlayer:table = Players[iPlayerID];
	if pPlayer then
		local pPlayerDiplomacy:table = pPlayer:GetDiplomacy();
		if pPlayerDiplomacy then
			tMission = pPlayerDiplomacy:GetMission(iPlayerID, iMissionID);
			if tMission == nil then
				UI.DataError("Unable to show misison completed popup for mission ID: " .. tostring(iMissionID));
				return
			end
		end
	end
	local kParameters = {}
	if tMission.InitialResult ~= EspionageResultTypes.CAPTURED and tMission.EscapeResult ~= EspionageResultTypes.CAPTURED then
		return print("Spy not Captured")
	end
	kParameters.Captured = true
	kParameters.OnStart = "GameplaySpyMissionCompleted"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iMissionID"] = iMissionID
	UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, kParameters)
end

function OnSpyRemoved(iSpyPlayerID, iCounterSpyPlayerID)
	Debug("Called", "OnSpyRemoved")
	local kParameters = {}
	kParameters.OnStart = "GameplaySpyRemoved"
	kParameters["iSpyPlayerID"] = iSpyPlayerID
	kParameters["iCounterSpyPlayerID"] = iCounterSpyPlayerID
	UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, kParameters)
end

function OnUnitCaptured(iCurrUnitPlayerID, iUnitID, iOwnerID, iCapturerID)
	Debug("Called", "OnUnitCaptured")
	local kParameters = {}
	kParameters.OnStart = "GameplayUnitCaptured"
	kParameters["iCurrUnitPlayerID"] = iCurrUnitPlayerID
	kParameters["iUnitID"] = iUnitID
	kParameters["iOwnerID"] = iOwnerID
	kParameters["iCapturerID"] = iCapturerID
	UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, kParameters)
end

function OnUnitRemovedFromMap(iPlayerID, iUnitID)
	Debug("Called", "OnUnitRemovedFromMap")
	local kParameters = {}
	kParameters.OnStart = "GameplayUnitRemovedFromMap"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iUnitID"] = iUnitID
	UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, kParameters)
end

function OnUnitAddedToMap(iPlayerID, iUnitID)
	Debug("Called", "OnUnitAddedToMap")
	local kParameters = {}
	kParameters.OnStart = "GameplayUnitAddedToMap"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iUnitID"] = iUnitID
	UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, kParameters)
end
--=========Events=========--

function Initialize()
	--Easy Resource and Nat Wonder Access (will probably have to broadcast from host because all the map stuff should match host)
	--allows to not rely on presence or absence of BBS
	if (Game.GetCurrentGameTurn() == GameConfiguration.GetStartTurn()) then
		local bIsMP = GameConfiguration.IsNetworkMultiplayer()
		local bIsHost = false
		if bIsMP then
			bIsHost = (Game.GetLocalPlayer() == Network.GetGameHostPlayerID())
		end
		if bIsMP == false or bIsHost then 
			--Events.ResourceAddedToMap.Add(OnResourceAddedToMap)
			--Events.FeatureAddedToMap.Add(OnFeatureAddedToMap)
			--Events.LocalPlayerTurnBegin.Add(OnLocalHostMapBroadcast)
		end
	end

	--Exp bug
	if GameConfiguration.GetValue("BBGTS_EXP_FIX") then
		Events.UnitPromoted.Add(OnPromotionFixExp);
	end
	--Movement bugfix
	if GameConfiguration.GetValue("BBGTS_MOVE_FIX") then
		Events.UnitAddedToMap.Add(OnUnitAddedToMap)
		Events.UnitUpgraded.Add(OnUnitUpgraded)
	end
	if GameConfiguration.GetValue("BBGTS_COMMUNISM_MOD") then
		--Communism through modifiers
		Events.CityWorkerChanged.Add(OnCityWorkerChanged)
		Events.GovernmentChanged.Add(OnGovernmentChanged)
		print("Communism (through modifiers) UI hooks added")
	end
	if GameConfiguration.GetValue("BBGTS_COMMUNISM_BUILD") then
		--through internal only buildings (hope for a good display)
		Events.GovernmentChanged.Add(OnGovernmentChanged_Build)
		Events.DistrictBuildProgressChanged.Add(OnDistrictProgressChanged)
		print("Communism (through buildings) UI hooks added")
	end
	--if GameConfiguration.GetValue("BBGTS_AMANI") then
		--Amani
		Events.GovernorAssigned.Add(OnGovernorAssigned)
		Events.GovernorChanged.Add(OnGovernorChanged)
		Events.TradeRouteActivityChanged.Add(OnTradeRouteActivityChanged)
		print("Delete Amani UI hooks added")
	--end
	if GameConfiguration.GetValue("BBGTS_UNIFIER") then
		--delete suntzu after use for non-unifier
		Events.UnitGreatPersonActivated.Add(OnUnitGreatPersonActivatedNotQinUnifier)
		print("Delete Suntzu UI Hook added")
	end
	--5.4 Change Religion Mechanism
	Events.ReligionFounded.Add(OnReligionFounded)
	Events.BeliefAdded.Add(OnBeliefAdded)
	Events.CapitalCityChanged.Add(OnCapitalCityChanged)
	Events.PlayerDefeat.Add(OnPlayerDefeat)

	if GameConfiguration.GetValue("BBGTS_TEST_SPY") then
		Events.SpyAdded.Add(OnSpyAdded) 
		Events.SpyMissionCompleted.Add(OnSpyMissionCompleted)
		Events.SpyRemoved.Add(OnSpyRemoved)
		Events.UnitCaptured.Add(OnUnitCaptured)
		Events.UnitRemovedFromMap.Add(OnUnitRemovedFromMap)
		Events.UnitAddedToMap.Add(OnUnitAddedToMap)
	end
	local tMajorIDs = PlayerManager.GetAliveMajorIDs()
	for i, iPlayerID in ipairs(tMajorIDs) do
		if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() == "LEADER_QIN_ALT" and GameConfiguration.GetValue("BBGTS_UNIFIER") then
			--Qin Unifier
			Events.UnitGreatPersonCreated.Add(OnUnitGreatPersonCreated)
			Events.UnitGreatPersonActivated.Add(OnUnitGreatPersonActivatedQinUnifier)
			Events.UnitMoved.Add(OnUnitMoved)
		elseif PlayerConfigurations[iPlayerID]:GetCivilizationTypeName() == "CIVILIZATION_INCA" and GameConfiguration.GetValue("BBGTS_INCA_WONDERS") then
			--inca dynamic yield cancelation
			Events.PlotYieldChanged.Add(OnIncaPlotYieldChanged)
		elseif PlayerConfigurations[iPlayerID]:GetLeaderTypeName()=="LEADER_LUDWIG" then
			Events.BuildingAddedToMap.Add(OnLudwigWonderPlaced)
			Events.BuildingRemovedFromMap.Add(OnLudwigWonderRemoved)
			Events.WonderCompleted.Add(OnLudwigWonderCompleted)
		elseif PlayerConfigurations[iPlayerID]:GetLeaderTypeName() ~= "LEADER_MVEMBA" then
			Events.CityReligionChanged.Add(OnMvembaCityReligionChanged)
			Events.CityAddedToMap.Add(OnMvembaCityAddedToMap)
			Events.CityRemovedFromMap.Add(OnMvembaCityRemovedFromMap)
			Events.CityTransfered.Add(OnMvembaCityTransfered)
		end
	end
	--BCY no rng setting (param names are still called BBCC)
	if GameConfiguration.GetValue("BBCC_SETTING_YIELD") == 1 then
		print("BCY: No RNG detected")
		Events.PlotYieldChanged.Add(OnBCYPlotYieldChanged)
	end
end

--====Activation====--
Initialize()