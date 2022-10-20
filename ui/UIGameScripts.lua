include "MPMAPI_core"
local debugcontext = "UIGameScripts"
print("Started",debugcontext)

----=========Units(incl Spy): Add Remove Capture==========----
function OnUnitCapturedTest(currentUnitOwner, unitID, owningPlayer, capturingPlayer)
	local debugcontext = "OnUnitCapturedTest(L)"
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

function OnUnitRemovedFromMapTest(playerID, unitID)
	local debugcontext = "OnUnitRemovedFromMapTest(L)"
	Debug("Started",debugcontext)
	local pPlayer = Players[playerID]
	local playerCiv = PlayerConfigurations[playerID]:GetCivilizationTypeName()
	local pUnit = UnitManager.GetUnit(playerID,unitID)
	if pUnit~=nil then
		local unitTypeName = GameInfo.Units[pUnit:GetType()].UnitType
		Debug(unitTypeName.." with ID: "..tostring(unitID).." Owned By Civ: "..playerCiv.." with ID: "..tostring(playerID).." was removed from MAP",debugcontext)
	else
		Debug("Unit with ID: "..tostring(unitID).." Owned By Civ: "..playerCiv.." with ID: "..tostring(playerID).." was removed from MAP",debugcontext)
	end
end

function OnUnitAddedToMapTest(playerID, unitID)
	local debugcontext = "OnUnitAddedToMapTest(L)"
	Debug("Started",debugcontext)
	local pUnit = UnitManager.GetUnit(playerID, unitID)
	if pUnit~=nil then
		local unitTypeName = GameInfo.Units[pUnit:GetType()].UnitType
		Debug("Unit with ID: "..tostring(unitID).." and type: "..tostring(unitTypeName).." Added For PlayerID: "..tostring(playerID),debugcontext)
	else
		Debug("Unit with ID: "..tostring(unitID).." Added For PlayerID: "..tostring(playerID),debugcontext)
	end
end

--===========City Events========------
function OnCityLiberatedTest(playerID, cityID)
	local debugcontext = "OnCityLiberatedTest(L)"
	Debug("Started")
	Debug("playerID: "..tostring(playerID).." Liberated cityID: "..tostring(cityID))
end

function OnCityRemovedFromMapTest(playerID, cityID)
	local debugcontext = "OnCityRemovedFromMapTest(L)"
	Debug("Started",debugcontext)
	local pCity = CityManager.GetCity(playerID, cityID)
	Debug("City with ID: "..tostring(cityID).." and name: "..tostring(pCity:GetName()).." Razed by PlayerID: "..tostring(playerID),debugcontext)
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
	local pCity = CityManager.GetCity(playerID, cityID)
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
	local pCity = CityManager.GetCity(playerID, cityID)
	Debug("District "..tostring(districtTypeName).."With ID: "..tostring(districtID).." Placed by PlayerID: "..tostring(playerID).." In City "..tostring(pCity:GetName()).." with ID: "..tostring(cityID).." at X,Y: "..tostring(iX)..","..tostring(iY).." %: "..tostring(percentComplete).." isPillaged: "..tostring(isPillaged).." Appeal: "..tostring(iAppeal).." Era: "..tostring(era).." Civ: "..tostring(civilization),debugcontext)
end

--============Building Events============----
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
--=============City Build/Purchase========---
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
	local playerCiv = PlayerConfigurations[playerID]:GetCivilizationTypeName()
	local projectName = GameInfo.Projects[projectID].ProjectType
	local buildingTypeName = GameInfo.Buildings[buildingID].BuildingType
	Debug(cityName.." with ID: "..tostring(cityID).." Owned by: "..playerCiv.." with ID: "..tostring(playerID).." located at iX,iY,pX,pY: "..tostring(iX)..","..tostring(iY)..","..tostring(pX)..","..tostring(pY).." completed Project: "..projectName.." in the Building: "..buildingTypeName,debugcontext)
end

function OnCityMadePurchaseTest(playerID, cityID, iX, iY, purchaseType, objectType)
	local debugcontext = "OnCityMadePurchaseTest(L)"
	Debug("Started", debugcontext)
	local pCity = CityManager.GetCity(playerID, cityID)
	local pX = pCity:GetX()
	local pY = pCity:GetY()
	local cityName = pCity:GetName()
	local pPlayer = Players[playerID]
	local playerCiv = PlayerConfigurations[playerID]:GetCivilizationTypeName()
	Debug(cityName.." with ID: "..tostring(cityID).." Owned by: "..playerCiv.." with ID: "..tostring(playerID).." located at pX,pY: "..tostring(pX)..","..tostring(pY).." Made Purchase of Type: "..tostring(purchaseType).." and objectType: "..tostring(objectType).." at iX,iY: "..tostring(iX)..","..tostring(iY),debugcontext)
end

--====================Improvement Events================------------
function OnImprovementActivatedTest(iX,iY,playerID, unitID, improvementType, improvementID,activationType)
	local debugcontext = "OnImprovementActivatedTest(L)"
	Debug("Started",debugcontext)
	local improvementName = GameInfo.Improvements[improvementType].ImprovementType
	local pUnit = UnitManager.GetUnit(playerID,unitID)
	if pUnit~=nil then
		local unitTypeName = GameInfo.Units[pUnit:GetType()].UnitType
		Debug(improvementName.." with ID: "..tostring(improvementID).." was activated by: "..unitTypeName.." with ID: "..tostring(unitID).." by PlayerID: "..tostring(playerID).." at X,Y: "..tostring(iX)..","..tostring(iY).." activationType: "..tostring(activationType),debugcontext)
	else
		Debug(improvementName.." with ID: "..tostring(improvementID).." was activated by: ".." unit with ID: "..tostring(unitID).." by PlayerID: "..tostring(playerID).." at X,Y: "..tostring(iX)..","..tostring(iY).." activationType: "..tostring(activationType),debugcontext)
	end
end

function OnImprovementAddedToMapTest(iX,iY,improvementType,playerID,resource, isPillaged,isWorked)
	local debugcontext = "OnImprovementAddedToMapTest(L)"
	Debug("Started",debugcontext)
	local improvementName = GameInfo.Improvements[improvementType].ImprovementType
	Debug(improvementName.." by PlayerID: "..tostring(playerID).." at X,Y: "..tostring(iX)..","..tostring(iY).." resource: "..tostring(resource).." isPillaged: "..tostring(isPillaged).." isWorked: "..tostring(isWorked),debugcontext)
end

function OnImprovementChangedTest(iX,iY,improvementType,playerID,resource, isPillaged,isWorked)
	local debugcontext = "OnImprovementChangedTest(L)"
	Debug("Started",debugcontext)
	local improvementName = GameInfo.Improvements[improvementType].ImprovementType
	Debug(improvementName.." by PlayerID: "..tostring(playerID).." at X,Y: "..tostring(iX)..","..tostring(iY).." resource: "..tostring(resource).." isPillaged: "..tostring(isPillaged).." isWorked: "..tostring(isWorked),debugcontext)
end

function OnImprovementRemovedFromMapTest(iX,iY, ownerID)
	local debugcontext = "OnImprovementRemovedFromMapTest(L)"
	Debug("Started",debugcontext)
	Debug("Improvement at X,Y: "..tostring(iX)..","..tostring(iY).." ownerID: "..tostring(ownerID).." Removed",debugcontext)
end

--================Unit/City/District combat/movement events==============---
function OnCombatTest(kCombatResults)
	local debugcontext = "OnCombatTest(L)"
	Debug("Started",debugcontext)
	Debug(tostring(kCombatResults),debugcontext)
end

function OnDistrictDamageChangedTest(playerID, districtID, damageType, newDamage, oldDamage)
	local debugcontext = "OnDistrictDamageChangedTest(L)"
	Debug("Started",debugcontext)
	local pDistrict = Game.GetObjectFromComponentID(districtID)
	local districtTypeName = GameInfo.Districts[pDistrict:GetType()].DistrictType
	Debug("District: "..tostring(districtTypeName).." with ID: "..tostring(districtID).." and OwnerID: "..tostring(playerID).." New Damage: "..tostring(newDamage).." Old Damage: "..tostring(oldDamage).." damageType: "..tostring(damageType),debugcontext)
end

function OnUnitDamageChangedTest(playerID, unitID, newDamage, oldDamage)
	local debugcontext = "OnUnitDamageChangedTest(L)"
	Debug("Started",debugcontext)
	local pUnit = UnitManager.GetUnit(playerID, unitID)
	if pUnit~=nil then
		local unitTypeName = GameInfo.Units[pUnit:GetType()].UnitType
		Debug("Unit: "..tostring(unitTypeName).." with ID: "..tostring(unitID).." and OwnerID: "..tostring(playerID).." New Damage: "..tostring(newDamage).." Old Damage: "..tostring(oldDamage),debugcontext)
	else
		Debug("Unit with ID: "..tostring(unitID).." and OwnerID: "..tostring(playerID).." New Damage: "..tostring(newDamage).." Old Damage: "..tostring(oldDamage),debugcontext)
	end
end

function OnUnitKilledInCombatTest(killedPlayerID, killedUnitID, playerID, unitID)
	local debugcontext = "OnUnitKilledInCombatTest(L)"
	Debug("Started",debugcontext)
	local pKilledUnit = UnitManager.GetUnit(killedPlayerID, killedUnitID)
	if pKilledUnit~=nil then
		local killedUnitTypeName = GameInfo.Units[pKilledUnit:GetType()].UnitType
	end
	local pUnit = UnitManager.GetUnit(playerID, unitID)
	if pUnit~=nil then
		local unitTypeName = GameInfo.Units[pUnit:GetType()].UnitType
	end
	if pKilledUnit~=nil and pUnit~=nil then
		Debug(tostring(killedUnitTypeName).." with ID: "..tostring(killedUnitID).." and Owner ID: "..tostring(killedPlayerID).." Was Killed by: "..tostring(unitTypeName).." with ID: "..tostring(unitID).." and Owner: "..tostring(playerID),debugcontext)
	else
		Debug("Unit with ID: "..tostring(killedUnitID).." and Owner ID: "..tostring(killedPlayerID).." Was Killed by Unit with ID: "..tostring(unitID).." and Owner: "..tostring(playerID),debugcontext)
	end
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
	if pUnit~=nil then
		local unitTypeName = GameInfo.Units[pUnit:GetType()].UnitType
		Debug(tostring(unitTypeName).." with ID: "..tostring(unitID).." and Owner ID: "..tostring(playerID).." Moved to X,Y: "..tostring(iX)..","..tostring(iY).." locallyVisible: "..tostring(locallyVisible).." stateChange: "..tostring(stateChange),debugcontext)
	else
		Debug("Unit with ID: "..tostring(unitID).." and Owner ID: "..tostring(playerID).." Moved to X,Y: "..tostring(iX)..","..tostring(iY).." locallyVisible: "..tostring(locallyVisible).." stateChange: "..tostring(stateChange),debugcontext)
	end
end

function OnUnitTeleportedTest(playerID, unitID, iX, iY)
	local debugcontext = "OnUnitTeleportedTest(L)"
	Debug("Started",debugcontext)
	local pUnit = UnitManager.GetUnit(playerID, unitID)
	if pUnit~=nil then
		local unitTypeName = GameInfo.Units[pUnit:GetType()].UnitType
		local fX = pUnit:GetX()
		local fY = pUnit:GetY()
		Debug(tostring(unitTypeName).." with ID: "..tostring(unitID).." and Owner ID: "..tostring(playerID).." UnitTeleported to X,Y: "..tostring(fX)..","..tostring(fY).." from X,Y: "..tostring(iX)..","..tostring(iY),debugcontext)
	else
		Debug("Unit ID: "..tostring(unitID).." and Owner ID: "..tostring(playerID).." UnitTeleported X,Y: "..tostring(iX)..","..tostring(iY),debugcontext)
	end
end

--============Operations and commands======--
function OnUnitOperationAddedTest(playerID, unitID, iUnknown, hOperation)
	local debugcontext = "OnUnitOperationAddedTest(L)"
	Debug("Started",debugcontext)
	Debug("PlayerID: "..tostring(playerID).." unitID: "..tostring(unitID).." iUnknown: "..tostring(iUnknown).." hOperation: "..tostring(hOperation),debugcontext)
end

function OnUnitOperationDeactivatedTest(playerID, unitID, hOperation, iData)
	local debugcontext = "OnUnitOperationDeactivatedTest(L)"
	Debug("Started",debugcontext)
	Debug("PlayerID: "..tostring(playerID).." unitID: "..tostring(unitID).." hOperation: "..tostring(hOperation).." iData: "..tostring(iData),debugcontext)
end

function OnUnitOperationSegmentCompleteTest(playerID, unitID, hOperation, iData)
	local debugcontext = "OnUnitOperationSegmentCompleteTest(L)"
	Debug("Started",debugcontext)
	Debug("PlayerID: "..tostring(playerID).." unitID: "..tostring(unitID).." hOperation: "..tostring(hOperation).." iData: "..tostring(iData),debugcontext)
end

function OnUnitOperationStartedTest(playerID, unitID, operationID)
	local debugcontext = "OnUnitOperationStartedTest(L)"
	Debug("Started",debugcontext)
	Debug("PlayerID: "..tostring(playerID).." unitID: "..tostring(unitID).." operationID: "..tostring(operationID),debugcontext)
end

function OnUnitOperationsClearedTest(playerID, unitID, hOperation, iData)
	local debugcontext = "OnUnitOperationsClearedTest(L)"
	Debug("Started",debugcontext)
	Debug("PlayerID: "..tostring(playerID).." unitID: "..tostring(unitID).." hOperation: "..tostring(hOperation).." iData: "..tostring(iData),debugcontext)
end

function OnUnitCommandStartedTest(playerID, unitID, hCommand, iData)
	local debugcontext = "OnUnitCommandStartedTest(L)"
	Debug("Started",debugcontext)
	Debug("PlayerID: "..tostring(playerID).." unitID: "..tostring(unitID).." hCommand: "..tostring(hCommand).." iData: "..tostring(iData),debugcontext)
end

function OnCityCommandStartedTest(playerID, cityID, districtOwnerID, commandType, iData)
	local debugcontext = "OnCityCommandStartedTest(L)"
	Debug("Started",debugcontext)
	Debug("PlayerID: "..tostring(playerID).." cityID: "..tostring(cityID).." districtOwnerID: "..tostring(districtOwnerID).." commandType: "..tostring(commandType).." iData: "..tostring(iData),debugcontext)
end

function OnPlayerOperationCompleteTest()
	local debugcontext = "OnPlayerOperationCompleteTest(L)"
	Debug("Started",debugcontext)
end

--========================Government Events================-----
function OnGovernmentChangedTest(playerID, governmentID)
	local debugcontext = "OnGovernmentChangedTest(L)"
	Debug("Started",debugcontext)
	local pPlayer = Players[playerID]
	local playerCiv = PlayerConfigurations[playerID]:GetCivilizationTypeName()
	local governmentName = GameInfo.Governments[governmentID].GovernmentType
	Debug(playerCiv.." with playerID: "..tostring(playerID).." Changed Government to: "..governmentName,debugcontext)	
end

function OnGovernmentPolicyChangedTest(playerID, policyID)
	local debugcontext = "OnGovernmentPolicyChangedTest(L)"
	Debug("Started",debugcontext)
	local pPlayer = Players[playerID]
	local playerCiv = PlayerConfigurations[playerID]:GetCivilizationTypeName()
	local policyName = GameInfo.Policies[policyID].PolicyType
	Debug(playerCiv.." with playerID: "..tostring(playerID).." Changed Policy: "..policyName,debugcontext)
end

function OnGovernmentPolicyObsoletedTest(playerID)
	local debugcontext = "OnGovernmentPolicyObsoletedTest(L)"
	Debug("Started",debugcontext)
	local pPlayer = Players[playerID]
	local playerCiv = PlayerConfigurations[playerID]:GetCivilizationTypeName()
	Debug(playerCiv.." with playerID: "..tostring(playerID).." Has an Obsolete Policy")
end

--===================Religion Events============--------
function OnReligionFoundedTest(playerID, religionID)
	local debugcontext = "OnReligionFoundedTest(L)"
	Debug("Started", debugcontext)
	local pPlayer = Players[playerID]
	local playerCiv = PlayerConfigurations[playerID]:GetCivilizationTypeName()
	Debug(tostring(playerCiv).." with ID: "..tostring(playerID).." Founded Religion with ID: "..tostring(religionID),debugcontext)
end

function OnBeliefAddedTest(playerID, beliefID)
	local debugcontext = "OnBeliefAddedTest(L)"
	Debug("Started",debugcontext)
	local pPlayer = Players[playerID]
	local playerCiv = PlayerConfigurations[playerID]:GetCivilizationTypeName()
	Debug(tostring(playerCiv).." with ID: "..tostring(playerID).." Adopted Belief with ID: "..tostring(beliefID),debugcontext)
end

function OnCityReligionChangedTest(playerID, cityID, eVisibility, city)
	local debugcontext = "OnCityReligionChangedTest(L)"
	Debug("Started",debugcontext)
	local pCity = CityManager.GetCity(playerID, cityID)
	local cityName : string
	if pCity ~= nil then
		cityName = pCity:GetName()
	end
	local cityReligionID = pCity:GetReligion():GetMajorityReligion()
	local pPlayer = Players[playerID]
	local playerCiv = PlayerConfigurations[playerID]:GetCivilizationTypeName()
	Debug(tostring(cityName).." Owned by Player: "..tostring(playerCiv).." with ID: "..tostring(playerID).." Converted to Religion with ID: "..tostring(cityReligionID).." eVisibility: "..tostring( eVisibility).." city: "..tostring(city),debugcontext)
end

function OnCityReligionFollowersChangedTest(playerID, cityID, eVisibility, city)
	local debugcontext = "OnCityReligionFollowersChangedTest(L)"
	Debug("Started",debugcontext)
	local pCity = CityManager.GetCity(playerID, cityID)
	local cityName : string
	if pCity ~= nil then
		cityName = pCity:GetName()
	end
	--local cityReligion = pCity:GetReligion()
	--local str: string = ""
	--for i = -1,24 do
		--if cityReligion:GetNumFollowers(i) ~= 0 then
			--str = str.."Religion ID: "..tostring(i).." Num Followers: "..tostring(cityReligion:GetNumFollowers(i))
		--end
	--end
	local pPlayer = Players[playerID]
	local playerCiv = PlayerConfigurations[playerID]:GetCivilizationTypeName()
	Debug("Religious Followers Changed in: "..tostring(cityName).." Owned by Player: "..tostring(playerCiv).." with ID: "..tostring(playerID).." eVisibility: "..tostring( eVisibility).." city: "..tostring(city),debugcontext)
end

--=======================Congress Events ?=========-------------
function OnDiplomacySessionClosedTest(sessionID)
	local debugcontext = "OnDiplomacySessionClosedTest(L)"
	Debug("Started",debugcontext)
	Debug("Diplo Session with ID: "..tostring(sessionID).." closed",debugcontext)
end

function OnPhaseBeginTest(...)
	local vars = {...}
	local debugcontext = "OnPhaseBeginTest(L)"
	local str = ""
	if #vars>0 then
		for i,var in ipairs(vars) do
			str = str.."Var "..tostring(i)..": "..tostring(var1).." "
		end
	end
	if str ~= "" or str~=nil then
		Debug(str,debugcontext)
	end
	local gamephase = Game.GetPhaseName()
	if gamephase ~= nil then
		Debug(tostring(Game.GetPhaseName()),debugcontext)
	else
		Debug("Started",debugcontext)
	end
end

function OnPhaseEndTest(...)
	local vars = {...}
	local debugcontext = "OnPhaseEndTest(L)"
	local str = ""
	if #vars>0 then
		for i,var in ipairs(vars) do
			str = str.."Var "..tostring(i)..": "..tostring(var1).." "
		end
	end
	if str ~= "" or str~=nil then
		Debug(str,debugcontext)
	end
	local gamephase = Game.GetPhaseName()
	if gamephase ~= nil then
		Debug(tostring(Game.GetPhaseName()),debugcontext)
	else
		Debug("Started",debugcontext)
	end
end

--======Diplo=====----
function OnDiplomacyMeetTest(playerID1,playerID2)
	local debugcontext = "OnDiplomacyMeetTest(L)"
	Debug("Started",debugcontext)
	local pPlayer1 = Players[playerID1]
	local pPlayer1Civ = PlayerConfigurations[playerID1]:GetCivilizationTypeName()
	local p1major = pPlayer1:IsMajor()
	local pPlayer2 = Players[playerID2]
	local pPlayer2Civ = PlayerConfigurations[playerID2]:GetCivilizationTypeName()
	local p2major = pPlayer2:IsMajor()
	Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Met Player: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
end


function OnDiplomacyMeetMajorMinorTest(...)
	local vars = {...}
	local debugcontext = "OnDiplomacyMeetMajorMinorTest(L)"
	Debug("Started",debugcontext)
	local str = ""
	if #vars>0 then
		for i,var in ipairs(vars) do
			str = str.."Var "..tostring(i)..": "..tostring(var1).." "
		end
	end
	if str ~= "" or str~=nil then
		Debug(str,debugcontext)
	end
end

function OnDiplomacyMeetMajorsTest(...)
	local vars = {...}
	local debugcontext = "OnDiplomacyMeetMajorsTest(L)"
	Debug("Started",debugcontext)
	local str = ""
	if #vars>0 then
		for i,var in ipairs(vars) do
			str = str.."Var "..tostring(i)..": "..tostring(var1).." "
		end
	end
	if str ~= "" or str~=nil then
		Debug(str,debugcontext)
	end
end

function OnDiplomacyMakePeaceTest(playerID1, playerID2)
	local debugcontext = "OnDiplomacyMakePeaceTest(L)"
	Debug("Started",debugcontext)
	local pPlayer1 = Players[playerID1]
	local pPlayer1Civ = PlayerConfigurations[playerID1]:GetCivilizationTypeName()
	local p1major = pPlayer1:IsMajor()
	local pPlayer2 = Players[playerID2]
	local pPlayer2Civ = PlayerConfigurations[playerID2]:GetCivilizationTypeName()
	local p2major = pPlayer2:IsMajor()
	Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Made Peace with Player: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
end

function OnInfluenceGivenTest(csID, playerID)
	local debugcontext = "OnInfluenceGivenTest(L)"
	Debug("Started",debugcontext)
	Debug("csID: "..tostring(playerID).." gave envory to playerID: "..tostring(playerID),debugcontext)
end

function OnDiplomacyRelationshipChangedTest(playerID1, playerID2)
	local debugcontext = "OnDiplomacyRelationshipChangedTest(L)"
	Debug("Started",debugcontext)
	local pPlayer1 = Players[playerID1]
	local pPlayer1Civ = PlayerConfigurations[playerID1]:GetCivilizationTypeName()
	local p1major = pPlayer1:IsMajor()
	local pPlayer2 = Players[playerID2]
	local pPlayer2Civ = PlayerConfigurations[playerID2]:GetCivilizationTypeName()
	local p2major = pPlayer2:IsMajor()

	local p1Diplo = pPlayer1:GetDiplomacy()
	if p1Diplo:HasMet(playerID2) then
		Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Diplo Changed Has Met(L) with: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
	end
	if p1Diplo:IsAtWarWith(playerID2) then
		Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Diplo Changed to War(L) with: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
	end
	if not p2major and not pPlayer2:IsBarbarian() then
		Debug("DiploTestPass",debugcontext)
		local p2suzId = pPlayer2:GetInfluence():GetSuzerain()
		if p2suzId == playerID1 then
			Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Diplo Changed to Suz(L) with: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
		end
	else
		if p1Diplo:HasOpenBordersFrom(playerID2) then
			Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Diplo Changed Open Borders(L) from: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
		elseif p1Diplo:HasDelegationAt(playerID2) then
			Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Diplo Changed Has Delegation(L) to: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
		elseif p1Diplo:HasEmbassyAt(playerID2) then
			Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Diplo Changed Has Embassy(L) to: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
		else
			local kParameters:table = {};
			kParameters.value = playerID2
			kParameters.OnStart = "CheckFriendAlly"
			UI.RequestPlayerOperation(playerID1, PlayerOperations.EXECUTE_SCRIPT, kParameters)
		end
	end
end

function OnDiplomacyDeclareWarTest(playerID1, playerID2)
	local debugcontext = "OnDiplomacyDeclareWarTest(L)"
	Debug("Started",debugcontext)
	local pPlayer1 = Players[playerID1]
	local pPlayer1Civ = PlayerConfigurations[playerID1]:GetCivilizationTypeName()
	local p1major = pPlayer1:IsMajor()
	local pPlayer2 = Players[playerID2]
	local pPlayer2Civ = PlayerConfigurations[playerID2]:GetCivilizationTypeName()
	local p2major = pPlayer2:IsMajor()
	Debug(tostring(pPlayer1Civ).." with ID: "..tostring(playerID1).." isMajor: "..tostring(p1major).." Declared War On: "..tostring(pPlayer2Civ).." with ID: "..tostring(playerID2).." isMajor: "..tostring(p2major),debugcontext)
end
--===========Local Player Turn stuff==============
function OnLocalPlayerTurnBeginTest()
	local debugcontext = "OnLocalPlayerTurnBeginTest(L)"
	local locID = Game.GetLocalPlayer()
	Debug("Turn started for playerID: "..tostring(locID),debugcontext)
end

function OnLocalPlayerTurnEndTest()
	local debugcontext = "OnLocalPlayerTurnEndTest(L)"
	local locID = Game.GetLocalPlayer()
	Debug("Turn Ended for playerID: "..tostring(locID),debugcontext)
end

function OnLocalPlayerTurnUnreadyTest()
	local debugcontext = "OnLocalPlayerTurnUnreadyTest(L)"
	local locID = Game.GetLocalPlayer()
	Debug("Turn Unready for playerID: "..tostring(locID),debugcontext)
end

function OnRemotePlayerTurnBeginTest()
	local debugcontext = "OnRemotePlayerTurnBeginTest(L)"
	Debug("Started",debugcontext)
end

function OnRemotePlayerTurnEndTest()
	local debugcontext = "OnRemotePlayerTurnEndTest(L)"
	Debug("Started",debugcontext)
end

function OnRemotePlayerTurnUnreadyTest()
	local debugcontext = "OnRemotePlayerTurnUnreadyTest(L)"
	Debug("Started",debugcontext)
end

function OnPlayerTurnActivatedTest(playerID, bIsFirstTime)
	local debugcontext="OnPlayerTurnActivatedTest(L)"
	Debug("Turn Activated for playerID: "..tostring(playerID).." bIsFirstTime: "..tostring(bIsFirstTime),debugcontext)
end

function OnPlayerTurnDeactivatedTest(playerID)
	local debugcontext="OnPlayerTurnDeactivatedTest(L)"
	Debug("Turn deactivated for playerID: "..tostring(playerID),debugcontext)
end	
--=========Event Actions for Gameplay==========---
function GameID()
	local debugcontext = "GameID(LS)"
	local currentTurn = Game.GetCurrentGameTurn()
	local startTurn = GameConfiguration.GetStartTurn()
	local GAME_ID = GetObjectState(Game,"GameID")
	local pDiplo = Players[0]:GetDiplomacy()
	if currentTurn == startTurn and GAME_ID==nil then
		FindGameID()
	elseif GAME_ID~=nil then
		Debug("GAME_ID detected. GAME_ID = "..tostring(GAME_ID[1]),debugcontext)
		Debug("Turn Started for PlayerID: "..tostring(playerID),debugcontext)
	else
		print("OnPlayerTurnDeactivatedTest(L): Error: NO GAME_ID detected or possible to set")
	end	
end
--=========Functions for Event Actions==========
function FindGameID()
	local debugcontext = "FindGameID(G/S)"
	local locID = Game.GetLocalPlayer()
	local hostID = -1
	if GameConfiguration.IsNetworkMultiplayer() then
		hostID = Network.GetGameHostPlayerID()
	else
		hostID = Game.GetLocalPlayer()
	end
	if GameConfiguration.GetValue('BBGTS_DEBUG_LUA') == false then
		return
	end

	Debug("Delta Debug Timer Started",debugcontext)
	if locID==hostID then
		local time, float = math.modf(Automation.GetTime())
		local GAME_ID = {}
		GAME_ID[1] = time
		newint, newfloat = math.modf(float*1000)
		GAME_ID[2] = newint/1000
		--Debug("Time: "..tostring(time),debugcontext)
		SetObjectState(Game,"GameID", GAME_ID)
		--Debug("GameID Set as "..tostring(locID).." PlayerID's: "..tostring(GAME_ID[1]).." starting time",debugcontext)
	end
end

--===========Scripts That Will Affect GamePlay========
function Initialize()
	Events.LocalPlayerTurnBegin.Add(GameID)
	--===========Local Player Turn stuff==============
	Events.LocalPlayerTurnBegin.Add(OnLocalPlayerTurnBeginTest)
	Events.LocalPlayerTurnEnd.Add(OnLocalPlayerTurnEndTest)
	Events.LocalPlayerTurnUnready.Add(OnLocalPlayerTurnUnreadyTest)
	Events.PlayerTurnActivated.Add(OnPlayerTurnActivatedTest)
	Events.PlayerTurnDeactivated.Add(OnPlayerTurnDeactivatedTest)
	Events.RemotePlayerTurnBegin.Add(OnRemotePlayerTurnBeginTest)
	Events.RemotePlayerTurnEnd.Add(OnRemotePlayerTurnEndTest)
	Events.RemotePlayerTurnUnready.Add(OnRemotePlayerTurnUnreadyTest)
	----=========Units(incl Spy): Add Remove Capture==========----
	Events.UnitCaptured.Add(OnUnitCapturedTest)
	Events.SpyRemoved.Add(OnSpyRemoveTest)
	Events.SpyAdded.Add(OnSpyAddedTest)
	Events.UnitRemovedFromMap.Add(OnUnitRemovedFromMapTest)
	Events.UnitAddedToMap.Add(OnUnitAddedToMapTest)
	--===========City Events========------
	Events.CityRemovedFromMap.Add(OnCityRemovedFromMapTest)
	Events.CityLiberated.Add(OnCityLiberatedTest)
	----===========District Events=====---------
	Events.DistrictAddedToMap.Add(OnDistrictAddedToMapTest)
	Events.DistrictPillaged.Add(OnDistrictPillagedTest)
	Events.DistrictRemovedFromMap.Add(OnDistrictRemovedFromMapTest)
	Events.DistrictBuildProgressChanged.Add(OnDistrictBuildProgressChangedTest)
	--============Building Events============----
	Events.BuildingAddedToMap.Add(OnBuildingAddedToMapTest)
	Events.BuildingChanged.Add(OnBuildingChangedTest)
	--=============City Build/Purchase========---
	Events.CityProductionCompleted.Add(OnCityProductionCompletedTest)
	Events.CityProductionChanged.Add(OnCityProductionChangedTest)
	Events.CityProjectCompleted.Add(OnCityProjectCompletedTest)
	Events.CityMadePurchase.Add(OnCityMadePurchaseTest)
	--====================Improvement Events================------------
	Events.ImprovementActivated.Add(OnImprovementActivatedTest)
	Events.ImprovementAddedToMap.Add(OnImprovementAddedToMapTest)
	Events.ImprovementChanged.Add(OnImprovementChangedTest)
	Events.ImprovementRemovedFromMap.Add(OnImprovementRemovedFromMapTest)
	--================Unit/City/District combat/movement events==============---
	Events.Combat.Add(OnCombatTest)
	Events.DistrictDamageChanged.Add(OnDistrictDamageChangedTest)
	Events.UnitDamageChanged.Add(OnUnitDamageChangedTest)
	Events.UnitKilledInCombat.Add(OnUnitKilledInCombatTest)
	Events.UnitMoveComplete.Add(OnUnitMoveCompleteTest)
	Events.UnitMoved.Add(OnUnitMovedTest)
	Events.UnitTeleported.Add(OnUnitTeleportedTest)
	--============Operations and commands======--
	Events.UnitOperationAdded.Add(OnUnitOperationAddedTest)
	Events.UnitOperationDeactivated.Add(OnUnitOperationDeactivatedTest)
	Events.UnitOperationSegmentComplete.Add(OnUnitOperationSegmentCompleteTest)
	Events.UnitOperationStarted.Add(OnUnitOperationStartedTest)
	Events.UnitOperationsCleared.Add(OnUnitOperationsClearedTest)
	Events.UnitCommandStarted.Add(OnUnitCommandStartedTest)
	Events.CityCommandStarted.Add(OnCityCommandStartedTest)
	Events.PlayerOperationComplete.Add(OnPlayerOperationCompleteTest)
	--========================Government Events================-----
	Events.GovernmentChanged.Add(OnGovernmentChangedTest)
	Events.GovernmentPolicyChanged.Add(OnGovernmentPolicyChangedTest)
	Events.GovernmentPolicyObsoleted.Add(OnGovernmentPolicyObsoletedTest)
	--===================Religion Events============--------
	Events.ReligionFounded.Add(OnReligionFoundedTest)
	Events.BeliefAdded.Add(OnBeliefAddedTest)
	Events.CityReligionChanged.Add(OnCityReligionChangedTest)
	Events.CityReligionFollowersChanged.Add(OnCityReligionFollowersChangedTest)
	--=======================Congress Events ?=========-------------
	--======Diplo=====----
	Events.DiplomacyMeet.Add(OnDiplomacyMeetTest)
	Events.DiplomacyMeetMajorMinor.Add(OnDiplomacyMeetMajorMinorTest)
	Events.DiplomacyMeetMajors.Add(OnDiplomacyMeetMajorsTest)
	Events.DiplomacyMakePeace.Add(OnDiplomacyMakePeaceTest)
	Events.InfluenceGiven.Add(OnInfluenceGivenTest)
	Events.DiplomacyDeclareWar.Add(OnDiplomacyDeclareWarTest)
	Events.DiplomacyRelationshipChanged.Add(OnDiplomacyRelationshipChangedTest)
end

Initialize()