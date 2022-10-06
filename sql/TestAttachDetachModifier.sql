INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
	('ALEX_PRODUCTION_MODIFIER','MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('ALEX_PRODUCTION_MODIFIER', 'YieldType', 'YIELD_PRODUCTION'),
	('ALEX_PRODUCTION_MODIFIER', 'Amount', '20');

INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
	('ALEX_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('ALEX_PRODUCTION', 'ModifierId', 'ALEX_PRODUCTION_MODIFIER');

/*INSERT INTO Types(Type,Kind) VALUES
	('SLOT_HIDDEN', 'KIND_SLOT');

INSERT INTO GovernmentSlots(GovernmentSlotType, Name, AllowsAnyPolicy) VALUES
	('SLOT_HIDDEN', 'LOC_SLOT_HIDDEN', 0);

INSERT INTO Government_SlotCounts(GovernmentType, GovernmentSlotType, NumSlots) VALUES
	('GOVERNMENT_CHIEFDOM','SLOT_HIDDEN','100');
*/
INSERT INTO Types(Type, Kind) VALUES
	('HIDDEN_POLICY_TEST', 'KIND_POLICY');

INSERT INTO Policies(PolicyType, Description, PrereqCivic, PrereqTech, Name, GovernmentSlotType, RequiresGovernmentUnlock, ExplicitUnlock) VALUES
	('HIDDEN_POLICY_TEST','LOC_HIDDEN_POLICY_TEST_DESC', NULL, NULL, 'LOC_HIDDEN_POLICY_TEST', 'SLOT_WILDCARD', NULL, 0);

INSERT INTO PolicyModifiers(PolicyType, ModifierId) VALUES
	('HIDDEN_POLICY_TEST', 'ALEX_PRODUCTION');