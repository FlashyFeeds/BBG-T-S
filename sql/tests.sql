--Gold Buy Spies with 1mil gold should be easy to test a lot
UPDATE Units SET CanRetreatWhenCaptured = '1' WHERE UnitType = 'UNIT_SPY';
--Give enables 20 spy capacity to major players for testing purposes
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
	('BBG_TEST_GIVE_20_SPY_CAPACITY', 'MODIFIER_PLAYER_GRANT_SPY');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('BBG_TEST_GIVE_20_SPY_CAPACITY', 'Amount', '20');
--Set district cost to 1 to 1 turn them
UPDATE Districts SET Cost = '1' WHERE DistrictType <> 'DISTRICT_CITY_CENTER';
--Set gov plaza building to