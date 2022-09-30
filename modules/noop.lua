local addon = select(2,...);
local pairs = pairs;
local hooksecurefunc = hooksecurefunc;

do
	MainMenuBar:EnableMouse(false)
	PetActionBarFrame:EnableMouse(false)
	ShapeshiftBarFrame:EnableMouse(false)
	PossessBarFrame:EnableMouse(false)
	BonusActionBarFrame:EnableMouse(false)
	BonusActionBarFrame:SetScale(0.001)
	
	local elements_texture = {
		MainMenuXPBarTexture0,
		MainMenuXPBarTexture1,
		MainMenuXPBarTexture2,
		MainMenuXPBarTexture3,
		ReputationXPBarTexture0,
		ReputationXPBarTexture1,
		ReputationXPBarTexture2,
		ReputationXPBarTexture3,
		ReputationWatchBarTexture0,
		ReputationWatchBarTexture1,
		ReputationWatchBarTexture2,
		ReputationWatchBarTexture3,
	};for _,tex in pairs(elements_texture) do
		tex:SetTexture(nil)
	end;

	local elements = {
		MainMenuBar,
		MainMenuBarArtFrame,
		BonusActionBarFrame,
		MainMenuBarOverlayFrame,
		VehicleMenuBar,
		-- VehicleMenuBarArtFrame,
		-- PossessBarFrame,
		PossessBackground1,
		PossessBackground2,
		PetActionBarFrame,
		ShapeshiftBarFrame,
		ShapeshiftBarLeft,
		ShapeshiftBarMiddle,
		ShapeshiftBarRight,
	};for _,element in pairs(elements) do
		if element:GetObjectType() == 'Frame' then
			element:UnregisterAllEvents()
			if element == MainMenuBarArtFrame then
				element:RegisterEvent('CURRENCY_DISPLAY_UPDATE');
			end
		end
		if element ~= MainMenuBar then
			element:Hide()
		end
		element:SetAlpha(0)
	end
	elements = nil
	
	local uiManagedFrames = {
		'MultiBarLeft',
		'MultiBarRight',
		'MultiBarBottomLeft',
		'MultiBarBottomRight',
		'ShapeshiftBarFrame',
		'PossessBarFrame',
		'PETACTIONBAR_YPOS',
		'MultiCastActionBarFrame',
		'MULTICASTACTIONBAR_YPOS',
	}
	local UIPARENT_MANAGED_FRAME_POSITIONS = UIPARENT_MANAGED_FRAME_POSITIONS;
	for _, frame in pairs(uiManagedFrames) do
		UIPARENT_MANAGED_FRAME_POSITIONS[frame] = nil
	end
	uiManagedFrames = nil

	if PlayerTalentFrame then
		PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
	else
		hooksecurefunc('TalentFrame_LoadUI', function()
			PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
		end)
	end
end