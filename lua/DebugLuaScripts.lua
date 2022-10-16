local debugcontext = "DebugLuaScripts"

function Debug(statement: string, context)
	if GameConfiguration.GetValue('BBGTS_DEBUG_LUA') == 0 then
		return
	end
	local currentTime, float = math.modf(Automation.GetTime())
	local GAME_ID = Game:GetProperty("GameID")
	local time_delta :number = currentTime + float - GAME_ID
	print(context..": "..statement..". Local Player: "..tostring(Game.GetLocalPlayer()).." Turn: "..tostring(Game.GetCurrentGameTurn()).." Time: "..string.format(
   "%.3f %%",tostring(time_delta)))
end

function Initialize()
	if GameConfiguration.GetValue('BBGTS_DEBUG_LUA') == 0 then
		return
	end
	print("Delta Debug Timer Started")
	if Game:GetProperty("GameID")==nil then
		local time, float = math.modf(Automation.GetTime())
		print("Time: ",time)
		Game:SetProperty("GameID", time)
		print("GameID Set as PlayerID's: "..tostring(Game:GetProperty("GameID")).." starting time")
	end
end

Initialize()
Debug("Started",debugcontext)