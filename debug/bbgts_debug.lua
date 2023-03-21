g_Debug = GameConfiguration.GetValue('BBGTS_DEBUG_LUA')

function Debug(statement: string, context)
	if g_Debug == false then
		return
	end
	local currentTime, float = math.modf(Automation.GetTime())
	local GAME_ID = Game.GetProperty("GameID")
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

function BuildRecursiveDataString(data: table)
	local str: string = ""
	--local tNonTable = {}
	for k,v in pairs(data) do
		if type(v)=="table" then
			--print("BuildRecursiveDataString: Table Detected")
			local deeper_data = v
			local new_string = BuildRecursiveDataString(deeper_data)
			--print("NewString ="..new_string)
			str = str.."[["..tostring(k).."=table: "..new_string.."]]; "
		else
			str = str..tostring(k)..": "..tostring(v)..", "
			--table.insert(tNonTable, k)
		end
	end
	--for i, key in ipairs(tNonTable) do
		--str = str..tostring(key)..": "..tostring(data[key])..", "
	--end
	return str
end

function civ6tostring(arg)
	if type(arg)=="table" then
		return print(BuildRecursiveDataString(arg))
	else
		return tostring(arg)
	end
end