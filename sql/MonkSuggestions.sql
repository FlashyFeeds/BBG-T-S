INSERT OR IGNORE INTO Requirements(RequirementId, RequirementType) Values
	('BBG_REQUIRES_MONK', 'REQUIREMENT_UNIT_TAG_MATCHES');

INSERT OR IGNORE INTO RequirementArguments(RequirementId, Name , Value) Values
	('BBG_REQUIRES_MONK', 'Tag', 'CLASS_WARRIOR_MONK');

INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) Values
	('BBG_UNIT_IS_MONK_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) Values
	('BBG_UNIT_IS_MONK_REQUIREMENTS', 'BBG_REQUIRES_MONK');

INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) 
	SELECT 'BBG_ABILITY_MODIFIER_MONKS_' || Civics.CivicType  , 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER', 'BBG_UNIT_IS_MONK_REQUIREMENTS'
	FROM Civics WHERE EraType IN ('ERA_ANCIENT','ERA_CLASSICAL', 'ERA_MEDIEVAL', 'ERA_RENAISSANCE', 'ERA_INDUSTRIAL');

INSERT INTO Modifiers(ModifierId, ModifierType)
	SELECT 'BBG_MODIFIER_MONKS_CS_' || Civics.CivicType , 'MODIFIER_UNIT_ADJUST_BASE_COMBAT_STRENGTH'
	FROM Civics WHERE EraType IN ('ERA_ANCIENT','ERA_CLASSICAL', 'ERA_MEDIEVAL', 'ERA_RENAISSANCE', 'ERA_INDUSTRIAL');

INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT 'BBG_MODIFIER_MONKS_CS_'|| Civics.CivicType , 'Amount', '1'
	FROM Civics WHERE EraType IN ('ERA_ANCIENT','ERA_CLASSICAL', 'ERA_MEDIEVAL', 'ERA_RENAISSANCE', 'ERA_INDUSTRIAL');

INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT 'BBG_ABILITY_MODIFIER_MONKS_' || Civics.CivicType , 'ModifierId', 'BBG_MODIFIER_MONKS_CS_' || Civics.CivicType 
	FROM Civics WHERE EraType IN ('ERA_ANCIENT','ERA_CLASSICAL', 'ERA_MEDIEVAL', 'ERA_RENAISSANCE', 'ERA_INDUSTRIAL');

INSERT INTO CivicModifiers(CivicType, ModifierId)
	SELECT Civics.CivicType, 'BBG_ABILITY_MODIFIER_MONKS_' || Civics.CivicType
	FROM Civics WHERE EraType IN ('ERA_ANCIENT','ERA_CLASSICAL', 'ERA_MEDIEVAL', 'ERA_RENAISSANCE', 'ERA_INDUSTRIAL');

--DELETE UNIQUE TEMPLES requirements
DELETE FROM Unit_BuildingPrereqs
	WHERE Unit = 'UNIT_WARRIOR_MONK' AND PrereqBuilding IN ('BUILDING_PRASAT', 'BUILDING_STAVE_CHURCH');

--Relax Requirement to SHRINE
UPDATE Unit_BuildingPrereqs SET PrereqBuilding = 'BUILDING_SHRINE' WHERE Unit = 'UNIT_WARRIOR_MONK';

--Reduce Base Cost and Strength, SET Scaling Cost to match closely non-unique units
--with the same CS across eras up to Industrial, Monk then stops scaling and Cost doesn't justify the str.
--Becomes Obsolete in Modern due to str/price. Still should kick ass in Industrial esp with tier II promo.
--Around Shrines Religion Timing should be around sword in strength
UPDATE Units SET Combat = '31' WHERE UnitType = 'UNIT_WARRIOR_MONK';
UPDATE Units SET Cost = '60' WHERE UnitType = 'UNIT_WARRIOR_MONK';
UPDATE Units SET CostProgressionModel = 'COST_PROGRESSION_GAME_PROGRESS' WHERE UnitType = 'UNIT_WARRIOR_MONK';
UPDATE Units SET CostProgressionParam1 = '1000' WHERE UnitType = 'UNIT_WARRIOR_MONK';

--Nerf Tier 2 promo Exploding Palms from +10 down to +7 to stay more in line with mele units
UPDATE ModifierArguments SET Value = '7' WHERE ModifierId = 'EXPLODING_PALMS_INCREASED_COMBAT_STRENGTH';
--Nerf Tier 4 promo Cobra Strike so that fullstacked monk Matches Full Stack Nihang
UPDATE ModifierArguments SET Value = '10' WHERE ModifierId = 'COBRA_STRIKE_INCREASED_COMBAT_STRENGTH';

--Add Unique Ability Icon and description to Monk's Scaling Ability in Unit Preview
--Modifiers Themself are added through civic tree as monk is not unique to a given player.
INSERT INTO Types(Type, Kind) Values
	('BBG_ABILITY_MONK_SCALING', 'KIND_ABILITY');
	
INSERT INTO TypeTags(Type, Tag) Values
	('BBG_ABILITY_MONK_SCALING', 'CLASS_WARRIOR_MONK');

INSERT INTO UnitAbilities(UnitAbilityType, Name, Description) Values
	('BBG_ABILITY_MONK_SCALING', 'LOC_BBG_ABILITY_MONK_SCALING_NAME', 'LOC_BBG_ABILITY_MONK_SCALING_DESCRIPTION');