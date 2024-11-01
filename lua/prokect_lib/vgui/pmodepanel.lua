local PANEL = {}

function PANEL:Init()
  self.base = vgui.Create("DModelPanel", self)
  self.base:Dock(FILL)
  self.base:SetPaintedManually(true)
end

function PANEL:GetBase()
  return self.base
end

function PANEL:SetModel(sModel)
  self.base:SetModel(sModel)
end

function PANEL:PushMask(mask)
  render.ClearStencil()
  render.SetStencilEnable(true)

  render.SetStencilWriteMask(1)
  render.SetStencilTestMask(1)

  render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
  render.SetStencilPassOperation(STENCILOPERATION_ZERO)
  render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
  render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
  render.SetStencilReferenceValue(1)

  mask()

  render.SetStencilFailOperation(STENCILOPERATION_ZERO)
  render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
  render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
  render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
  render.SetStencilReferenceValue(1)
end

function PANEL:PopMask()
  render.SetStencilEnable(false)
  render.ClearStencil()
end

function PANEL:Paint(w, h)    
    self:PushMask(function()
        local poly = {}
    
        local x, y = w / 2, h / 2
        for angle = 1, 360 do
          local rad = math.rad(angle)
    
          local cos = math.cos(rad) * y
          local sin = math.sin(rad) * y
    
          poly[#poly + 1] = {
            x = x + cos,
            y = y + sin
          }
        end
    
        draw.NoTexture()
        surface.SetDrawColor(255, 255, 255)
        surface.DrawPoly(poly)
      end)
    self.base:PaintManual()
    self:PopMask()
end

vgui.Register("ProkectLib.ModelPanel", PANEL)