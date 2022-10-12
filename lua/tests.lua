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

function OnStartAddStats(pPlayer)
	--MP cheats for testing
	local pTreasury = pPlayer:GetTreasury()
	--start with 1kk gold 1kk faith 42 gov titles and 10k favour 100 envoys
	pTreasury:ChangeGoldBalance(1000000)
	local pReligion = pPlayer:GetReligion()
    pReligion:ChangeFaithBalance(1000000)
    pPlayer:GetGovernors():ChangeGovernorPoints(42);
    if pPlayer:GetDiplomacy().ChangeFavor ~= nil then
		pPlayer:GetDiplomacy():ChangeFavor(10000);
	end
	local pEnvoy = pPlayer:GetInfluence()
    pEnvoy:ChangeTokensToGive(100)
	--Set free granted techs (database index -1)
	--flight, advanced flight, stealth, construction for terractota
	local freetechs = {17, 43, 50, 63}
	--Set free granted civics (database index - 1)
	--diplo service, political and monarchy for t2 gov building to put in cards for faster missions
	local freeculture = {8,20,23}
	for i, index in ipairs(freetechs) do
		local pTechs = pPlayer:GetTechs()
		pTechs:SetResearchProgress(index, pTechs:GetResearchCost(index))
	end
	for i, index in ipairs(culture) do
		local pCulture = pPlayer:GetCulture()
		pCulture:SetCulturalProgress(index, pTechs:GetCultureCost(index))
	end
	--Attach +20 spy capacity modifier
	pPlayer:AttachModifierByID('BBG_TEST_GIVE_20_SPY_CAPACITY');
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

function Initialize()

	print("BBG - Gameplay Script Launched")
	local currentTurn = Game.GetCurrentGameTurn()
	local startTurn = GameConfiguration.GetStartTurn()
	
	if currentTurn == startTurn then


	end
	Events.UnitCaptured.Add(OnSpyCapture)
	Events.SpyRemoved.Add(OnSpyRemoveTest)
	Events.SpyAdded.Add(OnSpyAddedTest)
	Events.UnitRemovedFromMap.Add(UnitKilled)
end

Initialize();

