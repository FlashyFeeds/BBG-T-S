-- // ----------------------------------------------------------------------------------------------
-- // Author: Sparrow, Integrated by FlashyFeeds
-- // DateCreated: 01/24/2019 2:27:04 PM
-- // ----------------------------------------------------------------------------------------------
include("Cheat_Menu_Panel_Functions");

local m_CheatPanelState:number		= 0;

function AttachPanelToWorldTracker()
	if (m_IsLoading) then
		return;
	end
	if (not m_IsAttached) then
		local worldTrackerPanel:table = ContextPtr:LookUpControl("/InGame/WorldTracker/PanelStack");
		if (worldTrackerPanel ~= nil) then
			Controls.CheatPanel:ChangeParent(worldTrackerPanel);
			worldTrackerPanel:AddChildAtIndex(Controls.CheatPanel, 1);
			worldTrackerPanel:CalculateSize();
			worldTrackerPanel:ReprocessAnchoring();
			m_IsAttached = true;
		end
	end
end

-- // ----------------------------------------------------------------------------------------------
-- // Attach Panel To WorldTracker
-- // ----------------------------------------------------------------------------------------------
function OnLoadGameViewStateDone()
	AttachPanelToWorldTracker();
end

-- // ----------------------------------------------------------------------------------------------
-- // Panel Control and Checkbox Attach
-- // ----------------------------------------------------------------------------------------------
function UpdateCheatPanel(hideCheatPanel:boolean)
	m_hideCheatPanel = hideCheatPanel; 
	Controls.CheatPanel:SetHide(m_hideCheatPanel);
	Controls.ToggleCheatPanel:SetCheck(not m_hideCheatPanel);
end
function InitDropdown()
	local parent = ContextPtr:LookUpControl("/InGame/WorldTracker/CivicsCheckButton",	Controls.PanelStack );
	if parent == nil then return end;
	Controls.CheatPanelStack:ChangeParent(parent);
	parent.ReprocessAnchoring();
	Events.LoadGameViewStateDone.Remove(InitDropdown);
end

-- ====================================================================================================
--	If the official Civ6 Expansion "Rise and Fall" (XP1) and "Gathering Storm" (XP2) is active.
-- ====================================================================================================
function IsExpansion1Active()
	local isActive1:boolean  = Modding.IsModActive("1B28771A-C749-434B-9053-D1380C553DE9");
	return isActive1;
end
-- ====================================================================================================
function IsExpansion2Active()
	local isActive2:boolean  = Modding.IsModActive("4873eb62-8ccc-4574-b784-dda455e74e68");
	return isActive2;
end
-- ====================================================================================================

function OnPanelTitleClicked()
	if (IsExpansion1Active() == true and IsExpansion2Active() == false) then
		OnPanelTitleClicked_Expansion1();
	elseif (IsExpansion1Active() == false and IsExpansion2Active() == true) or (IsExpansion1Active() == true and IsExpansion2Active() == true) then
		OnPanelTitleClicked_Expansion2();
	elseif (IsExpansion1Active() == false and IsExpansion2Active() == false) then
		OnPanelTitleClicked_Base();
	end
end
function OnPanelTitleClicked_Base()
    if(m_CheatPanelState == 0) then
		UI.PlaySound("Tech_Tray_Slide_Open");
		Controls.CheatPanel:SetSizeY(235);
		Controls.ButtonStackMIN:SetHide(false);
		Controls.ButtonSep:SetHide(false);
		Controls.CheatButtonDiplo:SetDisabled(true); --keep
		Controls.Diplo:SetHide(true); --keep
		Controls.CheatButtonGov:SetDisabled(true); --keep
		Controls.CheatButtonDiplo:SetToolTipString("Disabled - Requires GS DLC"); --keep
		m_CheatPanelState = 1;
	else
		UI.PlaySound("Tech_Tray_Slide_Closed");
		Controls.CheatPanel:SetSizeY(25);
		Controls.ButtonStackMIN:SetHide(true);
		Controls.ButtonSep:SetHide(true);
		Controls.Diplo:SetHide(true);--keep
		m_CheatPanelState = 0;
	end	
end
function OnPanelTitleClicked_Expansion1()
    if(m_CheatPanelState == 0) then
		UI.PlaySound("Tech_Tray_Slide_Open");
		Controls.CheatPanel:SetSizeY(235);
		Controls.ButtonStackMIN:SetHide(false);
		Controls.ButtonSep:SetHide(false);
		Controls.CheatButtonDiplo:SetDisabled(true); --keep
		Controls.Diplo:SetHide(true); --keep
		m_CheatPanelState = 1;
	else
		UI.PlaySound("Tech_Tray_Slide_Closed");
		Controls.CheatPanel:SetSizeY(25);
		Controls.ButtonStackMIN:SetHide(true);
		Controls.ButtonSep:SetHide(true);
		Controls.Diplo:SetHide(true); --keep
		m_CheatPanelState = 0;
	end	
end
function OnPanelTitleClicked_Expansion2()
    if(m_CheatPanelState == 0) then
		UI.PlaySound("Tech_Tray_Slide_Open");
		Controls.CheatPanel:SetSizeY(235);
		Controls.ButtonStackMIN:SetHide(false);
		Controls.ButtonSep:SetHide(false);
		m_CheatPanelState = 1;

	else
		UI.PlaySound("Tech_Tray_Slide_Closed");
		Controls.CheatPanel:SetSizeY(25);
		Controls.ButtonStackMIN:SetHide(true);
		Controls.ButtonSep:SetHide(true);
		m_CheatPanelState = 0;
	end	
end
function KeyHandler( key:number )
	if key == Keys.VK_ESCAPE then
		Hide();
		return true;
	end
	return false;
end
function OnInputHandler( pInputStruct:table )
	local uiMsg = pInputStruct:GetMessageType();
	if uiMsg == KeyEvents.KeyUp then 
		return KeyHandler( pInputStruct:GetKey() ); 
	end
	return false;
end

local function InitializeControls()
	Controls.HeaderTitle:RegisterCallback(Mouse.eLClick, OnPanelTitleClicked);
	Controls.CheatButtonGov:RegisterCallback(Mouse.eLClick, ChangeGovPoints); --keep
	Controls.CheatButtonGold:RegisterCallback(Mouse.eLClick, ChangeGold); --keep
	Controls.CheatButtonProduction:RegisterCallback(Mouse.eLClick, CompleteProduction); --keep
	Controls.CheatButtonScience:RegisterCallback(Mouse.eLClick, CompleteResearch); --keep
	Controls.CheatButtonCulture:RegisterCallback(Mouse.eLClick, CompleteCivic); --keep
	Controls.CheatButtonFaith:RegisterCallback(Mouse.eLClick, ChangeFaith); --keep
	Controls.CheatButtonEnvoy:RegisterCallback(Mouse.eLClick, ChangeEnvoy); --keep
	Controls.CheatButtonObs:RegisterCallback(Mouse.eLClick, RevealAll);	 --keep		
	Controls.CheatButtonDiplo:RegisterCallback(Mouse.eLClick, ChangeDiplomaticFavor); --keep
	Controls.CheatButtonGold:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end); --keep
	Controls.CheatButtonProduction:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end); --keep
	Controls.CheatButtonScience:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end); --keep
	Controls.CheatButtonCulture:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end); --keep
	Controls.CheatButtonFaith:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end); --keep
	Controls.CheatButtonAddMovement:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
	Controls.CheatButtonEnvoy:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end); --keep
	Controls.CheatButtonObs:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end); --keep
	Controls.CheatButtonGov:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end); --keep
	Controls.CheatButtonDiplo:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end); --keep
	Controls.ToggleCheatPanel:RegisterCheckHandler(function() UpdateCheatPanel(not m_hideCheatPanel); end);
	Controls.ToggleCheatPanel:SetCheck(true);
	UpdateCheatPanel(true);
end

-- // ----------------------------------------------------------------------------------------------
-- // Init
-- // ----------------------------------------------------------------------------------------------
function Initialize()
	m_IsLoading = true;
		Events.LoadGameViewStateDone.Add(OnLoadGameViewStateDone);
		Events.LoadGameViewStateDone.Add(InitDropdown);
		Events.InputActionTriggered.Add( OnInputActionTriggered );
		ContextPtr:SetInputHandler( OnInputHandler, true );
		InitializeControls();
		IsExpansion2Active();
		IsExpansion1Active();
		if  GameConfiguration.IsNetworkMultiplayer() then
			UpdateCheatPanel(true);
			Controls.ToggleCheatPanel:SetHide(true);
		else
			UpdateCheatPanel(false);
		end
	m_IsLoading = false;
end
Initialize();