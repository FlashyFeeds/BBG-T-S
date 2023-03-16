INSERT INTO Types(Type, Kind) VALUES
    ('BUILDING_HOLY_1', 'KIND_BUILDING'),
    ('BUILDING_CAMP_1', 'KIND_BUILDING'),
    ('BUILDING_ENCA_1', 'KIND_BUILDING'),
    ('BUILDING_HARB_1', 'KIND_BUILDING'),
    ('BUILDING_COMM_1', 'KIND_BUILDING'),
    ('BUILDING_THEA_1', 'KIND_BUILDING'),
    ('BUILDING_INDU_1', 'KIND_BUILDING');

INSERT INTO Buildings(BuildingType, Name, Cost, PrereqDistrict , PurchaseYield,  InternalOnly) VALUES
    ('BUILDING_HOLY_1', 'LOC_BUILDING_HOLY_1_NAME', '1', 'DISTRICT_HOLY_SITE', NULL, '1'),
    ('BUILDING_CAMP_1', 'LOC_BUILDING_CAMP_1_NAME', '1', 'DISTRICT_CAMPUS', NULL, '1'),
    ('BUILDING_ENCA_1', 'LOC_BUILDING_ENCA_1_NAME', '1', 'DISTRICT_ENCAMPMENT', NULL, '1'),
    ('BUILDING_HARB_1', 'LOC_BUILDING_HARB_1_NAME', '1', 'DISTRICT_HARBOR', NULL, '1'),
    ('BUILDING_COMM_1', 'LOC_BUILDING_COMM_1_NAME', '1', 'DISTRICT_COMMERCIAL_HUB', NULL, '1'),
    ('BUILDING_THEA_1', 'LOC_BUILDING_THEA_1_NAME', '1', 'DISTRICT_THEATER', NULL, '1'),
    ('BUILDING_INDU_1', 'LOC_BUILDING_INDU_1_NAME', '1', 'DISTRICT_INDUSTRIAL_ZONE', NULL, '1');

INSERT INTO Building_CitizenYieldChanges(BuildingType, YieldType, YieldChange) VALUES
    ('COMMUNISM_HOLY_1', 'YIELD_FAITH', '1'),
    ('COMMUNISM_CAMP_1', 'YIELD_SCIENCE', '1'),
    ('COMMUNISM_ENCA_1', 'YIELD_PRODUCTION', '1'),
    ('COMMUNISM_ENCA_1', 'YIELD_GOLD', '1'),
    ('COMMUNISM_HARB_1', 'YIELD_FOOD', '1'),
    ('COMMUNISM_HARB_1', 'YIELD_GOLD', '1'),
    ('COMMUNISM_COMM_1', 'YIELD_GOLD', '1'),
    ('COMMUNISM_THEA_1', 'YIELD_CULTURE', '1'),
    ('COMMUNISM_INDU_1', 'YIELD_PRODUCTION', '1');

-- Creating Modifiers to Add these buildings via Lua on met conditions
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('COMMUNISM_HOLY_1', 'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE'),
    ('COMMUNISM_CAMP_1', 'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE'),
    ('COMMUNISM_ENCA_1', 'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE'),
    ('COMMUNISM_HARB_1', 'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE'),
    ('COMMUNISM_COMM_1', 'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE'),
    ('COMMUNISM_THEA_1', 'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE'),
    ('COMMUNISM_INDU_1', 'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('COMMUNISM_HOLY_1', 'BuildingType', 'BUILDING_HOLY_1'),
    ('COMMUNISM_CAMP_1', 'BuildingType', 'BUILDING_CAMP_1'),
    ('COMMUNISM_ENCA_1', 'BuildingType', 'BUILDING_ENCA_1'),
    ('COMMUNISM_HARB_1', 'BuildingType', 'BUILDING_HARB_1'),
    ('COMMUNISM_COMM_1', 'BuildingType', 'BUILDING_COMM_1'),
    ('COMMUNISM_THEA_1', 'BuildingType', 'BUILDING_THEA_1'),
    ('COMMUNISM_INDU_1', 'BuildingType', 'BUILDING_INDU_1');