function Debug(statement: string, context)
	if GameConfiguration.GetValue('BBGTS_DEBUG_LUA') == 0 then
		return
	end
	local time_delta :number = tonumber(Automation.GetTime())-tonumber(Game:GetProperty("GameID"))
	print(context..": "..statement..". Local Player: "..tostring(Game.GetLocalPlayer()).." Turn: "..tostring(Game.GetCurrentGameTurn()).." Time: "..tostring(time_delta))
end

function Initialize()
	if GameConfiguration.GetValue('BBGTS_DEBUG_LUA') == 0 then
		return
	end
	print("Delta Debug Timer Started")
	if Game:GetProperty("GameID")==nil then
		Game:SetProperty("GameID", Automation.GetTime())
		print("GameID Set as PlayerID's: "..tostring(Game.GetLocalPlayer()).." starting time")
	end
end

Initialize()