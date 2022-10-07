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
    ('BBGTS_ProductionPanel_BBG', 'LOC_BBGTS_PRODUCTION_PANEL_NAME', 'LOC_BBGTS_BBGTS_PRODUCTION_PANEL_DESC', 'bool', '1', 'Game', 'BBGTS_PRODUCTION_PANEL_UTIL', 'AdvancedOptions','1', '1', '20020');

--Insert your Bug Fixes Here, sort order between 20020 and 30000
--ExampleCommentedOutBelow
--INSERT INTO Parameters(ParameterId, Name, Description, Domain, DefaultValue, ConfigurationGroup, ConfigurationId, GroupId, Visible, SupportsSinglePlayer, SortIndex) VALUES
    --('BBGTS_BugFix1', 'LOC_BBGTS_BUGFIX1_NAME', 'LOC_BBGTS_BUGFIX1_DESC', 'bool', '1', 'Game', 'BBGTS_BUGFIX1', 'AdvancedOptions', '1', '1', '20020');

INSERT INTO Parameters(ParameterId, Name, Description, Domain, DefaultValue, ConfigurationGroup, ConfigurationId, GroupId, Visible, SupportsSinglePlayer, SortIndex) VALUES
    ('BBGTS_KongoFix', 'LOC_BBGTS_KONGO_FIX_NAME', 'LOC_BBGTS_KONGO_FIX_DESC', 'bool', '0', 'Game', 'BBGTS_KONGO_FIX', 'AdvancedOptions', '1', '1', '20030'),
    ('BBGTS_FreeInqFix', 'LOC_BBGTS_FREEINQ_FIX_NAME', 'LOC_BBGTS_FREEINQ_FIX_DESC', 'bool', '0', 'Game', 'BBGTS_FREEINQ_FIX', 'AdvancedOptions', '1', '1', '20040'),
    ('BBGTS_ReligionModifierFix', 'LOC_BBGTS_RELIGION_MODIFIER_FIX_NAME', 'LOC_BBGTS_RELIGION_MODIFIER_FIX_DESC', 'bool', '0', 'Game', 'BBGTS_RELIGION_MODIFIER_FIX', 'AdvancedOptions', '1', '1', '20050'),
    ('BBGTS_RemoveMonkScalingFix', 'LOC_BBGTS_REMOVE_MONK_SCALING_FIX_NAME', 'LOC_BBGTS_REMOVE_MONK_SCALING_FIX_DESC', 'bool', '0', 'Game', 'BBGTS_REMOVE_MONK_SCALING_FIX', 'AdvancedOptions', '1', '1', '20060'),
    ('BBGTS_MacedonFix', 'LOC_BBGTS_MACEDON_FIX_NAME', 'LOC_BBGTS_MACEDON_FIX_DESC', 'bool', '0', 'Game', 'BBGTS_MACEDON_FIX', 'AdvancedOptions', '1', '1', '20070'),
    ('BBGTS_MonkNerf','LOC_BBGTS_MONK_NERF_NAME', 'LOC_BBGTS_MONK_NERF_DESC', 'bool', '0', 'Game', 'BBGTS_MONK_NERF', 'AdvancedOptions', '1', '1', '20080');
--Insert your Suggestions Here, sort order 30000+
--Insert your Suggestions Here, sort order 30000+
INSERT INTO Parameters(ParameterId, Name, Description, Domain, DefaultValue, ConfigurationGroup, ConfigurationId, GroupId, Visible, SupportsSinglePlayer, SortIndex) VALUES
    ('BBGTS_EthemenankiSuggestion', 'LOC_BBGTS_ETHEMENANKI_SUGGESTION_NAME', 'LOC_BBGTS_ETHEMENANKI_SUGGESTION_DESC', 'bool', '0', 'Game', 'BBGTS_ETHEMENANKI_SUGGESTION', 'AdvancedOptions', '1', '1', '30000'),
    ('BBGTS_BBCCSuggestion', 'LOC_BBGTS_BBCC_SUGGESTION_NAME', 'LOC_BBGTS_BBCC_SUGGESTION_DESC', 'bool', '0', 'Game', 'BBGTS_BBCC_SUGGESTION', 'AdvancedOptions', '1', '1', '30010'),
    ('BBGTS_AttachDetachModifier', 'LOC_BBGTS_ATTACH_DETACH_NAME', 'LOC_BBGTS_ATTACH_DETACH_DESC', 'bool', '0', 'Game', 'BBGTS_ATTACH_DETACH_TEST', 'AdvancedOptions', '1', '1', '30020'),
    ('BBGTS_WatermillSuggestion', 'LOC_BBGTS_WATERMILL_SUGGESTION_NAME', 'LOC_BBGTS_WATERMILL_SUGGESTION_DESC', 'bool', '0', 'Game', 'BBGTS_WATERMILL_SUGGESTION', 'AdvancedOptions', '1', '1', '30030');

--Hide Options Unless BBGTS is active, Just copy any existing line and replace parameter ID with your Suggestion Name 
    --Like So:
    --('BBGTS_BugFix1', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    --('BBGTS_Suggestion1', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1');

INSERT INTO ParameterCriteria(ParameterId, ConfigurationGroup, ConfigurationId, Operator, ConfigurationValue) VALUES
    ('BBGTS_KongoFix', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_FreeInqFix', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_ReligionModifierFix', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_RemoveMonkScalingFix', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_MacedonFix', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_EthemenankiSuggestion', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_BBCCSuggestion', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_MonkNerf', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_AttachDetachModifier', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_WatermillSuggestion', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1'),
    ('BBGTS_ProductionPanel_BBG', 'Game', 'BBGTS_GAMEMODE', 'Equals', '1');