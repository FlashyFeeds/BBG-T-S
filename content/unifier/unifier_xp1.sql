--Timur Unifier Interraction depends on XP1
INSERT INTO Types(Type, Kind) VALUES
	('ABILITY_TIMUR_BONUS_EXPERIENCE_QIN_ALT', 'KIND_ABILITY');
INSERT INTO TypeTags(Type, Tag) VALUES
	('ABILITY_TIMUR_BONUS_EXPERIENCE_QIN_ALT', 'CLASS_RECON'),
    ('ABILITY_TIMUR_BONUS_EXPERIENCE_QIN_ALT', 'CLASS_MELEE'),
    ('ABILITY_TIMUR_BONUS_EXPERIENCE_QIN_ALT', 'CLASS_RANGED'),
    ('ABILITY_TIMUR_BONUS_EXPERIENCE_QIN_ALT', 'CLASS_ANTI_CAVALRY'),
    ('ABILITY_TIMUR_BONUS_EXPERIENCE_QIN_ALT', 'CLASS_LIGHT_CAVALRY'),
    ('ABILITY_TIMUR_BONUS_EXPERIENCE_QIN_ALT', 'CLASS_HEAVY_CAVALRY'),
    ('ABILITY_TIMUR_BONUS_EXPERIENCE_QIN_ALT', 'CLASS_SIEGE'),
    ('ABILITY_TIMUR_BONUS_EXPERIENCE_QIN_ALT', 'CLASS_WARRIOR_MONK');
INSERT INTO UnitAbilities(UnitAbilityType, Name, Description, Inactive, Permanent) VALUES
	('ABILITY_TIMUR_BONUS_EXPERIENCE_QIN_ALT', 'LOC_ABILITY_TIMUR_BONUS_EXPERIENCE_NAME', 'LOC_ABILITY_TIMUR_BONUS_EXPERIENCE_DESCRIPTION', 1, 1);
INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
	('ABILITY_TIMUR_BONUS_EXPERIENCE_QIN_ALT', 'TIMUR_BONUS_EXPERIENCE');
INSERT INTO Modifiers(ModifierId, ModifierType, RunOnce, Permanent, SubjectRequirementSetId) VALUES
	('GREATPERSON_TIMUR_ACTIVE_UNIT_BONUS_QIN_ALT', 'MODIFIER_PLAYER_UNIT_GRANT_ABILITY', 1, 1, NULL);
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('GREATPERSON_TIMUR_ACTIVE_UNIT_BONUS_QIN_ALT', 'AbilityType', 'ABILITY_TIMUR_BONUS_EXPERIENCE_QIN_ALT');