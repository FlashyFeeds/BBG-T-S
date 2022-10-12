--V1 doesn't work
/*CREATE TABLE "Numbers"("Number" TEXT);

INSERT INTO Numbers VALUES ('6'),('16'),('26'),('36'),('46'),('56'),('66'),('76'),('86'),('96');

INSERT INTO Requirements(RequirementId, RequirementType)
	SELECT 'BBG_REQUIRES_DAMAGED_UNIT_THRESHOLD_' || Numbers.Number, 'REQUIREMENT_UNIT_DAMAGE_MINIMUM' FROM Numbers;

INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT 'BBG_REQUIRES_DAMAGED_UNIT_THRESHOLD_' || Numbers.Number, 'MinimumAmount', Numbers.Number FROM Numbers;

INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
	SELECT 'BBG_DAMAGED_UNIT_THRESHOLD_' || Numbers.Number || '_REQSET', 'REQUIREMENTSET_TEST_ALL' FROM Numbers;

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
	SELECT 'BBG_DAMAGED_UNIT_THRESHOLD_' || Numbers.Number || '_REQSET', 'BBG_REQUIRES_DAMAGED_UNIT_THRESHOLD_' || Numbers.Number FROM Numbers;

INSERT INTO Modifiers(ModifierId, ModifierType, OwnerRequirementSetId)
	SELECT 'BBG_PLANE_FIX_MODIFIER_HP_THRESHOLD_' || Numbers.Number, 'MODIFIER_UNIT_ADJUST_BASE_COMBAT_STRENGTH', 'BBG_DAMAGED_UNIT_THRESHOLD_' || Numbers.Number || '_REQSET' FROM Numbers;

INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT 'BBG_PLANE_FIX_MODIFIER_HP_THRESHOLD_' || Numbers.Number, 'Amount', '1' FROM Numbers;

INSERT INTO Types(Type, Kind) VALUES
	('BBG_ABILITY_DAMAGED_PLANE_CORRECTION', 'KIND_ABILITY');

INSERT INTO UnitAbilities(UnitAbilityType, Name, Description) VALUES
	('BBG_ABILITY_DAMAGED_PLANE_CORRECTION', 'LOC_ABILITY_DAMAGED_PLANE_CORRECTION_NAME', 'LOC_ABILITY_DAMAGED_PLANE_CORRECTION_DESC');

INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId)
	SELECT 'BBG_ABILITY_DAMAGED_PLANE_CORRECTION', 'BBG_PLANE_FIX_MODIFIER_HP_THRESHOLD_' || Numbers.Number FROM Numbers;

INSERT INTO TypeTags(Type, Tag) VALUES
	('BBG_ABILITY_DAMAGED_PLANE_CORRECTION', 'CLASS_AIRCRAFT');

DROP TABLE Numbers;
*/
--V2 use later for card
/*
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
	('BBG_UNIT_IS_ATTACKER_PLANE_REQSET', 'REQUIREMENTSET_TEST_ALL'),
	('BBG_UNIT_IS_PLANE_REQSET', 'REQUIREMENTSET_TEST_ANY');

INSERT INTO SubjectRequirementSetId(RequirementSetId, RequirementId) VALUES
	('BBG_UNIT_IS_ATTACKER_PLANE_REQSET', 'BBG_UNIT_IS_PLANE'),
	('BBG_UNIT_IS_ATTACKER_PLANE_REQSET', 'PLAYER_IS_ATTACKER_REQUIREMENTS'),
	('BBG_UNIT_IS_PLANE_REQSET', 'BBG_UNIT_IS_FIGHTER'),
	('BBG_UNIT_IS_PLANE_REQSET', 'BBG_UNIT_IS_BOMBER');

INSERT INTO Requirements(RequirementId, RequirementType) VALUES
	('BBG_UNIT_IS_PLANE', 'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('BBG_UNIT_IS_FIGHTER', 'REQUIREMENT_UNIT_TYPE_MATCHES'),
	('BBG_UNIT_IS_BOMBER', 'REQUIREMENT_UNIT_TYPE_MATCHES');

INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
	('BBG_UNIT_IS_PLANE', )
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('BBG_PLANES_ATTACK_FIX_MODIFIER','MODIFIER_PLAYER_UNITS_ADJUST_STRENGTH_REDUCTION_FOR_DAMAGE_MODIFIER', 'BBG_UNIT_IS_ATTACKER_PLANE_REQSET');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('BBG_PLANES_ATTACK_FIX_MODIFIER', 'Amount', '50');	

INSERT INTO Types(Type, Kind) VALUES
	('BBG_ABILITY_DAMAGED_PLANE_CORRECTION', 'KIND_ABILITY');

INSERT INTO UnitAbilities(UnitAbilityType, Name, Description) VALUES
	('BBG_ABILITY_DAMAGED_PLANE_CORRECTION', 'LOC_ABILITY_DAMAGED_PLANE_CORRECTION_NAME', 'LOC_ABILITY_DAMAGED_PLANE_CORRECTION_DESC');

INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId)
*/
--v3
/*
INSERT INTO Types(Type, Kind) VALUES
	('BBG_MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH_REDUCTION_FROM_DAMAGE', 'KIND_MODIFIER');

INSERT INTO DynamicModifiers(ModifierType, CollectionType, EffectType) VALUES
	('BBG_MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH_REDUCTION_FROM_DAMAGE', 'COLLECTION_UNIT_COMBAT', 'EFFECT_ADJUST_UNIT_STRENGTH_REDUCTION_FOR_DAMAGE_MODIFIER');

INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
	('BBG_UNIT_IS_ATTACKER_REQSET', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('BBG_UNIT_IS_ATTACKER_REQSET', 'PLAYER_IS_ATTACKER_REQUIREMENTS');

INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('BBG_PLANES_ATTACK_FIX_MODIFIER', 'BBG_MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH_REDUCTION_FROM_DAMAGE', 'BBG_UNIT_IS_ATTACKER_REQSET');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('BBG_PLANES_ATTACK_FIX_MODIFIER', 'Amount', '50');

INSERT INTO Types(Type, Kind) VALUES
	('BBG_ABILITY_DAMAGED_PLANE_CORRECTION', 'KIND_ABILITY');

INSERT INTO UnitAbilities(UnitAbilityType, Name, Description) VALUES
	('BBG_ABILITY_DAMAGED_PLANE_CORRECTION', 'LOC_ABILITY_DAMAGED_PLANE_CORRECTION_NAME', 'LOC_ABILITY_DAMAGED_PLANE_CORRECTION_DESC');

INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
	('BBG_ABILITY_DAMAGED_PLANE_CORRECTION', 'BBG_PLANES_ATTACK_FIX_MODIFIER');

INSERT INTO TypeTags(Type, Tag) VALUES
	('BBG_ABILITY_DAMAGED_PLANE_CORRECTION', 'CLASS_AIRCRAFT');

*/
--v4
UPDATE GameEffects SET SubjectInterfaces = '{3BCA4C49-F422-44AE-8A10-857B3ECEFD3A}' WHERE Type = 'REQUIREMENT_UNIT_DAMAGE_MINIMUM';

INSERT INTO Requirements(RequirementId, RequirementType) VALUES
	('BBG_REQUIRES_UNIT_IS_NOT_AIR', 'REQUIREMENT_UNIT_DOMAIN_MATCHES');

INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
	('BBG_REQUIRES_UNIT_IS_NOT_AIR', 'UnitDomain', 'DOMAIN_AIR');

UPDATE Requirements SET Inverse = '1' WHERE RequirementId = 'BBG_REQUIRES_UNIT_IS_NOT_AIR';

INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
	('BBG_PLANE_REQSET', 'REQUIREMENTSET_TEST_ALL'),
	('BBG_NOT_PLANE_REQSET', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('BBG_PLANE_REQSET', 'REQUIRES_AIR_DOMAIN'),
	('BBG_NOT_PLANE_REQSET', 'BBG_REQUIRES_UNIT_IS_NOT_AIR');

INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('BBG_PLANES_ATTACK_FIX_MODIFIER', 'MODIFIER_PLAYER_UNITS_ADJUST_STRENGTH_REDUCTION_FOR_DAMAGE_MODIFIER', 'BBG_PLANE_REQSET'),
	('BBG_PLANES_NATIONAL_IDENTITY', 'MODIFIER_PLAYER_UNITS_ADJUST_STRENGTH_REDUCTION_FOR_DAMAGE_MODIFIER', 'BBG_PLANE_REQSET');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('BBG_PLANES_ATTACK_FIX_MODIFIER', 'Amount', '50'),
	('BBG_PLANES_NATIONAL_IDENTITY', 'Amount','25');

UPDATE Modifiers SET SubjectRequirementSetId = 'BBG_NOT_PLANE_REQSET' WHERE ModifierId = 'NATIONALIDENTITY_REDUCESTRENGTHREDUCTIONFORDAMAGE';

INSERT INTO PolicyModifiers(PolicyType, ModifierId) VALUES
	('POLICY_NATIONAL_IDENTITY', 'BBG_PLANES_NATIONAL_IDENTITY');

CREATE TABLE "Numbers"("Number" TEXT);

INSERT INTO Numbers VALUES ('10'),('20'),('30'),('50'),('60'),('70'),('90');

INSERT INTO Requirements(RequirementId, RequirementType)
	SELECT 'BBG_REQUIRES_DAMAGED_UNIT_THRESHOLD_' || Numbers.Number, 'REQUIREMENT_UNIT_DAMAGE_MINIMUM' FROM Numbers;

INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT 'BBG_REQUIRES_DAMAGED_UNIT_THRESHOLD_' || Numbers.Number, 'MinimumAmount', Numbers.Number FROM Numbers;

INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
	SELECT 'BBG_DAMAGED_UNIT_THRESHOLD_' || Numbers.Number || '_REQSET', 'REQUIREMENTSET_TEST_ALL' FROM Numbers;

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
	SELECT 'BBG_DAMAGED_UNIT_THRESHOLD_' || Numbers.Number || '_REQSET', 'BBG_REQUIRES_DAMAGED_UNIT_THRESHOLD_' || Numbers.Number FROM Numbers;

INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
	('BBG_UNIT_IS_DEFENDER_REQSET', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('BBG_UNIT_IS_DEFENDER_REQSET', 'PLAYER_IS_DEFENDER_REQUIREMENTS');

INSERT INTO Modifiers(ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
	SELECT 'BBG_BASIC_PLANE_FIX_MODIFIER_HP_THRESHOLD_' || Numbers.Number, 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'BBG_DAMAGED_UNIT_THRESHOLD_' || Numbers.Number || '_REQSET', 'BBG_UNIT_IS_DEFENDER_REQSET' 
	FROM Numbers WHERE Number IN ('10','30', '50', '70', '90');

INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT 'BBG_BASIC_PLANE_FIX_MODIFIER_HP_THRESHOLD_' || Numbers.Number, 'Amount', '-1' 
	FROM Numbers WHERE Number IN ('10','30', '50', '70', '90');

INSERT INTO Modifiers(ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
	SELECT 'BBG_NATIONAL_PLANE_FIX_MODIFIER_HP_THRESHOLD_' || Numbers.Number, 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'BBG_DAMAGED_UNIT_THRESHOLD_' || Numbers.Number || '_REQSET', 'BBG_UNIT_IS_DEFENDER_REQSET' 
	FROM Numbers WHERE Number IN ('10','30', '50', '70', '90');

INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT 'BBG_NATIONAL_PLANE_FIX_MODIFIER_HP_THRESHOLD_' || Numbers.Number, 'Amount', '1' 
	FROM Numbers WHERE Number IN ('10','30', '50', '70', '90');

INSERT INTO Modifiers(ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
	SELECT 'BBG_NATIONAL_PLANE_FIX_MODIFIER_HP_THRESHOLD_' || Numbers.Number, 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'BBG_DAMAGED_UNIT_THRESHOLD_' || Numbers.Number || '_REQSET', 'BBG_UNIT_IS_DEFENDER_REQSET' 
	FROM Numbers WHERE Number IN ('20', '60');

INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT 'BBG_NATIONAL_PLANE_FIX_MODIFIER_HP_THRESHOLD_' || Numbers.Number, 'Amount', '-1' 
	FROM Numbers WHERE Number IN ('20', '60');

INSERT INTO Types(Type, Kind) VALUES
	('BBG_ABILITY_DAMAGED_BASIC_PLANE_CORRECTION', 'KIND_ABILITY'),
	('BBG_ABILITY_DAMAGED_NATIONAL_PLANE_CORRECTION', 'KIND_ABILITY');

INSERT INTO UnitAbilities(UnitAbilityType, Name, Description) VALUES
	('BBG_ABILITY_DAMAGED_BASIC_PLANE_CORRECTION', 'LOC_ABILITY_DAMAGED_BASIC_PLANE_CORRECTION_NAME', 'LOC_ABILITY_DAMAGED_BASIC_PLANE_CORRECTION_DESC'),
	('BBG_ABILITY_DAMAGED_NATIONAL_PLANE_CORRECTION', 'LOC_ABILITY_DAMAGED_NATIONAL_PLANE_CORRECTION_NAME', 'LOC_ABILITY_DAMAGED_NATIONAL_PLANE_CORRECTION_DESC');

INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId)
	SELECT 'BBG_ABILITY_DAMAGED_BASIC_PLANE_CORRECTION', 'BBG_BASIC_PLANE_FIX_MODIFIER_HP_THRESHOLD_' || Numbers.Number 
	FROM Numbers WHERE Number IN ('10','30', '50', '70', '90');

INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId)
	SELECT 'BBG_ABILITY_DAMAGED_NATIONAL_PLANE_CORRECTION', 'BBG_NATIONAL_PLANE_FIX_MODIFIER_HP_THRESHOLD_' || Numbers.Number FROM Numbers;

UPDATE UnitAbilities SET Inactive = '1' WHERE UnitAbilityType = 'BBG_ABILITY_DAMAGED_NATIONAL_PLANE_CORRECTION';

INSERT INTO TypeTags(Type, Tag) VALUES
	('BBG_ABILITY_DAMAGED_BASIC_PLANE_CORRECTION', 'CLASS_AIRCRAFT'),
	('BBG_ABILITY_DAMAGED_NATIONAL_PLANE_CORRECTION', 'CLASS_AIRCRAFT');

DROP TABLE Numbers;

INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
	('BBG_NATIONAL_IDENTITY_PLANE_CORRECTION_MODIFIER', 'MODIFIER_PLAYER_UNITS_GRANT_ABILITY');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('BBG_NATIONAL_IDENTITY_PLANE_CORRECTION_MODIFIER', 'AbilityType', 'BBG_ABILITY_DAMAGED_NATIONAL_PLANE_CORRECTION');

INSERT INTO PolicyModifiers(PolicyType, ModifierId) VALUES
	('POLICY_NATIONAL_IDENTITY', 'BBG_NATIONAL_IDENTITY_PLANE_CORRECTION_MODIFIER');

INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
	('TRAIT_LEADER_MAJOR_CIV', 'BBG_PLANES_ATTACK_FIX_MODIFIER');