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

local iDelay = 0
function ProkectLib:ErrorNotify(iTime, sMsg, vParent)
    if CurTime() < iDelay then return end	

    surface.SetFont(ProkectLib:Font(22, "Bold"))
    local iW, iH = surface.GetTextSize(sMsg)
    
    local vPanel = vgui.Create("DPanel", vParent)
    vPanel:SetSize(iW + ProkectLib.RespX(20), iH + ProkectLib.RespY(10))
    vPanel:SetPos(ScrW() / 2 - (iW + ProkectLib.RespX(20)) / 2 , -ProkectLib.RespY(30))
    vPanel:MoveTo(ScrW() / 2 - (iW + ProkectLib.RespX(20)) / 2, iH + ProkectLib.RespY(10), .5, 0, -1)
    vPanel.Paint = function(self, w, h)
        draw.RoundedBox(10, 0, 0, w, h, ProkectLib.Config.Color["Error"])
        draw.SimpleText(sMsg, ProkectLib:Font(22, "Bold"), w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    timer.Simple(iTime, function()
        vPanel:AlphaTo(0, .5, 0, function() vPanel:Remove() end)
    end)

    iDelay = CurTime() + iTime
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