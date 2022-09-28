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

if MultiCastActionBarFrame and class == 'SHAMAN' then
	MultiCastActionBarFrame:SetScript('OnUpdate', nil)
	MultiCastActionBarFrame:SetScript('OnShow', nil)
	MultiCastActionBarFrame:SetScript('OnHide', nil)
	MultiCastActionBarFrame:SetParent(pUiStanceHolder)
	MultiCastActionBarFrame:SetClearPoint('BOTTOMLEFT', pUiStanceHolder, -3, 0)
	
	hooksecurefunc('MultiCastActionButton_Update',function(actionButton)
		if not InCombatLockdown() then
			actionButton:SetAllPoints(actionButton.slotButton)
		end
	end);
	
	MultiCastActionBarFrame.SetParent = noop;
	MultiCastActionBarFrame.SetPoint = noop;
	MultiCastRecallSpellButton.SetPoint = noop;
end