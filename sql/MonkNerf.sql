--Nerf Monk CS values--
UPDATE Units SET Combat = '28' AND Cost = '50' AND CostProgressionParam1 = '1100' WHERE UnitType = 'UNIT_WARRIOR_MONK';
--Remove Monk +10 congress, +5/-5 via lua
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
	('BBG_REQUIRES_NOT_MONK_WC', 'REQUIREMENT_UNIT_TAG_MATCHES');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
	('BBG_REQUIRES_NOT_MONK_WC', 'Tag', 'CLASS_WARRIOR_MONK');
UPDATE Requirements SET Inverse = '1' WHERE RequirementId = 'BBG_REQUIRES_NOT_MONK_WC';

INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
	('BBG_REQSET_NOT_MONK_WC', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('BBG_REQSET_NOT_MONK_WC', 'BBG_REQUIRES_NOT_MONK_WC');

UPDATE Modifiers SET SubjectRequirementSetId = 'BBG_REQSET_NOT_MONK_WC' WHERE ModifierId = 'WC_RES_RELIGIOUS_UNITS_STRENGTH';
--Monk Kotoku, sql side--
INSERT INTO Unit_BuildingPrereqs(Unit, PrereqBuilding, NumSupported) VALUES
	('UNIT_WARRIOR_MONK', 'BUILDING_KOTOKU_IN', '-1');
