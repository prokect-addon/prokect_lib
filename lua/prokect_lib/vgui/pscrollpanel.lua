local PANEL = {}

function PANEL:Init()

    local vbar = self:GetVBar()
    vbar:SetWide(RX(6))
    vbar:SetHideButtons(true)
    vbar.Paint = function(self, w, h)
        draw.RoundedBox(RX(6), RX(0), RY(0), w, h, ProkectLib:Color("ScrollP1"))
    end
    function vbar.btnGrip:Paint(w, h)
        draw.RoundedBox(RX(6), RX(1), RY(1), w - RX(2), h - RY(2) , ProkectLib:Color("ScrollP2"))
    end

end

vgui.Register("PScrollPanel", PANEL, "DScrollPanel")