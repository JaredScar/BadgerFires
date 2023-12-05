
Fire = setmetatable({}, Fire);
Fire.__index = Fire;

Fire.Preview = false;
Fire.Flames = {};

Citizen.CreateThread(function()
	Citizen.Wait(3000);
	-- We need to get the fires for the client side, to display them...
	TriggerServerEvent('Fire:Client:RequestCurrent');
	if (Config.VehicleEngineFires) then 
		while (true) do 
			Citizen.Wait(0);
			local playerPed = GetPlayerPed(-1);
			local veh = GetVehiclePedIsIn(playerPed);
			if (GetVehicleHealthPercentage(veh) <= 0) then 
				NetworkExplodeVehicle(veh, true, false);
			end
		end
	end
end)
RegisterNetEvent('Fire:Client:CurrentReturn')
AddEventHandler('Fire:Client:CurrentReturn', function(flames)
	Fire.Flames = flames;
end)

function Fire.Preview(distance, area, density, scale, toggle)
	Citizen.CreateThread(function()
		Fire.Preview = false;
		Wait(100);
		Fire.Preview = toggle;
		while Fire.Preview do
			Wait(5);
			local heading = GetEntityHeading(GetPlayerPed(-1));
			local localPos = GetEntityCoords(GetPlayerPed(-1));
			local x = localPos.x + math.cos(math.rad(heading+90)) * distance;
			local y = localPos.y + math.sin(math.rad(heading+90)) * distance;
			local z = localPos.z;

			-- Display a circle for the area
			local angle = 0;
			while angle < 360 do
				local circle_x = x + math.cos(math.rad(angle)) * area/2;
				local circle_y = y + math.sin(math.rad(angle)) * area/2;
				local circle_x_next = x + math.cos(math.rad(angle + 1)) * area/2;
				local circle_y_next = y + math.sin(math.rad(angle + 1)) * area/2;
				local _, circle_z = GetGroundZFor_3dCoord(circle_x, circle_y, localPos.z + 5.0);
				local _, circle_z_next = GetGroundZFor_3dCoord(circle_x_next, circle_y_next, localPos.z);
				DrawLine(circle_x, circle_y, circle_z + 0.05, circle_x_next, circle_y_next, circle_z_next + 0.05, 0, 0, 255, 255);
				angle = angle + 1;
			end

			-- Display crosses at fire locations
			local area_x = x - area/2;
			local area_y = y - area/2;
			local area_x_max = x + area/2;
			local area_y_max = y + area/2;
			local step = math.ceil(area / density);
			while area_x <= area_x_max do
				area_y = y - area/2;
				while area_y <= area_y_max do
					if (GetDistanceBetweenCoords(x, y, z, area_x, area_y, 0, false) < area/2) then
						local _, area_z = GetGroundZFor_3dCoord(area_x, area_y, localPos.z + 5.0);
						DrawLine(area_x - 0.25, area_y - 0.25, area_z + 0.05, area_x + 0.25, area_y + 0.25, area_z + 0.05, 255, 0, 0, 255);
						DrawLine(area_x - 0.25, area_y + 0.25, area_z + 0.05, area_x + 0.25, area_y - 0.25, area_z + 0.05, 255, 0, 0, 255);
					end
					area_y = area_y + step;
				end
				area_x = area_x + step;
			end
		end
	end)
end
RegisterNetEvent("Fire:preview");
AddEventHandler("Fire:preview", Fire.Preview);


fireTrackID = 0;
fireStillLoading = false;
function Fire.start(distance, area, density, scale, id)
	local heading = GetEntityHeading(GetPlayerPed(-1));
	local localPos = GetEntityCoords(GetPlayerPed(-1));
	local x = localPos.x + math.cos(math.rad(heading+90)) * distance;
	local y = localPos.y + math.sin(math.rad(heading+90)) * distance;
	local z = localPos.z;
	local area_x = x - area/2;
	local area_y = y - area/2;
	local area_x_max = x + area/2;
	local area_y_max = y + area/2;
	local step = math.ceil(area / density);

	-- Loop through a square, with steps based on density
	Citizen.CreateThread(function()
		local x_arr = {};
		local y_arr = {};
		local z_arr = {};
		Citizen.Wait(0);
		while area_x <= area_x_max do
			Citizen.Wait(0);
			area_y = y - area/2;
			while area_y <= area_y_max do
				-- Check the distance to the center to make it into a circle only
				if (GetDistanceBetweenCoords(x, y, z, area_x, area_y, 0, false) < area/2) then
					local _, area_z = GetGroundZFor_3dCoord(area_x, area_y, localPos.z + 5.0);
					-- Fire.newFire(area_x, area_y, area_z, scale);
					Wait(1);
					table.insert(x_arr, area_x);
					table.insert(y_arr, area_y);
					table.insert(z_arr, area_z);
					--TriggerServerEvent("Fire:newFire", area_x, area_y, area_z, scale, id, fireTrackID);
				end
				area_y = area_y + step;
			end
			area_x = area_x + step;
		end
		TriggerServerEvent("Fire:newFire", x_arr, y_arr, z_arr, scale, id, fireTrackID, nil);
	end)
	fireTrackID = fireTrackID + 1;
end
function Fire.startLocation(x, y, z, distance, area, density, scale, locationInd)
	local area_x = x - area/2;
	local area_y = y - area/2;
	local area_x_max = x + area/2;
	local area_y_max = y + area/2;
	local step = math.ceil(area / density);

	-- Loop through a square, with steps based on density
	Citizen.CreateThread(function()
		local x_arr = {};
		local y_arr = {};
		local z_arr = {};
		Citizen.Wait(0);
		while area_x <= area_x_max do
			Citizen.Wait(0);
			area_y = y - area/2;
			while area_y <= area_y_max do
				-- Check the distance to the center to make it into a circle only
				if (GetDistanceBetweenCoords(x, y, z, area_x, area_y, 0, false) < area/2) then
					local _, area_z = GetGroundZFor_3dCoord(area_x, area_y, z + 5.0);
					-- Fire.newFire(area_x, area_y, area_z, scale);
					Wait(1);
					table.insert(x_arr, area_x);
					table.insert(y_arr, area_y);
					table.insert(z_arr, area_z);
				end
				area_y = area_y + step;
			end
			area_x = area_x + step;
		end
		-- Start new fire at location specified...
		Fire.newFire(x_arr, y_arr, z_arr, scale, nil, fireTrackID, locationInd)
	end)
	fireTrackID = fireTrackID + 1;
end
RegisterNetEvent("Fire:start");
AddEventHandler("Fire:start", Fire.start);
RegisterNetEvent("Fire:startLocation");
AddEventHandler("Fire:startLocation", Fire.startLocation);
Fire.Flames = {};
function Fire.newFire(posX, posY, posZ, scale, started, fireTrackID, locationIndex)
	-- Load the fire particle
	if (not HasNamedPtfxAssetLoaded("core")) then
		RequestNamedPtfxAsset("core");
		local waitTime = 0;
		while not HasNamedPtfxAssetLoaded("core") do
			if (waitTime >= 1000) then
				RequestNamedPtfxAsset("core");
				waitTime = 0;
			end
			Wait(10);
			waitTime = waitTime + 10;
		end
	end
	UseParticleFxAssetNextCall("core");

	-- Make both a standard fire and a big fire particle on top of it
	local currentFlames = Fire.Flames;
	Citizen.CreateThread(function()
		Citizen.Wait(0);
		local curInd = 1;
		if (locationIndex ~= nil) then 
			fireTrackID = tostring(fireTrackID) .. "L";
		end
		while (curInd < #posX) do
			Citizen.Wait(0);
			local x2 = tonumber(posX[curInd]);
			local y2 = tonumber(posY[curInd]);
			local z2 = tonumber(posZ[curInd]);
			if (x2 ~= nil and y2 ~= nil and z2 ~= nil) then
			end
			local fxHandle = StartParticleFxLoopedAtCoord(Config.ParticleEffect, x2, y2, z2 + 0.25, 0.0, 0.0, 0.0, scale + 0.001, false, false, false, false);
			local fireHandle = StartScriptFire(x2, y2, z2 + 0.25, 0, false);
			currentFlames[#currentFlames + 1] = {fire = fireHandle, ptfx = fxHandle, pos = {x = x2, y = y2, z = z2 + 0.05}, starter = started, fireTracked = fireTrackID, locationInd = locationIndex};		
			curInd = curInd + 1;
		end
		Fire.Flames = currentFlames;
	end)
end
RegisterNetEvent("Fire:newFire");
AddEventHandler("Fire:newFire", Fire.newFire);

function round(num, numDecimalPlaces)
	if numDecimalPlaces and numDecimalPlaces>0 then
		local mult = 10^numDecimalPlaces
		return math.floor(num * mult + 0.5) / mult
	end
	return math.floor(num + 0.5)
end
RegisterCommand("fires", function(source, args, rawCommand)
	local coords = GetEntityCoords(GetPlayerPed(-1), false);
	TriggerEvent('chat:addMessage', {
		color = { 255, 0, 0},
		multiline = true,
		args = {"^6Your started fires: "}
	  });
	local tracked = {};
	for i, flame in pairs(Fire.Flames) do
		if flame.starter == GetPlayerServerId(GetPlayerID()) then 
			-- It's their fire
			local trackID = flame.fireTracked;
			if tracked[trackID] == nil then 
				tracked[trackID] = true;
				local distance = GetDistanceBetweenCoords(flame.pos.x, flame.pos.y, flame.pos.z, coords.x, coords.y, coords.z, 1);
				TriggerEvent('chat:addMessage', {
					color = { 255, 0, 0},
					multiline = true,
					args = {"^3FireID: ^1" .. trackID .. " ^5||| ^3Distance: ^1" .. tostring( round(distance, 2) ) .. "^3m"}
				})
			end
		end
	end
	tracked = {};
	if (Config.RandomFireSpawning) then
		TriggerEvent('chat:addMessage', {
			color = { 255, 0, 0},
			multiline = true,
			args = {"^6Located fires: "}
		  });
		for i, flame in pairs(Fire.Flames) do
			local locInd = flame.locationInd;
			local trackID = flame.fireTracked;
			if (locInd ~= nil) then
				local locName = Config.RandomFireLocations[locInd].name;
				local distance = GetDistanceBetweenCoords(flame.pos.x, flame.pos.y, flame.pos.z, coords.x, coords.y, coords.z, 1);
				if (locName ~= nil) then
					if tracked[trackID] == nil then 
						tracked[trackID] = true;
						TriggerEvent('chat:addMessage', {
							color = { 255, 0, 0},
							multiline = true,
							args = {"^3FireID: ^1" .. trackID .. " ^5||| ^3" .. locName .. " ^5||| ^3Distance: ^1" .. tostring( round(distance, 2) ) .. "^3m"}
						});
					end
				end
			end
		end
	end
end)
function isFireStillActive(trackID, id)
	for i, flame in pairs(Fire.Flames) do
		if flame ~= nil then 
			if flame.starter == id and flame.fireTracked == trackID then
				return true; 
			end
		end
	end
	return false;
end

RegisterNetEvent("Fire:stopByUser");
AddEventHandler("Fire:stopByUser", Fire.stopByUser);

function GetPlayerID()
	for _, i in ipairs(GetActivePlayers()) do
        if NetworkIsPlayerActive(i) then
			if GetPlayerPed(i) == GetPlayerPed(-1) then
				return i;
			end
		end
    end
end

function Fire.stopByUser(id)
	for i, flame in pairs(Fire.Flames) do
		local continue = true;
		if flame == nil then 
			table.remove(Fire.Flames, i);
			continue = false;
		end
		if continue then
			if flame.starter == id then 
				if DoesParticleFxLoopedExist(flame.ptfx) then
					StopParticleFxLooped(flame.ptfx, 1);
					RemoveParticleFx(flame.ptfx, 1);
				end
				RemoveScriptFire(flame.fire);
				StopFireInRange(flame.pos.x, flame.pos.y, flame.pos.z, 20.0);
				Fire.Flames[i] = nil;
			end
		end
	end
end

local lockingMechanism = false;

function Fire.stop(fireHandle, id)
	lockingMechanism = true;
	Citizen.Wait(100);
	local size = 0;
	for i, flame in pairs(Fire.Flames) do 
		size = size + 1;
	end
	for i, flame in pairs(Fire.Flames) do
		local continue = true;
		if flame ~= nil then
			if tostring(flame.fireTracked) == tostring(fireHandle) and (fireHandle:find("L") or tonumber(flame.starter) == tonumber(id)) then
				if DoesParticleFxLoopedExist(flame.ptfx) then
					StopParticleFxLooped(flame.ptfx, 1);
					RemoveParticleFx(flame.ptfx, 1);
				end
				RemoveScriptFire(flame.fire);
				StopFireInRange(flame.pos.x, flame.pos.y, flame.pos.z, 100.0);
				Fire.Flames[i] = nil;
			end
		end
	end
	lockingMechanism = false;
end
function Fire.stopAll()
	for i, flame in pairs(Fire.Flames) do
		local continue = true;
		if flame == nil then 
			Fire.Flames[i] = nil;
			continue = false;
		end
		if continue then
			if DoesParticleFxLoopedExist(flame.ptfx) then
				StopParticleFxLooped(flame.ptfx, 1);
				RemoveParticleFx(flame.ptfx, 1);
			end
			RemoveScriptFire(flame.fire);
			StopFireInRange(flame.pos.x, flame.pos.y, flame.pos.z, 20.0);
			Fire.Flames[i] = nil;
		end
	end
end
RegisterNetEvent("Fire:stop");
AddEventHandler("Fire:stop", Fire.stop);
RegisterNetEvent("Fire:stopByLocation");
AddEventHandler("Fire:stopByLocation", Fire.stopByLocation);
function Fire.stopByLocation(index)
	lockingMechanism = true;
	Citizen.Wait(100);
	local size = 0;
	for i, flame in pairs(Fire.Flames) do 
		size = size + 1;
	end
	for i, flame in pairs(Fire.Flames) do
		local continue = true;
		if flame ~= nil then
			if tonumber(flame.locationInd) == tonumber(index) then
				if DoesParticleFxLoopedExist(flame.ptfx) then
					StopParticleFxLooped(flame.ptfx, 1);
					RemoveParticleFx(flame.ptfx, 1);
				end
				RemoveScriptFire(flame.fire);
				StopFireInRange(flame.pos.x, flame.pos.y, flame.pos.z, 100.0);
				Fire.Flames[i] = nil;
			end
		end
	end
	lockingMechanism = false;
end
RegisterNetEvent("Fire:stopall");
AddEventHandler("Fire:stopall", Fire.stopAll);

Citizen.CreateThread(function()
	while true do
		Wait(100);
		-- Loop through all the fires
		if not lockingMechanism then 
			for i, flame in ipairs(Fire.Flames) do
				if DoesParticleFxLoopedExist(flame.ptfx) then
					-- If there are no more 'normal' fire next to the big fire particle, remove the particle
					if (GetNumberOfFiresInRange(flame.pos.x, flame.pos.y, flame.pos.z, 0.2) <= 1) then
						StopParticleFxLooped(flame.ptfx, 1);
						RemoveParticleFx(flame.ptfx, 1);
						RemoveScriptFire(flame.fire);
						Fire.Flames[i] = nil;
					end
				end
			end
		end
	end
end)
