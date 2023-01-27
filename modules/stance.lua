local addon = select(2,...);
local config = addon.config;
local event = addon.package;
local class = addon._class;
local pUiMainBar = addon.pUiMainBar;
local unpack = unpack;
local select = select;
local pairs = pairs;
local _G = getfenv(0);
local noop = addon._noop;
-- const
local InCombatLockdown = InCombatLockdown;
local GetNumShapeshiftForms = GetNumShapeshiftForms;
local GetShapeshiftFormInfo = GetShapeshiftFormInfo;
local GetShapeshiftFormCooldown = GetShapeshiftFormCooldown;
local CreateFrame = CreateFrame;
local UIParent = UIParent;
local hooksecurefunc = hooksecurefunc;
local UnitAffectingCombat = UnitAffectingCombat;

local OG_MultiCastActionBarFrameSetPoint = MultiCastActionBarFrame.SetPoint
MultiCastActionBarFrame.SetPoint = noop
local totem = {["HERO"] = 'show'}
local stance = {
	['DEATHKNIGHT'] = 'show',
	['DRUID'] = 'show',
	['PALADIN'] = 'show',
	['PRIEST'] = 'show',
	['ROGUE'] = 'show',
	['WARLOCK'] = 'show',
	['WARRIOR'] = 'show',
	--- Ascension & CoA Support ---
	["HERO"] = 'show',
	["PROPHET"] = 'show',
	["FLESHWARDEN"] = 'show',
	["RANGER"] = 'show',
	["PYROMANCER"] = 'show',
	["WITCHHUNTER"] = 'show',
	["STARCALLER"] = 'show',
	["SPIRITMAGE"] = 'show',
	["CULTIST"] = 'show',
	["TINKER"] = 'show',
	["SUNCLERIC"] = 'show',
	["NECROMANCER"] = 'show',
	["WILDWALKER"] = 'show',
	["CHRONOMANCER"] = 'show',
	["STORMBRINGER"] = 'show',
	["SONOFARUGAL"] = 'show',
	["REAPER"] = 'show',
	["GUARDIAN"] = 'show',
	["MONK"] = 'show',
	["BARBARIAN"] = 'show',
	["WITCHDOCTOR"] = 'show',
	["DEMONHUNTER"] = 'show'
};
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
-- @param: config number
local offsetX = config.additional.stance.x_position;
local nobar = config.additional.y_position;
local exOffs = config.additional.leftbar_offset;
local exOffs2 = config.additional.rightbar_offset;
local leftOffset, rightOffset = nobar + exOffs, nobar + exOffs2;

local anchor = CreateFrame('Frame', 'pUiStanceHolder', pUiMainBar)
anchor:SetPoint('TOPLEFT', pUiMainBar, 'TOPLEFT', offsetX, nobar)
anchor:SetSize(37, 37)

-- method update position
function anchor:stancebar_update()
	local leftbar = MultiBarBottomLeft:IsShown();
	local rightbar = MultiBarBottomRight:IsShown();
	if not InCombatLockdown() and not UnitAffectingCombat('player') then
		if leftbar and rightbar then
			self:SetPoint('TOPLEFT', pUiMainBar, 'TOPLEFT', offsetX, leftOffset);
		elseif leftbar then
			self:SetPoint('TOPLEFT', pUiMainBar, 'TOPLEFT', offsetX, rightOffset);
		elseif rightbar then
			self:SetPoint('TOPLEFT', pUiMainBar, 'TOPLEFT', offsetX, leftOffset);
		else
			self:SetPoint('TOPLEFT', pUiMainBar, 'TOPLEFT', offsetX, nobar);
		end
		MultiCastActionBarFrame.SetPoint = OG_MultiCastActionBarFrameSetPoint
		MultiCastActionBarFrame:SetPoint('BOTTOMLEFT', pUiStanceHolder,'BOTTOMLEFT',( config.additional.size + config.additional.spacing)* stanceCount(), -3)
		MultiCastActionBarFrame.SetPoint = noop
	end
end

event:RegisterEvents(function()
	anchor:stancebar_update();
end,
	'PLAYER_LOGIN','ADDON_LOADED'
);

for _,bar in pairs({MultiBarBottomLeft,MultiBarBottomRight}) do
	if notRequired then return; end
	if InCombatLockdown() and UnitAffectingCombat('player') then return; end
	
	local yOffset = select(5, anchor:GetPoint());
	if (yOffset == nobar) then notRequired = true end
	
	bar:HookScript('OnShow',function()
		if (yOffset ~= nobar) then
			anchor:stancebar_update();
		end
	end);
	bar:HookScript('OnHide',function()
		if (yOffset ~= nobar) then
			anchor:stancebar_update();
		end
	end);
end;

local stancebar = CreateFrame('Frame', 'pUiStanceBar', anchor, 'SecureHandlerStateTemplate')
stancebar:SetAllPoints(anchor)

local function stancebutton_update()
	if not InCombatLockdown() then
		_G.ShapeshiftButton1:SetPoint('BOTTOMLEFT', anchor, 'BOTTOMLEFT', 0, 0)
	end
end

local btnsize = config.additional.size;
local space = config.additional.spacing;
local function C_totemButton_position(offsetStances)
	for index=1, NUM_MULTI_CAST_BUTTONS_PER_PAGE  do
		local button =  _G["MultiCastSlotButton"..index]
		button:ClearAllPoints()
		button:SetParent(stancebar)
		button:SetSize(btnsize, btnsize)
		if index == 1 then
			button:SetPoint('BOTTOMLEFT', stancebar, 'BOTTOMLEFT', 0, 0)
		else
			local previous = _G["MultiCastSlotButton"..index-1]
			button:SetPoint('LEFT', previous, 'RIGHT', space, 0)
		end
		
		if ( GetTotemInfo(index) and GetMultiCastTotemSpells(index) ) then 
			button:Show()
		else
			button:Hide()
		end
	end
	RegisterStateDriver(stancebar, 'visibility', totem[class] or 'hide')
	hooksecurefunc('MultiCastActionBarFrame_Update', stancebutton_update)
end
local function stancebutton_position()
	local count = 0
	for index=1, NUM_SHAPESHIFT_SLOTS do
		local button = _G['ShapeshiftButton'..index]
		button:ClearAllPoints()
		button:SetParent(stancebar)
		button:SetSize(btnsize, btnsize)
		if index == 1 then
			button:SetPoint('BOTTOMLEFT', anchor, 'BOTTOMLEFT', 0, 0)
		else
			local previous = _G['ShapeshiftButton'..index-1]
			button:SetPoint('LEFT', previous, 'RIGHT', space, 0)
		end
		local _,name = GetShapeshiftFormInfo(index)
		if name then
			button:Show()
			count = count+1
		else
			button:Hide()
		end
	end
	C_totemButton_position(count)
	RegisterStateDriver(stancebar, 'visibility', stance[class] or 'hide')
	hooksecurefunc('ShapeshiftBar_Update', stancebutton_update)
end

local function stancebutton_updatestate()
	local numForms = GetNumShapeshiftForms()
	local texture, name, isActive, isCastable;
	local button, icon, cooldown;
	local start, duration, enable;
	for index=1, NUM_SHAPESHIFT_SLOTS do
		button = _G['ShapeshiftButton'..index]
		icon = _G['ShapeshiftButton'..index..'Icon']
		if index <= numForms then
			texture, name, isActive, isCastable = GetShapeshiftFormInfo(index)
			icon:SetTexture(texture)
			cooldown = _G['ShapeshiftButton'..index..'Cooldown']
			if texture then
				cooldown:SetAlpha(1)
			else
				cooldown:SetAlpha(0)
			end
			start, duration, enable = GetShapeshiftFormCooldown(index)
			CooldownFrame_SetTimer(cooldown, start, duration, enable)
			if isActive then
				ShapeshiftBarFrame.lastSelected = button:GetID()
				button:SetChecked(1)
			else
				button:SetChecked(0)
			end
			if isCastable then
				icon:SetVertexColor(255/255, 255/255, 255/255)
			else
				icon:SetVertexColor(102/255, 102/255, 102/255)
			end
		end
	end
end

local function stancebutton_setup()
	if InCombatLockdown() then return end
	MultiCastActionBarFrame.SetPoint = OG_MultiCastActionBarFrameSetPoint
	MultiCastActionBarFrame:SetPoint('BOTTOMLEFT', pUiStanceHolder,'BOTTOMLEFT',( config.additional.size + config.additional.spacing)* stanceCount(), -3)
	MultiCastActionBarFrame.SetPoint = noop
	for index=1, NUM_SHAPESHIFT_SLOTS do
		local button = _G['ShapeshiftButton'..index]
		local _, name = GetShapeshiftFormInfo(index)
		if name then
			button:Show()
		else
			button:Hide()
		end
	end
	stancebutton_updatestate();
end

local function OnEvent(self,event,...)
	if GetNumShapeshiftForms() < 1 then return; end
	if event == 'PLAYER_LOGIN' then
		stancebutton_position();
	elseif event == 'UPDATE_SHAPESHIFT_FORMS' then
		stancebutton_setup();
	elseif event == 'PLAYER_ENTERING_WORLD' then
		self:UnregisterEvent('PLAYER_ENTERING_WORLD');
		addon.stancebuttons_template();
	else
		stancebutton_updatestate();
	end
end

stancebar:RegisterEvent('PLAYER_LOGIN');
stancebar:RegisterEvent('PLAYER_ENTERING_WORLD');
stancebar:RegisterEvent('UPDATE_SHAPESHIFT_FORMS');
stancebar:RegisterEvent('UPDATE_SHAPESHIFT_USABLE');
stancebar:RegisterEvent('UPDATE_SHAPESHIFT_COOLDOWN');
stancebar:RegisterEvent('UPDATE_SHAPESHIFT_FORM');
stancebar:RegisterEvent('ACTIONBAR_PAGE_CHANGED');
stancebar:SetScript('OnEvent', OnEvent);