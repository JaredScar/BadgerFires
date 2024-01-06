FireTracker = {};
LocationFireTracker = {};
RandomFireTimer = Config.RandomFireSpawningDelay; -- Need to wait this amount of time before trying to spawn a fire
Citizen.CreateThread(function()
	if (Config.RandomFireSpawning) then 
		while (true) do 
			Citizen.Wait(RandomFireTimer * (1000 * 60));
			-- The timer has expired, we want to randomly spawn a fire maybe...
			local rand = math.random(100);
			if (rand <= Config.RandomFireChance) then 
				-- It hit under the random fire chance, start a fire
				local randomFireIndex = math.random(#Config.RandomFireLocations);
				if (LocationFireTracker[randomFireIndex] == nil) then 
					local randomLocation = Config.RandomFireLocations[randomFireIndex];
					local x = randomLocation.x;
					local y = randomLocation.y;
					local z = randomLocation.z;
					local name = randomLocation.name;
					local size = randomLocation.size;
					local flameScale = randomLocation.flameScale;
					local density = randomLocation.density;
					-- TODO Need to check to make sure no players are within the size of this fire before trying to spawn...
					if (Config.RandomFiresAllowedNearPlayers) then 
						-- We need to check if players are in fire, then not spawn it...
						local startFire = true;
						for _, plyer in pairs(GetPlayers()) do 
							if not IsPlayerOutsideArea(plyer, {x = x, y = y, z = z}, size) then 
								startFire = false;
							end
						end
						if (startFire) then
							LocationFireTracker[randomFireIndex] = true;
							TriggerClientEvent("Fire:startLocation", -1, x, y, z, 0, size, density, flameScale, randomFireIndex, true);
							TriggerClientEvent('chatMessage', -1, Config.Messages.General.RandomFireAnnouncement:gsub("{NAME}", name));
						end
					else 
						-- Spawn fire and announce it
						LocationFireTracker[randomFireIndex] = true;
						TriggerClientEvent("Fire:startLocation", -1, x, y, z, 0, size, density, flameScale, randomFireIndex, false);
						TriggerClientEvent('chatMessage', -1, Config.Messages.General.RandomFireAnnouncement:gsub("{NAME}", name));
					end
				end
			end
		end
	end
end)
-- Function to check if a player is outside a specified area
function IsPlayerOutsideArea(player, startCoords, size)
    local playerCoords = GetEntityCoords(GetPlayerPed(player))
    
    local minX = startCoords.x - size
    local minY = startCoords.y - size
    local minZ = startCoords.z - size

    local maxX = startCoords.x + size
    local maxY = startCoords.y + size
    local maxZ = startCoords.z + size

    return (
        playerCoords.x < minX or
        playerCoords.y < minY or
        playerCoords.z < minZ or
        playerCoords.x > maxX or
        playerCoords.y > maxY or
        playerCoords.z > maxZ
    )
end
RegisterNetEvent('BadgerFires:AddLocationFire')
AddEventHandler('BadgerFires:AddLocationFire', function(fireIndex)
	LocationFireTracker[fireIndex] = true;
end)
RegisterNetEvent('BadgerFires:AddConcurrent')
AddEventHandler('BadgerFires:AddConcurrent', function(firetrackID)
	local src = source;
	if (FireTracker[src] ~= nil) then 
		FireTracker[src][fireTrackID] = true;
	else
		FireTracker[src] = {};
		FireTracker[src][fireTrackID] = true; 
	end
end)
RegisterNetEvent('BadgerFires:StopLocationFire')
AddEventHandler('BadgerFires:StopLocationFire', function(fireLocationIndex)
	LocationFireTracker[fireLocationIndex] = nil;
	TriggerClientEvent("Fire:stopByLocation", -1, fireLocationIndex);
end)

RegisterCommand("fire", function(source, args, rawCommand)
	local src = source;
	--[[
		Commands:
			/fire start <inFrontDistance> <size> <density> <flameScale> 
			/fire preview <inFrontDistance> <size> <density> <flameScale> 
			/fire stop <ID>
			/fire stopall - Requires `BadgerFires.StopAll` permission
			/fires - List all your started fires with their fire IDs
	]]--
	if #args == 0 then 
		-- Bring up usage
		sendUsage(src);
		return;
	end
	if args[1] == "start" then
		-- Start a new fire 
		if #args ~= 5 then 
			-- Return, not enough arguments
			sendUsage(src);
			return;
		end
		local size = tonumber(args[3]);
		local density = tonumber(args[4]);
		local flameScale = tonumber(args[5]);
		local concurrents = FireTracker[src];
		if concurrents == nil then 
			concurrents = 0;
		else
			concurrents = #concurrents; 
		end
		if size == nil or density == nil or flameScale == nil then 
			-- Invalid
			TriggerClientEvent('chatMessage', src, Config.Messages.Error.InvalidParams);
			return;
		end
		if Config.AnyoneCanUse then 
			local maxConcurrent = Config.Concurrent;
			if concurrents == maxConcurrent then 
				-- They have enough fires running already
				TriggerClientEvent('chatMessage', src, Config.Messages.Error.ConcurrentFiresReached:gsub("{MAX_CONCURRENT}", tostring(maxConcurrent)));
				return;
			end
			local maxSize = Config.MaxSize;
			if size > maxSize then 
				-- Too big of size
				TriggerClientEvent('chatMessage', src, Config.Messages.Error.SizeTooBig:gsub("{MAX_SIZE}", tostring(maxSize)));
				return;
			end
			local maxDensity = Config.MaxDensity;
			if density > maxDensity then 
				-- Too big of density
				TriggerClientEvent('chatMessage', src, Config.Messages.Error.DensityTooBig:gsub("{MAX_DENSITY}", tostring(maxDensity)));
				return;
			end
			local maxFlameScale = Config.MaxFlameScale;
			if flameScale > maxFlameScale then 
				-- Too big of flame scale
				TriggerClientEvent('chatMessage', src, Config.Messages.Error.FlameScaleTooBig:gsub("{MAX_FLAMES}", tostring(maxFlameScale)));
				return;
			end
			TriggerClientEvent("Fire:start", src, args[2], args[3], args[4], args[5], src);
			TriggerClientEvent('chatMessage', src, Config.Messages.General.FireStarting);
			return;
		else 
			-- Use permission nodes 
			local perms = Config.Permissions;
			local maxSize = 0;
			local maxDensity = 0;
			local maxFlameScale = 0;
			local maxConcurrent = 0;
			local hasPerms = false;
			for node, data in pairs(perms) do 
				if IsPlayerAceAllowed(src, node) then 
					hasPerms = true;
					if maxSize < data.MaxSize then 
						maxSize = data.MaxSize;
					end
					if maxDensity < data.MaxDensity then 
						maxDensity = data.MaxDensity;
					end
					if maxFlameScale < data.MaxFlameScale then 
						maxFlameScale = data.MaxFlameScale;
					end
					if maxConcurrent < data.Concurrent then 
						maxConcurrent = data.Concurrent;
					end
				end 
			end
			local concurrents = FireTracker[src];
			if concurrents == nil then 
				concurrents = 0;
			else
				concurrents = #concurrents; 
			end
			if not hasPerms then
				TriggerClientEvent('chatMessage', src, Config.Messages.Error.No_Permission); 
				return;
			end
			if concurrents == maxConcurrent then 
				-- They have enough fires running already
				TriggerClientEvent('chatMessage', src, Config.Messages.Error.ConcurrentFiresReached:gsub("{MAX_CONCURRENT}", tostring(maxConcurrent)));
				return;
			end
			if size > maxSize then 
				-- Too big of size
				TriggerClientEvent('chatMessage', src, Config.Messages.Error.SizeTooBig:gsub("{MAX_SIZE}", tostring(maxSize)));
				return;
			end
			if density > maxDensity then 
				-- Too big of density
				TriggerClientEvent('chatMessage', src, Config.Messages.Error.DensityTooBig:gsub("{MAX_DENSITY}", tostring(maxDensity)));
				return;
			end
			if flameScale > maxFlameScale then 
				-- Too big of flame scale
				TriggerClientEvent('chatMessage', src, Config.Messages.Error.FlameScaleTooBig:gsub("{MAX_FLAMES}", tostring(maxFlameScale)));
				return;
			end
			TriggerClientEvent("Fire:start", src, args[2], args[3], args[4], args[5], src);
			FireTracker[src] = {};
			TriggerClientEvent('chatMessage', src, Config.Messages.General.FireStarting);
			return;
		end
	elseif args[1] == "stop" then 
		-- Stop fire with <ID>
		if #args ~= 2 then 
			-- Return, not enough arguments
			sendUsage(src);
			return;
		end
		local concurrents = FireTracker[src];
		-- If it contains L, then they need a permission to stop the location based fire...
		if (not args[2]:find("L") or IsPlayerAceAllowed(src, "BadgerFires.Stop.Location")) then
			if (FireTracker[src][args[2]] ~= nil) then
				FireTracker[src][args[2]] = nil;
			end
			TriggerClientEvent("Fire:stop", -1, args[2], src);
		end
	elseif args[1] == "preview" then 
		if #args ~= 5 then 
			TriggerClientEvent('chatMessage', src, '^1[^5BadgerFires^1] ^2Preview Mode ^3has been ^1DISABLED^3...');
			TriggerClientEvent("Fire:preview", src, nil, nil, nil, nil, false);
			return;
		end
		local size = tonumber(args[3]);
		local density = tonumber(args[4]);
		local flameScale = tonumber(args[5]);
		if size == nil or density == nil or flameScale == nil then 
			-- Invalid
			TriggerClientEvent('chatMessage', src, Config.Messages.Error.InvalidParams);
			return;
		end
		if Config.AnyoneCanUse then 
			local maxSize = Config.MaxSize;
			if size > maxSize then 
				-- Too big of size
				TriggerClientEvent('chatMessage', src, Config.Messages.Error.SizeTooBig:gsub("{MAX_SIZE}", tostring(maxSize)));
				return;
			end
			local maxDensity = Config.MaxDensity;
			if density > maxDensity then 
				-- Too big of density
				TriggerClientEvent('chatMessage', src, Config.Messages.Error.DensityTooBig:gsub("{MAX_DENSITY}", tostring(maxDensity)));
				return;
			end
			local maxFlameScale = Config.MaxFlameScale;
			if flameScale > maxFlameScale then 
				-- Too big of flame scale
				TriggerClientEvent('chatMessage', src, Config.Messages.Error.FlameScaleTooBig:gsub("{MAX_FLAMES}", tostring(maxFlameScale)));
				return;
			end
			TriggerClientEvent("Fire:preview", src, args[2], args[3], args[4], args[5], true);
			TriggerClientEvent('chatMessage', src, '^1[^5BadgerFires^1] ^2Preview Mode ^3has been ^2ENABLED^3...');
			return;
		else 
			-- Use permission nodes 
			local perms = Config.Permissions;
			local maxSize = 0;
			local maxDensity = 0;
			local maxFlameScale = 0;
			local hasPerms = false;
			for node, data in pairs(perms) do 
				if IsPlayerAceAllowed(src, node) then 
					hasPerms = true;
					if maxSize < data.MaxSize then 
						maxSize = data.MaxSize;
					end
					if maxDensity < data.MaxDensity then 
						maxDensity = data.MaxDensity;
					end
					if maxFlameScale < data.MaxFlameScale then 
						maxFlameScale = data.MaxFlameScale;
					end
				end 
			end
			if not hasPerms then
				TriggerClientEvent('chatMessage', src, Config.Messages.Error.No_PermissionPreviewMode); 
				return;
			end
			if size > maxSize then 
				-- Too big of size
				TriggerClientEvent('chatMessage', src, Config.Messages.Error.SizeTooBig:gsub("{MAX_SIZE}", tostring(maxSize)));
				return;
			end
			if density > maxDensity then 
				-- Too big of density
				TriggerClientEvent('chatMessage', src, Config.Messages.Error.DensityTooBig:gsub("{MAX_DENSITY}", tostring(maxDensity)));
				return;
			end
			if flameScale > maxFlameScale then 
				-- Too big of flame scale
				TriggerClientEvent('chatMessage', src, Config.Messages.Error.FlameScaleTooBig:gsub("{MAX_FLAMES}", tostring(maxFlameScale)));
				return;
			end
			TriggerClientEvent("Fire:preview", src, args[2], args[3], args[4], args[5], true);
			TriggerClientEvent('chatMessage', src, Config.Messages.General.PreviewModeEnabled);
			return;
		end
	elseif args[1] == "stopall" then 
		if IsPlayerAceAllowed(src, "BadgerFires.StopAll") then 
			FireTracker = {};
			TriggerClientEvent("Fire:stopall", -1, args[2]);
			TriggerClientEvent('chatMessage', src, Config.Messages.General.AllFiresStopped);
		else 
			TriggerClientEvent('chatMessage', src, Config.Messages.Error.No_PermissionStopAll);
		end
	end
end)

AddEventHandler('playerDropped', function()
	local src = source;
	TriggerClientEvent("Fire:stopByUser", src);
	FireTracker[src] = nil;
end)

function sendUsage(source)
	TriggerClientEvent("chatMessage", source, "^1USAGE: ^5/fire start <inFrontDistance> <size> <density> <flameScale> ^3- Start a fire");
	TriggerClientEvent("chatMessage", source, "^1USAGE: ^5/fire stop <fireID> ^3- Stop a fire with the specified fireID");
	TriggerClientEvent("chatMessage", source, "^1USAGE: ^5/fire preview <inFrontDistance> <size> <density> <flameScale> ^3- Enter ^2Preview Mode");
	TriggerClientEvent("chatMessage", source, "^1USAGE: ^5/fire preview ^3- Cancel ^2Preview Mode");
	TriggerClientEvent("chatMessage", source, "^1USAGE: ^5/fires ^3- List all your started fires as well as their fireIDs");
end

function newFire(posX, posY, posZ, scale, starter, fireTrackID, locationInd)
	TriggerClientEvent('chatMessage', starter, Config.Messages.General.FireStarted:gsub("{STARTER_NAME}", GetPlayerName(starter)):gsub("{STARTER_ID}", starter));
	TriggerClientEvent("Fire:newFire", -1, posX, posY, posZ, scale, starter, fireTrackID, locationInd);
end
RegisterServerEvent("Fire:newFire");
AddEventHandler("Fire:newFire", newFire);

RegisterServerEvent('Fire:Client:RequestCurrent')
AddEventHandler('Fire:Client:RequestCurrent', function() 
end)
