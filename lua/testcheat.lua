include "Debug"
local debugcontext = "testcheat"
local MP_CHEATS = false
if GameConfiguration.GetValue('BBGTS_MP_CHEATS') == 1 then
	MP_CHEATS = true
end
Debug(tostring(GameConfiguration.GetValue('BBGTS_MP_CHEATS')),debugcontext)
Debug(tostring(GameConfiguration.GetValue('BBGTS_MP_CHEATS')),debugcontext)
Debug("BBGTS_DEBUG_LUA = "..tostring(MP_CHEATS), debugcontext)

--======================Test Scripts=============------
--======================Game Turn================--
function OnGameTurnStartedTest(playerID)
	debugcontext = "OnGameTurnStartedTest(G)"
	Debug("Started",debugcontext)
	local GAME_ID = Game:GetProperty("GameID")
	if GAME_ID~=nil then
		Debug("GAME_ID detected. GAME_ID = "..tostring(GAME_ID),debugcontext)
		Debug("Turn Started for PlayerID: "..tostring(playerID))
	end
end

--=======================Spy and Unit Capture/death=====--------
function OnUnitCaptureTest(currentUnitOwner, unitID, owningPlayer, capturingPlayer)
	local debugcontext = "OnUnitCaptureTest(L)"
	Debug("Started",debugcontext)
	local u1 = UnitManager.GetUnit(currentUnitOwner, unitID);
	local u2= UnitManager.GetUnit(owningPlayer, unitID);
	local u3= UnitManager.GetUnit(capturingPlayer, unitID)
	Debug('id1: '..tostring(u1)..' id2: '..tostring(u2)..' id3:'..tostring(u3),debugcontext);
	Debug('currentUnitOwner:'..tostring(currentUnitOwner)..' unitID: '..tostring(unitID)..' owningPlayer: '..tostring(owningPlayer)..' capturingPlayer: '..tostring(capturingPlayer),debugcontext)
	if u1~=nil then
		Debug('u1 was: '..tostring(GameInfo.Units[u1:GetType()].UnitType),debugcontext)
	end
	if u2~=nil then
		Debug('u2 was: '..tostring(GameInfo.Units[u2:GetType()].UnitType),debugcontext)
	end
	if u3~=nil then
		Debug('u3 was: '..tostring(GameInfo.Units[u3:GetType()].UnitType),debugcontext)
	end
	for i = 0, 64 do
		local unit = UnitManager.GetUnit(i, unitID)
		if unit ~= nil then
			Debug('Real Owner ID:'..tostring(i),debugcontext)
			Debug('unit was: '..tostring(GameInfo.Units[unit:GetType()].UnitType),debugcontext)
			Debug(tostring(GameInfo.Units[unit:GetType()].UnitType).." is not deleted",debugcontext)
			return
		end	
	end
	Debug("Unit was Deleted?")
	local playerId = Game.GetLocalPlayer()
	local pPlayer = Players[playerID]
	local pDiplo = pPlayer:GetDiplomacy()
	local numCapturedSpies:number = playerDiplomacy:GetNumSpiesCaptured()
	if #numCapturedSpies>0 then
		local lastCapturedSpyID = pDiplo:GetNthCapturedSpy(owningPlayer, numCapturedSpies-1)
		Debug("Last Captured Spy ID: "..tostring(lastCapturedSpyID),debugcontext)
	end
end

function OnSpyRemoveTest(spyOwner, counterspyPlayer)
	local debugcontext = "OnSpyRemoveTest(L)"
	Debug('Started', debugcontext)
	Debug('spyOwner: '..tostring(spyOwner)..' counterspyPlayer: '..tostring(counterspyPlayer),debugcontext)
	--local u1 = UnitManager.GetUnit(currentUnitOwner, unitID);
	--if u1~=nil then
		--print('u1 was', GameInfo.Units[u1:GetUnitType()].UnitType)
	--end
end

function OnSpyAddedTest(spyOwner, spyUnitID)
	local debugcontext = "OnSpyAddedTest(L)"
	Debug('Started', debugcontext)
	Debug('spyOwner: '..tostring(spyOwner)..' spyUnitID: '..tostring(spyUnitID),debugcontext)
	local u1 = UnitManager.GetUnit(spyOwner, spyUnitID);
	if u1==nil then
		return
	end
	Debug('u1 is: '..tostring(GameInfo.Units[u1:GetType()].UnitType),debugcontext)
	return
end

function OnUnitKilledTest(currentUnitOwner, unitID)
	local debugcontext = "OnUnitKilledTest(L)"
	Debug('Started', debugcontext)
	Debug('currentUnitOwner: '..tostring(currentUnitOwner)..' unitID: '..tostring(unitID),debugcontext)
	local unit = UnitManager.GetUnit(currentUnitOwner, unitID);
	if unit==nil then
		return
	end
	local type = GameInfo.Units[unit:GetType()].UnitType
	Debug('u1 was:'..tostring(type),debugcontext)
	return
end

function OnUnitAddedToMapTest(playerID, unitID)
	local debugcontext = "OnUnitAddedToMapTest(L)"
	Debug("Started",debugcontext)
	local pUnit = UnitManager.GetUnit(playerID, unitID)
	Debug("Unit with ID: "..tostring(unitID).." and type: "..tostring(GameInfo.Units[pUnit:GetType()].UnitType).." Added For PlayerID: "..tostring(playerID),debugcontext)
end

function OnUnitRetreatedTest(ownerPlayerID, unitID)
	local debugcontext = "OnUnitRetreatedTest(G)"
	Debug("Started",debugcontext)
	local pUnit = UnitManager.GetUnit(ownerPlayerID, unitID)
	Debug("Unit with ID:"..tostring(unitID).." and type: "..tostring(GameInfo.Units[pUnit:GetType()].UnitType).." Added For PlayerID: "..tostring(ownerPlayerID),debugcontext)
end
----==============City Events========---------
function OnCityBuiltTest(playerID, cityID, iX, iY)
	local debugcontext = "OnCityBuiltTest(G)"
	Debug("Started",debugcontext)

	local pCity = CityManager.GetCity(playerID, cityID)
	Debug("City with ID:"..tostring(cityID).." and name: "..tostring(pCity:GetName()).." Added For PlayerID: "..tostring(playerID).." with X,Y:"..tostring(iX)..","..tostring(iY),debugcontext)
	if MP_CHEATS then
		Debug("Giving and Removing Visibility to all from PlayerID: "..tostring(playerID),debugcontext)
		GiveVisibilityToAllMajors(playerID)
	end
end

function OnCityConqueredTest(newPlayerID, oldPlayerID, newCityID, iX, iY)
	local debugcontext = "OnCityConqueredTest(G)"
	Debug("Started",debugcontext)
	local pCity = CityManager.GetCity(newPlayerID, newCityID)
	Debug("City with ID:"..tostring(newCityID).." and name: "..tostring(pCity:GetName()).." Captured by PlayerID: "..tostring(newPlayerID).." from PlayerID: "..tostring(oldPlayerID).." with X,Y:"..tostring(iX)..","..tostring(iY),debugcontext)
end

function OnCityLiberatedTest(playerID, cityID)
	debugcontext = "OnCityLiberatedTest(L)"
	Debug("Started")
	Debug("playerID: "..tostring(playerID).." Liberated cityID: "..tostring(cityID))
end

function OnCityRemovedFromMapTest(playerID, cityID)
	local debugcontext = "OnCityRemovedFromMapTest(L)"
	Debug("Started",debugcontext)
	local pCity = CityManager.GetCity(playerID, cityID)
	Debug("City with ID:"..tostring(cityID).." and name: "..tostring(pCity:GetName()).." Razed by PlayerID: "..tostring(playerID),debugcontext)
end
----===========District Events=====---------
function OnDistrictAddedToMapTest(playerID, districtID, cityID, iX, iY, districtType, percentComplete)
	local debugcontext = "OnDistrictAddedToMapTest(L)"
	Debug("Started",debugcontext)
	local districtTypeName = GameInfo.Districts[districtType].DistrictType
	local pCity = CityManager.GetCity(playerID, cityID)
	Debug("District "..tostring(districtTypeName).."With ID: "..tostring(districtID).." Placed by PlayerID: "..tostring(playerID).." In City "..tostring(pCity:GetName()).." with ID: "..tostring(cityID).." at X,Y: "..tostring(iX)..","..tostring(iY).." %: "..tostring(percentComplete),debugcontext)
end

function OnDistrictPillagedTest(playerID, districtID, cityID, iX, iY, districtType, percentComplete, isPillaged)
	local debugcontext = "OnDistrictPillagedTest(L)"
	Debug("Started",debugcontext)
	local districtTypeName = GameInfo.Districts[districtType].DistrictType
	Debug("District "..tostring(districtTypeName).."With ID: "..tostring(districtID).." Placed by PlayerID: "..tostring(playerID).." In City "..tostring(pCity:GetName()).." with ID: "..tostring(cityID).." at X,Y: "..tostring(iX)..","..tostring(iY).." %: "..tostring(percentComplete).." isPillaged: "..tostring(isPillaged),debugcontext)
end

function OnDistrictRemovedFromMapTest(playerID, districtID)
	local debugcontext = "OnDistrictRemovedFromMapTest(L)"
	Debug("Started",debugcontext)
	Debug("Removed District with ID: "..tostring(districtID).." For playerID:"..tostring(playerID),debugcontext)
end

function OnDistrictBuildProgressChangedTest(playerID, districtID, cityID, iX, iY, districtType, era, civilization, percentComplete, iAppeal, isPillaged)
	local debugcontext = "OnDistrictBuildProgressChangedTest(L)"
	Debug("Started", debugcontext)
	local districtTypeName = GameInfo.Districts[districtType].DistrictType
	Debug("District "..tostring(districtTypeName).."With ID: "..tostring(districtID).." Placed by PlayerID: "..tostring(playerID).." In City "..tostring(pCity:GetName()).." with ID: "..tostring(cityID).." at X,Y: "..tostring(iX)..","..tostring(iY).." %: "..tostring(percentComplete).." isPillaged: "..tostring(isPillaged).." Appeal: "..tostring(iAppeal).." Era: "..tostring(era).." Civ: "..tostring(civilization),debugcontext)
end

function OnDistrictConstructedTest(playerID, districtID, iX, iY)
	local debugcontext = "OnDistrictConstructedTest(G)"
	Debug("Started",debugcontext)
	Debug("District with ID: "..tostring(districtID).." Constructed by PlayerID: "..tostring(playerID).." at X,y: "..tostring(iX)..","..tostring(iY),debugcontext)
end
-----============================Bulding===============-------------------
function OnBuildingAddedToMapTest(iX, iY, buildingID, playerID, misc2, misc3)
	local debugcontext = "OnBuildingAddedToMapTest(L)"
	Debug("Started",debugcontext)
	local buildingTypeName = GameInfo.Buildings[buildingID].BuildingType
	Debug("Added Building: "..tostring(buildingTypeName).." by PlayerID: "..tostring(playerID).." at X,Y: "..tostring(iX)..","..tostring(iY).." misc2: "..tostring(misc2).." misc3: "..tostring(misc3),debugcontext)
end

function OnBuildingChangedTest(iX,iY, buildingID, playerID, iPercentComplete, iUnknown)
	local debugcontext = "OnBuildingChangedTest(L)"
	Debug("Started",debugcontext)
	local buildingTypeName = GameInfo.Buildings[buildingID].BuildingType
	Debug("Added Building: "..tostring(buildingTypeName).." by PlayerID: "..tostring(playerID).." at X,Y: "..tostring(iX)..","..tostring(iY).." iPercentComplete: "..tostring(iPercentComplete).." iUnknown: "..tostring(iUnknown),debugcontext)
end

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
--==========================City Events============-----------
function OnCityProductionChangedTest(playerID, cityID, productionID, objectID, bCancelled)
	local debugcontext = "OnCityProductionChangedTest(L)"
	Debug("Started",debugcontext)
	Debug("playerID: "..tostring(playerID).." cityID: "..tostring(cityID).." productionID: "..tostring(productionID).." objectID: "..tostring(objectID).." bCancelled: "..tostring(bCancelled),debugcontext)
end

function OnCityProductionCompletedTest(playerID, cityID, productionID, objectID, bCancelled)
	local debugcontext = "OnCityProductionCompletedTest(L)"
	Debug("Started",debugcontext)
	Debug("playerID: "..tostring(playerID).." cityID: "..tostring(cityID).." productionID: "..tostring(productionID).." objectID: "..tostring(objectID).." bCancelled: "..tostring(bCancelled),debugcontext)
end

function OnCityProjectCompletedTest(playerID, cityID, projectID, buildingID, iX, iY, bCancelled)
	local debugcontext = "OnCityProjectCompletedTest(L)"
	Debug("Started", debugcontext)
	local pCity = CityManager.GetCity(playerID, cityID)
	local pX = pCity:GetX()
	local pY = pCity:GetY()
	local cityName = pCity:GetName()
	local pPlayer = Players[playerID]
	local playerCiv = pPlayer:GetCivilizationTypeName()
	local projectName = GameInfo.Projects[projectID].ProjectType
	local buildingTypeName = GameInfo.Buildings[buildingID].BuildingType
	Debug(cityName.." with ID: "..tostring(cityID).." Owned by: "..playerCiv.." with ID: "..tostring(playerID).." located at iX,iY,pX,pY: "..tostring(iX)..","..tostring(iY)..","..tostring(pX)..","..tostring(pY).." completed Project: "..projectName.." in the Building: "..buildingTypeName,debugcontext)
end

function OnCityMadePurchaseTest(playerID, cityID, iX, iY, purchaseType, objectType)
	debugcontext = "OnCityMadePurchaseTest(L)"
	Debug("Started", debugcontext)
	local pCity = CityManager.GetCity(playerID, cityID)
	local pX = pCity:GetX()
	local pY = pCity:GetY()
	local cityName = pCity:GetName()
	local pPlayer = Players[playerID]
	local playerCiv = pPlayer:GetCivilizationTypeName()
	Debug(cityName.." with ID: "..tostring(cityID).." Owned by: "..playerCiv.." with ID: "..tostring(playerID).." located at pX,pY: "..tostring(pX)..","..tostring(pY).." Made Purchase of Type: "..tostring(purchaseType).." and objectType: "..tostring(objectType).." at iX,iY: "..tostring(iX)..","..tostring(iY),debugcontext)
end
--====================Improvement Events================------------
function OnImprovementActivatedTest(iX,iY,unitID,playerID,improvementType, improvementID,activationType)
	debugcontext = "OnImprovementActivatedTest(L)"
	Debug("Started",debugcontext)
	local improvementName = GameInfo.Improvements[improvementType].ImprovementType
	local pUnit = UnitManager.GetUnit(playerID,unitID)
	local unitTypeName = GameInfo.Units[pUnit:GetType()].UnitType
	Debug(improvementName.." with ID: "..tostring(improvementID).." was built by: "..unitTypeName.." with ID: "..tostring(unitID).." by PlayerID: "..tostring(playerID).." at X,Y: "..tostring(iX)..","..tostring(iY).." activationType: "..tostring(activationType),debugcontext)
end

function OnImprovementAddedToMapTest(iX,iY,improvementType,playerID,resource, isPillaged,isWorked)
	debugcontext = "OnImprovementAddedToMapTest(L)"
	Debug("Started",debugcontext)
	local improvementName = GameInfo.Improvements[improvementType].ImprovementType
	Debug(improvementName.." by PlayerID: "..tostring(playerID).." at X,Y: "..tostring(iX)..","..tostring(iY).." resource: "..tostring(resource).." isPillaged: "..tostring(isPillaged).." isWorked: "..tostring(isWorked),debugcontext)
end

function OnImprovementChangedTest(iX,iY,improvementType,playerID,resource, isPillaged,isWorked)
	debugcontext = "OnImprovementChangedTest(L)"
	Debug("Started",debugcontext)
	local improvementName = GameInfo.Improvements[improvementType].ImprovementType
	Debug(improvementName.." by PlayerID: "..tostring(playerID).." at X,Y: "..tostring(iX)..","..tostring(iY).." resource: "..tostring(resource).." isPillaged: "..tostring(isPillaged).." isWorked: "..tostring(isWorked),debugcontext)
end

function OnImprovementRemovedFromMapTest(iX,iY, ownerID)
	debugcontext = "OnImprovementRemovedFromMapTest(L)"
	Debug("Started",debugcontext)
	Debug("Improvement at X,Y: "..tostring(iX)..","..tostring(iY).." ownerID: "..tostring(ownerID).." Removed",debugcontext)
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
		local pAttDistrict = Players[attackerPlayerID]:GetDistricts():FindID(attackerDistrictID)
		if defenderUnitID == -1 then
			local pDefDistrict = Players[defenderPlayerID]:GetDistricts():FindID(defenderDistrictID)
			Debug("attDistrict: "..tostring(GameInfo.Districts[pAttDistrict:GetType()].DistrictType).." with ID: "..tostring(attackerDistrictID).." of Attacker ID: "..tostring(attackerPlayerID).."Hit defDistrict: "..tostring(GameInfo.Districts[pDefDistrict:GetType()].DistrictType).." with ID: "..tostring(defenderDistrictID).." of defender ID: "..tostring(defenderPlayerID), debugcontext)
		else
			local pDefUnit = UnitManager.GetUnit(defenderPlayerID, defenderUnitID)
			Debug("attDistrict: "..tostring(GameInfo.Districts[pAttDistrict:GetType()].DistrictType).." with ID: "..tostring(attackerDistrictID).."Hit Unit: "..tostring(GameInfo.Units[pDefUnit:GetType()].UnitType).."with ID: "..tostring(defenderUnitID).." of defender ID: "..tostring(defenderPlayerID), debugcontext)
		end
	else
		local pAttUnit = UnitManager.GetUnit(attackerPlayerID, attackerUnitID)
		local pAttUnitType = GameInfo.Units[pAttUnit:GetType()].UnitType
		if defenderUnitID == -1 then
			local pDefDistrict = Players[defenderPlayerID]:GetDistricts():FindID(defenderDistrictID)
			local pDefDistrictType = GameInfo.Districts[pDefDistrict:GetType()].DistrictType
			Debug("att Unit: "..tostring(pAttUnitType).." with ID: ".." of Attacker ID: "..tostring(attackerPlayerID).." Hit def District: "..tostring(pDefDistrictType).." with ID: "..tostring(defenderDistrictID).." of Defender ID: "..tostring(defenderPlayerID),debugcontext)
		else
			local pDefUnit = UnitManager.GetUnit(defenderPlayerID, defenderUnitID)
			local pDefUnitType = GameInfo.Units[pDefUnit:GetType()].UnitType
			Debug("att Unit: "..tostring(pAttUnitType).." with ID: ".." of Attacker ID: "..tostring(attackerPlayerID).." Hit def Unit: "..tostring(pDefUnitType).." with ID: "..tostring(defenderUnitID).." of Defender ID: "..tostring(defenderPlayerID),debugcontext)
		end
	end
end

function OnCombatTest(kCombatResults)
	local debugcontext = "OnCombatTest(L)"
	Debug("Started",debugcontext)
	Debug(kCombatResults,debugcontext)
end

function OnDistrictDamageChangedTest(playerID, districtID, damageType, newDamage, oldDamage)
	local debugcontext = "OnDistrictDamageChangedTest(L)"
	Debug("Started",debugcontext)
	local pDistrict = Players[playerID]:GetDistricts():FindID(districtID)
	local districtTypeName = GameInfo.Districts[pDistrict:GetType()].DistrictType
	Debug("District: "..tostring(districtTypeName).." with ID: "..tostring(districtID).." and OwnerID: "..tostring(playerID).." New Damage: "..tostring(newDamage).." Old Damage: "..tostring(oldDamage).." damageType: "..tostring(damageType),debugcontext)
end

function OnUnitDamageChangedTest(playerID, unitID, newDamage, oldDamage)
	local debugcontext = "OnUnitDamageChangedTest(L)"
	Debug("Started",debugcontext)
	local pUnit = UnitManager.GetUnit(playerID, unitID)
	local unitTypeName = GameInfo.Units[pUnit:GetType()].UnitType
	Debug("Unit: "..tostring(unitTypeName).." with ID: "..tostring(unitID).." and OwnerID: "..tostring(playerID).." New Damage: "..tostring(newDamage).." Old Damage: "..tostring(oldDamage),debugcontext)
end

function OnUnitKilledInCombatTest(killedPlayerID, killedUnitID, playerID, unitID)
	local debugcontext = "OnUnitKilledInCombatTest(L)"
	Debug("Started",debugcontext)
	local pKilledUnit = UnitManager.GetUnit(killedPlayerID, killedUnitID)
	local killedUnitTypeName = GameInfo.Units[pKilledUnit:GetType()].UnitType
	local pUnit = UnitManager.GetUnit(playerID, unitID)
	local unitTypeName = GameInfo.Units[pUnit:GetType()].UnitType
	Debug(tostring(killedUnitTypeName).." with ID: "..tostring(killedUnitID).." and Owner ID: "..tostring(killedPlayerID).." Was Killed by: "..tostring(unitTypeName).." with ID: "..tostring(unitID).." and Owner: "..tostring(playerID),debugcontext)
end

function OnUnitMoveCompleteTest(playerID, unitID, iX, iY)
	local debugcontext = "OnUnitMoveCompleteTest(L)"
	Debug("Started",debugcontext)
	local pUnit = UnitManager.GetUnit(playerID, unitID)
	local unitTypeName = GameInfo.Units[pUnit:GetType()].UnitType
	Debug(tostring(unitTypeName).." with ID: "..tostring(unitID).." and Owner ID: "..tostring(playerID).." Moved to X,Y: "..tostring(iX)..","..tostring(iY),debugcontext)
end

function OnUnitMovedTest(playerID, unitID, iX, iY, locallyVisible, stateChange)
	local debugcontext = "OnUnitMovedTest(L)"
	Debug("Started",debugcontext)
	local pUnit = UnitManager.GetUnit(playerID, unitID)
	local unitTypeName = GameInfo.Units[pUnit:GetType()].UnitType
	Debug(tostring(unitTypeName).." with ID: "..tostring(unitID).." and Owner ID: "..tostring(playerID).." Moved to X,Y: "..tostring(iX)..","..tostring(iY).." locallyVisible: "..tostring(locallyVisible).." stateChange: "..tostring(stateChange),debugcontext)
end

function OnUnitTeleportedTest(playerID, unitID, iX, iY)
	local debugcontext = "OnUnitTeleportedTest(L)"
	Debug("Started",debugcontext)
	local pUnit = UnitManager.GetUnit(killedPlayerID, killedUnitID)
	local unitTypeName = GameInfo.Units[pUnit:GetType()].UnitType
	local fX = pUnit:GetX()
	local fY = pUnit:GetY()
	Debug(tostring(unitTypeName).." with ID: "..tostring(unitID).." and Owner ID: "..tostring(playerID).." UnitTeleported to X,Y: "..tostring(fX)..","..tostring(fY).." from X,Y: "..tostring(iX)..","..tostring(iY),debugcontext)
end
--================================Diplo=========================
function OnDiplomacyDeclareWarTest(playerID1, playerID2)
	local debugcontext = "OnDiplomacyDeclareWarTest(L)"
	Debug("Started",debugcontext)
	local pPlayer1 = Players[playerID1]
	local pPlayer1Civ = pPlayer1:GetCivilizationTypeName()
	local p1major = pPlayer1:IsMajor()
	local pPlayer2 = Players[playerID2]
	local pPlayer2Civ = pPlayer2:GetCivilizationTypeName()
	local p2major = pPlayer2:IsMajor()
	Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Declared War On: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
end

function  OnDiploSurpriseDeclareWarTest(playerID1, playerID2)
	local debugcontext = "OnDiploSurpriseDeclareWarTest(G)"
	Debug("Started",debugcontext)
	local pPlayer1 = Players[playerID1]
	local pPlayer1Civ = pPlayer1:GetCivilizationTypeName()
	local p1major = pPlayer1:IsMajor()
	local pPlayer2 = Players[playerID2]
	local pPlayer2Civ = pPlayer2:GetCivilizationTypeName()
	local p2major = pPlayer2:IsMajor()
	Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Declared SurpriseWar(G) On: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
end

function OnDiplomacyRelationshipChangedTest(playerID1, playerID2)
	local debugcontext = "OnDiplomacyRelationshipChangedTest(L)"
	Debug("Started",debugcontext)
	local pPlayer1 = Players[playerID1]
	local pPlayer1Civ = pPlayer1:GetCivilizationTypeName()
	local p1major = pPlayer1:IsMajor()
	local pPlayer2 = Players[playerID2]
	local pPlayer2Civ = pPlayer2:GetCivilizationTypeName()
	local p2major = pPlayer2:IsMajor()

	local p1Diplo = pPlayer1:GetDiplomacy()
	if p1Diplo:HasMet(playerID2) then
		Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Diplo Changed Has Met(L) with: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
	end
	if p1Diplo:IsAtWarWith(playerID2) then
		Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Diplo Changed to War(L) with: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
	end
	if p2major and not pPlayer2:IsBarbarian() == false then
		local p2suzId = pPlayer2:GetInfluence():GetSuzerain()
		if p2suzId == playerID then
			Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Diplo Changed to Suz(L) with: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
		end
	else
		if p1Diplo:HasOpenBordersFrom(playerID2) then
			Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Diplo Changed Open Borders(L) from: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
		elseif p1Diplo:HasDeclaredFriendship(playerID2) then
			Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Diplo Changed Friendship(L) with: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
		elseif p1Diplo:HasAllied(playerID2) then
			Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Diplo Changed Has Allied(L) with: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
		elseif p1Diplo:HasDelegationAt(playerID2) then
			Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Diplo Changed Has Delegation(L) to: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
		elseif p1Diplo:HasEmbassyAt(playerID2) then
			Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Diplo Changed Has Embassy(L) to: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
		end
	end
end

function OnPlayerGaveInfluenceTokenTest(majorID, minorID, iAmount)
	debugcontext = "OnPlayerGaveInfluenceTokenTest(G)"
	Debug("Started",debugcontext)
	local pPlayerMaj = Players[majorID]
	local pPlayerMajCiv = pPlayerMaj:GetCivilizationTypeName()
	local pMajMajor = pPlayerMaj:IsMajor()
	local pPlayerMin = Players[majorID]
	local pPlayerMinCiv = pPlayerMin:GetCivilizationTypeName()
	local pMinMajor = pPlayer2:IsMajor()
	Debug(tostring(pPlayerMajCiv).." with ID: "..tostring(majorID).." isMajor: "..tostring(pMajMajor).." Gave "..tostring(iAmount).." Envoys to: "..tostring(pPlayerMinCiv).." with ID: "..tostring(minorID).." isMajor: "..tostring(pMinMajor),debugcontext)
end

function OnDiplomacyMeetTest(playerID1,playerID2)
	debugcontext = "OnDiplomacyMeetTest(L)"
	Debug("Started",debugcontext)
	local pPlayer1 = Players[playerID1]
	local pPlayer1Civ = pPlayer1:GetCivilizationTypeName()
	local p1major = pPlayer1:IsMajor()
	local pPlayer2 = Players[playerID2]
	local pPlayer2Civ = pPlayer2:GetCivilizationTypeName()
	local p2major = pPlayer2:IsMajor()
	Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Met Player: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
end


function OnDiplomacyMeetMajorMinorTest(...)
	local vars = {...}
	debugcontext = "OnDiplomacyMeetMajorMinorTest(L)"
	Debug("Started")
	local str = ""
	if #vars>0 then
		for i,var in ipairs(vars) do
			str = str.."Var "..tostring(i)..": "..tostring(var1).." "
		end
	end
	Debug(str,debugcontext)
end

function OnDiplomacyMeetMajorsTest(...)
	local vars = {...}
	debugcontext = "OnDiplomacyMeetMajorsTest(L)"
	Debug("Started")
	local str = ""
	if #vars>0 then
		for i,var in ipairs(vars) do
			str = str.."Var "..tostring(i)..": "..tostring(var1).." "
		end
	end
	Debug(str,debugcontext)
end

function OnDiplomacyMakePeaceTest(playerID1, playerID2)
	debugcontext = "OnDiplomacyMakePeaceTest(L)"
	Debug("Started",debugcontext)
	local pPlayer1 = Players[playerID1]
	local pPlayer1Civ = pPlayer1:GetCivilizationTypeName()
	local p1major = pPlayer1:IsMajor()
	local pPlayer2 = Players[playerID2]
	local pPlayer2Civ = pPlayer2:GetCivilizationTypeName()
	local p2major = pPlayer2:IsMajor()
	Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Made Peace with Player: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
end

function OnInfluenceGivenTest(csID, playerID)
	debugcontext = "OnInfluenceGivenTest(L)"
	Debug("Started",debugcontext)
	Debug("csID: "..tostring(playerID).." gave envory to playerID: "..tostring(playerID),debugcontext)
end
--=======================Congress Events ?=========-------------
function OnDiplomacySessionClosedTest(sessionID)
	debugcontext = "OnDiplomacySessionClosedTest(L)"
	Debug("Started",debugcontext)
	Debug("Diplo Session with ID: "..tostring(sessionID).." closed",debugcontext)
end

function OnPhaseBeginTest(...)
	local vars = {...}
	debugcontext = "OnPhaseBeginTest(L)"
	local str = ""
	if #vars>0 then
		for i,var in ipairs(vars) do
			str = str.."Var "..tostring(i)..": "..tostring(var1).." "
		end
	end
	Debug(str,debugcontext)
	Debug(tostring(Game.GetPhaseName()),debugcontext)
end

function OnPhaseEndTest(...)
	local vars = {...}
	debugcontext = "OnPhaseEndTest(L)"
	local str = ""
	if #vars>0 then
		for i,var in ipairs(vars) do
			str = str.."Var "..tostring(i)..": "..tostring(var1).." "
		end
	end
	Debug(str,debugcontext)
	Debug(tostring(Game.GetPhaseName()),debugcontext)
end
--===================Religion Events============--------
function OnReligionFoundedTest(playerID, religionID)
	debugcontext = "OnReligionFoundedTest(L)"
	Debug("Started", debugcontext)
	local pPlayer = Players[playerID]
	local playerCiv = pPlayer:GetCivilizationTypeName()
	Debug(tostring(playerCiv).." with ID: "..tostring(playerID).." Founded Religion with ID: "..tostring(religionID),debugcontext)
end

function OnBeliefAddedTest(playerID, beliefID)
	debugcontext = "OnBeliefAddedTest(L)"
	Debug("Started",debugcontext)
	local pPlayer = Players[playerID]
	local playerCiv = pPlayer:GetCivilizationTypeName()
	Debug(tostring(playerCiv).." with ID: "..tostring(playerID).." Adopted Belief with ID: "..tostring(beliefID),debugcontext)
end

function OnCityReligionChangedTest(playerID, cityID, eVisibility, city)
	debugcontext = "OnCityReligionChangedTest(L)"
	Debug("Started",debugcontext)
	local pCity = CityManager.GetCity(playerID, cityID)
	local cityName : string
	if pCity ~= nil then
		cityName = pCity:GetName()
	end
	local cityReligionID = pCity:GetReligion():GetMajorityReligion()
	local pPlayer = Players[playerID]
	local playerCiv = pPlayer:GetCivilizationTypeName()
	Debug(tostring(cityName).." Owned by Player: "..tostring(playerCiv).." with ID: "..tostring(playerID).." Converted to Religion with ID: "..tostring(cityReligionID).." eVisibility: "..tostring( eVisibility).." city: "..tostring(city),debugcontext)
end

function OnCityReligionFollowersChangedTest(playerID, cityID, eVisibility, city)
	debugcontext = "OnCityReligionFollowersChangedTest(L)"
	Debug("Started",debugcontext)
	local pCity = CityManager.GetCity(playerID, cityID)
	local cityName : string
	if pCity ~= nil then
		cityName = pCity:GetName()
	end
	local cityReligion = pCity:GetReligion()
	local str: string = ""
	for i = -1,24 do
		if cityReligion:GetNumFollowers(i) ~= 0 then
			str = str.."Religion ID: "..tostring(i).." Num Followers: "..tostring(cityReligion:GetNumFollowers(i))
		end
	end
	local pPlayer = Players[playerID]
	local playerCiv = pPlayer:GetCivilizationTypeName()
	Debug(tostring(cityName).." Owned by Player: "..tostring(playerCiv).." with ID: "..tostring(playerID).." Religious Followers: "..str.." eVisibility: "..tostring( eVisibility).." city: "..tostring(city),debugcontext)
end

function OnNewMajorityReligionTest(...)
	debugcontext = "OnNewMajorityReligionTest(G)"
	Debug("Started",debugcontext)
	vars = {...}
	local str = ""
	if #vars>0 then
		for i,var in ipairs(vars) do
			str = str.."Var "..tostring(i)..": "..tostring(var1).." "
		end
	end
	Debug(str,debugcontext)
	local playerID = Game.GetLocalPlayer()
	local pPlayer = Players[playerID]
	local playerMajReligionID = pPlayer:GetReligion():GetReligionInMajorityOfCities()
	Debug("Player ID: "..tostring(playerID).." Has New Majority Religion with ID: "..tostring(playerMajReligionID),debugcontext)
end

--========================Government Events================-----
function OnGovernmentChangedTest(playerID, governmentID)
	debugcontext = "OnGovernmentChangedTest(L)"
	Debug("Started",debugcontext)
	local pPlayer = Players[playerID]
	local playerCiv = pPlayer:GetCivilizationTypeName()
	local governmentName = GameInfo.Governments[governmentID].GovernmentType
	Debug(playerCiv.." with playerID: "..tostring(playerID).." Changed Government to: "..governmentName,debugcontext)	
end

function OnGovernmentPolicyChangedTest(playerID, governmentID)
	debugcontext = "OnGovernmentPolicyChangedTest(L)"
	Debug("Started",debugcontext)
	local pPlayer = Players[playerID]
	local playerCiv = pPlayer:GetCivilizationTypeName()
	local policyName = GameInfo.Policies[policyID].PolicyType
	Debug(playerCiv.." with playerID: "..tostring(playerID).." Changed Policy: "..policyName,debugcontext)
end

function OnGovernmentPolicyObsoletedTest(playerID)
	debugcontext = "OnGovernmentPolicyObsoletedTest(L)"
	Debug("Started",debugcontext)
	local pPlayer = Players[playerID]
	local playerCiv = pPlayer:GetCivilizationTypeName()
	Debug(playerCiv.." with playerID: "..tostring(playerID).." Has an Obsolete Policy")
end

function OnPolicyChangedTest(playerID, policyID, bEnacted)
	debugcontext = "OnPolicyChangedTest(G)"
	Debug("Started",debugcontext)
	local pPlayer = Players[playerID]
	local playerCiv = pPlayer:GetCivilizationTypeName()
	local policyName = GameInfo.Policies[policyID].PolicyType
	Debug(playerCiv.." with playerID: "..tostring(playerID).." bEnacted: "..tostring(bEnacted).." Policy: "..policyName,debugcontext)
end

--====================Gameplay Cheats============--
function OnStartAddStats(pPlayer)
	local debugcontext = "OnStartAddStats(L/S)"
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
	local freeculture = {8,20,23}
	for i, index in ipairs(culture) do
		local pCulture = pPlayer:GetCulture()
		pCulture:SetCulturalProgress(index, pTechs:GetCultureCost(index))
	end
	Debug("Civics Added",debugcontext)
	--Attach +20 spy capacity modifier
	pPlayer:AttachModifierByID('BBG_TEST_GIVE_20_SPY_CAPACITY')
	Debug("Spy Capacity Increased", debugcontext)
end

function GiveVisibilityToAllMajors(playerID)
	debugcontext = "GiveVisibilityToAllMajors(L/S)"
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
	debugcontext = "Start(G)"
	Debug("BBGTS - Gameplay Script Launched",debugcontext)
	local currentTurn = Game.GetCurrentGameTurn()
	local startTurn = GameConfiguration.GetStartTurn()
	
	if currentTurn == startTurn and MP_CHEATS then
		local locPlayerID = Game.GetLocalPlayer()
		local pLocalPlayer = Players[locPlayerID]
		if pLocalPlayer:IsMajor() then
			Debug("Starting cheat script",debugcontext)
			OnStartAddStats(pLocalPlayer)
		end

	end
	Debug("Adding Listener Events",debugcontext)
	--=============Game Turn========--
	GameEvents.OnGameTurnStarted.Add(OnGameTurnStartedTest)
	--=============Spy Functions============-----------
	Events.UnitCaptured.Add(OnUnitCapturedTest)
	Events.SpyRemoved.Add(OnSpyRemoveTest)
	Events.SpyAdded.Add(OnSpyAddedTest)
	Events.UnitRemovedFromMap.Add(OnUnitRemovedFromMapTest)
	Events.UnitAddedToMap.Add(OnUnitAddedToMapTest)
	GameEvents.OnUnitRetreated.Add(OnUnitRetreatedTest)
	--=============City Events Functions=============----------
	GameEvents.CityBuilt.Add(OnCityBuiltTest)
	GameEvents.CityConquered.Add(OnCityConqueredTest)
	Events.CityRemovedFromMap.Add(OnCityRemovedFromMapTest)
	Events.CityLiberated.Add(OnCityLiberatedTest)
	--=============Improvement Events=====----------------
	Events.ImprovementActivated.Add(OnImprovementActivatedTest)
	Events.ImprovementAddedToMap.Add(OnImprovementAddedToMapTest)
	Events.ImprovementChanged.Add(OnImprovementChangedTest)
	Events.ImprovementRemovedFromMap.Add(OnImprovementRemovedFromMapTest)
	--=============District Events===========-----------
	Events.DistrictAddedToMap.Add(OnDistrictAddedToMapTest)
	Events.DistrictPillaged.Add(OnDistrictPillagedTest)
	Events.DistrictRemovedFromMap.Add(OnDistrictRemovedFromMapTest)
	Events.DistrictBuildProgressChanged.Add(OnDistrictBuildProgressChangedTest)
	GameEvents.OnDistrictConstructed.Add(OnDistrictConstructedTest)
	--=============Building Events================--
	Events.BuildingAddedToMap.Add(OnBuildingAddedToMapTest)
	Events.BuildingChanged.Add(OnBuildingChangedTest)
	GameEvents.BuildingConstructed.Add(OnBuildingConstructedTest)
	GameEvents.BuildingPillageStateChanged.Add(OnBuildingPillageStateChangedTest)
	--=============City Construction============---
	Events.CityProductionCompleted.Add(OnCityProductionCompletedTest)
	Events.CityProductionChanged.Add(OnCityProductionChangedTest)
	Events.CityProjectCompleted.Add(OnCityProjectCompletedTest)
	Events.CityMadePurchase.Add(OnCityMadePurchaseTest)
	--=============General Pillage Event==========--
	GameEvents.OnPillage.Add(OnPillageTest)
	--=============Combat Events=============--
	GameEvents.OnCombatOccurred.Add(OnCombatOccurredTest)
	Events.Combat.Add(OnCombatTest)
	Events.DistrictDamageChanged.Add(OnDistrictDamageChangedTest)
	Events.UnitDamageChanged.Add(OnUnitDamageChangedTest)
	Events.UnitKilledInCombat.Add(OnUnitKilledInCombatTest)
	--=============Unit Movement Events=========---
	Events.UnitMoveComplete.Add(OnUnitMoveCompleteTest)
	Events.UnitMoved.Add(OnUnitMovedTest)
	Events.UnitTeleported.Add(OnUnitTeleportedTest)
	--=============Diplomacy Events==========--
	Events.DiplomacyDeclareWar.Add(OnDiplomacyDeclareWarTest)
	GameEvents.DiploSurpriseDeclareWar.Add(OnDiploSurpriseDeclareWarTest)
	Events.DiplomacyRelationshipChanged.Add(OnDiplomacyRelationshipChangedTest)
	GameEvents.OnPlayerGaveInfluenceToken.Add(OnPlayerGaveInfluenceTokenTest)
	Events.DiplomacyMeet.Add(OnDiplomacyMeetTest)
	Events.DiplomacyMeetMajorMinor.Add(OnDiplomacyMeetMajorMinorTest)
	Events.DiplomacyMeetMajors.Add(OnDiplomacyMeetMajorsTest)
	Events.DiplomacyMakePeace.Add(OnDiplomacyMakePeaceTest)
	Events.InfluenceGiven.Add(OnInfluenceGivenTest)
	--============Congress Events?===========--
	Events.DiplomacySessionClosed.Add(OnDiplomacySessionClosedTest)
	Events.PhaseBegin.Add(OnPhaseBeginTest)
	Events.PhaseEnd.Add(OnPhaseEndTest)
	--============Religion==========--
	Events.ReligionFounded.Add(OnReligionFoundedTest)
	Events.BeliefAdded.Add(OnBeliefAddedTest)
	Events.CityReligionChanged.Add(OnCityReligionChangedTest)
	Events.CityReligionFollowersChanged.Add(OnCityReligionFollowersChangedTest)
	GameEvents.OnNewMajorityReligion.Add(OnNewMajorityReligionTest)
	--============Government==========--
	Events.GovernmentChanged.Add(OnGovernmentChangedTest)
	Events.GovernmentPolicyChanged.Add(OnGovernmentPolicyChangedTest)
	Events.GovernmentPolicyObsoleted.Add(OnGovernmentPolicyObsoletedTest)
	GameEvents.PolicyChanged.Add(OnPolicyChangedTest)
end

Initialize();

