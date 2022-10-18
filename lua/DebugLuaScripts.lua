include "Debug"

local debugcontext = "DebugLuaScripts"

function Initialize()
	if GameConfiguration.GetValue('BBGTS_DEBUG_LUA') == false then
		return
	end
	print("Delta Debug Timer Started")
	if Game:GetProperty("GameID")==nil then
		local time, float = math.modf(Automation.GetTime())
		print("Time: ",time)
		Game:SetProperty("GameID", time)
		print("GameID Set as "..tostring(Game.GetLocalPlayer()).." PlayerID's: "..tostring(Game:GetProperty("GameID")).." starting time")
	end
end

Initialize()
Debug("Started",debugcontext)