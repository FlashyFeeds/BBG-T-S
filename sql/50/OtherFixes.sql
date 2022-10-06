--Chateau Housing
UPDATE Improvements SET Housing=2, TilesRequired=2, PreReqCivic='CIVIC_FEUDALISM', RequiresAdjacentBonusOrLuxury=0, RequiresRiver=0, SameAdjacentValid=0 WHERE ImprovementType='IMPROVEMENT_CHATEAU';
--zigurat Housing
UPDATE Improvements SET SameAdjacentValid=0, Housing=2, TilesRequired=2 WHERE ImprovementType='IMPROVEMENT_ZIGGURAT';
--Ayutthaya
UPDATE ModifierArguments SET Value=10 WHERE ModifierId='MINOR_CIV_AYUTTHAYA_CULTURE_COMPLETE_BUILDING' AND Name='BuildingProductionPercent';
--Phonecia
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='MEDITERRANEAN_COLONIES_EXTRA_MOVEMENT';
--Liberty
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='STATUELIBERTY_DIPLOVP' AND Name='Amount';
--Misile Cruiser
UPDATE Units SET Range=4 WHERE UnitType='UNIT_MISSILE_CRUISER';
--Red Card Rocket Arty
INSERT INTO PolicyModifiers (PolicyType, ModifierId) VALUES
	('POLICY_TRENCH_WARFARE', 'TRENCH_WARFARE_INFORMATION_SIEGE_PRODUCTION');

INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
	('TRENCH_WARFARE_INFORMATION_SIEGE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION');

INSERT OR IGNORE INTO ModifierArguments(ModifierId, Name, Value, Extra) VALUES
	('TRENCH_WARFARE_INFORMATION_SIEGE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_SIEGE', -1 ),
	('TRENCH_WARFARE_INFORMATION_SIEGE_PRODUCTION', 'EraType', 'ERA_INFORMATION', -1 ),
	('TRENCH_WARFARE_INFORMATION_SIEGE_PRODUCTION', 'Amount', 50, -1);
--Spear of fion
UPDATE Modifiers SET SubjectRequirementSetId='ATTACKING_REQUIREMENT_SET' WHERE ModifierId='SPEAR_OF_FIONN_ADJUST_COMBAT_STRENGTH';
--Mattehorn
DELETE FROM UnitAbilityModifiers WHERE ModifierId='ALPINE_TRAINING_COMBAT_HILLS';
DELETE FROM Modifiers WHERE ModifierId='ALPINE_TRAINING_COMBAT_HILLS';