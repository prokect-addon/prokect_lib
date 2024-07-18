local PANEL = {}

function PANEL:Init()
    self:SetTextColor(ProkectLib.Config.Color["Text"])
end

function PANEL:Paint(w, h)
    if not self:IsHovered() then
        draw.RoundedBox(RX(6), RX(0), RY(0), w, h, ProkectLib.Config.Color["BtnP1"])
        draw.RoundedBox(RX(6), RX(2), RY(2), w - RX(4), h - RY(4), ProkectLib.Config.Color["BtnP2"])
    else
        draw.RoundedBox(RX(6), RX(0), RY(0), w, h, ProkectLib.Config.Color["BtnP2"])
        draw.RoundedBox(RX(6), RX(2), RY(2), w - RX(4), h - RY(4), ProkectLib.Config.Color["BtnHover"])
    end
end

vgui.Register("PButton", PANEL, "DButton")