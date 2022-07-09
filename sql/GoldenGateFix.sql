--Fixed Golden Gate Bridge Bug, where Bridge isn't passible on one side
INSERT INTO Requirements(RequirementId, RequirementType) Values
	('BBG_REQUIRES_PLOT_IS_ADJACENT_TO_GOLDENGATE', 'REQUIREMENT_PLOT_ADJACENT_BUILDING_TYPE_MATCHES');

INSERT INTO RequirementArguments(RequirementId, Name, Value) Values
	('BBG_REQUIRES_PLOT_IS_ADJACENT_TO_GOLDENGATE', 'BuildingType', 'BUILDING_GOLDEN_GATE_BRIDGE'),
	('BBG_REQUIRES_PLOT_IS_ADJACENT_TO_GOLDENGATE', 'MinRange', '0'),
	('BBG_REQUIRES_PLOT_IS_ADJACENT_TO_GOLDENGATE', 'MaxRange', '1');

INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) Values
	('BBG_GOLDENGATE_REQSET', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) Values
	('BBG_GOLDENGATE_REQSET', 'BBG_REQUIRES_PLOT_IS_ADJACENT_TO_GOLDENGATE'),
	('BBG_GOLDENGATE_REQSET', 'AOE_REQUIRES_LAND_DOMAIN');

INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) Values
	('BBG_GOLDENGATE_IGNORE_CLIFF', 'MODIFIER_ALL_UNITS_ATTACH_MODIFIER', 'BBG_GOLDENGATE_REQSET');

INSERT INTO ModifierArguments(ModifierId, Name, Value) Values
	('BBG_GOLDENGATE_IGNORE_CLIFF', 'ModifierId', 'COMMANDO_BONUS_IGNORE_CLIFF_WALLS');

INSERT INTO GameModifiers(ModifierId) VALUES ('BBG_GOLDENGATE_IGNORE_CLIFF');
