function KotokuAddMonks(iX, iY, buildingID, playerID, cityID, iPercentComplete, iUnknown)
	print('Wonder Completed Triggered')
	if Players[playerID]==nil then
		return
	end
	local pPlayer = Players[playerID]
	local pCity = CityManager.GetCity(playerID, cityID)
	
	if pCity == nil then
		return
	end
	
	if GameInfo.Buildings[buildingID].BuildingType ~= 'BUILDING_KOTOKU_IN' then
		return
	end
	print('Kotoku Built')

	local kotokuCity = {}
	kotokuCity.ID = cityID
	kotokuCity.status = false

	if pCity:GetReligion():GetMajorityReligion() == -1 then
		Game:SetProperty('KOTOKU_CITY', kotokuCity);
		print('Monks Cannot Recruit, no Religion')
		return
	end

	for row in GameInfo.Units() do
		if row.UnitType == 'UNIT_WARRIOR_MONK' then
			pCity:SetUnitFaithPurchaseEnabled(row.Index, true)
			kotokuCity.status = true
		end
	end

	Game:SetProperty('KOTOKU_CITY', kotokuCity);
	print('Monks Can Recruit')
end


function OnKotokuReligionChanged(playerID, cityID, eVisibility, city)
	print('City Converted Triggered')
	if Game:GetProperty('KOTOKU_CITY') == nil then
		return
	end

	local kotokuStatus = Game:GetProperty('KOTOKU_CITY')

	if cityID ~= kotokuStatus.ID then
		return
	end

	local pCity = CityManager.GetCity(playerID, cityID)

	if pCity == nil then
		return
	end

	print('Kotoku City Converted')

	if pCity:GetReligion():GetMajorityReligion() == -1 and kotokuStatus.status== true then

		kotokuStatus.status = false
		for row in GameInfo.Units() do
			if row.UnitType == 'UNIT_WARRIOR_MONK' then
				pCity:SetUnitFaithPurchaseEnabled(row.Index, false)
			end
		end

		print('Converted to -1 Cannot Recruit')
	end


	if pCity:GetReligion():GetMajorityReligion() ~= -1 and kotokuStatus.status== false then

		kotokuStatus.status = true
		for row in GameInfo.Units() do
			if row.UnitType == 'UNIT_WARRIOR_MONK' then
				pCity:SetUnitFaithPurchaseEnabled(row.Index, true)
			end
		end
		print('Converted to Religion can Recruit')
	end

	Game:SetProperty('KOTOKU_CITY', kotokuStatus)	
end

function OnKotokuCityRazed(playerID, cityID)
	print('City Razed Triggered')
	if Game:GetProperty('KOTOKU_CITY') == nil then
		return
	end
	local kotokuStatus = Game:GetProperty('KOTOKU_CITY')

	if cityID ~= kotokuStatus.ID then
		return
	end
	print('Kotoku City Razed')
	Game:SetProperty('KOTOKU_CITY', nil)
	print('Kotoku Property Released')
end

function Initialize()
	print('Monk Kotoku Started')
	Events.WonderCompleted.Add(KotokuAddMonks)
	Events.CityReligionChanged.Add(OnKotokuReligionChanged)
	Events.CityRemovedFromMap.Add(OnKotokuCityRazed)
end

Initialize()