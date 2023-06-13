--Creating Spy Capacity Modifier (lua attaches it)
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
	('MODIFIER_CAPTURED_ADD_SPY_CAPACITY_BBG', 'MODIFIER_PLAYER_GRANT_SPY');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('MODIFIER_CAPTURED_ADD_SPY_CAPACITY_BBG', 'Amount', '1');

--Deliting diplomatic option to trade spy
DELETE FROM DealItems WHERE DealItemType = "DEAL_ITEM_CAPTIVE";
DELETE FROM Types WHERE Type = "DEAL_ITEM_CAPTIVE";