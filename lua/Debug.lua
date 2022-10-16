function Debug(statement: string, context)
	if GameConfiguration.GetValue('BBGTS_DEBUG_LUA') == 0 then
		return
	end
	local currentTime, float = math.modf(Automation.GetTime())
	local GAME_ID = Game:GetProperty("GameID")
	if GAME_ID==nil then
		return
	end
	local time_delta :number = currentTime + float - GAME_ID
	print(context..": "..statement..". Local Player: "..tostring(Game.GetLocalPlayer()).." Turn: "..tostring(Game.GetCurrentGameTurn()).." Time: "..string.format(
   "%.3f %%",tostring(time_delta)))
end
