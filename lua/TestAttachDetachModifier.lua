function  OnWarriorBuilt(playerID, cityID, iConstructionType, unitID, bCancelled)
	print('WarriorBuilt')
	local pPlayer = Players[playerID]

	if pPlayer == nil then
		return
	end

	if PlayerConfigurations[playerID]:GetLeaderTypeName()~='LEADER_ALEXANDER' then
		return
	end

	local pCity = City(playerID, cityID)
	
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
	print('Slinger Built')
	local pPlayer = Players[playerID]

	if pPlayer == nil then
		return
	end

	if PlayerConfigurations[playerID]:GetLeaderTypeName()~='LEADER_ALEXANDER' then
		return
	end

	local pCity = City(playerID, cityID)
	
	if pCity == nil then
		return
	end

	if GameInfo.Units[unitID].UnitType == 'UNIT_SLINGER' then
		print('Slinger Built')
		pPlayer:AttachModifierByID('ALEX_PRODUCTION', false)
		print("Modifier Detached")
	end
end

function Initialize()
	Events.CityProductionCompleted.Add(OnWarriorBuilt)
	Events.CityProductionCompleted.Add(OnSlingerBuilt)
end

Initialize()