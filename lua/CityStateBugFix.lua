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
	return MajCount, MajTable, CsCount, CsTable;
end