local PANEL = {}

function PANEL:Init()
    self.iMargin, self.iRoundness = 5, 0

    self:SetFont(ProkectLib:Font(15))
    self:SetTextColor(color_white)

    self.tBgColor = Color(25,25,25)
    self.tBoxColor = Color(25,25,25)
    self.Rougness = 0 
    self.DropButton:SetVisible(true)
    self.hbgcolor = Color(45, 45, 45)
end

function PANEL:DoClick()
    self.iCursorX, self.iCursorY = self:LocalCursorPos()
    self.fLayerAlpha = 50
    self.fLayerScale = 0
    self.fLayerScaleTo = math.max(self:GetWide(), self:GetTall())
    self.bDrawAnim = true
    local s = self
    if self:IsMenuOpen() then
        self:CloseMenu()
        return
    end
   
    self:OpenMenu()

    local dMenu = self.Menu
    if not IsValid(dMenu) then
        return
    end

    local iMargin = self.iMargin
    local iRoundness = self.iRoundness

    local iX, iH = dMenu:GetPos()
    dMenu:SetPos(iX, (iH + 3))

    function dMenu:Paint(iW, iH)
        surface.SetDrawColor(s.tBoxColor)
        self:DrawFilledRect()

        surface.SetDrawColor(s.tBoxColor)
        surface.DrawOutlinedRect(0, 0, iW, iH)
    end

    local dVBar = dMenu:GetVBar()
    dVBar:SetWidth(ScrH() * .008)
    dVBar:SetHideButtons(true)
    
    function dVBar:Paint(iW, iH)
        surface.SetDrawColor(Color(58, 58, 58))
        self:DrawFilledRect()
    end

    function dVBar.btnGrip:Paint(iW, iH)
        surface.SetDrawColor(Color(73, 73, 73))
        self:DrawFilledRect()
    end

    for k, v in pairs(dMenu:GetCanvas():GetChildren()) do
        v:SetTextColor(color_white)
        v:SetFont(self:GetFont())
        v:SetTextInset(iMargin, 0)
        function v:Paint(iW, iH)
            if self.Hovered then
                surface.SetDrawColor(s.hbgcolor)
                self:DrawFilledRect()
            end
        end
    end
end

function PANEL:SetBgColor(tColor)
    self.tBgColor = tColor
end

function PANEL:SetBgHoverColor(tColor)
    self.tBoxColor = tColor
end

function PANEL:Paint(iW, iH)
    draw.RoundedBox(self.Rougness,0,0,iW,iH,self.tBoxColor)
    if self.bDrawAnim then
        self.fLayerAlpha = Lerp(RealFrameTime() * 8, self.fLayerAlpha, 0)
        self.fLayerScale = Lerp(RealFrameTime() * 8, self.fLayerScale, self.fLayerScaleTo * 2)

        if (self.fLayerAlpha < 1) then
            self.iCursorX, self.iCursorY = nil, nil
            self.fLayerAlpha, self.fLayerScale, self.fLayerScaleTo  = nil, nil, nil
            self.bDrawAnim = nil
        end
    end

    if self:IsMenuOpen() or self.bHighlight then
        if not self.bSelected then
            self:SetTextColor(color_white)
            
            self.bSelected = true
        end

        return
    end
end

vgui.Register("PComboBox", PANEL, "DComboBox")