local addon = select(2,...);
local config = addon.config;
local class = addon._class;
local noop = addon._noop;
local select = select;
local InCombatLockdown = InCombatLockdown;
local hooksecurefunc = hooksecurefunc;

local possessbar = CreateFrame('Frame', 'pUiPossessBar', UIParent, 'SecureHandlerStateTemplate')
possessbar:SetAllPoints(pUiPetBarHolder)
PossessBarFrame:SetParent(possessbar)
PossessBarFrame:SetClearPoint('BOTTOMLEFT', -68, 0)

local btnsize = config.additional.size;
local space = config.additional.spacing;
local function possessbutton_position()
	local button
	for index=1, NUM_POSSESS_SLOTS do
		button = _G['PossessButton'..index];
		button:ClearAllPoints();
		button:SetSize(btnsize, btnsize);
		if index == 1 then
			button:SetPoint('BOTTOMLEFT', 0, 0);
		else
			button:SetPoint('LEFT', _G['PossessButton'..index-1], 'RIGHT', space, 0);
		end
		button:Show();
	end
	addon.possessbuttons_template();
	RegisterStateDriver(possessbar, 'visibility', '[vehicleui][@vehicle,exists] hide; show');
end
possessbutton_position();

local function stanceCount()
	local count = 0
	for index=1, NUM_SHAPESHIFT_SLOTS do
		local _,name = GetShapeshiftFormInfo(index)
		if name then
			count = count+1
		end
	end
	return count
end


if MultiCastActionBarFrame and ( class == 'SHAMAN' or class == 'HERO' or C_Player:IsCustomClass()) then
	MultiCastActionBarFrame:SetScript('OnUpdate', nil)
	MultiCastActionBarFrame:SetScript('OnShow', nil)
	MultiCastActionBarFrame:SetScript('OnHide', nil)
	if class == 'SHAMAN' then 
		MultiCastActionBarFrame:SetParent(pUiStanceHolder)
		MultiCastActionBarFrame:SetClearPoint('BOTTOMLEFT', pUiStanceHolder, -3, 0)
		MultiCastActionBarFrame.SetParent = noop;
		MultiCastActionBarFrame.SetPoint = noop;
		MultiCastRecallSpellButton.SetPoint = noop;
	else
		MultiCastActionBarFrame:SetParent(pUiStanceHolder)
		MultiCastActionBarFrame:SetPoint('BOTTOMLEFT', pUiStanceHolder,'BOTTOMLEFT',( config.additional.size + config.additional.spacing)* stanceCount(), -3)
	end
	hooksecurefunc('MultiCastActionButton_Update',function(actionButton)
		if not InCombatLockdown() then
			actionButton:SetAllPoints(actionButton.slotButton)
		end
	end);
end