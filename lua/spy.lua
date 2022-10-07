function OnSpyCapture(currentUnitOwner, unitID, owningPlayer, capturingPlayer)
	local u1 = UnitManager.GetUnit(currentUnitOwner, unitID);
	local u2= UnitManager.GetUnit(currentUnitOwner, owningPlayer);
	local u3= UnitManager.GetUnit(capturingPlayer, owningPlayer)
	print('id1',u1,'id2',u2, 'id3', u3);
	print('Owner',currentUnitOwner,'unitID',unitID, 'owningPlayer', owningPlayer, 'capturingPlayer', capturingPlayer)
end

function OnSpyRemoveTest(spyOwner, counterspyPlayer)
	print('Owner', spyOwner, 'Counter')
end

function OnSpyAddedTest(spyOwner, spyUnitID)
	print('Owner',spyOwner,'id', spyUnitID)
end

function Initialize()
	Events.UnitCapture.Add(OnSpyCapture)
	Events.SpyRemoved.Add(OnSpyRemoveTest)
	Events.SpyAdded.Add(OnSpyAddedTest)
end

Initialize()
