include "MPMAPI_core"

local debugcontext = "GameCoreScripts"
local MP_CHEATS = false
if GameConfiguration.GetValue('BBGTS_MP_CHEATS') == true then
	MP_CHEATS = true
	Debug("MP_CHEATS_FOR_DEBUG_ON: true",debugcontext)
end
print(where(1))
--======================Test Scripts=============------

--===========Research Listeners=================--
--======================Game Turn================--
--GamePlayAction Present
function OnGameTurnStartedTest(playerID)
	local debugcontext = "OnGameTurnStartedTest(S)"
	Debug("Started",debugcontext)
	local currentTurn = Game.GetCurrentGameTurn()
	local startTurn = GameConfiguration.GetStartTurn()
	print(where(1))
	if currentTurn == startTurn and MP_CHEATS then
		local tCheatReceived = {}
		for i =0,60 do
			local pPlayer = Players[i]
			if pPlayer:IsMajor() then
				tCheatReceived[i] = false
			end
		end
		SetObjectState(Game,"CheatReceived",tCheatReceived)
		Debug("Cheat Status Initial State",debugcontext)
	end
end
--=======================Spy and Unit Capture/death=====--------
function OnUnitRetreatedTest(ownerPlayerID, unitID)
	local debugcontext = "OnUnitRetreatedTest(G)"
	Debug("Started",debugcontext)
	local pUnit = UnitManager.GetUnit(ownerPlayerID, unitID)
	if pUnit~=nil then
		local unitTypeName = GameInfo.Units[pUnit:GetType()].UnitType
		Debug("Unit with ID: "..tostring(unitID).." and type: "..tostring(unitTypeName).." Retreated For PlayerID: "..tostring(playerID),debugcontext)
	else
		Debug("Unit with ID: "..tostring(unitID).." Retreated For PlayerID: "..tostring(playerID),debugcontext)
	end
end
----==============City Events========---------
--Gameplay Action Present
function OnCityBuiltTest(playerID, cityID, iX, iY)
	local debugcontext = "OnCityBuiltTest(G)"
	Debug("Started",debugcontext)

	local pCity = CityManager.GetCity(playerID, cityID)
	Debug("City with ID: "..tostring(cityID).." and name: "..tostring(pCity:GetName()).." Added For PlayerID: "..tostring(playerID).." with X,Y:"..tostring(iX)..","..tostring(iY),debugcontext)
	if MP_CHEATS then
		Debug("Giving and Removing Visibility to all from PlayerID: "..tostring(playerID),debugcontext)
		GiveVisibilityToAllMajors(playerID)
		local pLocalPlayer = Players[playerID]
		local tCheatStatus = GetObjectState(Game,"CheatReceived")
		if tCheatStatus~=nil then
			local pCheatStatus = tCheatStatus[playerID] 
			Debug("Global Cheat State Table Received",debugcontext)
		else
			Debug("Error: Instance Built after Player load",debugcontext)
		end
		if pLocalPlayer:IsMajor() and pLocalPlayer:IsHuman() and pCheatStatus ~= true then
			Debug("Starting cheat script",debugcontext)
			OnStartAddStats(pLocalPlayer)
			Debug("Stats Added Success",debugcontext)
			tCheatStatus[playerID] = true
			SetObjectState(Game,"CheatReceived",tCheatStatus)
			Debug("Cheat Status Updated",debugcontext)
		end
	end
end

function OnCityConqueredTest(newPlayerID, oldPlayerID, newCityID, iX, iY)
	local debugcontext = "OnCityConqueredTest(G)"
	Debug("Started",debugcontext)
	local pCity = CityManager.GetCity(newPlayerID, newCityID)
	Debug("City with ID: "..tostring(newCityID).." and name: "..tostring(pCity:GetName()).." Captured by PlayerID: "..tostring(newPlayerID).." from PlayerID: "..tostring(oldPlayerID).." with X,Y:"..tostring(iX)..","..tostring(iY),debugcontext)
end

--=========District==============----

function OnDistrictConstructedTest(playerID, districtID, iX, iY)
	local debugcontext = "OnDistrictConstructedTest(G)"
	Debug("Started",debugcontext)
	Debug("District with ID: "..tostring(districtID).." Constructed by PlayerID: "..tostring(playerID).." at X,y: "..tostring(iX)..","..tostring(iY),debugcontext)
end
-----============================Bulding===============-------------------
function OnBuildingConstructedTest(playerID, cityID, buildingID, plotID, bOriginalConstruction)
	local debugcontext = "OnBuildingConstructedTest(G)"
	Debug("Started",debugcontext)
	local pCity = CityManager.GetCity(playerID, cityID)
	local buildingTypeName = GameInfo.Buildings[buildingID].BuildingType
	Debug("Building Constructed: "..tostring(buildingTypeName).." by PlayerID: "..tostring(playerID).." In City: "..tostring(pCity:GetName()).." with ID: "..tostring(cityID).." at plotID: "..tostring(plotID).." bOriginalConstruction:"..tostring(bOriginalConstruction),debugcontext)
end

function OnBuildingPillageStateChangedTest(playerID, cityID, buildingID, bPillageState)
	local debugcontext = "OnBuildingPillageStateChangedTest(G)"
	Debug("Started",debugcontext)
	local pCity = CityManager.GetCity(playerID, cityID)
	local buildingTypeName = GameInfo.Buildings[buildingID].BuildingType
	Debug("Bulding: "..tostring(buildingTypeName).." In City: "..tostring(pCity:GetName()).." With cityID: "..tostring(cityID).." Owned by PlayerID: "..tostring(playerID).." PillageStatus: "..tostring(bPillageState),debugcontext)
end

-----------================Pillage========================-----------
function OnPillageTest(playerID, unitID, improvementID, buildingID, districtID, plotID)
	local debugcontext = "OnPillageTest(G)"
	Debug("Started",debugcontext)
	local pUnit = UnitManager.GetUnit(playerID,unitID)
	local unitTypeName = GameInfo.Units[pUnit:GetType()].UnitType
	local improvementTypeName : string
	local buildingTypeName: string
	local districtTypeName: string
	if improvementID ~=nil or -1 then
		improvementTypeName = GameInfo.Improvements[improvementID].ImprovementType
		Debug("Player with PlayerID: "..tostring(playerID).." Pillaged with unit: "..tostring(unitTypeName).." unitID: "..tostring(unitID).." Improvement: "..tostring(improvementTypeName).." At PlotID: "..tostring(plotID),debugcontext)
	end
	if buildingID ~= nil or -1 then
		buildingTypeName = GameInfo.Buildings[buildingID].BuildingType
		Debug("Player with PlayerID: "..tostring(playerID).." Pillaged with unit: "..tostring(unitTypeName).." unitID: "..tostring(unitID).." Building: "..tostring(buildingTypeName).." At PlotID: "..tostring(plotID),debugcontext)
	end
	if districtID~=nil or -1 then
		districtTypeName = GameInfo.Districts[districtID].DistrictType
		Debug("Player with PlayerID: "..tostring(playerID).." Pillaged with unit: "..tostring(unitTypeName).." unitID: "..tostring(unitID).." District: "..tostring(districtTypeName).." At PlotID: "..tostring(plotID),debugcontext)
	end
end
---------===============Combat unit Movement===========-----------
function OnCombatOccurredTest(attackerPlayerID, attackerUnitID, defenderPlayerID, defenderUnitID, attackerDistrictID, defenderDistrictID)
	local debugcontext = "OnCombatOccurredTest(G)"
	Debug("Started",debugcontext)
	if attackerUnitID==-1 then
		local pAttDistrict = Game.GetObjectFromComponentID(attackerDistrictID)
		local attackerDistrictType = GameInfo.Districts[pAttDistrict:GetType()].DistrictType
		if defenderUnitID == -1 then
			local pDefDistrict = Game.GetObjectFromComponentID(defenderDistrictID)
			local defenderDistrictType = GameInfo.Districts[pDefDistrict:GetType()].DistrictType
			Debug("attDistrict: "..tostring(attackerDistrictType).." with ID: "..tostring(attackerDistrictID).." of Attacker ID: "..tostring(attackerPlayerID).."Hit defDistrict: "..tostring(defenderDistrictType).." with ID: "..tostring(defenderDistrictID).." of defender ID: "..tostring(defenderPlayerID), debugcontext)
		else
			local pDefUnit = UnitManager.GetUnit(defenderPlayerID, defenderUnitID)
			local pDefUnitType = GameInfo.Units[pDefUnit:GetType()].UnitType
			Debug("attDistrict: "..tostring(attackerDistrictType).." with ID: "..tostring(attackerDistrictID).."Hit Unit: "..tostring(pDefUnitType).."with ID: "..tostring(defenderUnitID).." of defender ID: "..tostring(defenderPlayerID), debugcontext)
		end
	else
		local pAttUnit = UnitManager.GetUnit(attackerPlayerID, attackerUnitID)
		local pAttUnitType = GameInfo.Units[pAttUnit:GetType()].UnitType
		if defenderUnitID == -1 then
			local pDefDistrict = Game.GetObjectFromComponentID(defenderDistrictID)
			local pDefDistrictType = GameInfo.Districts[pDefDistrict:GetType()].DistrictType
			Debug("att Unit: "..tostring(pAttUnitType).." with ID: ".." of Attacker ID: "..tostring(attackerPlayerID).." Hit def District: "..tostring(pDefDistrictType).." with ID: "..tostring(defenderDistrictID).." of Defender ID: "..tostring(defenderPlayerID),debugcontext)
		else
			local pDefUnit = UnitManager.GetUnit(defenderPlayerID, defenderUnitID)
			local pDefUnitType = GameInfo.Units[pDefUnit:GetType()].UnitType
			Debug("att Unit: "..tostring(pAttUnitType).." with ID: ".." of Attacker ID: "..tostring(attackerPlayerID).." Hit def Unit: "..tostring(pDefUnitType).." with ID: "..tostring(defenderUnitID).." of Defender ID: "..tostring(defenderPlayerID),debugcontext)
		end
	end
end
--================================Diplo=========================
function  OnDiploSurpriseDeclareWarTest(playerID1, playerID2)
	local debugcontext = "OnDiploSurpriseDeclareWarTest(G)"
	Debug("Started",debugcontext)
	local pPlayer1 = Players[playerID1]
	local pPlayer1Civ = PlayerConfigurations[playerID1]:GetCivilizationTypeName()
	local p1major = pPlayer1:IsMajor()
	local pPlayer2 = Players[playerID2]
	local pPlayer2Civ = PlayerConfigurations[playerID2]:GetCivilizationTypeName()
	local p2major = pPlayer2:IsMajor()
	Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Declared SurpriseWar(G) On: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
end

function OnPlayerGaveInfluenceTokenTest(majorID, minorID, iAmount)
	local debugcontext = "OnPlayerGaveInfluenceTokenTest(G)"
	Debug("Started",debugcontext)
	local pPlayerMaj = Players[majorID]
	local pPlayerMajCiv = PlayerConfigurations[majorID]:GetCivilizationTypeName()
	local pMajMajor = pPlayerMaj:IsMajor()
	local pPlayerMin = Players[minorID]
	local pPlayerMinCiv = PlayerConfigurations[minorID]:GetCivilizationTypeName()
	local pMinMajor = pPlayerMin:IsMajor()
	Debug(tostring(pPlayerMajCiv).." with ID: "..tostring(majorID).." isMajor: "..tostring(pMajMajor).." Gave "..tostring(iAmount).." Envoys to: "..tostring(pPlayerMinCiv).." with ID: "..tostring(minorID).." isMajor: "..tostring(pMinMajor),debugcontext)
end

function OnCheckFriendAllyTest(playerID1, kParameters)
	local debugcontext = "OnCheckFriendAllyTest(GS)"
	Debug("Started",debugcontext)
	local p1Diplo = Players[playerID1]:GetDiplomacy()
	local playerID2 = kParameters.value
	if p1Diplo:HasDeclaredFriendship(playerID2) then
		Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Diplo Changed Friendship(L) with: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
	elseif p1Diplo:HasAllied(playerID2) then
		Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Diplo Changed Has Allied(L) with: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
	end
end
--===================Religion Events============--------
function OnNewMajorityReligionTest(...)
	local debugcontext = "OnNewMajorityReligionTest(G)"
	Debug("Started",debugcontext)
	vars = {...}
	local str = ""
	if #vars>0 then
		for i,var in ipairs(vars) do
			str = str.."Var "..tostring(i)..": "..tostring(var1).." "
		end
	end
	if str ~= "" or str~=nil then
		Debug(str,debugcontext)
	end
	local playerID = Game.GetLocalPlayer()
	local pPlayer = Players[playerID]
	local playerMajReligionID = pPlayer:GetReligion():GetReligionInMajorityOfCities()
	Debug("Player ID: "..tostring(playerID).." Has New Majority Religion with ID: "..tostring(playerMajReligionID),debugcontext)
end
--========================Government Events================-----
function OnPolicyChangedTest(playerID, policyID, bEnacted)
	local debugcontext = "OnPolicyChangedTest(G)"
	Debug("Started",debugcontext)
	local pPlayer = Players[playerID]
	local playerCiv = PlayerConfigurations[playerID]:GetCivilizationTypeName()
	local policyName = GameInfo.Policies[policyID].PolicyType
	Debug(playerCiv.." with playerID: "..tostring(playerID).." bEnacted: "..tostring(bEnacted).." Policy: "..policyName,debugcontext)
end
--===============Commands and Operations=========----
function OnPlayerCommandSetObjectStateTest(playerID, kParameters)
	local debugcontext = "OnPlayerCommandSetObjectStateTest(G)"
	local str = BuildRecursiveDataString(kParameters)
	Debug("PlayerID: "..tostring(playerID).." SetParameterTable: "..tostring(str),debugcontext)
	--if kParameters.propertyName == "GameID" then
		--Debug("GameID started as "..tostring(playerID).." PlayerID. With GAME_ID: "..tostring(kParameters.value[1]).." starting time",debugcontext)
		--local GAME_ID = GetObjectState(Game,"GameID")
		--if GAME_ID~=nil then
			--print("extra print to confirm:"..tostring(GAME_ID[1]))
		--else
			--print("Weird Bug Investigate")
		--end
	--elseif kParameters.propertyName == "CheatReceived" then
		--Debug("Error: CheatReceived shouldn't trigger here",debugcontext)
	--end
end

--====================Gameplay Cheats============--
function OnStartAddStats(pPlayer)
	local debugcontext = "OnStartAddStats(G/S)"
	Debug('Started', debugcontext)
	--MP cheats for testing
	local pTreasury = pPlayer:GetTreasury()
	--start with 1kk gold 1kk faith 42 gov titles and 10k favour 100 envoys
	pTreasury:ChangeGoldBalance(1000000)
	Debug('Gold Added', debugcontext)
	local pReligion = pPlayer:GetReligion()
    pReligion:ChangeFaithBalance(1000000)
    Debug("Faith Added", debugcontext)
    pPlayer:GetGovernors():ChangeGovernorPoints(42);
    Debug("Governor Titles Added",debugcontext)
    if pPlayer:GetDiplomacy().ChangeFavor ~= nil then
		pPlayer:GetDiplomacy():ChangeFavor(10000);
	end
	local pEnvoy = pPlayer:GetInfluence()
    pEnvoy:ChangeTokensToGive(100)
    Debug("Envoys Added", debugcontext)
	--Set free granted techs (database index -1)
	--flight, advanced flight, stealth, construction for terractota
	local freetechs = {17, 43, 50}
	for i, index in ipairs(freetechs) do
		local pTechs = pPlayer:GetTechs()
		pTechs:SetResearchProgress(index, pTechs:GetResearchCost(index))
	end
	Debug("Techs Added", debugcontext)
	--Set free granted civics (database index - 1)
	--diplo service, political and monarchy for t2 gov building to put in cards for faster missions
	local freeculture = {0,8,20,23}
	for i, index in ipairs(freeculture) do
		local pCulture = pPlayer:GetCulture()
		Debug("CultureReceived",debugcontext)
		pCulture:SetCulturalProgress(index, pCulture:GetCultureCost(index))
	end
	Debug("Civics Added",debugcontext)
	--Attach +20 spy capacity modifier
	pPlayer:AttachModifierByID('BBG_TEST_GIVE_20_SPY_CAPACITY')
	Debug("Spy Capacity Increased", debugcontext)
end

function GiveVisibilityToAllMajors(playerID)
	local debugcontext = "GiveVisibilityToAllMajors(G/S)"
	Debug("Started",debugcontext)
	local pVis = PlayersVisibility[playerID]
	Debug("visibility table retrieved for PlayerID:"..tostring(playerID),debugcontext)
	for i=0,60 do
		local nPlayer = Players[i]
		if nPlayer:IsMajor() and i ~= playerID then
			Debug("Major Player with ID: "..tostring(i).." Detected",debugcontext)
			pVis:AddOutgoingVisibility(i)
			pVis:RemoveOutgoingVisibility(i)
			Debug("Visibility Added and Removed for PlayerID: "..tostring(i),debugcontext)
		end
	end
end

function Initialize()
	local debugcontext = "Start(G)"
	Debug("GameCoreScripts - Launched",debugcontext)
	Debug("Adding Listener Events",debugcontext)
	--=============Game Turn========--
	GameEvents.OnGameTurnStarted.Add(OnGameTurnStartedTest) --Has GamePlayAction
	--=============Spy Functions============-----------
	GameEvents.OnUnitRetreated.Add(OnUnitRetreatedTest)
	--=============City Events Functions=============----------
	GameEvents.CityBuilt.Add(OnCityBuiltTest)  --Has GamePlayAction
	GameEvents.CityConquered.Add(OnCityConqueredTest)
	--=============District Events===========-----------
	GameEvents.OnDistrictConstructed.Add(OnDistrictConstructedTest)
	--=============Building Events================--
	GameEvents.BuildingConstructed.Add(OnBuildingConstructedTest)
	GameEvents.BuildingPillageStateChanged.Add(OnBuildingPillageStateChangedTest)
	--=============General Pillage Event==========--
	GameEvents.OnPillage.Add(OnPillageTest)
	--=============Combat Events=============--
	GameEvents.OnCombatOccurred.Add(OnCombatOccurredTest)
	--=============Diplomacy Events==========--
	GameEvents.DiploSurpriseDeclareWar.Add(OnDiploSurpriseDeclareWarTest)
	GameEvents.CheckFriendAlly.Add(OnCheckFriendAllyTest)
	GameEvents.OnPlayerGaveInfluenceToken.Add(OnPlayerGaveInfluenceTokenTest)
	--============Religion==========--
	GameEvents.OnNewMajorityReligion.Add(OnNewMajorityReligionTest)
	--============Government==========--
	GameEvents.PolicyChanged.Add(OnPolicyChangedTest)
	--============Operations and commands======--
	GameEvents.OnPlayerCommandSetObjectState.Add(OnPlayerCommandSetObjectStateTest)

end

Initialize();

