-- // ----------------------------------------------------------------------------------------------
-- // Author: Sparrow, Integrated by FlashyFeeds
-- // DateCreated: 01/24/2019 2:27:04 PM
-- // ----------------------------------------------------------------------------------------------
include("cheat_menu_panel_functions");
include("bbgts_debug.lua")
local m_CheatPanelState:number		= 0;
--//turn processing
local bFirstTick = false
local bFirstOut = false
local bEndTimerSet = false
local bNoCheats = false
--timer
local nMyTime = -1
local nMyTurnEnd = -1
local nTimerPhase = -1 -- -1: EmptyCircle, 0 - TimerTicks, 1 Check
local nChachedPercent = 0
local nCachedDisplay = 3
local nBeeperPhase = 3
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
		Controls.CheatPanel:SetSizeY(150);
		Controls.CheatReadyContainer:SetHide(false)
		DisplayCircle(nTimerPhase)
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
		Controls.CheatReadyContainer:SetHide(true)
		Controls.CheatInputShield:SetHide(true)
		Controls.ButtonStackMIN:SetHide(true);
		Controls.ButtonSep:SetHide(true);
		Controls.Diplo:SetHide(true);--keep
		m_CheatPanelState = 0;
	end	
end
function OnPanelTitleClicked_Expansion1()
    if(m_CheatPanelState == 0) then
		UI.PlaySound("Tech_Tray_Slide_Open");
		Controls.CheatPanel:SetSizeY(150);
		Controls.CheatReadyContainer:SetHide(false)
		DisplayCircle(nTimerPhase)
		Controls.ButtonStackMIN:SetHide(false);
		Controls.ButtonSep:SetHide(false);
		Controls.CheatButtonDiplo:SetDisabled(true); --keep
		Controls.Diplo:SetHide(true); --keep
		m_CheatPanelState = 1;
	else
		UI.PlaySound("Tech_Tray_Slide_Closed");
		Controls.CheatPanel:SetSizeY(25);
		Controls.CheatReadyContainer:SetHide(true)
		Controls.CheatInputShield:SetHide(true)
		Controls.ButtonStackMIN:SetHide(true);
		Controls.ButtonSep:SetHide(true);
		Controls.Diplo:SetHide(true); --keep
		m_CheatPanelState = 0;
	end	
end
function OnPanelTitleClicked_Expansion2()
    if(m_CheatPanelState == 0) then
		UI.PlaySound("Tech_Tray_Slide_Open");
		Controls.CheatPanel:SetSizeY(150);
		Controls.CheatReadyContainer:SetHide(false)
		DisplayCircle(nTimerPhase)
		Controls.ButtonStackMIN:SetHide(false);
		Controls.ButtonSep:SetHide(false);
		m_CheatPanelState = 1;

	else
		UI.PlaySound("Tech_Tray_Slide_Closed");
		Controls.CheatPanel:SetSizeY(25);
		Controls.CheatReadyContainer:SetHide(true)
		Controls.CheatInputShield:SetHide(true)
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
	Controls.CheatButtonMS:RegisterCallback(Mouse.eLClick, ChangeMS); --keep
	Controls.CheatButtonGold:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end); --keep
	Controls.CheatButtonProduction:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end); --keep
	Controls.CheatButtonScience:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end); --keep
	Controls.CheatButtonCulture:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end); --keep
	Controls.CheatButtonFaith:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end); --keep
	Controls.CheatButtonEnvoy:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end); --keep
	Controls.CheatButtonObs:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end); --keep
	Controls.CheatButtonGov:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end); --keep
	Controls.CheatButtonDiplo:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end); --keep
	Controls.CheatButtonMS:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end); --keep
	Controls.ToggleCheatPanel:RegisterCheckHandler(function() UpdateCheatPanel(not m_hideCheatPanel); end);
	Controls.ToggleCheatPanel:SetCheck(true);
	UpdateCheatPanel(true);
end

--turn processing
function DisplayCircle(nControl, bMode)
	bMode = bMode or nil
	if nControl == -1 then
		Controls.CheatReadyCheckContainer:SetHide(false)
		Controls.CheatReadyCheck:SetSelected(false)
		Controls.CheatTurnTimerBG:SetHide(true)
		Controls.CheatTurnTimerMeter:SetHide(true)
		Controls.CheatReadyButtonContainer:SetHide(true)
		Controls.CheatInputShield:SetHide(false)
	elseif nControl == 0 then
		Controls.CheatReadyCheckContainer:SetHide(true)
		Controls.CheatReadyCheck:SetSelected(false)
		Controls.CheatReadyButtonContainer:SetHide(false)
		Controls.CheatTurnTimerBG:SetHide(false)
		Controls.CheatTurnTimerMeter:SetHide(false)
		Controls.CheatTurnTimerMeter:SetPercent(nChachedPercent)
		Controls.CheatReadyButton:LocalizeAndSetText(nCachedDisplay);
		Controls.CheatReadyButton:LocalizeAndSetToolTip( "" );
		if bMode == false then
			Controls.CheatInputShield:SetHide(false)
		elseif bMode == true then
			Controls.CheatInputShield:SetHide(true)
		end	 
	elseif nControl == 1 then
		Controls.CheatReadyCheckContainer:SetHide(false)
		Controls.CheatReadyCheck:SetSelected(true)
		Controls.CheatTurnTimerBG:SetHide(true)
		Controls.CheatTurnTimerMeter:SetHide(true)
		Controls.CheatReadyButtonContainer:SetHide(true)
		Controls.CheatInputShield:SetHide(true)
	end
end

function TesterPanel_SetDefault()
	Controls.CheatReadyCheckContainer:SetHide(false)
	Controls.CheatReadyCheck:SetSelected(false)
	Controls.CheatTurnTimerBG:SetHide(true)
	Controls.CheatTurnTimerMeter:SetHide(true)
	Controls.CheatReadyButtonContainer:SetHide(true)
	Controls.CheatInputShield:SetHide(false)
end

function TesterPanel_SetActive()
	Controls.CheatReadyCheckContainer:SetHide(false)
	Controls.CheatReadyCheck:SetSelected(true)
	Controls.CheatTurnTimerBG:SetHide(true)
	Controls.CheatTurnTimerMeter:SetHide(true)
	Controls.CheatReadyButtonContainer:SetHide(true)
	Controls.CheatInputShield:SetHide(true)
end

function TimerTick(elapsedTime, nStartTime, nEndTime, bMode)
	
	if elapsedTime < nStartTime + 0.1 and (nTimerPhase == -1) and (bMode == false) then
		nTimerPhase = 0
		--hide default off grey circle, keep consume mouse hover, display timer
		if m_CheatPanelState == 1 then
			DisplayCircle(nTimerPhase, false)
		end
	elseif (elapsedTime > nEndTime) and (bMode == false) then
		nTimerPhase = 1
		nChachedPercent = 0
		nCachedDisplay = 3
		nBeeperPhase = 3
		-- remove consume mouse, remove timer, display OK
		if m_CheatPanelState == 1 then
			DisplayCircle(nTimerPhase, false)
		end
	elseif elapsedTime < nStartTime + 0.1 and (nTimerPhase == 1) and (bMode == true) then
		nTimerPhase = 0
		--hide ok, keep consume mouse, show timer
		if m_CheatPanelState == 1 then
			DisplayCircle(nTimerPhase, true)
		end
	elseif (elapsedTime > nEndTime) and (bMode == true) then
		nTimerPhase = -1
		nChachedPercent = 0
		nCachedDisplay = 3
		nBeeperPhase = 3
		--hide timer, display default circle, consume mouse
		if m_CheatPanelState == 1 then
			DisplayCircle(nTimerPhase, true)
		end
	end

	if nTimerPhase == 0 then
		local nTimeDelta = 3 - (elapsedTime - nStartTime)
		local nPercent = 1 - nTimeDelta/3
		if nPercent > nChachedPercent + 0.02 then
			nChachedPercent = nPercent
			nCachedDisplay  = math.floor(nTimeDelta*10)/10
		end
		if m_CheatPanelState == 1 then
			Controls.CheatTurnTimerMeter:SetPercent(nChachedPercent)
			Controls.CheatReadyButton:LocalizeAndSetText(nCachedDisplay);
			Controls.CheatReadyButton:LocalizeAndSetToolTip( "" );
			if math.abs(nTimeDelta-nBeeperPhase) < 0.05 then
				UI.PlaySound("Play_MP_Game_Launch_Timer_Beep");
				nBeeperPhase = nBeeperPhase - 1
			end
		end
	end
	
end 

function OnTurnTimerUpdated(elapsedTime :number, maxTurnTime :number)
	if maxTurnTime <= 0 then
		return
	elseif nMyTime == -1 then
		nMyTime = elapsedTime
		if bFirstOut == true then
			if (nMyTime>maxTurnTime-6) then
				bNoCheats = true
				print("Ending Timer at ", elapsedTime)
				EndTimer()
			else
				nMyTurnEnd = maxTurnTime
				local nTimeDelta_Broadcast = maxTurnTime - nMyTime
				BroadcastTimeDelta(nTimeDelta_Broadcast)
			end
			return
		end
	elseif elapsedTime < nMyTime+3.1 and (not bNoCheats) then
		TimerTick(elapsedTime, nMyTime, nMyTime + 3, false)
	--elseif (elapsedTime>=nMyTime+3) and (elapsedTime<=maxTurnTime + delta -5) and (not bNoCheats) then
		--TimerTick(elapsedTime, nMyTime + 3, maxTurnTime + delta - 5)
	elseif (elapsedTime> maxTurnTime - 5.1) and (elapsedTime<maxTurnTime - 1.9) and (not bNoCheats) then
		TimerTick(elapsedTime, nMyTurnEnd-5, nMyTurnEnd-2, true)
	end
	if (not bNoCheats) then
		--Debug("bFirstTick "..tostring(bFirstTick), "OnTurnTimerUpdated")
		if (elapsedTime>=nMyTime+3) and (not bFirstTick) then
			Debug("Forwarding All Players Loaded to Gameplay","OnTurnTimerUpdated")
			bFirstTick = true
			--extended debug
			local tPassParams = {}
			tPassParams["bFirstTick"] = bFirstTick
			tPassParams["bFirstOut"] = bFirstOut
			tPassParams["bEndTimerSet"] = bEndTimerSet
			tPassParams["bNoCheats"] = bNoCheats
			tPassParams["nMyTime"] = nMyTime
			tPassParams["nMyTurnEnd"] = nMyTurnEnd
			tPassParams["nTimerPhase"] = nTimerPhase
			tPassParams["nChachedPercent"] = nChachedPercent
			tPassParams["nCachedDisplay"] = nCachedDisplay
			tPassParams["nBeeperPhase"] = nBeeperPhase
			SwitchOnHumanLoaded(tPassParams)
		end

		--Ticking in the end before disable
		if (elapsedTime> maxTurnTime-1.9) and (bFirstOut) and (not bEndTimerSet) then
			Debug("Forwarding Unload all Players loaded to Gameplay","OnTurnTimerUpdated")
			bEndTimerSet = true
			--extended debug
			local tPassParams = {}
			tPassParams["bFirstTick"] = bFirstTick
			tPassParams["bFirstOut"] = bFirstOut
			tPassParams["bEndTimerSet"] = bEndTimerSet
			tPassParams["bNoCheats"] = bNoCheats
			tPassParams["nMyTime"] = nMyTime
			tPassParams["nMyTurnEnd"] = nMyTurnEnd
			tPassParams["nTimerPhase"] = nTimerPhase
			tPassParams["nChachedPercent"] = nChachedPercent
			tPassParams["nCachedDisplay"] = nCachedDisplay
			tPassParams["nBeeperPhase"] = nBeeperPhase
			EndTimer(tPassParams)
		end
	end
end

function ExposedMembers.ActivateLocalTurnerEvent()
	Debug("Called: Attaching Turner Event", "ExposedMembers.ActivateLocalTurnerEvent")
	if bTurnProcessing == true then
		Events.TurnTimerUpdated.Add(OnTurnTimerUpdated)
	else
		TesterPanel_SetActive()
	end
end

function ExposedMembers.DeactivateTesterPanelWT()
	Debug("Called: Resetting all Control", "ExposedMembers.DeactivateTesterPanel")
	nMyTime = -1
	nMyTurnEnd = -1
	bFirstTick = false
	bFirstOut = false 
	bEndTimerSet = false
	bNoCheats = false
	Events.TurnTimerUpdated.Remove(OnTurnTimerUpdated)
	TesterPanel_SetDefault()
end

function ExposedMembers.SetFirstOut()
	Debug("Called: Setting bFirstOut","ExposedMembers.SetFirstOut")
	bFirstOut = true
end

function ExposedMembers.SetTurnEnd(nTimeDelta)
	Debug("Called", "ExposedMembers.SetTurnEnd")
	if nMyTurnEnd == -1 then
		nMyTurnEnd = nMyTime + nTimeDelta
	end
	Debug("nMyTime = "..tostring(nMyTime).." and nMyTurnEnd = "..tostring(nMyTurnEnd), "ExposedMembers.SetTurnEnd")
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
		UpdateCheatPanel(false);
		--if  GameConfiguration.IsNetworkMultiplayer() then
			--UpdateCheatPanel(true);
			--Controls.ToggleCheatPanel:SetHide(true);
		--else
			--UpdateCheatPanel(false);
		--end
	m_IsLoading = false;
	
end
Initialize();