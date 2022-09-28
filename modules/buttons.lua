local addon = select(2,...);
local config = addon.config;
local action = addon.functions;
local unpack = unpack;
local select = select;
local format = string.format;
local match = string.match;
local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS;
local NUM_SHAPESHIFT_SLOTS = NUM_SHAPESHIFT_SLOTS;
local NUM_POSSESS_SLOTS = NUM_POSSESS_SLOTS;
local VEHICLE_MAX_ACTIONBUTTONS = VEHICLE_MAX_ACTIONBUTTONS;
local hooksecurefunc = hooksecurefunc;
local GetName = GetName;
local _G = getfenv(0);

-- RANGE_INDICATOR = "•";

local actionbars = {
	'ActionButton',
	'MultiBarBottomLeftButton',
	'MultiBarBottomRightButton',
	'MultiBarRightButton',
	'MultiBarLeftButton',
};

local function actionbuttons_iterator()
	local index = 0
	local barIndex = 1
	return function()
		index = index + 1
		if index > 12 then
			index = 1
			barIndex = barIndex + 1
		end
		if actionbars[barIndex] then
			return _G[actionbars[barIndex]..index]
		end
	end
end

local function actionbuttons_grid()
	for index=1, NUM_ACTIONBAR_BUTTONS do
		local ActionButtons = _G[format('ActionButton%d', index)]
		ActionButtons:SetAttribute('showgrid', 1)
		ActionButton_ShowGrid(ActionButtons)
	end
end

local function is_petaction(self, name)
	local spec = self:GetName():match(name)
	if (spec) then return true else return false end
end

local function fix_texture(self, texture)
	if texture and texture ~= config.assets.normal then
		self:SetNormalTexture(config.assets.normal)
	end
end

local function setup_background(button, anchor, shadow)
	if not button or button.shadow then return; end
	if shadow and not button.shadow then
		local shadow = button:CreateTexture(nil, 'ARTWORK', nil, 1)
		shadow:SetPoint('TOPRIGHT', anchor, 3.8, 3.8)
		shadow:SetPoint('BOTTOMLEFT', anchor, -3.8, -3.8)
		shadow:set_atlas('ui-hud-actionbar-iconframe-flyoutbordershadow', true)
		button.shadow = shadow;
	end

	local background = button:CreateTexture(nil, 'BACKGROUND');
	background:SetAllPoints(anchor);
	background:Hide();

	local parent = button:GetParent():GetName();
	local isAction = parent == 'pUiMainBar' and config.buttons.only_actionbackground;
	if isAction then
		background:set_atlas('ui-hud-actionbar-iconframe-slot');
		background:Show();
	elseif not config.buttons.only_actionbackground then
		background:set_atlas('ui-hud-actionbar-iconframe-slot');
		background:Show();
	else
		background:SetTexture(addon._dir..'uiactionbarbackground2x');
		background:Show();
	end
	return background;
end

local function actionbuttons_hotkey(button)
	local hotkey = _G[button:GetName()..'HotKey'];
	local text = hotkey:GetText();
	if not text then return; end
	if text == RANGE_INDICATOR then
		if config.buttons.hotkey.range then
			hotkey:SetText(RANGE_INDICATOR);
		else
			hotkey:SetText'';
		end
	else
		if not config.buttons.hotkey.show then hotkey:SetAlpha(0) end
		hotkey:SetText(addon.GetKeyText(text))
		hotkey:SetFont(unpack(config.buttons.hotkey.font))
		hotkey:SetShadowOffset(-1.3, -1.1)
		hotkey:SetShadowColor(unpack(config.buttons.hotkey.shadow))
	end
end

local function main_buttons(button)
	if not button or button.__styled then return; end

	local name = button:GetName();
	local normal = _G[name..'NormalTexture'] or button:GetNormalTexture();
	local icon = _G[name..'Icon']
	local flash = _G[name..'Flash']
	local count = _G[name..'Count']
	local macros = _G[name..'Name']
	local cooldown = _G[name..'Cooldown']
	local border = _G[name..'Border']
	
	normal:ClearAllPoints()
	normal:SetPoint('TOPRIGHT', button, 2.2, 2.3)
	normal:SetPoint('BOTTOMLEFT', button, -2.2, -2.2)
	normal:SetVertexColor(1, 1, 1, 1)
	normal:SetDrawLayer('OVERLAY')

	if macros then
		if not config.buttons.macros.show then macros:SetAlpha(0) end
		macros:SetFont(unpack(config.buttons.macros.font))
		macros:SetVertexColor(unpack(config.buttons.macros.color))
		macros:SetDrawLayer('OVERLAY')
	end

	if count then
		if not config.buttons.count.show then count:SetAlpha(0) end
		count:SetPoint(unpack(config.buttons.count.position))
		count:SetFont(unpack(config.buttons.count.font))
		count:SetDrawLayer('OVERLAY')
	end

	if flash then
		flash:set_atlas('ui-hud-actionbar-iconframe-flash')
	end

	if icon then
		icon:SetTexCoord(.05, .95, .05, .95)
		icon:SetDrawLayer('BORDER')
	end

	if cooldown then
		cooldown:ClearAllPoints()
		cooldown:SetPoint('TOPRIGHT', button, -1, -1)
		cooldown:SetPoint('BOTTOMLEFT', button, 1, 1)
		cooldown:SetFrameLevel(button:GetParent():GetFrameLevel() +1)
	end
	
	if border then
		border:set_atlas('_ui-hud-actionbar-iconborder-checked')
		border:SetAllPoints(normal)
		if IsEquippedAction(button.action) then
			border:SetAlpha(1)
		else
			border:SetAlpha(0)
		end
	end
	
	-- apply textures
	button:GetCheckedTexture():set_atlas('_ui-hud-actionbar-iconborder-checked')
	button:GetPushedTexture():set_atlas('_ui-hud-actionbar-iconborder-pushed')
	button:SetHighlightTexture(config.assets.highlight)
	button:GetCheckedTexture():SetAllPoints(normal)
	button:GetPushedTexture():SetAllPoints(normal)
	button:GetHighlightTexture():SetAllPoints(normal)
	button:GetCheckedTexture():SetDrawLayer('OVERLAY')
	button:GetPushedTexture():SetDrawLayer('OVERLAY')

	button.background = setup_background(button, normal, true)
	
	button.__styled = true
	-- button:SetSize(37, 37)
end

local function additional_buttons(button)
	if not button then return; end
	
	button:SetNormalTexture(config.assets.normal)
	if button.background then return; end

	local name = button:GetName();
	local icon = _G[name..'Icon']
	local flash = _G[name..'Flash']
	local normal = _G[name..'NormalTexture2'] or _G[name..'NormalTexture']
	local cooldown = _G[name..'Cooldown']
	local castable = _G[name..'AutoCastable']

	normal:ClearAllPoints()
	normal:SetPoint('TOPRIGHT', button, 2.2, 2.3)
	normal:SetPoint('BOTTOMLEFT', button, -2.2, -2.2)

	-- apply textures
	button:GetCheckedTexture():set_atlas('_ui-hud-actionbar-iconborder-checked')
	button:GetPushedTexture():set_atlas('_ui-hud-actionbar-iconborder-pushed')
	button:SetHighlightTexture(config.assets.highlight)
	button:GetCheckedTexture():SetAllPoints(normal)
	button:GetPushedTexture():SetAllPoints(normal)
	button:GetHighlightTexture():SetAllPoints(normal)

	if cooldown then
		cooldown:ClearAllPoints()
		cooldown:SetPoint('TOPRIGHT', button, -1, -1)
		cooldown:SetPoint('BOTTOMLEFT', button, 1, 1)
		cooldown:SetFrameLevel(button:GetParent():GetFrameLevel() +1)
	end

	if icon then
		icon:SetTexCoord(.05, .95, .05, .95)
		icon:SetPoint('TOPRIGHT', button, 1, 1)
		icon:SetPoint('BOTTOMLEFT', button, -1, -1)
		icon:SetDrawLayer('BORDER')
	end

	if flash then
		flash:set_atlas('ui-hud-actionbar-iconframe-flash')
	end
	
	if castable then
		castable:ClearAllPoints()
		castable:SetPoint('TOP', 0, 14)
		castable:SetPoint('BOTTOM', 0, -15)
	end

	if is_petaction(button, 'PetActionButton') then
		hooksecurefunc(button, "SetNormalTexture", fix_texture)
	end
	button.background = setup_background(button, normal, false)
end

local function actionbuttons_update(button)
	if not button then return; end
	local name = button:GetName();
	if name:find('MultiCast') then return; end
	button:SetNormalTexture(config.assets.normal);
end

-- main buttons
for button in actionbuttons_iterator() do
	main_buttons(button)
	button:SetSize(37, 37)
end

-- i really don't want to do it with a hook
addon.package:RegisterEvents(function()
	for button in actionbuttons_iterator() do
		actionbuttons_hotkey(button)
	end
end,
	'UPDATE_BINDINGS'
);

-- vehicle buttons
function addon.vehiclebuttons_template()
	if UnitHasVehicleUI('player') then
		for index=1, VEHICLE_MAX_ACTIONBUTTONS do
			main_buttons(_G['VehicleMenuBarActionButton'..index])
		end
	end
end

-- possess buttons
function addon.possessbuttons_template()
	for index=1, NUM_POSSESS_SLOTS do
		additional_buttons(_G['PossessButton'..index])
	end
end

-- petbar buttons
function addon.petbuttons_template()
	for index=1, NUM_PET_ACTION_SLOTS do
		additional_buttons(_G['PetActionButton'..index])
	end
end

-- stancebar buttons
function addon.stancebuttons_template()
	for index=1, NUM_SHAPESHIFT_SLOTS do
		additional_buttons(_G['ShapeshiftButton'..index])
	end
end

-- setup grid
local function actionbuttons_showgrid(button)
	_G[button:GetName()..'NormalTexture']:SetVertexColor(unpack(config.buttons.border_color))
end

addon.package:RegisterEvents(function()
	actionbuttons_grid();
	collectgarbage();
end,
	'PLAYER_LOGIN'
);

hooksecurefunc('ActionButton_Update', actionbuttons_update);
hooksecurefunc('ActionButton_ShowGrid', actionbuttons_showgrid);