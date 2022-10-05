--Fixed BUG: Culture Bombs worked only for founders and not for followers.

--Fixed Holly Waters, so it follows the same logic as Defender/Crusade
UPDATE Modifiers Set ModifierType = 'MODIFIER_ALL_UNITS_ATTACH_MODIFIER' WHERE ModifierId = 'HOLY_WATERS_HEALING';
UPDATE Modifiers Set SubjectRequirementSetId = 'PLAYER_FOUNDED_RELIGION_REQUIREMENTS' WHERE ModifierId = 'HOLY_WATERS_HEALING';

UPDATE Modifiers Set ModifierType = 'MODIFIER_PLAYER_UNIT_ADJUST_HEAL_PER_TURN' WHERE ModifierId = 'HOLY_WATERS_HEALING_MODIFIER';

UPDATE Modifiers Set SubjectRequirementSetId = NULL WHERE ModifierId = 'HOLY_WATERS_HEALING_MODIFIER';

INSERT INTO Requirements(RequirementId, RequirementType) VALUES
	('REQUIRES_CITY_SAME_RELIGION_PFBF', 'REQUIREMENT_REQUIREMENTSET_IS_MET');

INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
	('REQUIRES_CITY_SAME_RELIGION_PFBF', 'RequirementSetId', 'HOLY_WATERS_HEALING_MODIFIER_REQUIREMENTS');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('HOLY_WATERS_HEALING_REQUIREMENTS', 'REQUIRES_CITY_SAME_RELIGION_PFBF');