CREATE TABLE "Numbers"("Number" TEXT);

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
