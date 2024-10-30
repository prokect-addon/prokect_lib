ProkectLib.Fonts = {}

ProkectLib.RespX = ProkectLib.RespX or function(x) return x / 1920 * ScrW() end
ProkectLib.RespY = ProkectLib.RespY or function(y) return y / 1080 * ScrH() end

function ProkectLib:Font(iSize, sType, bAwesome)
	iSize = iSize or 15
	sType = sType or "Medium" -- Light, Medium or Bold
	bAwesome = bAwesome or false

	local sName = ("ProkectLib:Font:%i:%s"):format(iSize, sType)
	if not ProkectLib.Fonts[sName] then

		surface.CreateFont(sName, {
			font = bAwesome and ("Font Awesome 6 Pro %s"):format(sType) or ("Montserrat %s"):format(sType):Trim(),
			size = ProkectLib.RespX(iSize),
			weight = 500,
			extended = bAwesome and true or false
		})

		ProkectLib.Fonts[sName] = true
	end

	return sName
end

function ProkectLib:Color(sName)
	return ProkectLib.Config.Color[sName]
end

function ProkectLib:Material(sName)
	return ProkectLib.Config.Materials[sName]
end

function ProkectLib.DrawMaterial(iX, iY, iW, iH, sMat, cColor)
	surface.SetDrawColor(cColor or color_white)
	surface.SetMaterial(sMat)
	surface.DrawTexturedRect(iX, iY, iW, iH)
end

function ProkectLib:Notify(msg, enum, time)
	local enums = {
		["generic"] = 0,
		["error"] = 1,
		["refresh"] = 2,
		["info"] = 3,
		["cut"] = 4,
	}

	if not IsValid(enums[enum]) then
		print("Invalid enum: " .. enum)
		print("Valid enums: generic, error, refresh, info, cut")
		return
	end

	notification.AddLegacy(msg, enums[enum], time)
end

function ProkectLib.IsMaterial(sName)
	local mat = Material(sName)
	
	return mat and mat:IsError() == false
end

function ProkectLib:Sound(sName)
	if not ProkectLib.Config.Sound[sName] then ProkectLib.Log("error", "ProkectLib:Sound: Invalid sName expected string got " .. type(sName)) return end

	surface.PlaySound(ProkectLib.Config.Sound[sName])
end

--[[
    Example: ProkectLib:GradientText("Text", "DermaDefault", 0, 0, Color(0, 0, 0), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
]]
function ProkectLib:GradientText(sText, sFont, iX, iY, c1, c2, sXAlign, sYAlign)
    sText = tostring(sText)
    sFont = sFont or "DermaDefault"
    iX = iX or 0
    iY = iY or 0
    c1 = c1 or color_white
    c2 = c2 or color_white
    sXAlign = sXAlign or TEXT_ALIGN_LEFT
    sYAlign = sYAlign or TEXT_ALIGN_TOP

    surface.SetFont(sFont)
    local iWText, iHText = surface.GetTextSize(sText)

    local rStep = (c2.r - c1.r) / #sText
    local gStep = (c2.g - c1.g) / #sText
    local bStep = (c2.b - c1.b) / #sText
    local aStep = (c2.a - c1.a) / #sText
    
    if sXAlign == TEXT_ALIGN_CENTER then
        iX = iX - iWText / 2
    elseif sXAlign == TEXT_ALIGN_RIGHT then
        iX = iX - iWText
    end
    
    if sYAlign == TEXT_ALIGN_CENTER then
        iY = iY - iHText / 2
    elseif sYAlign == TEXT_ALIGN_BOTTOM then
        iY = iY - iHText
    end

    local iCurrentX = iX
    for i = 1, #sText do
        local sChar = sText:sub(i, i)
        local color = Color(
            c1.r + rStep * (i - 1),
            c1.g + gStep * (i - 1),
            c1.b + bStep * (i - 1),
            c1.a + aStep * (i - 1)
        )
        
        surface.SetTextColor(color)
        surface.SetTextPos(iCurrentX, iY)
        surface.DrawText(sChar)
        
        local iWChar, _ = surface.GetTextSize(sChar)
        iCurrentX = iCurrentX + iWChar
    end
end

--[[
    Example : ProkectLib.ColorText("DermaDefault", 0, 0, 0, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, Color(255, 255, 255), "Hello", Color(255, 0, 0), "World")
]]
function ProkectLib.ColorText(sFont, iX, iY, sXAlign, sYAlign, ...)
    local tArgs = {...}
    local iTotalW = 0
    local iTotalH = 0

    sFont = sFont or "DermaDefault"
    iX = iX or 0
    iY = iY or 0
    sXAlign = sXAlign or TEXT_ALIGN_LEFT
    sYAlign = sYAlign or TEXT_ALIGN_TOP

    surface.SetFont(sFont)
    
    for i = 1, #tArgs, 2 do
        local sText = tostring(tArgs[i + 1])
        local iTextW, iTextH = surface.GetTextSize(sText)
        iTotalW = iTotalW + iTextW
        iTotalH = math.max(iTotalH, iTextH)
    end

    if sXAlign == TEXT_ALIGN_CENTER then
        iX = iX - iTotalW / 2
    elseif sXAlign == TEXT_ALIGN_RIGHT then
        iX = iX - iTotalW
    end
    
    if sYAlign == TEXT_ALIGN_CENTER then
        iY = iY - iTotalH / 2
    elseif sYAlign == TEXT_ALIGN_BOTTOM then
        iY = iY - iTotalH
    end

    local iCurrentX = iX
    for i = 1, #tArgs, 2 do
        local cColor = tArgs[i] or color_white
        local sText = tostring(tArgs[i + 1]) or ""

        local iWText, iHText = surface.GetTextSize(sText)

        surface.SetTextColor(cColor)
        surface.SetTextPos(iX, iY)
        surface.DrawText(sText)

        iX = iX + iWText
    end
end

/*
    EZMASK STENCIL
*/

--[[
Copyright 2021 alexsnowrun

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the
Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

ProkectLib.EZMASK = {}

local function ResetStencils()
	render.SetStencilWriteMask(0xFF)
	render.SetStencilTestMask(0xFF)
	render.SetStencilReferenceValue(0)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.ClearStencil()
end

local function EnableMasking()
	render.SetStencilEnable(true)
	render.SetStencilReferenceValue(1)
	render.SetStencilCompareFunction(STENCIL_NEVER)
	render.SetStencilFailOperation(STENCIL_REPLACE)
end

local function SaveMask()
    render.SetStencilCompareFunction(STENCIL_EQUAL)
    render.SetStencilFailOperation(STENCIL_KEEP)
end

local function DisableMasking()
    render.SetStencilEnable(false)
end

function ProkectLib.EZMASK.DrawWithMask(func_mask, func_todraw)
    ResetStencils()
    EnableMasking()
    func_mask()
    SaveMask()
    func_todraw()
    DisableMasking()
end

ProkectLib.EZMASK.ResetStencils = ResetStencils
ProkectLib.EZMASK.EnableMasking = EnableMasking
ProkectLib.EZMASK.SaveMask = SaveMask
ProkectLib.EZMASK.DisableMasking = DisableMasking

function ProkectLib.DrawCircle(x, y, radius, angle_start, angle_end, color)
	local poly = {}
	angle_start = (angle_start or 0) + 270
	angle_end   = (angle_end or 360) + 270
	x = (x or 0) + radius
    y = (y or 0) + radius

	poly[1] = { x = x, y = y }
	for i = math.min( angle_start, angle_end ), math.max( angle_start, angle_end ) do
		local a = math.rad( i )
		if angle_start < 0 then
			poly[#poly + 1] = { x = x + math.cos( a ) * radius, y = y + math.sin( a ) * radius }
		else
			poly[#poly + 1] = { x = x - math.cos( a ) * radius, y = y - math.sin( a ) * radius }
		end
	end
	poly[#poly + 1] = { x = x, y = y }

	draw.NoTexture()
	surface.SetDrawColor( color or color_white )
	surface.DrawPoly( poly )

	return poly
end