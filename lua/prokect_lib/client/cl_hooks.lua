hook.Add("OnScreenSizeChanged", "ProkectLib:OnScreenSizeChanged", function()
	ProkectLib.Fonts = {}
end)

hook.Add("InitPostEntity", "ProkectLib:InitPostEntity", function()
	net.Start("ProkectLib:InitPlayer")
	net.SendToServer()
end)