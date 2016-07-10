FOVFixer = {};

FOVFixer.ModsSettings = {};

function FOVFixer.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(Steerable, specializations);
end;

function FOVFixer:load(xmlFile)	

	-- Go through each cameras for the vehicle, get the existing values from ModsSettings.
	for i = 1, self.numCameras do			
		local currentValue = g_currentMission.FOVFixer:getFOV(self.configFileName, i);	

		if currentValue ~= 0 then
			setFovy(self.cameras[i].cameraNode, currentValue);
		else
			-- There's nothing for this camera currently, we might as well save the default. 
			g_currentMission.FOVFixer:setFOV(self.configFileName, i, getFovy(self.cameras[i].cameraNode));
		end
	end	
end;

function FOVFixer:delete()	
end;

function FOVFixer:loadFromAttributesAndNodes(xmlFile, key, resetVehicles)  
end;

function FOVFixer:getSaveAttributesAndNodes(nodeIdent)
end;

function FOVFixer:mouseEvent(posX, posY, isDown, isUp, button)
end;

function FOVFixer:keyEvent(unicode, sym, modifier, isDown)
end;

function FOVFixer:updateTick(dt)
end;

function FOVFixer:update(dt)
	if self:getIsActive() then	
		if self:getIsActiveForInput() then	

			local camera = self.cameras[self.camIndex];
			local cameraId = camera.cameraNode;
			local currentFOV = getFovy(cameraId);	
			
			if InputBinding.hasEvent(InputBinding.FOVFixer_UP) then
				local newFOV = currentFOV + 1;
				g_currentMission.FOVFixer:setFOV(self.configFileName, self.camIndex, newFOV);
				setFovy(cameraId, newFOV);
			end

			if InputBinding.hasEvent(InputBinding.FOVFixer_DOWN) then
				local newFOV = currentFOV - 1;
				g_currentMission.FOVFixer:setFOV(self.configFileName, self.camIndex, newFOV);
				setFovy(cameraId, newFOV);
			end
		end
	end		
end;

function FOVFixer:draw() 
	if self:getIsActiveForInput() then
		-- Add the inputBindings to the F1 help box (they need to be registered globally first, check addSpecialization.lua)
		g_currentMission:addHelpButtonText(g_i18n:getText("FOVFixer_UP"), InputBinding.FOVFixer_UP);
		g_currentMission:addHelpButtonText(g_i18n:getText("FOVFixer_DOWN"), InputBinding.FOVFixer_DOWN);

		local camera = self.cameras[self.camIndex];	

		if camera ~= nil then
			local currentFOV = getFovy(camera.cameraNode);
			g_currentMission:addHelpButtonText("Field of view : " .. currentFOV, InputBinding.FOVFixer_DEFAULT);
		end
	end	
end;