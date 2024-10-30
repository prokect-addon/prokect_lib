local PANEL = {}

function PANEL:Init()
    self.cColor = Color(25, 25, 25)
    self.cknob = Color(82, 113, 255)
    self.iMin = 0
    self.iMax = 50
    self.iValue = 0

    self.Knob.Paint = function(s, w, h)
        draw.RoundedBox(32, 0, 0, w, h, self.cknob)
    end
end

function PANEL:SetMin(iMin)
    self.iMin = iMin
end

function PANEL:SetMax(iMax)
    self.iMax = iMax
end

function PANEL:SetValue(iValue)
    self.iValue = math.Clamp(iValue, self.iMin or 0, self.iMax or 1)

    self:SetSlideX(0)
end

function PANEL:GetValue()
    return self.iValue
end

local fcOnValueChanged = nil
function PANEL:OnValueChanged(iValue)
    self.iValue = Lerp(iValue, self.iMin or 0, self.iMax or 1)
    
    if fcOnValueChanged then
        fcOnValueChanged(self.iValue)
    end
end

function PANEL:Paint(w, h)
    draw.RoundedBox(32, 0, 0, w, h, self.cColor)
end

vgui.Register("ProkectLib.Slider", PANEL, "DSlider")

