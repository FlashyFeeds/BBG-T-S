include("WorldCongress")

-- ===========================================================================

GameEvents.WC_Validate_LuxuryBan.RemoveAll()

function Def_WC_Validate_LuxuryBan(resolutionType, playerId, options)
	-- Need to only determine this once.
	if(cachedLuxuryResources == nil) then
		cachedLuxuryResources = {};
		for row in GameInfo.Resources() do
			if(row.ResourceClassType == "RESOURCECLASS_LUXURY" and (row.Frequency > 0 or row.SeaFrequency> 0)) then
				if(Map.GetResourceCount(row.Hash) > 0) then
					table.insert(cachedLuxuryResources, row.Hash);
				end
			end
		end
	end
	
	-- Assign valid resources to only be luxury resources.
	options.ResolutionOptions = cachedLuxuryResources;
end

print('WC_Validate_LuxuryBan has', GameEvents.WC_Validate_LuxuryBan.Count())
GameEvents.WC_Validate_LuxuryBan.Add(Def_WC_Validate_LuxuryBan)
print('WC_Validate_LuxuryBan has', GameEvents.WC_Validate_LuxuryBan.Count())

-- ===========================================================================

GameEvents.WC_Validate_PowerResourceBan.RemoveAll()

function Def_WC_Validate_PowerResourceBan(resolutionType, playerId, options)
	if(cachedPowerResources == nil) then
		cachedPowerResources = {};
		
		for row in GameInfo.Resource_Consumption() do
			local resource = GameInfo.Resources[row.ResourceType];
			if(resource and resource.PowerProvided ~= 0) then
				table.insert(cachedPowerResources, resource.Hash);
			end
		end
	end
	
	-- Assign valid resources to only be luxury resources.
	options.ResolutionOptions = cachedPowerResources;
end

print('WC_Validate_PowerResourceBan has', GameEvents.WC_Validate_PowerResourceBan.Count())
GameEvents.WC_Validate_PowerResourceBan.Add(Def_WC_Validate_PowerResourceBan)
print('WC_Validate_LuxuryBan has', GameEvents.WC_Validate_LuxuryBan.Count())

-- ===========================================================================

GameEvents.WC_Validate_PowerBuilding.RemoveAll()

function Def_WC_Validate_PowerBuilding(resolutionType, playerId, options)
	if(cachedPowerBuildingTypes == nil) then
		cachedPowerBuildingTypes = {};
		
		for row in GameInfo.Buildings() do
			if(row.BuildingType == "BUILDING_COAL_POWER_PLANT") then
				table.insert(cachedPowerBuildingTypes, row.Hash);
			end
			if(row.BuildingType == "BUILDING_FOSSIL_FUEL_POWER_PLANT") then
				table.insert(cachedPowerBuildingTypes, row.Hash);
			end
			if(row.BuildingType == "BUILDING_POWER_PLANT") then
				table.insert(cachedPowerBuildingTypes, row.Hash);
			end
		end
	end
	
	-- Assign valid buildings to only be Power providing types
	options.ResolutionOptions = cachedPowerBuildingTypes;
end;

print('WC_Validate_PowerBuilding has', GameEvents.WC_Validate_PowerBuilding.Count())
GameEvents.WC_Validate_PowerBuilding.Add(Def_WC_Validate_PowerBuilding)
print('WC_Validate_PowerBuilding has', GameEvents.WC_Validate_PowerBuilding.Count())

-- ===========================================================================

GameEvents.WC_ValidateGovernanceDoctrine.RemoveAll()

function Def_WC_ValidateGovernanceDoctrine(resolutionType, playerId, options)
	if (cachedGovernorTypes == nil) then
		cachedGovernorTypes = {};

		for row in GameInfo.Governors() do
			if (row.TraitType == nil) then
				table.insert(cachedGovernorTypes, row.Hash);
			end
		end
	end

	-- Assign valid Governor types
	options.ResolutionOptions = cachedGovernorTypes;
end;

print('WC_ValidateGovernanceDoctrine', GameEvents.WC_ValidateGovernanceDoctrine.Count())
GameEvents.WC_ValidateGovernanceDoctrine.Add(Def_WC_ValidateGovernanceDoctrine)
print('WC_ValidateGovernanceDoctrine', GameEvents.WC_ValidateGovernanceDoctrine.Count())

-- ===========================================================================
GameEvents.WC_Validate_GreatWorkObjects.RemoveAll()

function Def_WC_Validate_GreatWorkObjects(resolutionType, playerId, options)
	-- Add filtering here if necessary
end;

print('WC_Validate_GreatWorkObjects', GameEvents.WC_Validate_GreatWorkObjects.Count())
GameEvents.WC_Validate_GreatWorkObjects.Add(Def_WC_Validate_GreatWorkObjects)
print('WC_Validate_GreatWorkObjects', GameEvents.WC_Validate_GreatWorkObjects.Count())
-- ===========================================================================

GameEvents.WC_Validate_PolicyTreaty.RemoveAll()

function Def_WC_Validate_PolicyTreaty(resolutionType, playerId, options)
	cachedPolicyTypes = {};

	local pPlayerCulture : object = Players[playerId]:GetCulture();
	if (pPlayerCulture ~= nil) then

		for row in GameInfo.Policies() do
			if (pPlayerCulture:IsPolicyUnlocked(row.Hash) and not pPlayerCulture:IsPolicyObsolete(row.Hash)) then
				table.insert(cachedPolicyTypes, row.Hash);
			end
		end
	end

	options.ResolutionOptions = cachedPolicyTypes;
end;
print('WC_Validate_PolicyTreaty', GameEvents.WC_Validate_PolicyTreaty.Count())
GameEvents.WC_Validate_PolicyTreaty.Add(Def_WC_Validate_PolicyTreaty)
print('WC_Validate_PolicyTreaty', GameEvents.WC_Validate_PolicyTreaty.Count())
-- ===========================================================================

GameEvents.WC_Validate_WorldIdeology.RemoveAll()

function Def_Validate_WorldIdeology(resolutionType, playerId, options)
	if (cachedWildcardGovtTypes == nil) then
		cachedWildcardGovtTypes = {};

		for row in GameInfo.Governments() do
			-- Only permit governments that contain Wildcard slots by default
			local bHasWildcards : boolean = false;
			for slotsRow in GameInfo.Government_SlotCounts() do
				if (slotsRow.GovernmentType == row.GovernmentType and slotsRow.GovernmentSlotType == "SLOT_WILDCARD") then
					bHasWildcards = true;
					break;
				end
			end

			if (bHasWildcards == true) then
				table.insert(cachedWildcardGovtTypes, row.Hash);
			end
		end
	end

	options.ResolutionOptions = cachedWildcardGovtTypes;
end;
print('WC_Validate_WorldIdeology', GameEvents.WC_Validate_WorldIdeology.Count())
GameEvents.WC_Validate_WorldIdeolog.Add(Def_Validate_WorldIdeology)
print('WC_Validate_WorldIdeology', GameEvents.WC_Validate_WorldIdeology.Count())
-- ===========================================================================

GameEvents.WC_Validate_UrbanDevelopment.RemoveAll()

function Def_WC_Validate_UrbanDevelopment(resolutionType, playerId, options)
	if(cachedDistrictTypes == nil) then
		cachedDistrictTypes = {};
		
		for row in GameInfo.Districts() do
			if (row.DistrictType == "DISTRICT_CITY_CENTER") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_HOLY_SITE") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_CAMPUS") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_ENCAMPMENT") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_HARBOR") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_AERODROME") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_COMMERCIAL_HUB") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_ENTERTAINMENT_COMPLEX") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_THEATER") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_INDUSTRIAL_ZONE") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_GOVERNMENT") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_WATER_ENTERTAINMENT_COMPLEX") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_DIPLOMATIC_QUARTER") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_PRESERVE") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
		end
	end

	-- Build a second list including only those Districts which are applicable in the current era
	local outputDistricts:table = {};
	
	local currentEra	= Game.GetEras():GetCurrentEra();
	local kEraData		:table  = GameInfo.Eras[currentEra];
	local iEraSort		:number = kEraData.ChronologyIndex;

	for _, row in ipairs(cachedDistrictTypes) do
		local pDistrictInfo	:table = GameInfo.Districts[row];

		local allowed:boolean = true;
		if (pDistrictInfo.PrereqCivic and pDistrictInfo.PrereqCivic ~= "") then
			local kPrereq	:table = GameInfo.Civics[pDistrictInfo.PrereqCivic];
			local kEra		= kPrereq.EraType;
			local kEraDef	:table = GameInfo.Eras[kEra];
			local iOtherEraSort	:number = kEraDef.ChronologyIndex;
			if (iOtherEraSort > iEraSort) then
				allowed = false;
			end
		end

		if (pDistrictInfo.PrereqTech and pDistrictInfo.PrereqTech ~= "") then
			local kPrereq	:table = GameInfo.Technologies[pDistrictInfo.PrereqTech];
			local kEra		= kPrereq.EraType;
			local kEraDef	:table = GameInfo.Eras[kEra];
			local iOtherEraSort	:number = kEraDef.ChronologyIndex;
			if (iOtherEraSort > iEraSort) then
				allowed = false;
			end
		end

		if allowed then
			table.insert(outputDistricts, row);
		end
	end
	
	-- Assign valid buildings to only be Power providing types
	options.ResolutionOptions = outputDistricts;
end;

print('WC_Validate_UrbanDevelopment', GameEvents.WC_Validate_UrbanDevelopment.Count())
GameEvents.WC_Validate_UrbanDevelopment.Add(Def_WC_Validate_UrbanDevelopment)
print('WC_Validate_UrbanDevelopment', GameEvents.WC_Validate_UrbanDevelopment.Count())
-- ===========================================================================

GameEvents.WC_Validate_BorderControl.RemoveAll()
function Def_WC_Validate_BorderControl(resolutionType, playerId, options)
	cachedPlayers = {};
		
	local aPlayers:table = PlayerManager.GetAliveMajors();
	local pDiplomacy:table = Players[playerId]:GetDiplomacy();
	for _, pPlayer in ipairs(aPlayers) do
		if(pPlayer ~= nil) then
			local loopPlayerID:number = pPlayer:GetID();
			local playerMet:boolean = pDiplomacy:HasMet(loopPlayerID);
			if playerMet then
				table.insert(cachedPlayers, loopPlayerID);
			elseif (loopPlayerID == playerId) then
				table.insert(cachedPlayers, loopPlayerID);
			end
		end
	end

	-- Assign valid options
	options.ResolutionOptions = cachedPlayers;
end;

print('WC_Validate_BorderControl', GameEvents.WC_Validate_BorderControl.Count())
GameEvents.WC_Validate_BorderControl.Add(Def_WC_Validate_BorderControl)
print('WC_Validate_BorderControl', GameEvents.WC_Validate_BorderControl.Count())
-- ===========================================================================

GameEvents.WC_Validate_MigrationTreaty.RemoveAll()

function Def_WC_Validate_MigrationTreaty(resolutionType, playerId, options)
	cachedPlayers = {};
		
	local aPlayers:table = PlayerManager.GetAliveMajors();
	local pDiplomacy:table = Players[playerId]:GetDiplomacy();
	for _, pPlayer in ipairs(aPlayers) do
		if(pPlayer ~= nil) then
			local loopPlayerID:number = pPlayer:GetID();
			local playerMet:boolean = pDiplomacy:HasMet(loopPlayerID);
			if playerMet then
				table.insert(cachedPlayers, loopPlayerID);
			elseif (loopPlayerID == playerId) then
				table.insert(cachedPlayers, loopPlayerID);
			end
		end
	end

	-- Assign valid options
	options.ResolutionOptions = cachedPlayers;
end;

print('WC_Validate_MigrationTreaty', GameEvents.WC_Validate_MigrationTreaty.Count())
GameEvents.WC_Validate_MigrationTreaty.Add(Def_WC_Validate_MigrationTreaty)
print('WC_Validate_MigrationTreaty', GameEvents.WC_Validate_MigrationTreaty.Count())
-- ===========================================================================

GameEvents.WC_Validate_PublicWorks.RemoveAll()

function Def_WC_Validate_PublicWorks(resolutionType, playerId, options)
	if(cachedProjects == nil) then
		cachedProjects = {};
		
		for row in GameInfo.Projects() do
			if (row.SpaceRace == true or row.WMD) then
				table.insert(cachedProjects, row.Hash);
			end
		end
	end
	
	-- Assign valid options
	options.ResolutionOptions = cachedProjects;
end;

print('WC_Validate_PublicWorks', GameEvents.WC_Validate_PublicWorks.Count())
GameEvents.WC_Validate_PublicWorks.Add(Def_WC_Validate_PublicWorks)
print('WC_Validate_PublicWorks', GameEvents.WC_Validate_PublicWorks.Count())

-- ===========================================================================

GameEvents.WC_Validate_Patronage.RemoveAll()
function Def_WC_Validate_Patronage(resolutionType, playerId, options)
	cachedGreatPeopleClasses = {};
		
	local pGreatPeople : table  = Game.GetGreatPeople();
	if (pGreatPeople == nil) then
		return;
	end

	for row in GameInfo.GreatPersonClasses() do
		if (pGreatPeople:IsClassAvailable(row.Index)) then
			table.insert(cachedGreatPeopleClasses, row.Hash);
		end
	end
	
	-- Assign valid options
	options.ResolutionOptions = cachedGreatPeopleClasses;
end;

print('WC_Validate_Patronage', GameEvents.WC_Validate_Patronage.Count())
GameEvents.WC_Validate_Patronage.Add(Def_WC_Validate_Patronage)
print('WC_Validate_Patronage', GameEvents.WC_Validate_Patronage.Count())
-- ===========================================================================

GameEvents.WC_Validate_DeforestationFeature.RemoveAll()

function Def_WC_Validate_DeforestationFeature(resolutionType, playerId, options)
	if(cachedFeatureTypes == nil) then
		cachedFeatureTypes = {};
		
		for row in GameInfo.Features() do
			if (row.FeatureType == "FEATURE_MARSH") then
				table.insert(cachedFeatureTypes, row.Hash);
			end
			if (row.FeatureType == "FEATURE_FOREST") then
				table.insert(cachedFeatureTypes, row.Hash);
			end
			if (row.FeatureType == "FEATURE_JUNGLE") then
				table.insert(cachedFeatureTypes, row.Hash);
			end
		end
	end
	
	-- Assign valid options
	options.ResolutionOptions = cachedFeatureTypes;
end;

print('WC_Validate_DeforestationFeature', GameEvents.WC_Validate_DeforestationFeature.Count())
GameEvents.WC_Validate_DeforestationFeature.Add(Def_WC_Validate_DeforestationFeature)
print('WC_Validate_DeforestationFeature', GameEvents.WC_Validate_DeforestationFeature.Count())

-- ===========================================================================
GameEvents.WC_Validate_ArmsControlTreaty.RemoveAll()

function Def_WC_Validate_ArmsControlTreaty(resolutionType, playerId, options)
	cachedPlayers = {};
		
	local aPlayers:table = PlayerManager.GetAliveMajors();
	local pDiplomacy:table = Players[playerId]:GetDiplomacy();
	for _, pPlayer in ipairs(aPlayers) do
		if(pPlayer ~= nil) then
			local loopPlayerID:number = pPlayer:GetID();
			local playerMet:boolean = pDiplomacy:HasMet(loopPlayerID);
			if playerMet then
				table.insert(cachedPlayers, loopPlayerID);
			elseif (loopPlayerID == playerId) then
				table.insert(cachedPlayers, loopPlayerID);
			end
		end
	end

	-- Assign valid options
	options.ResolutionOptions = cachedPlayers;
end;

print('WC_Validate_ArmsControlTreaty', GameEvents.WC_Validate_ArmsControlTreaty.Count())
GameEvents.WC_Validate_ArmsControlTreaty.Add(Def_WC_Validate_ArmsControlTreaty)
print('WC_Validate_ArmsControlTreaty', GameEvents.WC_Validate_ArmsControlTreaty.Count())

-- ===========================================================================
GameEvents.WC_Validate_TradeTreaty.RemoveAll()

function Def_WC_Validate_TradeTreaty(resolutionType, playerId, options)
	cachedPlayers = {};
		
	local aPlayers:table = PlayerManager.GetAliveMajors();
	local pDiplomacy:table = Players[playerId]:GetDiplomacy();
	for _, pPlayer in ipairs(aPlayers) do
		if(pPlayer ~= nil) then
			local loopPlayerID:number = pPlayer:GetID();
			local playerMet:boolean = pDiplomacy:HasMet(loopPlayerID);
			if playerMet then
				table.insert(cachedPlayers, loopPlayerID);
			elseif (loopPlayerID == playerId) then
				table.insert(cachedPlayers, loopPlayerID);
			end
		end
	end

	-- Assign valid options
	options.ResolutionOptions = cachedPlayers;
end;

print('WC_Validate_TradeTreaty', GameEvents.WC_Validate_TradeTreaty.Count())
GameEvents.WC_Validate_TradeTreaty.Add(Def_WC_Validate_TradeTreaty)
print('WC_Validate_TradeTreaty', GameEvents.WC_Validate_TradeTreaty.Count())

-- ===========================================================================
GameEvents.WC_Validate_DiploVictory.RemoveAll()

function Def_WC_Validate_DiploVictory(resolutionType, playerId, options)
	cachedPlayers = {};
		
	local aPlayers:table = PlayerManager.GetAliveMajors();
	local pDiplomacy:table = Players[playerId]:GetDiplomacy();
	for _, pPlayer in ipairs(aPlayers) do
		if(pPlayer ~= nil) then
			local loopPlayerID:number = pPlayer:GetID();
			local playerMet:boolean = pDiplomacy:HasMet(loopPlayerID);
			if playerMet then
				table.insert(cachedPlayers, loopPlayerID);
			elseif (loopPlayerID == playerId) then
				table.insert(cachedPlayers, loopPlayerID);
			end
		end
	end

	-- Assign valid options
	options.ResolutionOptions = cachedPlayers;
end;

print('WC_Validate_DiploVictory', GameEvents.WC_Validate_DiploVictory.Count())
GameEvents.WC_Validate_DiploVictory.Add(Def_WC_Validate_DiploVictory)
print('WC_Validate_DiploVictory', GameEvents.WC_Validate_DiploVictory.Count())

-- ===========================================================================

GameEvents.WC_Validate_ESPIONAGE_PACT.RemoveAll()
function Def_WC_Validate_ESPIONAGE_PACT(resolutionType, playerId, options)
	if (cachedOperations == nil) then
		cachedOperations = {};

		for row in GameInfo.UnitOperations() do
			if (row.CategoryInUI == "OFFENSIVESPY" and row.BaseProbability > 0) then
				table.insert(cachedOperations, row.Hash);
			end
		end
	end

	-- Assign valid options
	options.ResolutionOptions = cachedOperations;
end;

print('WC_Validate_ESPIONAGE_PACT', GameEvents.WC_Validate_ESPIONAGE_PACT.Count())
GameEvents.WC_Validate_ESPIONAGE_PACT.Add(Def_WC_Validate_ESPIONAGE_PACT)
print('WC_Validate_ESPIONAGE_PACT', GameEvents.WC_Validate_ESPIONAGE_PACT.Count())

-- ===========================================================================
GameEvents.WC_Validate_MILITARY_ADVISORY.RemoveAll()

function Def_WC_Validate_MILITARY_ADVISORY(resolutionType, playerId, options)
	if (cachedUnitPromotions == nil) then
		cachedUnitPromotions = {};

		for row in GameInfo.UnitPromotionClasses() do
			if (row.PromotionClassType == "PROMOTION_CLASS_RECON") then
				table.insert(cachedUnitPromotions, row.Hash);
			elseif (row.PromotionClassType == "PROMOTION_CLASS_MELEE") then
				table.insert(cachedUnitPromotions, row.Hash);
			elseif (row.PromotionClassType == "PROMOTION_CLASS_RANGED") then
				table.insert(cachedUnitPromotions, row.Hash);
			elseif (row.PromotionClassType == "PROMOTION_CLASS_ANTI_CAVALRY") then
				table.insert(cachedUnitPromotions, row.Hash);
			elseif (row.PromotionClassType == "PROMOTION_CLASS_LIGHT_CAVALRY") then
				table.insert(cachedUnitPromotions, row.Hash);
			elseif (row.PromotionClassType == "PROMOTION_CLASS_HEAVY_CAVALRY") then
				table.insert(cachedUnitPromotions, row.Hash);
			elseif (row.PromotionClassType == "PROMOTION_CLASS_SIEGE") then
				table.insert(cachedUnitPromotions, row.Hash);
			elseif (row.PromotionClassType == "PROMOTION_CLASS_MONK") then 
				table.insert(cachedUnitPromotions, row.Hash);
			elseif (row.PromotionClassType == "PROMOTION_CLASS_NIHANG") then 
				table.insert(cachedUnitPromotions, row.Hash);
			end
		end
	end

	-- Assign valid options
	options.ResolutionOptions = cachedUnitPromotions;
end;

print('WC_Validate_MILITARY_ADVISORY', GameEvents.WC_Validate_MILITARY_ADVISORY.Count())
GameEvents.WC_Validate_MILITARY_ADVISORY.Add(Def_WC_Validate_MILITARY_ADVISORY)
print('WC_Validate_MILITARY_ADVISORY', GameEvents.WC_Validate_MILITARY_ADVISORY.Count())