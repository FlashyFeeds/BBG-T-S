function EstablishPlayers()
	local CsTable :table;
	local CsTable ={};
	local MajTable :table;
	local MajTable = {};
	local MajCount :number;
	local MajCount = 0;
	local CsCount :number;
	local CsCount = 0;
	for i = 0, 60 do
		local tmp_civ = Players[i]
		if Players[i] ~= nil then
			if IsMajNotObserver(i) and (tmp_civ:IsAlive() or tmp_civ:WasEverAlive()) then
				MajCount = MajCount + 1 
				MajTable[MajCount]=i
			elseif IsCS(i) and (tmp_civ:IsAlive() or tmp_civ:WasEverAlive()) then
				CsCount = CsCount + 1)
				CsTable[CsCount]=i
			end
		end
	end
	print("players established")
	return MajTable, CsTable
end

function IsCS(PlayerID)
	local CheckedPlayer = Players[PlayerID];
	if CheckedPlayer:IsMajor()==false and (CheckedPlayer:IsBarbarian()==false or GameInfo.Leaders[CheckedPlayer:GetLeader()].LeaderType ~= "LEADER_FREE_CITIES") then
		return true
	else
		return false
	end
end

function IsMajNotObserver(PlayerID)
	local CheckedPlayer = Players[PlayerID];
	if CheckedPlayer:IsMajor() == true and  (not ( PlayerConfigurations[PlayerID]:GetLeaderTypeName() == "LEADER_SPECTATOR" or PlayerConfigurations[PlayerID]:GetHandicapTypeID() == 2021024770 )) then
		return true ;
	else
		return false ;
	end
end

function On