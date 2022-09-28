local addon = select(2,...);
local config = addon.config;
local noop = addon._noop;
local unpack = unpack;
local ceil = ceil;
local GetTime = GetTime;
local hooksecurefunc = hooksecurefunc;

if not config.buttons.cooldown.show then return; end
local cooldownMixin = {};

function cooldownMixin:update_cooldown(elapsed)
	if not self:GetParent().action then return end
	if not self.remain then return end

	local text = self.text
	local remaining = self.remain - GetTime()
    if remaining > 0 then
        if remaining <= 2 then
            text:SetTextColor(1, 0, .2)
            text:SetFormattedText('%.1f',remaining)
        elseif remaining <= 60 then
            text:SetTextColor(unpack(config.buttons.cooldown.color))
            text:SetText(ceil(remaining))
        elseif remaining <= 3600 then
            text:SetText(ceil(remaining/60)..'m')
            text:SetTextColor(1, 1, 1)
        else
            text:SetText(ceil(remaining/3600)..'h')
            text:SetTextColor(.6, .6, .6)
        end
    else
        self.remain = nil
    	text:Hide()
		text:SetText''
    end
end

function cooldownMixin:create_string()
	local text = self:CreateFontString(nil, 'OVERLAY')
	text:SetPoint('CENTER')
	self.text = text
	self:SetScript('OnUpdate', cooldownMixin.update_cooldown)
	return text
end

function cooldownMixin:set_cooldown(start, duration)
	if start > 0 and duration > config.buttons.cooldown.min_duration then
		self.remain = start + duration
		
		local text = self.text or cooldownMixin.create_string(self)
		text:SetFont(unpack(config.buttons.cooldown.font))
		text:SetPoint(unpack(config.buttons.cooldown.position))
		text:Show()
	else
		if self.text then
			self.text:Hide()
		end
	end
end

local methods = getmetatable(_G.ActionButton1Cooldown).__index
hooksecurefunc(methods, 'SetCooldown', cooldownMixin.set_cooldown)