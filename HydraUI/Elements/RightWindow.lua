local HydraUI, GUI, Language, Assets, Settings, Defaults = select(2, ...):get()

local Window = HydraUI:NewModule("Right Window")
local DT = HydraUI:GetModule("DataText")

Defaults["right-window-enable"] = true
Defaults["right-window-size"] = "SINGLE"
Defaults["right-window-width"] = 392
Defaults["right-window-height"] = 128
Defaults["right-window-fill"] = 70
Defaults["right-window-left-fill"] = 70
Defaults["right-window-right-fill"] = 70
Defaults["right-window-middle-pos"] = 50
Defaults["right-window-bottom-height"] = 26
Defaults["right-window-top-height"] = 26

-- Work us in
Defaults["rw-top-fill"] = 100
Defaults["rw-bottom-fill"] = 100

function Window:CreateSingleWindow()
	local R, G, B = HydraUI:HexToRGB(Settings["ui-window-main-color"])
	local Border = Settings["ui-border-thickness"]
	local Width = Settings["right-window-width"]
	
	self.Bottom = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	self.Bottom:SetSize(Width, Settings["right-window-bottom-height"])
	self.Bottom:SetPoint("BOTTOMRIGHT", self, 0, 0)
	HydraUI:AddBackdrop(self.Bottom, Assets:GetTexture(Settings["ui-header-texture"]))
	self.Bottom.Outside:SetBackdropColor(R, G, B, (Settings["rw-bottom-fill"] / 100))
	
	self.Middle = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	self.Middle:SetSize(Width, Settings["right-window-height"])
	self.Middle:SetPoint("BOTTOMLEFT", self.Bottom, "TOPLEFT", 0, 1 > Border and -1 or -(Border + 2))
	HydraUI:AddBackdrop(self.Middle)
	self.Middle.Outside:SetBackdropColor(R, G, B, (Settings["right-window-fill"] / 100))
	
	self.Top = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	self.Top:SetSize(Width, Settings["right-window-top-height"])
	self.Top:SetPoint("BOTTOMLEFT", self.Middle, "TOPLEFT", 0, 1 > Border and -1 or -(Border + 2))
	HydraUI:AddBackdrop(self.Top, Assets:GetTexture(Settings["ui-header-texture"]))
	self.Top.Outside:SetBackdropColor(R, G, B, (Settings["rw-top-fill"] / 100))
end

function Window:CreateDoubleWindow()
	local R, G, B = HydraUI:HexToRGB(Settings["ui-window-main-color"])
	local Border = Settings["ui-border-thickness"]
	local Adjust = 1 > Border and -1 or -(Border + 2)
	local Width = Settings["right-window-width"]
	local LeftWidth = (Width * Settings["right-window-middle-pos"] / 100) - Adjust
	local RightWidth = (Width - (Width * Settings["right-window-middle-pos"] / 100))
	
	self.Bottom = CreateFrame("Frame", nil, self, "BackdropTemplate")
	self.Bottom:SetSize(Width, Settings["right-window-bottom-height"])
	self.Bottom:SetPoint("BOTTOMRIGHT", self, 0, 0)
	HydraUI:AddBackdrop(self.Bottom, Assets:GetTexture(Settings["ui-header-texture"]))
	self.Bottom.Outside:SetBackdropColor(R, G, B, 1)
	
	self.Left = CreateFrame("Frame", nil, self, "BackdropTemplate")
	self.Left:SetSize(LeftWidth, Settings["right-window-height"])
	self.Left:SetPoint("BOTTOMLEFT", self.Bottom, "TOPLEFT", 0, Adjust) -- -4
	HydraUI:AddBackdrop(self.Left)
	self.Left.Outside:SetBackdropColor(R, G, B, (Settings["right-window-fill"] / 100))
	
	self.Right = CreateFrame("Frame", nil, self, "BackdropTemplate")
	self.Right:SetSize(RightWidth, Settings["right-window-height"])
	self.Right:SetPoint("BOTTOMRIGHT", self.Bottom, "TOPRIGHT", 0, Adjust) -- -4
	HydraUI:AddBackdrop(self.Right)
	self.Right.Outside:SetBackdropColor(R, G, B, (Settings["right-window-fill"] / 100))
	
	self.TopLeft = CreateFrame("Frame", nil, self, "BackdropTemplate")
	self.TopLeft:SetSize(LeftWidth, Settings["right-window-top-height"])
	self.TopLeft:SetPoint("BOTTOMLEFT", self.Left, "TOPLEFT", 0, Adjust) -- -4
	HydraUI:AddBackdrop(self.TopLeft, Assets:GetTexture(Settings["ui-header-texture"]))
	self.TopLeft.Outside:SetBackdropColor(R, G, B)
	
	self.TopRight = CreateFrame("Frame", nil, self, "BackdropTemplate")
	self.TopRight:SetSize(RightWidth, Settings["right-window-top-height"])
	self.TopRight:SetPoint("BOTTOMRIGHT", self.Right, "TOPRIGHT", 0, Adjust) -- -4
	HydraUI:AddBackdrop(self.TopRight, Assets:GetTexture(Settings["ui-header-texture"]))
	self.TopRight.Outside:SetBackdropColor(R, G, B)
end

function Window:AddDataTexts()
	local Width = self.Bottom:GetWidth() / 3
	local Height = self.Bottom:GetHeight()
	
	local Left = DT:NewAnchor("Window-Left", self.Bottom)
	Left:SetSize(Width, Height)
	Left:SetPoint("LEFT", self.Bottom, 0, 0)
	
	local Middle = DT:NewAnchor("Window-Middle", self.Bottom)
	Middle:SetSize(Width, Height)
	Middle:SetPoint("LEFT", Left, "RIGHT", 0, 0)
	
	local Right = DT:NewAnchor("Window-Right", self.Bottom)
	Right:SetSize(Width, Height)
	Right:SetPoint("LEFT", Middle, "RIGHT", 0, 0)
	
	DT:SetDataText("Window-Left", Settings["data-text-extra-left"])
	DT:SetDataText("Window-Middle", Settings["data-text-extra-middle"])
	DT:SetDataText("Window-Right", Settings["data-text-extra-right"])
end

function Window:UpdateDataTexts()
	local Width = self.Bottom:GetWidth() / 3
	
	local Left = DT:GetAnchor("Window-Left")
	Left:SetWidth(Width)
	Left:ClearAllPoints()
	Left:SetPoint("LEFT", self.Bottom, 0, 0)
	
	local Middle = DT:GetAnchor("Window-Middle")
	Middle:SetWidth(Width)
	Middle:ClearAllPoints()
	Middle:SetPoint("LEFT", Left, "RIGHT", 0, 0)
	
	local Right = DT:GetAnchor("Window-Right")
	Right:SetWidth(Width)
	Right:ClearAllPoints()
	Right:SetPoint("LEFT", Middle, "RIGHT", 0, 0)
end

function Window:Load()
	if (not Settings["right-window-enable"]) then
		return
	end
	
	self:SetSize(Settings["right-window-width"], Settings["right-window-height"] + Settings["right-window-bottom-height"] + Settings["right-window-top-height"]) -- Border fix me
	self:SetPoint("BOTTOMRIGHT", HydraUI.UIParent, -13, 13)
	self:SetFrameStrata("BACKGROUND")
	
	if (Settings["right-window-size"] == "SINGLE") then
		self:CreateSingleWindow()
	else
		self:CreateDoubleWindow()
	end
	
	self:AddDataTexts()
	
	HydraUI:CreateMover(self)
end

local UpdateLeftText = function(value)
	DT:SetDataText("Window-Left", value)
end

local UpdateMiddleText = function(value)
	DT:SetDataText("Window-Middle", value)
end

local UpdateRightText = function(value)
	DT:SetDataText("Window-Right", value)
end

local UpdateOpacity = function(value)
	if (Settings["right-window-size"] == "SINGLE") then
		local R, G, B = HydraUI:HexToRGB(Settings["ui-window-main-color"])
		
		Window.Middle.Outside:SetBackdropColor(R, G, B, (Settings["right-window-fill"] / 100))
	end
end

local UpdateLeftOpacity = function(value)
	if (Settings["right-window-size"] ~= "SINGLE") then
		local R, G, B = HydraUI:HexToRGB(Settings["ui-window-main-color"])
		
		Window.Left.Outside:SetBackdropColor(R, G, B, (value / 100))
	end
end

local UpdateRightOpacity = function(value)
	if (Settings["right-window-size"] ~= "SINGLE") then
		local R, G, B = HydraUI:HexToRGB(Settings["ui-window-main-color"])
		
		Window.Right.Outside:SetBackdropColor(R, G, B, (value / 100))
	end
end

local UpdateWidth = function(value)
	if (Settings["right-window-size"] == "SINGLE") then
		Window.Bottom:SetWidth(value)
		Window.Middle:SetWidth(value)
		Window.Top:SetWidth(value)
	else
		local LeftWidth = (value * Settings["right-window-middle-pos"] / 100)
		local RightWidth = (value - LeftWidth) + (Settings["ui-border-thickness"] < 2 and 1 or 0)
	
		Window.Bottom:SetWidth(value)
		Window.Left:SetWidth(LeftWidth)
		Window.TopLeft:SetWidth(LeftWidth)
		Window.Right:SetWidth(RightWidth)
		Window.TopRight:SetWidth(RightWidth)
	end
	
	Window:UpdateDataTexts()
end

local UpdateHeight = function(value)
	if (Settings["right-window-size"] == "SINGLE") then
		Window.Middle:SetHeight(value)
	else
		Window.Left:SetHeight(value)
		Window.Right:SetHeight(value)
	end
end

local UpdateSplitPosition = function(value)
	if (Settings["right-window-size"] == "SINGLE") then
		return
	end
	
	local Width = Settings["right-window-width"]
	local LeftWidth = (Width * value / 100)
	local RightWidth = (Width - LeftWidth) + (Settings["ui-border-thickness"] < 2 and 1 or 0)
	
	Window.Left:SetWidth(LeftWidth)
	Window.TopLeft:SetWidth(LeftWidth)
	
	Window.Right:SetWidth(RightWidth)
	Window.TopRight:SetWidth(RightWidth)
end

GUI:AddWidgets(Language["General"], Language["Data Texts"], function(left, right)
	left:CreateHeader(Language["Right Window Texts"])
	left:CreateDropdown("data-text-extra-left", Settings["data-text-extra-left"], DT.List, Language["Set Left Text"], Language["Set the information to be displayed in the left data text anchor"], UpdateLeftText)
	left:CreateDropdown("data-text-extra-middle", Settings["data-text-extra-middle"], DT.List, Language["Set Middle Text"], Language["Set the information to be displayed in the middle data text anchor"], UpdateMiddleText)
	left:CreateDropdown("data-text-extra-right", Settings["data-text-extra-right"], DT.List, Language["Set Right Text"], Language["Set the information to be displayed in the right data text anchor"], UpdateRightText)
end)

GUI:AddWidgets(Language["General"], Language["Right"], Language["Chat"], function(left, right)
	left:CreateHeader(Language["General"])
	left:CreateSwitch("right-window-enable", Settings["right-window-enable"], Language["Enable Right Window"], Language["Enable the right side window, for placing chat or addons into"], ReloadUI):RequiresReload(true)
	left:CreateDropdown("right-window-size", Settings["right-window-size"], {[Language["Single"]] = "SINGLE", [Language["Double"]] = "DOUBLE"}, Language["Set Window Size"], Language["Set the number of windows to be displayed"], ReloadUI):RequiresReload(true)
	left:CreateSlider("right-window-width", Settings["right-window-width"], 300, 650, 1, Language["Window Width"], Language["Set the width of the window"], UpdateWidth)
	left:CreateSlider("right-window-height", Settings["right-window-height"], 40, 350, 1, Language["Window Height"], Language["Set the height of the window"], UpdateHeight)
	
	local Single = left:CreateSlider("right-window-fill", Settings["right-window-fill"], 0, 100, 5, Language["Background Opacity"], Language["Set the opacity of the window background"], UpdateOpacity, nil, "%")
	local Left = left:CreateSlider("right-window-left-fill", Settings["right-window-left-fill"], 0, 100, 5, Language["Left Opacity"], Language["Set the opacity of the left window background"], UpdateLeftOpacity, nil, "%")
	local Right = left:CreateSlider("right-window-right-fill", Settings["right-window-right-fill"], 0, 100, 5, Language["Right Opacity"], Language["Set the opacity of the right window background"], UpdateRightOpacity, nil, "%")
	
	left:CreateSlider("right-window-middle-pos", Settings["right-window-middle-pos"], 1, 99, 1, "Set divider", "blah", UpdateSplitPosition, nil, "%")
	
	if (Settings["right-window-size"] == "SINGLE") then
		Left:GetParent():Disable()
		Right:GetParent():Disable()
	else
		Single:GetParent():Disable()
	end
end)