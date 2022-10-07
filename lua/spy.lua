function OnSpyCapture(currentUnitOwner, unitID, owningPlayer, capturingPlayer)
	local u1 = UnitManager.GetUnit(currentUnitOwner, unitID);
	local u2= UnitManager.GetUnit(currentUnitOwner, owningPlayer);
	local u3= UnitManager.GetUnit(capturingPlayer, owningPlayer)
	print('id1',u1,'id2',u2, 'id3', u3);
	print('Owner',currentUnitOwner,'unitID',unitID, 'owningPlayer', owningPlayer, 'capturingPlayer', capturingPlayer)
	if u1~=nil then
		print('u1 was', GameInfo.Units[u1:GetUnitType()].UnitType)
	end
	if u2~=nil then
		print('u2 was', GameInfo.Units[u2:GetUnitType()].UnitType)
	end
	if u3~=nil then
		print('u3 was', GameInfo.Units[u3:GetUnitType()].UnitType)
	end
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
	local u1 = UnitManager.GetUnit(currentUnitOwner, spyUnitID);
	if u1~=nil then
		print('u1 was', GameInfo.Units[u1:GetUnitType()].UnitType)
	end
end

function UnitKilled(currentUnitOwner, unitID)
	print('UnitKilled Spy Test')
	print('Owner',currentUnitOwner,'id', unitID)
	local u1 = UnitManager.GetUnit(currentUnitOwner, unitID);
	if u1~=nil then
		print('u1 was', GameInfo.Units[u1:GetUnitType()].UnitType)
	end
end

function Initialize()
	print("Spy Test On")
	Events.UnitCaptured.Add(OnSpyCapture)
	Events.SpyRemoved.Add(OnSpyRemoveTest)
	Events.SpyAdded.Add(OnSpyAddedTest)
	Events.UnitRemovedFromMap.Add(UnitKilled)
end

Initialize()
