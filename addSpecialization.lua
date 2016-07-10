addSpecialization = {};
addSpecialization.isLoaded = true;
addSpecialization.g_currentModDirectory = g_currentModDirectory;

if SpecializationUtil.specializations["FOVFixer"] == nil then
	SpecializationUtil.registerSpecialization("FOVFixer", "FOVFixer", g_currentModDirectory .. "FOVFixer.lua")
	addSpecialization.isLoaded = false;
end;

addModEventListener(addSpecialization);

function addSpecialization:loadMap(name)	
    if not g_currentMission.RockSpawnModIsLoaded then
		if not addSpecialization.isLoaded then
			addSpecialization:add();
			addSpecialization.isLoaded = true;
		end;
		
		g_currentMission.RockSpawnModIsLoaded = true;
	else
		print("FOVFixer - Error: The FOVFixer mod has been loaded already! Please remove one of the copies.");
	end;
end;

function addSpecialization:deleteMap()
	g_currentMission.RockSpawnModIsLoaded = nil;
end;

function addSpecialization:mouseEvent(posX, posY, isDown, isUp, button)
end;

function addSpecialization:keyEvent(unicode, sym, modifier, isDown)
end;

function addSpecialization:update(dt)
end;

function addSpecialization:draw()
end;

function addSpecialization:add()
	
	FOVFixerVehicles = {"steerable"};
	
	for i = 1, table.getn(FOVFixerVehicles) do
	
		local searchWords = {};
		local searchSpecializations = {{"FOVFixer", false},{FOVFixerVehicles[i], true}}; -- only globally accessible scripts. (steerable, fillable etc.) 
		
		for k, vehicle in pairs(VehicleTypeUtil.vehicleTypes) do
			local locationAllowed, specialization;
		
			
			for _, s in ipairs(searchSpecializations) do s[3] = false; end;

			for _, vs in ipairs(vehicle.specializations) do
				for _, s in ipairs(searchSpecializations) do
					if vs == SpecializationUtil.getSpecialization(s[1]) then
						if s[2] then
							locationAllowed = "allowed";
							s[3] = true;
						else
							locationAllowed = "has";
							specialization = s[1];
							break;
						end;
					end;
				end;
				
				if locationAllowed ~= nil and locationAllowed ~= "allowed" then
					break;
				end;
			end;
			
			if locationAllowed == nil then
				locationAllowed = "allowed";
			end;
			
			for _, s in ipairs(searchSpecializations) do
				if s[2] then
					if s[3] ~= true then
						locationAllowed = "missing";
						specialization = s[1];
						break;
					end;
				end;
			end;
			
			if locationAllowed == "allowed" then
				local addSpec;
				local modName = Utils.splitString(".", k);
				local spec = {};
				
				for name in pairs(SpecializationUtil.specializations) do
					if string.find(name, modName[1]) ~= nil then
						local parts = Utils.splitString(".", name);
						
						if table.getn(parts) > 1 then
							table.insert(spec, parts);
						end;
					end;
				end;
				
				for _, s in ipairs(spec) do
					for _, search in ipairs(searchWords) do
						if string.find(string.lower(s[2]), string.lower(search)) ~= nil then
							addSpec = s[2];
							break;
						end;
					end;
					
					if addSpec ~= nil then
						break;
					end;
				end;
				
				if addSpec == nil then
					table.insert(vehicle.specializations, SpecializationUtil.getSpecialization("FOVFixer"));
				else
					print("FOVFixer: Failed inserting on " .. k .. " as it has the specialization (" .. addSpec .. ")");
				end;
			elseif locationAllowed == "has" then
				print("FOVFixer: Failed inserting on " .. k .. " as it has the specialization (" .. specialization .. ")");
			end;
		end;
	end;

	--make l10n global
	g_i18n.globalI18N.texts["FOVFixer_UP"] = g_i18n:getText("FOVFixer_UP");
	g_i18n.globalI18N.texts["FOVFixer_DOWN"] = g_i18n:getText("FOVFixer_DOWN");	
end;