local addon = select(2,...);
local config = addon.config;
local pairs = pairs;
local gsub = string.gsub;
local UIParent = UIParent;
local hooksecurefunc = hooksecurefunc;
local _G = _G;

-- const
local PERFORMANCEBAR_LOW_LATENCY = 300;
local PERFORMANCEBAR_MEDIUM_LATENCY = 600;

local MainMenuMicroButtonMixin = {};
local MainMenuBarBackpackButton = _G.MainMenuBarBackpackButton;
local KeyRingButton = _G.KeyRingButton;

local bagslots = {
    _G.CharacterBag0Slot,
    _G.CharacterBag1Slot,
    _G.CharacterBag2Slot,
    _G.CharacterBag3Slot
};
local MICRO_BUTTONS = {
	_G.CharacterMicroButton,
	_G.SpellbookMicroButton,
	_G.TalentMicroButton,
	_G.AchievementMicroButton,
	_G.QuestLogMicroButton,
	_G.SocialsMicroButton,
	_G.LFDMicroButton,
	_G.CollectionsMicroButton,
	_G.PVPMicroButton,
	_G.MainMenuMicroButton,
	_G.HelpMicroButton,
};

KeyRingButton:SetParent(_G.CharacterBag3Slot)
function MainMenuMicroButtonMixin:bagbuttons_setup()
	MainMenuBarBackpackButton:SetSize(50, 50)
	MainMenuBarBackpackButton:SetNormalTexture(nil)
	MainMenuBarBackpackButton:SetPushedTexture(nil)
	MainMenuBarBackpackButton:SetHighlightTexture''
	MainMenuBarBackpackButton:SetCheckedTexture''
	MainMenuBarBackpackButton:GetHighlightTexture():set_atlas('bag-main-highlight-2x')
	MainMenuBarBackpackButton:GetCheckedTexture():set_atlas('bag-main-highlight-2x')
	MainMenuBarBackpackButtonIconTexture:set_atlas('bag-main-2x')
	MainMenuBarBackpackButton:SetClearPoint('BOTTOMRIGHT', _G.HelpMicroButton, 'BOTTOMRIGHT', 6, 30)
	MainMenuBarBackpackButton.SetPoint = addon._noop
	
	MainMenuBarBackpackButtonCount:SetClearPoint('CENTER', MainMenuBarBackpackButton, 'BOTTOM', 0, 14)
	CharacterBag0Slot:SetClearPoint('RIGHT', MainMenuBarBackpackButton, 'LEFT', -14, -2)
	
	KeyRingButton:SetSize(34, 34)
	KeyRingButton:SetClearPoint('RIGHT', CharacterBag3Slot, 'LEFT', -2, 0)
	KeyRingButton:SetNormalTexture''
	KeyRingButton:SetPushedTexture(nil)
	KeyRingButton:SetHighlightTexture''
	KeyRingButton:SetCheckedTexture''
	
	local highlight = KeyRingButton:GetHighlightTexture();
	highlight:SetAllPoints();
	highlight:SetBlendMode('ADD');
	highlight:SetAlpha(.4);
	highlight:set_atlas('bag-border-highlight-2x', true)
	KeyRingButton:GetNormalTexture():set_atlas('bag-reagent-border-2x')
	KeyRingButton:GetCheckedTexture():set_atlas('bag-border-highlight-2x', true)
	KeyRingButton:Hide();
	
	for _,bags in pairs(bagslots) do
		bags:SetHighlightTexture''
		bags:SetCheckedTexture''
		bags:SetPushedTexture(nil)
		bags:SetNormalTexture''
		bags:SetSize(28, 28)

		bags:GetCheckedTexture():set_atlas('bag-border-highlight-2x', true)
		bags:GetCheckedTexture():SetDrawLayer('OVERLAY', 7)
		
		local highlight = bags:GetHighlightTexture();
		highlight:SetAllPoints();
		highlight:SetBlendMode('ADD');
		highlight:SetAlpha(.4);
		highlight:set_atlas('bag-border-highlight-2x', true)

		local icon = _G[bags:GetName()..'IconTexture']
		icon:ClearAllPoints()
		icon:SetPoint('TOPRIGHT', bags, 'TOPRIGHT', -5, -2.9);
		icon:SetPoint('BOTTOMLEFT', bags, 'BOTTOMLEFT', 2.9, 5);
		icon:SetTexCoord(.08,.92,.08,.92)
		
		local border = bags:CreateTexture(nil, 'OVERLAY')
		border:SetPoint('CENTER')
		border:set_atlas('bag-border-2x', true)
		bags:GetCheckedTexture():SetAllPoints(border)
		
		local w, h = border:GetSize()
		bags.background = bags:CreateTexture(nil, 'BACKGROUND')
		bags.background:SetSize(w, h)
		bags.background:SetPoint('CENTER')
		bags.background:SetTexture(addon._dir..'bagslots2x')
		bags.background:SetTexCoord(295/512, 356/512, 64/128, 125/128)
		
		local count = _G[bags:GetName()..'Count']
		count:SetClearPoint('CENTER', 0, -10);
		count:SetDrawLayer('OVERLAY')
	end
end

addon.package:RegisterEvents(function(self)
	self:UnregisterEvent('PLAYER_ENTERING_WORLD')
	if HasKey() then
		KeyRingButton:Show();
	else
		KeyRingButton:Hide();
	end
	if config.style.bags == 'new' then
		for _,bags in pairs(bagslots) do
			local icon = _G[bags:GetName()..'IconTexture']
			local empty = icon:GetTexture() == 'interface\\paperdoll\\UI-PaperDoll-Slot-Bag'
			if empty then
				icon:SetAlpha(0)
			else
				icon:SetAlpha(1)
			end
		end
	end
end,
	'BAG_UPDATE', 'PLAYER_ENTERING_WORLD'
);

do
	if config.style.bags == 'new' then
		MainMenuMicroButtonMixin:bagbuttons_setup();
	elseif config.style.bags == 'old' then
		MainMenuBarBackpackButton:SetClearPoint('BOTTOMRIGHT', _G.HelpMicroButton, 'BOTTOMRIGHT', 0, 34)
		MainMenuBarBackpackButtonIconTexture:SetTexture(addon._dir..'INV_Misc_Bag_08')
		CharacterBag0Slot:SetClearPoint('RIGHT', MainMenuBarBackpackButton, 'LEFT', -20, 0)
	else
		MainMenuBarBackpackButton:Hide();
		for _,bags in pairs(bagslots) do
			bags:Hide();
		end
	end
end

do
	local old = config.style.bags == 'old'
	local arrow = CreateFrame('CheckButton', 'pUiArrowManager', MainMenuBarBackpackButton)
	arrow:SetSize(12, 18)
	arrow:SetPoint('RIGHT', MainMenuBarBackpackButton, 'LEFT', old and -4 or 0, -2)
	arrow:SetNormalTexture''
	arrow:SetPushedTexture''
	arrow:SetHighlightTexture''
	arrow:RegisterForClicks('LeftButtonUp')

	local normal = arrow:GetNormalTexture()
	normal:set_atlas('bag-arrow-invert-2x')

	local pushed = arrow:GetPushedTexture()
	pushed:set_atlas('bag-arrow-invert-2x')

	local highlight = arrow:GetHighlightTexture()
	highlight:set_atlas('bag-arrow-invert-2x')
	highlight:SetAlpha(.4)
	highlight:SetBlendMode('ADD')

	arrow:SetScript('OnClick',function(self)
		local checked = self:GetChecked();
		if checked then
			normal:set_atlas('bag-arrow-2x')
			pushed:set_atlas('bag-arrow-2x')
			highlight:set_atlas('bag-arrow-2x')
			for _,bags in pairs(bagslots) do bags:Hide(); end
		else
			normal:set_atlas('bag-arrow-invert-2x')
			pushed:set_atlas('bag-arrow-invert-2x')
			highlight:set_atlas('bag-arrow-invert-2x')
			for _,bags in pairs(bagslots) do bags:Show(); end
		end
		collapse_state = checked
	end)
	
	addon.package:RegisterEvents(function(self, event)
		self:UnregisterEvent(event)
		if not collapse_state then collapse_state = {} end
		if collapse_state == 1 then
			for _,bags in pairs(bagslots) do bags:Hide(); end
			normal:set_atlas('bag-arrow-2x')
			pushed:set_atlas('bag-arrow-2x')
			highlight:set_atlas('bag-arrow-2x')
			arrow:SetChecked(1)
		else
			for _,bags in pairs(bagslots) do bags:Show(); end
			arrow:SetChecked(nil)
		end
	end, 'ADDON_LOADED'
	);
end

hooksecurefunc('MiniMapLFG_UpdateIsShown',function()
	MiniMapLFGFrame:SetClearPoint('LEFT', _G.CharacterMicroButton, -32, 2)
	MiniMapLFGFrame:SetScale(1.6)
	MiniMapLFGFrameBorder:SetTexture(nil)
	MiniMapLFGFrame.eye.texture:SetTexture(addon._dir..'uigroupfinderflipbookeye.tga')
end)

MiniMapLFGFrame:SetScript('OnClick',function(self, button)
	local mode, submode = GetLFGMode();
	if ( button == "RightButton" or mode == "lfgparty" or mode == "abandonedInDungeon") then
		PlaySound("igMainMenuOpen");
		local yOffset;
		if ( mode == "queued" ) then
			MiniMapLFGFrameDropDown.point = "BOTTOMRIGHT";
			MiniMapLFGFrameDropDown.relativePoint = "TOPLEFT";
			yOffset = 105;
		else
			MiniMapLFGFrameDropDown.point = nil;
			MiniMapLFGFrameDropDown.relativePoint = nil;
			yOffset = 110;
		end
		ToggleDropDownMenu(1, nil, MiniMapLFGFrameDropDown, "MiniMapLFGFrame", -60, yOffset);
	elseif ( mode == "proposal" ) then
		if ( not LFDDungeonReadyPopup:IsShown() ) then
			PlaySound("igCharacterInfoTab");
			StaticPopupSpecial_Show(LFDDungeonReadyPopup);
		end
	elseif ( mode == "queued" or mode == "rolecheck" ) then
		ToggleLFDParentFrame();
	elseif ( mode == "listed" ) then
		ToggleLFRParentFrame();
	end
end)

LFDSearchStatus:SetParent(MinimapBackdrop)
LFDSearchStatus:SetClearPoint('TOPRIGHT', MinimapBackdrop, 'TOPLEFT')

hooksecurefunc('CharacterMicroButton_SetPushed',function()
	MicroButtonPortrait:SetTexCoord(0,0,0,0);
	MicroButtonPortrait:SetAlpha(0);
end)

hooksecurefunc('CharacterMicroButton_SetNormal',function()
	MicroButtonPortrait:SetTexCoord(0,0,0,0);
	MicroButtonPortrait:SetAlpha(0);
end)

function MainMenuMicroButtonMixin:OnUpdate(elapsed)
	local _, _, latencyHome = GetNetStats();
	local latency = latencyHome;
	if ( latency > PERFORMANCEBAR_MEDIUM_LATENCY ) then
		self:SetStatusBarColor(1, 0, 0);
	elseif ( latency > PERFORMANCEBAR_LOW_LATENCY ) then
		self:SetStatusBarColor(1, 1, 0);
	else
		self:SetStatusBarColor(0, 1, 0);
	end
end

function MainMenuMicroButtonMixin:CreateBar()
	local latencybar = CreateFrame('Statusbar', nil, UIParent)
	latencybar:SetParent(HelpMicroButton)
	latencybar:SetSize(19, 39)
	latencybar:SetPoint('BOTTOM', HelpMicroButton, 'BOTTOM', 0, -4)
	latencybar:SetStatusBarTexture(addon._dir..'ui-mainmenubar-performancebar')
	latencybar:SetStatusBarColor(1, 1, 0)
	latencybar:GetStatusBarTexture():SetBlendMode('ADD')
	latencybar:GetStatusBarTexture():SetDrawLayer('OVERLAY')
	latencybar:SetScript('OnUpdate', MainMenuMicroButtonMixin.OnUpdate)
end
MainMenuMicroButtonMixin:CreateBar();

local function setupMicroButtons(xOffset)
	local buttonxOffset = 0
	local menu = CreateFrame('Frame', 'pUiMicroMenu', UIParent)
	menu:SetSize(10, 10)
	menu:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMRIGHT', xOffset, config.micromenu.y_position)
	menu:SetScale(1.4)
	for _,button in pairs(MICRO_BUTTONS) do
		local buttonName = button:GetName():gsub('MicroButton', '')
		local name = strlower(buttonName);

		button:texture_strip()

		CharacterMicroButton:SetDisabledTexture'' -- doesn't exist by default
		PVPMicroButton:SetDisabledTexture'' -- doesn't exist by default
		PVPMicroButton:GetDisabledTexture():set_atlas('ui-hud-micromenu-pvp-disabled-2x')

		button:SetParent(pUiMainBar)
		button:SetScale(1.4)
		button:SetSize(14, 19)
		button:SetClearPoint('BOTTOMLEFT', menu, 'BOTTOMRIGHT', buttonxOffset, 55)
		button.SetPoint = addon._noop
		button:SetHitRectInsets(0,0,0,0)

		button:GetNormalTexture():set_atlas('ui-hud-micromenu-'..name..'-up-2x')
		button:GetPushedTexture():set_atlas('ui-hud-micromenu-'..name..'-down-2x')
		button:GetDisabledTexture():set_atlas('ui-hud-micromenu-'..name..'-disabled-2x')
		button:GetHighlightTexture():set_atlas('ui-hud-micromenu-'..name..'-mouseover-2x')
		button:GetHighlightTexture():SetBlendMode('ADD')

		buttonxOffset = buttonxOffset + 15
	end
end

addon.package:RegisterEvents(function()
	local xOffset
	if IsAddOnLoaded('ezCollections') then
		xOffset = -180
		_G.CollectionsMicroButton:UnregisterEvent('UPDATE_BINDINGS')
	else
		xOffset = -166
	end
	setupMicroButtons(xOffset + config.micromenu.x_position);
end, 'PLAYER_LOGIN'
);