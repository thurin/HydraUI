local HydraUI, GUI, Language, Assets, Settings, Defaults = select(2, ...):get()

local Map = HydraUI:NewModule("Minimap")

Defaults["minimap-enable"] = true
Defaults["minimap-size"] = 140
Defaults["minimap-show-top"] = true
Defaults["minimap-show-bottom"] = true
Defaults["minimap-buttons-enable"] = true
Defaults["minimap-buttons-size"] = 22
Defaults["minimap-buttons-spacing"] = 2
Defaults["minimap-buttons-perrow"] = 5
Defaults["minimap-top-height"] = 28
Defaults["minimap-bottom-height"] = 28
Defaults["minimap-top-fill"] = 100
Defaults["minimap-bottom-fill"] = 100

function Map:Disable(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
	end
	
	if (object.GetScript and object:GetScript("OnUpdate")) then
		object:SetScript("OnUpdate", nil)
	end
	
	object.Show = function() end
	object:Hide()
end

local OnMouseWheel = function(self, delta)
	if (delta > 0) then
		MinimapZoomIn:Click()
	elseif (delta < 0) then
		MinimapZoomOut:Click()
	end
end

function Map:Style()
	local R, G, B = HydraUI:HexToRGB(Settings["ui-window-main-color"])
	local Border = Settings["ui-border-thickness"]
	local Width = Settings["minimap-size"] + (Border * 2)

	-- Backdrop
	self:SetPoint("TOPRIGHT", HydraUI.UIParent, -12, -12)
	self:SetSize((Settings["minimap-size"] + 8), ((Settings["minimap-show-top"] == true and 22 or 0) + (Settings["minimap-show-bottom"] == true and 22 or 0) + 8 + Settings["minimap-size"]))
	
	self.TopFrame = CreateFrame("Frame", "HydraUIMinimapTop", self, "BackdropTemplate")
	self.TopFrame:SetSize(Width, Settings["minimap-top-height"])
	self.TopFrame:SetPoint("TOP", self, 0, 0)
	HydraUI:AddBackdrop(self.TopFrame, Assets:GetTexture("HydraUI 4"))
	self.TopFrame.Outside:SetBackdropColor(R, G, B, (Settings["minimap-top-fill"] / 100))
	
	self.Middle = CreateFrame("Frame", nil, self, "BackdropTemplate")
	self.Middle:SetSize(Width, Settings["minimap-size"])
	self.Middle:SetPoint("TOP", self.TopFrame, "BOTTOM", 0, 1 > Border and 1 or (Border + 2))
	HydraUI:AddBackdrop(self.Middle)
	self.Middle.Outside:SetBackdropColor(R, G, B, 0)
	
	self.BottomFrame = CreateFrame("Frame", "HydraUIMinimapBottom", self, "BackdropTemplate")
	self.BottomFrame:SetSize(Width, Settings["minimap-bottom-height"])
	self.BottomFrame:SetPoint("TOP", self.Middle, "BOTTOM", 0, 1 > Border and 1 or (Border + 2))
	HydraUI:AddBackdrop(self.BottomFrame, Assets:GetTexture("HydraUI 4"))
	self.BottomFrame.Outside:SetBackdropColor(R, G, B, (Settings["minimap-bottom-fill"] / 100))
	
	-- Style minimap
	Minimap:SetMaskTexture(Assets:GetTexture("Blank"))
	Minimap:SetParent(self)
	Minimap:ClearAllPoints()
	Minimap:SetSize(Settings["minimap-size"], Settings["minimap-size"])
	Minimap:SetPoint("TOPLEFT", self.Middle, Border + 1, -(Border + 1))
	Minimap:SetPoint("BOTTOMRIGHT", self.Middle, -(Border + 1), Border + 1)
	Minimap:EnableMouseWheel(true)
	Minimap:SetScript("OnMouseWheel", OnMouseWheel)
	
	MiniMapMailFrame:ClearAllPoints()
	MiniMapMailFrame:SetPoint("TOPRIGHT", -4, 12)
	
	MiniMapMailIcon:SetSize(32, 32)
	MiniMapMailIcon:SetTexture(Assets:GetTexture("Mail 2"))
	MiniMapMailIcon:SetVertexColor(HydraUI:HexToRGB("EEEEEE"))
	
	MinimapNorthTag:SetTexture(nil)
	
	MiniMapTrackingBackground:SetTexture(nil)
	MiniMapTrackingBorder:SetTexture(nil)
	MiniMapTrackingShine:SetTexture(nil)
	
	self.Tracking = CreateFrame("Frame", nil, Minimap, "BackdropTemplate")
	self.Tracking:SetSize(20, 20)
	self.Tracking:SetPoint("TOPLEFT", Minimap, 2, -2)
	self.Tracking:SetBackdrop(HydraUI.BackdropAndBorder)
	self.Tracking:SetBackdropColor(0, 0, 0)
	self.Tracking:SetBackdropBorderColor(0, 0, 0)
	
	self.Tracking.Tex = self.Tracking:CreateTexture(nil, "ARTWORK")
	self.Tracking.Tex:SetPoint("TOPLEFT", self.Tracking, 1, -1)
	self.Tracking.Tex:SetPoint("BOTTOMRIGHT", self.Tracking, -1, 1)
	self.Tracking.Tex:SetTexture(Assets:GetTexture(Settings["ui-header-texture"]))
	self.Tracking.Tex:SetVertexColor(HydraUI:HexToRGB(Settings["ui-header-texture-color"]))
	
	MiniMapTracking:SetParent(self.Tracking)
	MiniMapTracking:ClearAllPoints()
	MiniMapTracking:SetPoint("CENTER", self.Tracking, 0, 0)
	
	MiniMapTrackingIcon:SetSize(18, 18)
	MiniMapTrackingIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	MiniMapTrackingIcon:SetPoint("CENTER", self.Tracking)
	
	MiniMapBattlefieldFrame:ClearAllPoints()
	MiniMapBattlefieldFrame:SetPoint("BOTTOMLEFT", Minimap, 0, -3)
	
	self:Disable(MinimapCluster)
	self:Disable(MinimapBorder)
	self:Disable(MinimapBorderTop)
	self:Disable(MinimapZoomIn)
	self:Disable(MinimapZoomOut)
	self:Disable(MinimapNorthTag)
	self:Disable(MiniMapWorldMapButton)
	self:Disable(MiniMapMailBorder)
	self:Disable(GameTimeFrame)
	self:Disable(TimeManagerClockButton)
	
	if (not Settings["minimap-show-top"]) then
		self.TopFrame:Hide()
	end
	
	if (not Settings["minimap-show-bottom"]) then
		self.BottomFrame:Hide()
	end
	
	HydraUI:CreateMover(self)
end

local UpdateMinimapSize = function(value)
	Map:SetSize((value + 8), ((Settings["minimap-show-top"] == true and Settings["minimap-top-height"] or 0) + (Settings["minimap-show-bottom"] == true and Settings["minimap-bottom-height"] or 0) + 8 + value))
	
	Minimap:SetSize(value, value)
	Minimap:SetZoom(Minimap:GetZoom() + 1)
	Minimap:SetZoom(Minimap:GetZoom() - 1)
	Minimap:UpdateBlips()
	
	Map.Middle:SetSize(value, value)
	Map.TopFrame:SetWidth(value)
	Map.BottomFrame:SetWidth(value)
end

local UpdateShowTopBar = function(value)
	local Anchor = HydraUI:GetModule("DataText"):GetAnchor("Minimap-Top")
	
	if value then
		Map.TopFrame:Show()
		
		if Anchor.Enable then
			Anchor:Enable()
		end
	else
		Map.TopFrame:Hide()
		
		if Anchor.Disable then
			Anchor:Disable()
		end
	end
	
	UpdateMinimapSize(Settings["minimap-size"])
end

local UpdateShowBottomBar = function(value)
	local Anchor = HydraUI:GetModule("DataText"):GetAnchor("Minimap-Bottom")
	
	if value then
		Map.BottomFrame:Show()
		
		if Anchor.Enable then
			Anchor:Enable()
		end
	else
		Map.BottomFrame:Hide()
		
		if Anchor.Disable then
			Anchor:Disable()
		end
	end
	
	UpdateMinimapSize(Settings["minimap-size"])
end

local UpdateTopHeight = function(value)
	Map.TopFrame:SetHeight(value)
end

local UpdateBottomHeight = function(value)
	Map.BottomFrame:SetHeight(value)
end

local UpdateTopFill = function(value)
	local R, G, B = HydraUI:HexToRGB(Settings["ui-window-main-color"])
	
	Map.TopFrame.Outside:SetBackdropColor(R, G, B, (value / 100))
end

local UpdateBottomFill = function(value)
	local R, G, B = HydraUI:HexToRGB(Settings["ui-window-main-color"])
	
	Map.BottomFrame.Outside:SetBackdropColor(R, G, B, (value / 100))
end

function Map:Load()
	if (not Settings["minimap-enable"]) then
		return
	end
	
	self:Style()
	
	function GetMinimapShape()
		return "SQUARE"
	end
end

GUI:AddWidgets(Language["General"], Language["Minimap"], function(left, right)
	left:CreateHeader(Language["Enable"])
	left:CreateSwitch("minimap-enable", Settings["minimap-enable"], Language["Enable Mini Map Module"], Language["Enable the HydraUI mini map module"], ReloadUI):RequiresReload(true)
	
	left:CreateHeader(Language["Styling"])
	left:CreateSwitch("minimap-show-top", Settings["minimap-show-top"], Language["Enable Top Bar"], Language["Enable the data text bar on top of the mini map"], UpdateShowTopBar)
	left:CreateSwitch("minimap-show-bottom", Settings["minimap-show-bottom"], Language["Enable Bottom Bar"], Language["Enable the data text bar on the bottom of the mini map"], UpdateShowBottomBar)
	left:CreateSlider("minimap-size", Settings["minimap-size"], 100, 250, 10, Language["Mini Map Size"], Language["Set the size of the mini map"], UpdateMinimapSize)
	left:CreateSlider("minimap-top-height", Settings["minimap-top-height"], 14, 40, 1, Language["Top Height"], Language["Set the height for the top of the minimap"], UpdateTopHeight)
	left:CreateSlider("minimap-bottom-height", Settings["minimap-bottom-height"], 14, 40, 1, Language["Bottom Height"], Language["Set the height for the bottom of the minimap"], UpdateBottomHeight)
	left:CreateSlider("minimap-top-fill", Settings["minimap-top-fill"], 0, 100, 5, Language["Top Fill"], Language["Set the opacity for the top of the minimap"], UpdateTopFill, nil, "%")
	left:CreateSlider("minimap-bottom-fill", Settings["minimap-bottom-fill"], 0, 100, 5, Language["Bottom Fill"], Language["Set the opacity for the bottom of the minimap"], UpdateBottomFill, nil, "%")
end)