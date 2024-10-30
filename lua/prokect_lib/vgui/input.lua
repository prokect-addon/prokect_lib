local PANEL = {}

function PANEL:Init()
    self:SetTextColor(color_white)
    self:SetDrawLanguageID(false)
    self:SetPaintBackground(false)
    self.cBack = Color(25,25,25)
    self.bIcon = false
    self.sIcon = ""
    self.bFontAwesome = false
    self.iSizeFont = 16
end

function PANEL:PSetIcon(sIcon, bFontAwesome, iX, iY, iW, iH)
    self.bIcon = true
    self.sIcon = sIcon
    self.bFontAwesome = bFontAwesome

    self.tPos = {
        iX,
        iY
    }
    self.tSize = {
        iW,
        iH
    }
end

function PANEL:PSetText(iX, iY, iSizeFont)
    self.tTextPos = {
        iX,
        iY
    }
    self.iSizeFont = iSizeFont
end

function PANEL:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, self.cBack)

    if self.bIcon then
        if self.bFontAwesome then
            draw.SimpleText( self.sIcon, ProkectLib:Font(self.tSize[2], "Solid", true), self.tPos[1] + self.tSize[1] / 2, self.tPos[2] + self.tSize[2] / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        else
            surface.SetDrawColor(color_white)
            surface.SetMaterial(self.sIcon)
            surface.DrawTexturedRect(self.tPos[1], self.tPos[2], self.tSize[1], self.tSize[2])
        end
    end

    draw.SimpleText(self:GetText() == "" and self:GetPlaceholderText() or self:GetText(), ProkectLib:Font(self.iSizeFont, "Medium"), (self.tTextPos and self.tTextPos[1]) or RX(5), (self.tTextPos and self.tTextPos[2]) or h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

vgui.Register("ProkectLib.Input", PANEL, "DTextEntry")