local addon = select(2,...);
local config = addon.config;
local class = addon._class;
local unpack = unpack;
local ipairs = ipairs;
local RegisterStateDriver = RegisterStateDriver;
local UnitVehicleSkin = UnitVehicleSkin;
local UIParent = UIParent;
local _G = getfenv(0);

-- const
local pUiMainBar = addon.pUiMainBar;
local vehicleType = UnitVehicleSkin('player');
local btnsize = config.additional.size;
local vehicle_pos = config.additional.vehicle.position;
local barstyle = config.additional.vehicle.artstyle;
local vehicleBarBackground = CreateFrame(
	'Frame',
	'mixin2template',
	UIParent,
	'VehicleBarUiTemplate'
);
local vehiclebar = CreateFrame(
	'Frame',
	'pUiVehicleBar',
	mixin2template,
	'SecureHandlerStateTemplate'
);
local vehicleExit = CreateFrame(
	'CheckButton',
	'vehicleExit',
	pUiMainBar,
	'SecureHandlerClickTemplate,SecureHandlerStateTemplate'
);
vehicleBarBackground:SetScale(config.mainbars.scale_vehicle)
vehiclebar:ClearAllPoints();
vehiclebar:SetAllPoints(mixin2template);

local function vehiclebar_power_setup()
	VehicleMenuBarLeaveButton:SetParent(vehiclebar)
	VehicleMenuBarLeaveButton:SetSize(47, 50)
	VehicleMenuBarLeaveButton:SetClearPoint('BOTTOMRIGHT', -178, 14)
	VehicleMenuBarLeaveButton:SetHighlightTexture('Interface\\Vehicles\\UI-Vehicles-Button-Highlight')
	VehicleMenuBarLeaveButton:GetHighlightTexture():SetTexCoord(0.130625, 0.879375, 0.130625, 0.879375)
	VehicleMenuBarLeaveButton:GetHighlightTexture():SetBlendMode('ADD')
	VehicleMenuBarLeaveButton:SetScript('OnClick', VehicleExit)

	VehicleMenuBarHealthBar:SetParent(vehiclebar)
	-- VehicleMenuBarHealthBar:SetClearPoint('BOTTOMLEFT', 119, 3)
	VehicleMenuBarHealthBarOverlay:SetParent(VehicleMenuBarHealthBar)
	VehicleMenuBarHealthBarOverlay:SetSize(46, 105)
	VehicleMenuBarHealthBarOverlay:SetClearPoint('BOTTOMLEFT', -5, -9)
	VehicleMenuBarHealthBarBackground:SetParent(VehicleMenuBarHealthBar)
	VehicleMenuBarHealthBarBackground:SetTexture([[Interface\Tooltips\UI-Tooltip-Background]])
	VehicleMenuBarHealthBarBackground:SetTexCoord(0.0, 1.0, 0.0, 1.0)
	VehicleMenuBarHealthBarBackground:SetVertexColor(
		TOOLTIP_DEFAULT_BACKGROUND_COLOR.r,
		TOOLTIP_DEFAULT_BACKGROUND_COLOR.g,
		TOOLTIP_DEFAULT_BACKGROUND_COLOR.b
	);

	VehicleMenuBarPowerBar:SetParent(vehiclebar)
	-- VehicleMenuBarPowerBar:SetClearPoint('BOTTOMRIGHT', -119, 3)
	VehicleMenuBarPowerBarOverlay:SetParent(VehicleMenuBarPowerBar)
	VehicleMenuBarPowerBarOverlay:SetSize(46, 105)
	VehicleMenuBarPowerBarOverlay:SetClearPoint('BOTTOMLEFT', -5, -9)
	VehicleMenuBarPowerBarBackground:SetParent(VehicleMenuBarPowerBar)
	VehicleMenuBarPowerBarBackground:SetTexture([[Interface\Tooltips\UI-Tooltip-Background]])
	VehicleMenuBarPowerBarBackground:SetTexCoord(0.5390625, 0.953125, 0.0, 1.0)
	VehicleMenuBarPowerBarBackground:SetVertexColor(
		TOOLTIP_DEFAULT_BACKGROUND_COLOR.r,
		TOOLTIP_DEFAULT_BACKGROUND_COLOR.g,
		TOOLTIP_DEFAULT_BACKGROUND_COLOR.b
	);
end

local function vehiclebar_mechanical_setup()
	mixin2template.OrganicUi:Hide()
	mixin2template.MechanicUi:Show()
	
	VehicleMenuBarLeaveButton:SetNormalTexture(addon._dir..'mechanical2')
	VehicleMenuBarLeaveButton:GetNormalTexture():SetTexCoord(45/512, 84/512, 185/512, 224/512)
	VehicleMenuBarLeaveButton:SetPushedTexture(addon._dir..'mechanical2')
	VehicleMenuBarLeaveButton:GetPushedTexture():SetTexCoord(2/512, 40/512, 185/512, 223/512)
	
	VehicleMenuBarHealthBar:SetSize(38, 84)
	VehicleMenuBarPowerBar:SetSize(38, 84)
	VehicleMenuBarPowerBar:SetClearPoint('BOTTOMRIGHT', -94, 6)
	VehicleMenuBarHealthBar:SetClearPoint('BOTTOMLEFT', 74, 6)
	VehicleMenuBarHealthBarBackground:SetSize(40, 92)
	VehicleMenuBarPowerBarBackground:SetSize(40, 92)
	VehicleMenuBarHealthBarBackground:SetClearPoint('BOTTOMLEFT', -2, -6)
	VehicleMenuBarPowerBarBackground:SetClearPoint('BOTTOMLEFT', -2, -6)
	VehicleMenuBarHealthBarOverlay:SetTexture(addon._dir..'mechanical2')
	VehicleMenuBarHealthBarOverlay:SetTexCoord(4/512, 44/512, 263/512, 354/512)
	VehicleMenuBarPowerBarOverlay:SetTexture(addon._dir..'mechanical2')
	VehicleMenuBarPowerBarOverlay:SetTexCoord(4/512, 44/512, 263/512, 354/512)
	
	VehicleMenuBarPitchUpButton:SetParent(mixin2template.MechanicUi)
	VehicleMenuBarPitchUpButton:SetSize(32, 31)
	VehicleMenuBarPitchUpButton:SetClearPoint('BOTTOMLEFT', 156, 46)
	VehicleMenuBarPitchUpButton:SetNormalTexture(addon._dir..'mechanical2')
	VehicleMenuBarPitchUpButton:SetPushedTexture(addon._dir..'mechanical2')
	VehicleMenuBarPitchUpButton:GetNormalTexture():SetTexCoord(1/512, 34/512, 227/512, 259/512)
	VehicleMenuBarPitchUpButton:GetPushedTexture():SetTexCoord(36/512, 69/512, 227/512, 259/512)

	VehicleMenuBarPitchDownButton:SetParent(mixin2template.MechanicUi)
	VehicleMenuBarPitchDownButton:SetSize(32, 31)
	VehicleMenuBarPitchDownButton:SetClearPoint('BOTTOMLEFT', 156, 8)
	VehicleMenuBarPitchDownButton:SetNormalTexture(addon._dir..'mechanical2')
	VehicleMenuBarPitchDownButton:SetPushedTexture(addon._dir..'mechanical2')
	VehicleMenuBarPitchDownButton:GetNormalTexture():SetTexCoord(148/512, 180/512, 289/512, 320/512)
	VehicleMenuBarPitchDownButton:GetPushedTexture():SetTexCoord(148/512, 180/512, 323/512, 354/512)

	VehicleMenuBarPitchSlider:SetParent(mixin2template.MechanicUi)
	VehicleMenuBarPitchSlider:SetSize(20, 82)
	VehicleMenuBarPitchSlider:SetClearPoint('BOTTOMLEFT', 124, 2)
	
	mixin2templateBACKGROUND1:SetDrawLayer('BACKGROUND', -1)
	
	VehicleMenuBarPitchSliderBG:SetTexture([[Interface\Vehicles\UI-Vehicles-Endcap]]);
	VehicleMenuBarPitchSliderBG:SetTexCoord(0.46875, 0.50390625, 0.31640625, 0.62109375)
	VehicleMenuBarPitchSliderBG:SetVertexColor(0, 0.85, 0.99)

	VehicleMenuBarPitchSliderMarker:SetWidth(20)
	VehicleMenuBarPitchSliderMarker:SetTexture([[Interface\Vehicles\UI-Vehicles-Endcap]]);
	VehicleMenuBarPitchSliderMarker:SetTexCoord(0.46875, 0.50390625, 0.45, 0.55)
	VehicleMenuBarPitchSliderMarker:SetVertexColor(1, 0, 0)
	
	VehicleMenuBarPitchSliderOverlayThing:SetPoint('TOPLEFT', -5, 2)
	VehicleMenuBarPitchSliderOverlayThing:SetPoint('BOTTOMRIGHT', 3, -4)
end

local function vehiclebar_organic_setup()
	mixin2template.OrganicUi:Show();
	mixin2template.MechanicUi:Hide();
	VehicleMenuBarHealthBar:SetSize(38, 74)
	VehicleMenuBarPowerBar:SetSize(38, 74)
	VehicleMenuBarPowerBar:SetClearPoint('BOTTOMRIGHT', -119, 3)
	VehicleMenuBarHealthBar:SetClearPoint('BOTTOMLEFT', 119, 3)
	VehicleMenuBarHealthBarBackground:SetSize(40, 83)
	VehicleMenuBarPowerBarBackground:SetSize(40, 83)
	VehicleMenuBarHealthBarBackground:SetClearPoint('BOTTOMLEFT', -2, -9)
	VehicleMenuBarPowerBarBackground:SetClearPoint('BOTTOMLEFT', -2, -9)
	VehicleMenuBarLeaveButton:SetNormalTexture('Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up')
	VehicleMenuBarLeaveButton:GetNormalTexture():SetTexCoord(0.140625, 0.859375, 0.140625, 0.859375)
	VehicleMenuBarLeaveButton:SetPushedTexture('Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down')
	VehicleMenuBarLeaveButton:GetPushedTexture():SetTexCoord(0.140625, 0.859375, 0.140625, 0.859375)
	VehicleMenuBarHealthBarOverlay:SetTexture([[Interface\Vehicles\UI-Vehicles-Endcap-Organic-bottle]])
	VehicleMenuBarHealthBarOverlay:SetTexCoord(0.46484375, 0.66015625, 0.0390625, 0.9375)
	VehicleMenuBarPowerBarOverlay:SetTexture([[Interface\Vehicles\UI-Vehicles-Endcap-Organic-bottle]])
	VehicleMenuBarPowerBarOverlay:SetTexCoord(0.46484375, 0.66015625, 0.0390625, 0.9375)
end

local function vehiclebar_layout_setup()
	if IsVehicleAimAngleAdjustable() then
		vehiclebar_mechanical_setup();
	else
		vehiclebar_organic_setup();
	end
end

local function vehiclebutton_position()
	local button
	if pUiVehicleBar:IsShown() or mixin2template:IsShown() then
		for index=1, VEHICLE_MAX_ACTIONBUTTONS do
			button = _G['VehicleMenuBarActionButton'..index]
			button:ClearAllPoints()
			button:SetParent(pUiVehicleBar)
			button:SetSize(52, 52)
			button:Show()
			if index == 1 then
				button:SetPoint('BOTTOMLEFT', pUiVehicleBar, 'BOTTOMRIGHT', -594, 21)
			else
				local previous = _G['VehicleMenuBarActionButton'..index-1]
				button:SetPoint('LEFT', previous, 'RIGHT', 6, 0)
			end
		end
	end
end

local function vehiclebutton_state(self)
	local button
	for index=1, VEHICLE_MAX_ACTIONBUTTONS do
		button = _G['VehicleMenuBarActionButton'..index]
		self:SetFrameRef('VehicleMenuBarActionButton'..index, button)
	end	
	self:SetAttribute('_onstate-vehicleupdate', [[
		if newstate == 's1' then
			self:GetParent():Show()
		else
			self:GetParent():Hide()
		end
	]]);
	RegisterStateDriver(self, 'vehicleupdate', '[vehicleui] s1; s2');
end

local vehicleLeave = CreateFrame('CheckButton','pUiVehicleLeaveButton',pUiMainBar,'SecureHandlerClickTemplate');
vehicleLeave:SetParent(pUiStanceBar)
vehicleLeave:SetSize(btnsize, btnsize)
vehicleLeave:SetPoint(unpack(vehicle_pos))
vehicleLeave:SetNormalTexture('Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up')
vehicleLeave:GetNormalTexture():SetTexCoord(0.140625, 0.859375, 0.140625, 0.859375)
vehicleLeave:SetPushedTexture('Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down')
vehicleLeave:GetPushedTexture():SetTexCoord(0.140625, 0.859375, 0.140625, 0.859375)
vehicleLeave:SetHighlightTexture('Interface\\Vehicles\\UI-Vehicles-Button-Highlight')
vehicleLeave:GetHighlightTexture():SetTexCoord(0.130625, 0.879375, 0.130625, 0.879375)
vehicleLeave:GetHighlightTexture():SetBlendMode('ADD')
vehicleLeave:RegisterForClicks('AnyUp')
vehicleLeave:SetScript('OnEnter', function(self)
	GameTooltip_AddNewbieTip(self, LEAVE_VEHICLE, 1.0, 1.0, 1.0, nil);
end)
vehicleLeave:SetScript('OnLeave', GameTooltip_Hide)
vehicleLeave:SetScript('OnClick', function(self)
	VehicleExit();
	self:SetChecked(true);
end)
vehicleLeave:SetScript('OnShow', function(self)
	self:SetChecked(false)
end)
RegisterStateDriver(vehicleLeave, 'visibility', '[vehicleui][target=vehicle,noexists] hide;show')

-- vehicle exit for bonusbar page
local function vehiclebutton_leave()
	vehicleExit:SetParent(pUiStanceBar)
	vehicleExit:SetSize(btnsize, btnsize)
	vehicleExit:SetPoint(unpack(vehicle_pos))
	vehicleExit:SetNormalTexture('Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up')
	vehicleExit:GetNormalTexture():SetTexCoord(0.140625, 0.859375, 0.140625, 0.859375)
	vehicleExit:SetPushedTexture('Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down')
	vehicleExit:GetPushedTexture():SetTexCoord(0.140625, 0.859375, 0.140625, 0.859375)
	vehicleExit:SetHighlightTexture('Interface\\Vehicles\\UI-Vehicles-Button-Highlight')
	vehicleExit:GetHighlightTexture():SetTexCoord(0.130625, 0.879375, 0.130625, 0.879375)
	vehicleExit:GetHighlightTexture():SetBlendMode('ADD')
	vehicleExit:RegisterForClicks('AnyUp')
	vehicleExit:SetScript('OnEnter', function(self)
		GameTooltip_AddNewbieTip(self, LEAVE_VEHICLE, 1.0, 1.0, 1.0, nil);
	end)
	vehicleExit:SetScript('OnLeave', GameTooltip_Hide)
	vehicleExit:SetScript('OnClick', function(self)
		VehicleExit();
		self:SetChecked(true);
	end)
	vehicleExit:SetScript('OnShow', function(self)
		self:SetChecked(false)
	end)
end

local function OnEvent(self,event,...)
	if event == 'PLAYER_LOGIN' then
		vehiclebutton_state(self);
	elseif event == 'PLAYER_ENTERING_WORLD' then
		vehiclebutton_position();
	elseif event == 'UNIT_ENTERED_VEHICLE' then
		vehiclebar_layout_setup();
		addon.vehiclebuttons_template();
		UnitFrameHealthBar_Update(VehicleMenuBarHealthBar, 'vehicle');
		UnitFrameManaBar_Update(VehicleMenuBarPowerBar, 'vehicle');
	elseif event == 'UNIT_DISPLAYPOWER' then
		UnitFrameManaBar_Update(VehicleMenuBarPowerBar, 'vehicle');
		vehiclebutton_position();
	end
end

local stance = {
	['DRUID'] = '[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 7; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;',
	['WARRIOR'] = '[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;',
	['PRIEST'] = '[bonusbar:1] 7;',
	['ROGUE'] = '[bonusbar:1] 7; [form:3] 7;',
	['DEFAULT'] = '[bonusbar:5] 11; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;',
}

local function getbarpage()
	local condition = stance['DEFAULT']
	local page = stance[class]
	if page then
		condition = condition..' '..page
	end
	condition = condition..' 1'
	return condition
end

-- bonus bar vehicle
pUiMainBar:SetFrameRef('vehicleExit', vehicleExit)
pUiMainBar:Execute([[
	vehicleExit = self:GetFrameRef('vehicleExit')
	buttons = newtable()
	for i = 1, 12 do
		table.insert(buttons, self:GetFrameRef('ActionButton'..i))
	end
]]);
pUiMainBar:SetAttribute('_onstate-page', [[
	for i, button in ipairs(buttons) do
		button:SetAttribute('actionpage', tonumber(newstate))
	end
]]);
RegisterStateDriver(pUiMainBar, 'page', getbarpage());

local function vehiclebar_initialize()
	if barstyle then
		vehiclebar:RegisterEvent('UNIT_ENTERING_VEHICLE');
		vehiclebar:RegisterEvent('UNIT_EXITED_VEHICLE');
		vehiclebar:RegisterEvent('UNIT_ENTERED_VEHICLE');
		vehiclebar:RegisterEvent('UNIT_DISPLAYPOWER');
		vehiclebar:RegisterEvent('PLAYER_LOGIN');
		vehiclebar:RegisterEvent('PLAYER_ENTERING_WORLD');
		vehiclebar:SetScript('OnEvent', OnEvent);
		
		vehiclebar_power_setup();
		
		pUiMainBar:SetAttribute('_onstate-vehicleupdate', [[
			if newstate == '1' then
				self:Hide()
			else
				self:Show()
			end
		]]);
		RegisterStateDriver(pUiMainBar, 'vehicleupdate', '[vehicleui] 1; 2');
	else
		vehicleBarBackground:Hide();
		vehiclebutton_leave();
		pUiMainBar:SetAttribute('_onstate-vehicle', [[
			if newstate == '1' then
				vehicleExit:Show()
			else
				vehicleExit:Hide()
			end
		]]);
		RegisterStateDriver(pUiMainBar, 'vehicle', '[bonusbar:5] 1; 0');
	end
end
vehiclebar_initialize();