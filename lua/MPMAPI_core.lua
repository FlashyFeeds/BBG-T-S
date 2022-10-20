local USE_CACHE : boolean = true;
local g_ObjectStateCache = {};
local debugcontext = "MPMAPI(C)"

function Debug(statement: string, context)
	if GameConfiguration.GetValue('BBGTS_DEBUG_LUA') == false then
		return
	end
	local currentTime, float = math.modf(Automation.GetTime())
	local GAME_ID = GetObjectState(Game,"GameID")
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

-- ===========================================================================
function SetObjectState(pObject : object, sPropertyName : string, value)
	debugcontext = "SetObjectState(CS)"
	--print("SetObjectState(CS): Started")
	if (sPropertyName == nil) then
		return nil;
	end

	if (pObject == nil) then
		print("SetObjectState(CS): ERROR: object is nil!");
		return nil;
	end

	if (USE_CACHE == true) then
		if (g_ObjectStateCache[pObject] == nil) then
			g_ObjectStateCache[pObject] = {};
		end

		-- update cache
		g_ObjectStateCache[pObject][sPropertyName] = value;
	end
	-- update gamecore

	if UI ~= nil then
		-- We are on the UI side of things.  We must sent a command to change the game state
		local kParameters:table = {};
		kParameters.propertyName = sPropertyName;
		kParameters.value = value;
		kParameters.objectID = pObject:GetComponentID();
		-- Send this GameEvent when processing the operation
		kParameters.OnStart = "OnPlayerCommandSetObjectState";

		UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, kParameters);
		print("SetObjectState(CS): OnPlayerCommandSetObjectState GameEvent sent to GamePlayScript")
	else
		if (pObject.SetProperty ~= nil) then
			pObject:SetProperty(sPropertyName, value);
		end
	end
end

-- ===========================================================================
function OnPlayerCommandSetObjectStateHandler(ePlayer : number, params : table)
	--debugcontext = "OnPlayerCommandSetObjectStateHandler(G)"
	--print("OnPlayerCommandSetObjectStateHandler(G): Started")
	local pObject = Game.GetObjectFromComponentID(params.objectID);

	if pObject ~= nil then
		SetObjectState(pObject, params.propertyName, params.value);
	end
		
end

-- This file gets includes on both the UI and GameCore side, we only want to handle the event on the Game Core side.
if UI == nil then
	print("MPMAPI(C): OnPlayerCommandSetObjectStateHandler Added")
	GameEvents.OnPlayerCommandSetObjectState.Add( OnPlayerCommandSetObjectStateHandler );
end

-- ===========================================================================
function GetObjectState(pObject : object, sPropertyName : string, bCacheCheckOnly : boolean)
	debugcontext = "GetObjectState(CS)"
	--print("GetObjectState(CS): Started")
	if (sPropertyName == nil) then
		return nil;
	end

	if (pObject == nil) then
		print("GetObjectState(CS): ERROR: object is nil!");
		return nil;
	end

	bCacheCheckOnly = bCacheCheckOnly or false;

	if (USE_CACHE == true) then
		if (g_ObjectStateCache[pObject] == nil) then
			g_ObjectStateCache[pObject] = {};
		end

		if (g_ObjectStateCache[pObject][sPropertyName] ~= nil) then
			return g_ObjectStateCache[pObject][sPropertyName];
		else
			if (bCacheCheckOnly) then
				return nil;
			else
				return RefreshObjectState(pObject, sPropertyName);
			end
		end
	else
		return pObject:GetProperty(sPropertyName);
	end
end

-- ===========================================================================
-- Forces a call to gamecore and cache update.
function RefreshObjectState(pObject : object, sPropertyName : string)
	debugcontext = "GetObjectState(CS)"
	--print("GetObjectState(CS): Started")
	if (sPropertyName == nil) then
		return nil;
	end

	if (pObject.GetProperty == nil) then
		return nil;
	end	

	local propResult = pObject:GetProperty(sPropertyName);

	if (g_ObjectStateCache[pObject] == nil) then
		g_ObjectStateCache[pObject] = {};
	end

	g_ObjectStateCache[pObject][sPropertyName] = propResult;
	return propResult;
end