FOVFixerLoader = {};

addModEventListener(FOVFixerLoader);

function FOVFixerLoader:loadMap(name)
	g_currentMission.FOVFixer = self;

	self.ourFovDataTable = {};
end;

function FOVFixerLoader:deleteMap()	
	g_currentMission.FOVFixer = nil;
end;


function FOVFixerLoader:mouseEvent(posX, posY, isDown, isUp, button)
end;

function FOVFixerLoader:keyEvent(unicode, sym, modifier, isDown)
end;

function FOVFixerLoader:update(dt)	
end;

function FOVFixerLoader:draw()
end;

function FOVFixerLoader:getFOV(filename, camIndex)
	-- Convert self.configFileName to something friendlier for XML tags.
	filename = FOVFixerLoader:getModName(filename);

	-- If the value already exists in our table, send that.
	if self.ourFovDataTable[filename] ~= nil and self.ourFovDataTable[filename][camIndex] then
		return self.ourFovDataTable[filename][camIndex];
	end	

	local existingValue = 0;

	-- If ModsSettings is defined, try to get the value from there.
	if ModsSettings ~= nil then		
		local modName = string.format("FOVFixer_%s", filename);
		local keyName = string.format("Camera%d", camIndex);

		existingValue = ModsSettings.getFloatLocal(modName, keyName, "current", 0);

		-- If we got a non-zero value from ModsSettings.XML, add it to our table.
		if existingValue ~= 0 then

			if self.ourFovDataTable[filename] == nil then
				self.ourFovDataTable[filename] = {};
			end

			self.ourFovDataTable[filename][camIndex] = existingValue;
		end
	end

	return existingValue; 
end

function FOVFixerLoader:setFOV(filename, camIndex, value)
	-- Convert self.configFileName to something friendlier for XML tags.
	filename = FOVFixerLoader:getModName(filename);

	if self.ourFovDataTable[filename] == nil then
		self.ourFovDataTable[filename] = {};
	end

	self.ourFovDataTable[filename][camIndex] = value;
end

function FOVFixerLoader.saveToXML()	

	-- Go through our table and save everything to the XML file.
	if ModsSettings ~= nil then
		for key, value in pairs(g_currentMission.FOVFixer.ourFovDataTable) do
			for key2, value2 in pairs(value) do
				local modName = string.format("FOVFixer_%s", key);
				local keyName = string.format("Camera%d", key2);

				ModsSettings.setFloatLocal(modName, keyName, "current", value2);
			end
		end
	end
end

function FOVFixerLoader:getModName(filename)
	-- Remove the extension from the filename.
	local fileName = Utils.getFilenameInfo(filename);
	
	-- Split it at the /
	local fileNameParts = Utils.splitString("/", fileName);

	return fileNameParts[#fileNameParts];
end

-- When the game is saved, we want to save data to ModsSettings.XML as well
CareerScreen.saveSavegame= Utils.appendedFunction(CareerScreen.saveSavegame, FOVFixerLoader.saveToXML);