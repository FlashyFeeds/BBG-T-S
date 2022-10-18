include "Debug"

function FindGameID()
	local debugcontext = "FindGameID(L)"
	local currentTurn = Game.GetCurrentGameTurn()
	local startTurn = GameConfiguration.GetStartTurn()
	if currentTurn ~= startTurn then
		return
	end
	if GameConfiguration.GetValue('BBGTS_DEBUG_LUA') == false then
		return
	end
	print("Delta Debug Timer Started")
	if Game:GetProperty("GameID")==nil then
		local time, float = math.modf(Automation.GetTime())
		print("Time: ",time)
		Game:SetProperty("GameID", time)
		print("GameID Set as "..tostring(Game.GetLocalPlayer()).." PlayerID's: "..tostring(Game:GetProperty("GameID")).." starting time")
	else
		print("GameID started as "..tostring(Game.GetLocalPlayer()).." PlayerID. With GAME_ID: "..tostring(Game:GetProperty("GameID")).." starting time")
	end
end

function Initialize()
	Events.LocalPlayerTurnBegin.Add(FindGameID)
end

Initialize()
