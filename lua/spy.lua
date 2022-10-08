function OnSpyCapture(currentUnitOwner, unitID, owningPlayer, capturingPlayer)
	print('Spy Capture Test')
	local u1 = UnitManager.GetUnit(currentUnitOwner, unitID);
	local u2= UnitManager.GetUnit(owningPlayer, unitID);
	local u3= UnitManager.GetUnit(capturingPlayer, unitID)
	print('id1',u1,'id2',u2, 'id3', u3);
	print('Owner',currentUnitOwner,'unitID',unitID, 'owningPlayer', owningPlayer, 'capturingPlayer', capturingPlayer)
	if u1~=nil then
		print('u1 was', GameInfo.Units[u1:GetType()].UnitType)
	end
	if u2~=nil then
		print('u2 was', GameInfo.Units[u2:GetType()].UnitType)
	end
	if u3~=nil then
		print('u3 was', GameInfo.Units[u3:GetType()].UnitType)
	end
	for i = 0, 64 do
		local unit = UnitManager.GetUnit(i, unitID)
		if unit ~= nil then
			print('Real Owner ID', i)
		end
	end
	print("Spy is trully deleted")
end

function OnSpyRemoveTest(spyOwner, counterspyPlayer)
	print('Spy Remove Test')
	print('Owner', spyOwner, 'Counter', counterspyPlayer)
	--local u1 = UnitManager.GetUnit(currentUnitOwner, unitID);
	--if u1~=nil then
		--print('u1 was', GameInfo.Units[u1:GetUnitType()].UnitType)
	--end
end

function OnSpyAddedTest(spyOwner, spyUnitID)
	print('Spy Added Test')
	print('Owner',spyOwner,'id', spyUnitID)
	local u1 = UnitManager.GetUnit(spyOwner, spyUnitID);
	if u1==nil then
		return
	end
	print('u1 was', GameInfo.Units[u1:GetType()].UnitType)
	return
end

function UnitKilled(currentUnitOwner, unitID)
	print('UnitKilled Spy Test')
	print('Owner',currentUnitOwner,'id', unitID)
	local unit = UnitManager.GetUnit(currentUnitOwner, unitID);
	if unit==nil then
		return
	end
	local type = GameInfo.Units[unit:GetType()].UnitType
	print('u1 was', type)
	return
end

function Initialize()
	print("Spy Test On")
	for i = 0, 64 do
		local unit = UnitManager.GetUnit(i, 851980)
		if unit ~= nil then
			print('Real Owner ID', i)
		end
	end
	print("Spy is trully dead")
	Events.UnitCaptured.Add(OnSpyCapture)
	Events.SpyRemoved.Add(OnSpyRemoveTest)
	Events.SpyAdded.Add(OnSpyAddedTest)
	Events.UnitRemovedFromMap.Add(UnitKilled)
end

Initialize()
