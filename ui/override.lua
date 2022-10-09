function PopulateLivePlayerData( ePlayer:number )

	if ePlayer == -1 then
		return;
	end

	local kPlayer		:table = Players[ePlayer];
	local kPlayerCulture:table = kPlayer:GetCulture();

	-- Restore data from prior turn (likely only necessary in hot-seat)
	if m_kAllPlayerData[ ePlayer ] ~= nil then
		local playerData:table = m_kAllPlayerData[ ePlayer ];
		m_kPolicyFilterCurrent = playerData[DATA_FIELD_CURRENT_FILTER];
	end

	local governmentRowId :number = kPlayerCulture:GetCurrentGovernment();
	if governmentRowId ~= -1 then
		g_kCurrentGovernment = g_kGovernments[ GameInfo.Governments[governmentRowId].GovernmentType ];
	else
		g_kCurrentGovernment = nil;
	end
	
	-- Cache which civic was unlocked this turn, so we can determine whether to display new policy icons
	local civicCompletedThisTurn:string;
	if kPlayerCulture:CivicCompletedThisTurn() then
		-- Check for nil, it is possible that we do not have a valid civic completed!
		local civicInfo = GameInfo.Civics[kPlayerCulture:GetCivicCompletedThisTurn()];
		if civicInfo ~= nil then
			civicCompletedThisTurn = civicInfo.CivicType;
		end
	end
	
	-- Policies: populate unlocked (and not obsolete) ones for the catalog
	m_kUnlockedPolicies = {};
	m_kNewPoliciesThisTurn = {};
	for row in GameInfo.Policies() do
		local isPolicyAvailable :boolean = IsPolicyAvailable(kPlayerCulture, row.Hash);
		local policyType		:string = row.PolicyType;
		m_kUnlockedPolicies[policyType] = isPolicyAvailable or m_debugShowAllPolicies;
		m_kNewPoliciesThisTurn[policyType] = civicCompletedThisTurn and civicCompletedThisTurn == row.PrereqCivic;
	end
	
	m_ActivePoliciesByType = {};
	m_ActivePoliciesBySlot = {};
	m_ActivePolicyRows[ROW_INDEX.MILITARY] = { SlotArray={} };
	m_ActivePolicyRows[ROW_INDEX.ECONOMIC] = { SlotArray={} };
	m_ActivePolicyRows[ROW_INDEX.DIPLOMAT] = { SlotArray={} };
	m_ActivePolicyRows[ROW_INDEX.WILDCARD] = { SlotArray={} };
	
	local nPolicySlots:number = kPlayerCulture:GetNumPolicySlots();
	for i = 0, nPolicySlots-1, 1 do
		local iSlotType :number = kPlayerCulture:GetSlotType(i);
		local iPolicyID :number = kPlayerCulture:GetSlotPolicy(i);

		local strSlotType :string = GameInfo.GovernmentSlots[iSlotType].GovernmentSlotType
		-- strSlotType is of the form SLOT_##NAME##, and we want only the first 8 chars of ##NAME##
		local strRowKey :string = string.sub( strSlotType, 6, 13 );
		local nRowIndex :number = ROW_INDEX[strRowKey];
		
		if ( nRowIndex == nil ) then
				assert( false );
			UI.DataError("On initialization; slot type '"..strSlotType.."' requires key '"..strRowKey.."'");
		end

		local tSlotData :table = {
			-- Static members
			UI_RowIndex		= nRowIndex,
			GC_SlotIndex	= i,

			-- Dynamic members
			GC_PolicyType	= EMPTY_POLICY_TYPE
		};

		if ( iPolicyID ~= -1 ) then
			tSlotData.GC_PolicyType = GameInfo.Policies[iPolicyID].PolicyType;
			m_ActivePoliciesByType[tSlotData.GC_PolicyType] = tSlotData;
		end

		table.insert( m_ActivePolicyRows[nRowIndex].SlotArray, tSlotData );
		m_ActivePoliciesBySlot[i+1] = tSlotData;
	end

	m_kBonuses = {};
	for governmentType, government in pairs(g_kGovernments) do
		local bonusName		:string = (government.Index ~= -1) and GameInfo.Governments[government.Index].BonusType or "NO_GOVERNMENTBONUS";
		local iBonusIndex	:number = -1;
		if bonusName ~= "NO_GOVERNMENTBONUS" then
			iBonusIndex = GameInfo.GovernmentBonusNames[bonusName].Index;
		end
		if government.BonusFlatAmountPreview >= 0 then
			m_kBonuses[governmentType] = {
				BonusPercent			= government.BonusFlatAmountPreview
			}
		end	
	end
	
	-- Unlocked governments
	m_kUnlockedGovernments = {};
	for governmentType,government in pairs(g_kGovernments) do
		if kPlayerCulture:IsGovernmentUnlocked(government.Hash) then
			m_kUnlockedGovernments[governmentType] = true;			
		end
	end

	-- DEBUG:
	if m_debugOutputGovInfo then
		DebugOutput();
	end

end