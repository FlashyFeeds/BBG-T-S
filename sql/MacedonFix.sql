UPDATE Modifiers SET RunOnce = '1' WHERE ModifierId = 'TRAIT_CIVILIZATION_HELLENISTIC_FUSION_PRODUCTION_MODIFIER';

INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
	('TRAIT_CIVILIZATION_HELLENISTIC_FUSION_PRODUCTION', 'MODIFIER_PLAYER_CAPTURED_CITY_ATTACH_MODIFIER');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('TRAIT_CIVILIZATION_HELLENISTIC_FUSION_PRODUCTION','ModifierId', 'TRAIT_CIVILIZATION_HELLENISTIC_FUSION_PRODUCTION_MODIFIER'),
	('TRAIT_CIVILIZATION_HELLENISTIC_FUSION_PRODUCTION', 'Amount', '1'),
	('TRAIT_CIVILIZATION_HELLENISTIC_FUSION_PRODUCTION', 'Source', 'CAPTURED_CITY');