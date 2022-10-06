--Nerf Monk CS values--
UPDATE Units SET Combat = '28',Cost = '50',CostProgressionParam1 = '1100', PurchaseYield = NULL, MustPurchase = '0', EnabledByReligion ='0', TrackReligion = '0' WHERE UnitType = 'UNIT_WARRIOR_MONK';
--Remove Monk +10 congress (by setting track religion = 0), +5/-5 via lua

--Now Monk belief coupling should change accordingly so the belief doesn't break

INSERT INTO Types(Type, Kind) VALUES
	('MODIFIER_ALL_CITIES_ENABLE_UNIT_FAITH_PURCHASE','KIND_MODIFIER');

INSERT INTO DynamicModifiers(ModifierType, CollectionType, EffectType) VALUES
	('MODIFIER_ALL_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 'COLLECTION_ALL_CITIES', 'EFFECT_ENABLE_UNIT_FAITH_PURCHASE');

UPDATE Modifiers SET ModifierType = 'MODIFIER_ALL_CITIES_ENABLE_UNIT_FAITH_PURCHASE', SubjectRequirementSetId = 'CITY_FOLLOWS_RELIGION_REQUIREMENTS' WHERE ModifierId = 'ALLOW_WARRIOR_MONKS';
/*
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
	('BBG_REQUIRES_NOT_MONK_WC', 'REQUIREMENT_UNIT_TAG_MATCHES');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
	('BBG_REQUIRES_NOT_MONK_WC', 'Tag', 'CLASS_WARRIOR_MONK');
UPDATE Requirements SET Inverse = '1' WHERE RequirementId = 'BBG_REQUIRES_NOT_MONK_WC';

INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
	('BBG_REQSET_NOT_MONK_WC', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('BBG_REQSET_NOT_MONK_WC', 'BBG_REQUIRES_NOT_MONK_WC');
*/

INSERT INTO Unit_BuildingPrereqs(Unit, PrereqBuilding, NumSupported) VALUES
	('UNIT_WARRIOR_MONK', 'BUILDING_KOTOKU_IN', '-1');
