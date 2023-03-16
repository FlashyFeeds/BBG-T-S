-- Enables The Game MODE and Settings in Game Configuration
-- Author: FlashyFeeds
-- DateCreated: 7/9/2022 3:16:54 PM
--------------------------------------------------------------
--Creates BBGTS gamemode and default options
INSERT INTO GameModeItems('GameModeType', 'Name', 'Description', 'Portrait', 'Background', 'Icon', 'SortIndex') VALUES
        ('BBGTS_GAMEMODE', 'LOC_BBGTS_GAMEMODE_NAME', 'LOC_BBGTS_GAMEMODE_DESCRIPTION', 'BBGTS_Portrait.dds', 'BBGTS_Background.dds', 'ICON_BBGTS_GAMEMODE', '-10');

INSERT INTO Parameters(ParameterId, Name, Description, Domain, DefaultValue, ConfigurationGroup, ConfigurationId, GroupId, Visible, SupportsSinglePlayer, SortIndex) VALUES
    ('BBGTS_GameMode', 'LOC_BBGTS_GAMEMODE_NAME', 'LOC_BBGTS_GAMEMODE_DESCRIPTION', 'bool', '1', 'Game', 'BBGTS_GAMEMODE', 'GameModes', '1', '1', '-10'),
    ('BBGTS_DebugLua', 'LOC_BBGTS_DEBUG_LUA_NAME', 'LOC_BBGTS_DEBUG_LUA_DESC', 'bool', '1', 'Game', 'BBGTS_DEBUG_LUA', 'AdvancedOptions','1', '1', '20010'),
    ('BBGTS_MP_CHEATS', 'LOC_BBGTS_MP_CHEAT_NAME', 'LOC_BBGTS_MP_CHEAT_DESC', 'bool', '0', 'Game', 'BBGTS_MP_CHEATS', 'AdvancedOptions','1', '1', '20020');
    --('BBGTS_ProductionPanel_BBG', 'LOC_BBGTS_PRODUCTION_PANEL_NAME', 'LOC_BBGTS_BBGTS_PRODUCTION_PANEL_DESC', 'bool', '1', 'Game', 'BBGTS_PRODUCTION_PANEL_UTIL', 'AdvancedOptions','1', '1', '20020');--

--Insert your Bug Fixes Here, sort order between 20020 and 30000
--ExampleCommentedOutBelow
--INSERT INTO Parameters(ParameterId, Name, Description, Domain, DefaultValue, ConfigurationGroup, ConfigurationId, GroupId, Visible, SupportsSinglePlayer, SortIndex) VALUES
    --('BBGTS_BugFix1', 'LOC_BBGTS_BUGFIX1_NAME', 'LOC_BBGTS_BUGFIX1_DESC', 'bool', '1', 'Game', 'BBGTS_BUGFIX1', 'AdvancedOptions', '1', '1', '20020');
/*
INSERT INTO Parameters(ParameterId, Name, Description, Domain, DefaultValue, ConfigurationGroup, ConfigurationId, GroupId, Visible, SupportsSinglePlayer, SortIndex) VALUES
    ('BBGTS_KongoFix', 'LOC_BBGTS_KONGO_FIX_NAME', 'LOC_BBGTS_KONGO_FIX_DESC', 'bool', '0', 'Game', 'BBGTS_KONGO_FIX', 'AdvancedOptions', '1', '1', '20030'),
    ('BBGTS_FreeInqFix', 'LOC_BBGTS_FREEINQ_FIX_NAME', 'LOC_BBGTS_FREEINQ_FIX_DESC', 'bool', '0', 'Game', 'BBGTS_FREEINQ_FIX', 'AdvancedOptions', '1', '1', '20040'),
    ('BBGTS_ReligionModifierFix', 'LOC_BBGTS_RELIGION_MODIFIER_FIX_NAME', 'LOC_BBGTS_RELIGION_MODIFIER_FIX_DESC', 'bool', '0', 'Game', 'BBGTS_RELIGION_MODIFIER_FIX', 'AdvancedOptions', '1', '1', '20050'),
    ('BBGTS_RemoveMonkScalingFix', 'LOC_BBGTS_REMOVE_MONK_SCALING_FIX_NAME', 'LOC_BBGTS_REMOVE_MONK_SCALING_FIX_DESC', 'bool', '0', 'Game', 'BBGTS_REMOVE_MONK_SCALING_FIX', 'AdvancedOptions', '1', '1', '20060'),
    ('BBGTS_MacedonFix', 'LOC_BBGTS_MACEDON_FIX_NAME', 'LOC_BBGTS_MACEDON_FIX_DESC', 'bool', '0', 'Game', 'BBGTS_MACEDON_FIX', 'AdvancedOptions', '1', '1', '20070'),
    ('BBGTS_MonkNerf','LOC_BBGTS_MONK_NERF_NAME', 'LOC_BBGTS_MONK_NERF_DESC', 'bool', '0', 'Game', 'BBGTS_MONK_NERF', 'AdvancedOptions', '1', '1', '20080'),
    ('BBGTS_PlanesFix','LOC_BBGTS_PLANES_FIX_NAME', 'LOC_BBGTS_PLANES_FIX_DESC', 'bool', '0', 'Game', 'BBGTS_PLANES_FIX', 'AdvancedOptions', '1', '1', '20090');
--Insert your Suggestions Here, sort order 30000+
*/
--Insert your Suggestions Here, sort order 30000+
INSERT INTO Parameters(ParameterId, Name, Description, Domain, DefaultValue, ConfigurationGroup, ConfigurationId, GroupId, Visible, SupportsSinglePlayer, SortIndex) VALUES
    ('BBGTS_Amani', 'LOC_BBGTS_AMANI_NAME', 'LOC_BBGTS_AMANI_DESC', 'bool', '0', 'Game', 'BBGTS_AMANI', 'AdvancedOptions', '1', '1', '30000'),
    ('BBGTS_Communism_Mod', 'LOC_BBGTS_COMMUNISM_MOD_NAME', 'LOC_BBGTS_COMMUNISM_MOD_DESC', 'bool', '0', 'Game', 'BBGTS_COMMUNISM_MOD', 'AdvancedOptions', '1', '1', '30010'),
    ('BBGTS_Communism_Build', 'LOC_BBGTS_COMMUNISM_BUILD_NAME', 'LOC_BBGTS_COMMUNISM_BUILD_DESC', 'bool', '0', 'Game', 'BBGTS_COMMUNISM_BUILD', 'AdvancedOptions', '1', '1', '30020'),
    ('BBGTS_Unifier', 'LOC_BBGTS_UNIFIER_NAME', 'LOC_BBGTS_UNIFIER_DESC', 'bool', '0', 'Game', 'BBGTS_UNIFIER', 'AdvancedOptions', '1', '1', '30030'),
    ('BBGTS_IncaWonders', 'LOC_BBGTS_INCA_WONDERS_NAME', 'LOC_BBGTS_INCA_WONDERS_DESC', 'bool', '0', 'Game', 'BBGTS_INCA_WONDERS', 'AdvancedOptions', '1', '1', '30040'),
    ('BBGTS_MacedonBugFix', 'LOC_BBGTS_MACEDON_FIX_NAME', 'LOC_BBGTS_MACEDON_FIX_DESC', 'bool', '0', 'Game', 'BBGTS_MACEDON_FIX', 'AdvancedOptions', '1', '1', '30050'),
    ('BBGTS_ExpBugFix', 'LOC_BBGTS_EXP_FIX_NAME', 'LOC_BBGTS_EXP_FIX_DESC', 'bool', '0', 'Game', 'BBGTS_EXP_FIX', 'AdvancedOptions', '1', '1', '30060'),
    ('BBGTS_MovementBugFix', 'LOC_BBGTS_MOVE_FIX_NAME', 'LOC_BBGTS_MOVE_FIX_DESC', 'bool', '0', 'Game', 'BBGTS_MOVE_FIX', 'AdvancedOptions', '1', '1', '30070');
    --('BBGTS_AttachDetachModifier', 'LOC_BBGTS_ATTACH_DETACH_NAME', 'LOC_BBGTS_ATTACH_DETACH_DESC', 'bool', '0', 'Game', 'BBGTS_ATTACH_DETACH_TEST', 'AdvancedOptions', '1', '1', '30020'),
    --('BBGTS_WatermillSuggestion', 'LOC_BBGTS_WATERMILL_SUGGESTION_NAME', 'LOC_BBGTS_WATERMILL_SUGGESTION_DESC', 'bool', '0', 'Game', 'BBGTS_WATERMILL_SUGGESTION', 'AdvancedOptions', '1', '1', '30030'),
    --('BBGTS_Spy', 'LOC_BBGTS_SPY_NAME', 'LOC_BBGTS_SPY_DESC', 'bool', '0', 'Game', 'BBGTS_SPY_TEST', 'AdvancedOptions', '1', '1', '30040');

--Hide Options Unless BBGTS is active, Just copy any existing line and replace parameter ID with your Suggestion Name 
    --Like So:
    --('BBGTS_BugFix1', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    --('BBGTS_Suggestion1', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1');

INSERT INTO ParameterCriteria(ParameterId, ConfigurationGroup, ConfigurationId, Operator, ConfigurationValue) VALUES
    ('BBGTS_DebugLua', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_MP_CHEATS', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_Amani', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_Communism_Mod', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_Communism_Build', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_Unifier', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_IncaWonders', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_MacedonBugFix', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_ExpBugFix', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_MovementBugFix', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1');
    

    /*
    ('BBGTS_KongoFix', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_FreeInqFix', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_ReligionModifierFix', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_RemoveMonkScalingFix', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_MacedonFix', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_MonkNerf', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_AttachDetachModifier', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_WatermillSuggestion', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_ProductionPanel_BBG', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_Spy', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_PlanesFix', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1');
    */