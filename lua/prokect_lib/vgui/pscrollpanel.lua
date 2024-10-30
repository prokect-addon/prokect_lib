local PANEL = {}
local RX, RY = ProkectLib.RespX, ProkectLib.RespY

function PANEL:Init()
    self.cBack = Color(25, 25, 25)
    self.cGrip1 = Color(82, 90, 255)
    self.cGrip2 = Color(82, 113, 255)
    self.iScrollTarget = 0
    self.iCurrentScroll = 0

    local vbar = self:GetVBar()
    vbar:SetHideButtons(true)

    vbar.Paint = function(s, w, h)
        draw.RoundedBox(RX(6), w - RX(12), RY(0), w - RX(8), h, self.color)
    end

    vbar.btnGrip.Paint = function(s, w, h)
        if not s:IsHovered() then
            draw.RoundedBox(RX(6), w - RX(9), RY(3), w - RX(14), h - RY(7) , self.cGrip1)
        else
            draw.RoundedBox(RX(6), w - RX(9), RY(3), w - RX(14), h - RY(7) , self.cGrip2)
        end
    end

    function vbar:OnMouseWheeled(dlta)
        self:GetParent():AddScroll(dlta * -20)
    end
end

function PANEL:SetColors(c1, c2, c3)
    if not c1 then c1 = self.cBack end
    if not c2 then c2 = self.cGrip1 end
    if not c3 then c3 = self.cGrip2 end

    self.cBack = c1
    self.cGrip1 = c2
    self.cGrip2 = c3
end

function PANEL:Think()
    local vbar = self:GetVBar()
    if self.iScrollTarget != vbar.Scroll then
        self.iScrollTarget = math.Clamp(self.iScrollTarget, 0, 1)
        self.iCurrentScroll = Lerp(FrameTime() * 5, self.iCurrentScroll, self.iScrollTarget)
        vbar:SetScroll(self.iCurrentScroll * vbar.CanvasSize)
    end
end

function PANEL:AddScroll(delta)
    local vbar = self:GetVBar()
    self.iScrollTarget = math.Clamp(self.iScrollTarget + delta / vbar.CanvasSize, 0, 1)
end

vgui.Register("ProkectLib.Scroll", PANEL, "DScrollPanel")