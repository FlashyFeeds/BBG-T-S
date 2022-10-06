function  OnWarriorBuilt(playerID, cityID, iConstructionType, unitID, bCancelled)

	local pPlayer = Players[playerID]

	if pPlayer == nil then
		return
	end

	if PlayerConfigurations[playerID]:GetLeaderTypeName()~='LEADER_ALEXANDER' then
		return
	end

	local pCity = CityManager.GetCity(playerID, cityID)
	
	if pCity == nil then
		return
	end

	if GameInfo.Units[unitID].UnitType == 'UNIT_WARRIOR' then
		print('WarriorBuilt')
		pPlayer:AttachModifierByID('ALEX_PRODUCTION')
		print("Modifier Attached")
	end
end

function OnSlingerBuilt(playerID, cityID, iConstructionType, unitID, bCancelled)

	local pPlayer = Players[playerID]

	if pPlayer == nil then
		return
	end

	if PlayerConfigurations[playerID]:GetLeaderTypeName()~='LEADER_ALEXANDER' then
		return
	end

	local pCity = CityManager.GetCity(playerID, cityID)
	
	if pCity == nil then
		return
	end

	if GameInfo.Units[unitID].UnitType == 'UNIT_SLINGER' then
		print('Slinger Built')
		pPlayer:DetachModifier('ALEX_PRODUCTION')
		print("Modifier Detached")
	end
end

function Initialize()
	Events.CityProductionCompleted.Add(OnWarriorBuilt)
	Events.CityProductionCompleted.Add(OnSlingerBuilt)
end


Initialize()