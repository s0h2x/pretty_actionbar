local addon = select(2,...);
local config = addon.config;
local event = addon.package;
local class = addon._class;
local pUiMainBar = addon.pUiMainBar;
local unpack = unpack;
local select = select;
local pairs = pairs;
local _G = getfenv(0);

-- const
local GetPetActionInfo = GetPetActionInfo;
local RegisterStateDriver = RegisterStateDriver;
local CreateFrame = CreateFrame;
local UIParent = UIParent;
local hooksecurefunc = hooksecurefunc;

-- @param: config number
local offsetX = config.additional.pet.x_position;
local nobar = config.additional.y_position;
local exOffs = config.additional.leftbar_offset;
local exOffs2 = config.additional.rightbar_offset;
local leftOffset, rightOffset = nobar + exOffs, nobar + exOffs2;

local anchor = CreateFrame('Frame', 'pUiPetBarHolder', UIParent)
anchor:SetPoint('TOPLEFT', pUiMainBar, 'TOPLEFT', offsetX, nobar)
anchor:SetSize(37, 37)

-- method update position
function anchor:petbar_update()
	local leftbar = MultiBarBottomLeft:IsShown();
	local rightbar = MultiBarBottomRight:IsShown();
	if not InCombatLockdown() and not UnitAffectingCombat('player') then
		if leftbar and rightbar then
			self:SetPoint('TOPLEFT', pUiMainBar,'TOPLEFT', offsetX, leftOffset);
		elseif leftbar then
			self:SetPoint("TOPLEFT", pUiMainBar,'TOPLEFT', offsetX, rightOffset);
		elseif rightbar then
			self:SetPoint("TOPLEFT", pUiMainBar,'TOPLEFT', offsetX, leftOffset);
		else
			self:SetPoint("TOPLEFT", pUiMainBar,'TOPLEFT', offsetX, nobar);
		end
	end
end

event:RegisterEvents(function()
	anchor:petbar_update();
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
			anchor:petbar_update();
		end
	end);
	bar:HookScript('OnHide',function()
		if (yOffset ~= nobar) then
			anchor:petbar_update();
		end
	end);
end;

local petbar = CreateFrame('Frame', 'pUiPetBar', UIParent, 'SecureHandlerStateTemplate')
petbar:SetAllPoints(anchor)

local function petbutton_updatestate(self, event)
	local petActionButton, petActionIcon, petAutoCastableTexture, petAutoCastShine
	for index=1, NUM_PET_ACTION_SLOTS, 1 do
		local buttonName = 'PetActionButton'..index
		petActionButton = _G[buttonName]
		petActionIcon = _G[buttonName..'Icon']
		petAutoCastableTexture = _G[buttonName..'AutoCastable']
		petAutoCastShine = _G[buttonName..'Shine']
		
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(index)
		if not isToken then
			petActionIcon:SetTexture(texture)
			petActionButton.tooltipName = name
		else
			petActionIcon:SetTexture(_G[texture])
			petActionButton.tooltipName = _G[name]
		end
		petActionButton.isToken = isToken
		petActionButton.tooltipSubtext = subtext
		if isActive and name ~= 'PET_ACTION_FOLLOW' then
			petActionButton:SetChecked(true)
			if IsPetAttackAction(index) then
				PetActionButton_StartFlash(petActionButton)
			end
		else
			petActionButton:SetChecked(false)
			if IsPetAttackAction(index) then
				PetActionButton_StopFlash(petActionButton)
			end
		end
		if autoCastAllowed then
			petAutoCastableTexture:Show()
		else
			petAutoCastableTexture:Hide()
		end
		if autoCastEnabled then
			AutoCastShine_AutoCastStart(petAutoCastShine)
		else
			AutoCastShine_AutoCastStop(petAutoCastShine)
		end
		if name then
			if not config.additional.pet.grid then
				petActionButton:SetAlpha(1)
			end
		else
			if not config.additional.pet.grid then
				petActionButton:SetAlpha(0)
			end
		end
		if texture then
			if GetPetActionSlotUsable(index) then
				SetDesaturation(petActionIcon, nil)
			else
				SetDesaturation(petActionIcon, 1)
			end
			petActionIcon:Show()
		else
			petActionIcon:Hide()
		end
		if not PetHasActionBar() and texture and name ~= 'PET_ACTION_FOLLOW' then
			PetActionButton_StopFlash(petActionButton)
			SetDesaturation(petActionIcon, 1)
			petActionButton:SetChecked(false)
		end
	end
end

local btnsize = config.additional.size;
local space = config.additional.spacing;
local function petbutton_position()
	local button
	for index=1, 10 do
		button = _G['PetActionButton'..index];
		button:ClearAllPoints();
		button:SetParent(pUiPetBar);
		button:SetSize(btnsize, btnsize);
		if index == 1 then
			button:SetPoint('BOTTOMLEFT', 0, 0);
		else
			button:SetPoint('LEFT', _G['PetActionButton'..index-1], 'RIGHT', space, 0);
		end
		button:Show();
		petbar:SetAttribute('addchild', button);
	end
	PetActionBarFrame.showgrid = 1;
	RegisterStateDriver(petbar, 'visibility', '[pet,novehicleui,nobonusbar:5] show; hide');
	hooksecurefunc('PetActionBar_Update', petbutton_updatestate);
end

local function OnEvent(self,event,...)
	-- if not UnitIsVisible('pet') then return; end
	local arg1 = ...;
	if event == 'PLAYER_LOGIN' then
		petbutton_position();
	elseif event == 'PET_BAR_UPDATE'
	or event == 'UNIT_PET' and arg1 == 'player'
	or event == 'PLAYER_CONTROL_LOST'
	or event == 'PLAYER_CONTROL_GAINED'
	or event == 'PLAYER_FARSIGHT_FOCUS_CHANGED'
	or event == 'UNIT_FLAGS'
	or arg1 == 'pet' and event == 'UNIT_AURA' then
		petbutton_updatestate();
	elseif event == 'PET_BAR_UPDATE_COOLDOWN' then
		PetActionBar_UpdateCooldowns();
	else
		addon.petbuttons_template();
	end
end

petbar:RegisterEvent('PET_BAR_HIDE');
petbar:RegisterEvent('PET_BAR_UPDATE');
petbar:RegisterEvent('PET_BAR_UPDATE_COOLDOWN');
petbar:RegisterEvent('PET_BAR_UPDATE_USABLE');
petbar:RegisterEvent('PLAYER_CONTROL_GAINED');
petbar:RegisterEvent('PLAYER_CONTROL_LOST');
petbar:RegisterEvent('PLAYER_FARSIGHT_FOCUS_CHANGED');
petbar:RegisterEvent('PLAYER_LOGIN');
petbar:RegisterEvent('UNIT_AURA');
petbar:RegisterEvent('UNIT_FLAGS');
petbar:RegisterEvent('UNIT_PET');
petbar:SetScript('OnEvent',OnEvent);