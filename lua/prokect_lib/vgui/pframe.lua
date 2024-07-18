local PANEL = {}

function PANEL:Init()
    self:SetTitle("")
    self:SetDraggable(false)
    self:ShowCloseButton(false)
    self:MakePopup()
    self:Rounded(6)
end

function PANEL:Rounded(radius)
    self.roundedRadius = radius
end

function PANEL:Paint(w, h)
    local roundedRadius = self.roundedRadius or RX(0)
    draw.RoundedBox(roundedRadius, RX(0), RY(0), w, h, ProkectLib:Color("P1"))
    draw.RoundedBox(roundedRadius, RX(5), RY(5), w - RX(10), h - RY(10), ProkectLib:Color("P2"))
end

vgui.Register("PFrame", PANEL, "DFrame")