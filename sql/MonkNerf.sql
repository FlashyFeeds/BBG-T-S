--Nerf Monk CS values--
UPDATE Units SET Combat = '28', PurchaseYield = NULL, MustPurchase = '0', EnabledByReligion ='0', TrackReligion = '0' WHERE UnitType = 'UNIT_WARRIOR_MONK';
--Remove Monk +10 congress (by setting track religion = 0), +5/-5 via lua

--Now Monk belief coupling should change accordingly so the belief doesn't break
/*
INSERT INTO Types(Type, Kind) VALUES
	('MODIFIER_ALL_CITIES_ENABLE_UNIT_FAITH_PURCHASE','KIND_MODIFIER');

INSERT INTO DynamicModifiers(ModifierType, CollectionType, EffectType) VALUES
	('MODIFIER_ALL_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 'COLLECTION_ALL_CITIES', 'EFFECT_ENABLE_UNIT_FAITH_PURCHASE');
*/
UPDATE Modifiers SET ModifierType = 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER' WHERE ModifierId = 'ALLOW_WARRIOR_MONKS';

INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('BBG_PLAYER_ALLOW_MONKS_IN_CITY', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE' ,'CITY_FOLLOWS_RELIGION_REQUIREMENTS');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('BBG_PLAYER_ALLOW_MONKS_IN_CITY', 'Tag', 'CLASS_WARRIOR_MONK');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('ALLOW_WARRIOR_MONKS', 'ModifierId', 'BBG_PLAYER_ALLOW_MONKS_IN_CITY');
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

--Kotoku Allows Monk Buy SQL
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
	('BBG_REQUIRES_CITY_HAS_KOTOKU', 'REQUIREMENT_CITY_HAS_BUILDING');

INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
	('BBG_REQUIRES_CITY_HAS_KOTOKU', 'BuildingType','BUILDING_KOTOKU_IN');

INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
	('BBG_CITY_HAS_KOTOKU_REQSET', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('BBG_CITY_HAS_KOTOKU_REQSET', 'BBG_REQUIRES_CITY_HAS_KOTOKU');

INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('BBG_KOTOKU_ALLOW_MONK_BUY', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 'BBG_CITY_HAS_KOTOKU_REQSET');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('BBG_KOTOKU_ALLOW_MONK_BUY', 'Tag', 'CLASS_WARRIOR_MONK');

INSERT INTO BuildingModifiers(BuildingType, ModifierId) VALUES
	('BUILDING_KOTOKU_IN', 'BBG_KOTOKU_ALLOW_MONK_BUY');