local Class = select(2, UnitClass("player"))

if (Class ~= "DRUID" and Class ~= "ROGUE") then
	return
end

local _, ns = ...
local oUF = ns.oUF

local UnitPower = UnitPower
local GetTime = GetTime

local LastTick = GetTime()
local LastPower = 0

local OnUpdate = function(self)
	local Power = UnitPower("player")
	local Time = GetTime()
	local Value = Time - LastTick
	
	if (Power > LastPower) or (Value >= 2) then
		LastTick = Time
	end
	
	self:SetValue(Value)
	
	LastPower = Power
end

local OnEvent = function(self)
	if (UnitPowerType("player") ~= 3) then
		self:Hide()
	else
		self:Show()
	end
end

local ForceUpdate = function(element)
	return OnUpdate(element)
end

local Path = function(self)
	return OnUpdate(self.EnergyTick)
end

local Enable = function(self)
	local element = self.EnergyTick
	
	if element then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		
		element:SetMinMaxValues(0, 2)
		element:SetScript("OnUpdate", OnUpdate)
		
		if (Class == "DRUID") then
			element:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
			element:SetScript("OnEvent", OnEvent)
		end
		
		OnEvent(element)
	end
end

local Disable = function(self)
	local element = self.EnergyTick
	
	if element then
		element:Hide()
		element:SetScript("OnUpdate", nil)
		element:SetScript("OnEvent", nil)
	end
end

oUF:AddElement("EnergyTick", Path, Enable, Disable)