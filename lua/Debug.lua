function Debug(statement: string, context)
	if GameConfiguration.GetValue('BBGTS_DEBUG_LUA') == false then
		return
	end
	local currentTime, float = math.modf(Automation.GetTime())
	local GAME_ID = Game:GetProperty("GameID")
	if GAME_ID==nil then
		print(context..": "..statement..". Local Player: "..tostring(Game.GetLocalPlayer()).." Turn: "..tostring(Game.GetCurrentGameTurn()))
		return
	end
	local GAME_ID_int = GAME_ID[1]
	local GAME_ID_float = GAME_ID[2]
	local time_delta :number = currentTime + float - GAME_ID_int - GAME_ID_float
	print(context..": "..statement..". Local Player: "..tostring(Game.GetLocalPlayer()).." Turn: "..tostring(Game.GetCurrentGameTurn()).." Time: "..string.format("%.3f %%",time_delta))
	return
end
