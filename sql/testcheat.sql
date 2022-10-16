--Gold Buy Spies with 1mil gold should be easy to test a lot
--UPDATE Units SET CanRetreatWhenCaptured = '1' WHERE UnitType = 'UNIT_SPY';
--Give enables 20 spy capacity to major players for testing purposes

INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
	('BBG_TEST_GIVE_20_SPY_CAPACITY', 'MODIFIER_PLAYER_GRANT_SPY');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('BBG_TEST_GIVE_20_SPY_CAPACITY', 'Amount', '20');
--Set district cost to 1 to 1 turn them
--UPDATE Districts SET Cost = '2' WHERE DistrictType <> 'DISTRICT_CITY_CENTER';
--Set gov plaza building to

--UPDATE Buildings SET Cost = '2' WHERE BuildingType IN ('BUILDING_GOV_TALL', 'BUILDING_GOV_WIDE', 'BUILDING_GOV_CONQUEST','BUILDING_GOV_CITYSTATES','BUILDING_GOV_SPIES', 'BUILDING_GOV_FAITH','BUILDING_GOV_MILITARY','BUILDING_GOV_CULTURE', 'BUILDING_GOV_SCIENCE');
