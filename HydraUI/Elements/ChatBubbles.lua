local HydraUI, GUI, Language, Assets, Settings = select(2, ...):get()

local Bubbles = HydraUI:NewModule("Chat Bubbles")

local next = next
local select = select
local GetAllChatBubbles = C_ChatBubbles.GetAllChatBubbles

function Bubbles:RefreshBubble(bubble)
	local R, G, B = HydraUI:HexToRGB(Settings["ui-window-main-color"])
	
	HydraUI:SetFontInfo(bubble.Text, Settings["chat-bubbles-font"], Settings["chat-bubbles-font-size"], Settings["chat-bubbles-font-flags"])
	bubble:SetBackdropColor(R, G, B, Settings["chat-bubbles-opacity"] / 100)
	
	self.NeedsRefresh = false	
end

function Bubbles:SkinBubble(bubble)
	local Child = bubble:GetChildren()
	
	if (Child and Child:IsForbidden()) then
		return
	end
	
	Child.Tail:Hide()
	Child:DisableDrawLayer("BORDER")
	
	if Child.SetBackdrop then
		Child:SetBackdrop(nil)
	end
	
	HydraUI:SetFontInfo(Child.String, Settings["chat-bubbles-font"], Settings["chat-bubbles-font-size"], Settings["chat-bubbles-font-flags"])
	
	local R, G, B = HydraUI:HexToRGB(Settings["ui-window-main-color"])
	local Scale = HydraUI:GetSuggestedScale()
	
	bubble.Backdrop = CreateFrame("Frame", nil, Child, "BackdropTemplate")
	bubble.Backdrop:SetPoint("TOPLEFT", Child, 4, -4)
	bubble.Backdrop:SetPoint("BOTTOMRIGHT", Child, -4, 4)
	bubble.Backdrop:SetBackdrop(HydraUI.BackdropAndBorder)
	bubble.Backdrop:SetBackdropColor(R, G, B, Settings["chat-bubbles-opacity"] / 100)
	bubble.Backdrop:SetBackdropBorderColor(0, 0, 0)
	bubble.Backdrop:SetFrameStrata("LOW")
	
	bubble:SetScale(Scale)
	
	bubble.Skinned = true
end

function Bubbles:ScanForBubbles()
	local Bubble
	
	for Index, Bubble in next, GetAllChatBubbles() do
		if self.NeedsRefresh then
			self:RefreshBubble(Bubble)
		elseif (not Bubble.Skinned) then
			self:SkinBubble(Bubble)
		end
	end
end

function Bubbles:OnUpdate(elapsed)
	self.Elapsed = self.Elapsed + elapsed
	
	if (self.Elapsed > 0.15) then
		self:ScanForBubbles()
		
		self.Elapsed = 0
	end
end

function Bubbles:Load()
	if (not Settings["chat-bubbles-enable"]) then
		return
	end
	
	self.Elapsed = 0
	self:SetScript("OnUpdate", self.OnUpdate)
end

local SetToRefresh = function()
	Bubbles.NeedsRefresh = true
end

local UpdateShowBubbles = function(value)
	if (value == "ALL") then
		SetCVar("chatBubbles", 1)
		SetCVar("chatBubblesParty", 1)
	elseif (value == "EXCLUDE_PARTY") then
		SetCVar("chatBubbles", 1)
		SetCVar("chatBubblesParty", 0)
	else -- "NONE"
		SetCVar("chatBubbles", 0)
		SetCVar("chatBubblesParty", 0)
	end
end

GUI:AddWidgets(Language["General"], Language["Chat"], function(left, right)
	right:CreateHeader(Language["Chat Bubbles"])
	right:CreateSwitch("chat-bubbles-enable", Settings["chat-bubbles-enable"], Language["Enable Chat Bubbles Module"], "Enable the HydraUI chat bubbles module", ReloadUI):RequiresReload(true)
	right:CreateSlider("chat-bubbles-opacity", Settings["chat-bubbles-opacity"], 0, 100, 5, "Background Opacity", "Set the opacity of the chat bubbles background", SetToRefresh, nil, "%")
	right:CreateDropdown("chat-bubbles-font", Settings["chat-bubbles-font"], Assets:GetFontList(), Language["Font"], "Set the font of the chat bubbles", SetToRefresh, "Font")
	right:CreateSlider("chat-bubbles-font-size", Settings["chat-bubbles-font-size"], 8, 32, 1, "Font Size", "Set the font size of the chat bubbles", SetToRefresh)
	right:CreateDropdown("chat-bubbles-font-flags", Settings["chat-bubbles-font-flags"], Assets:GetFlagsList(), Language["Font Flags"], "Set the font flags of the chat bubbles", SetToRefresh)
	--right:CreateDropdown("chat-bubbles-show", Settings["chat-bubbles-show"], {[Language["All"]] = "ALL", [Language["None"]] = "NONE", [Language["Exclude Party"]] = "EXCLUDE_PARTY"}, Language["Show Chat Bubbles"], "Set who to display chat bubbles from", UpdateShowBubbles)
end)