local PANEL = {}

function PANEL:Init()

    self:SetTextColor( color_white )
    self:SetCursorColor( Color(104,104,104) )
    self:SetHighlightColor( Color(18,64,133)  )
    self:SetDrawLanguageID( false )
    self:SetPaintBackground( false )
    self.color = Color(25,25,25)
    self.text = self:GetPlaceholderText()
end

function PANEL:SetVGColor(color)
    self.color = color 
end

function PANEL:SetAutoSize( b )
    self.wantautosize = b
end

function PANEL:OnTextChanged()
    if self.wantautosize then
        self:SetSize(surface.GetTextSize(self:GetText()) + 10, self:GetTall() )
    end
end

function PANEL:OnGetFocus()
    self:SetTextColor(color_white)
end

function PANEL:OnLoseFocus()
    self:SetTextColor(Color(156,156,156))
end

function PANEL:IsPlaceholderVisible()
    if not self:HasFocus() and ( self:GetText() == "" ) and self.m_txtPlaceholder then
        return true
    end
end

function PANEL:Paint( w, h )
    
    draw.RoundedBox(3, 0, 0, w, h, self.color )
    self:DrawTextEntryText( self.m_colText, self.m_colHighlight, self.m_colCursor )
    draw.SimpleText( self:HasFocus() and "" or self:GetText() == "" and self.m_txtPlaceholder or "", ProkectLib:Font(15), 5, h/2, Color( 255, 255, 255, 100 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    
end

vgui.Register("PTextEntry", PANEL, "DTextEntry")