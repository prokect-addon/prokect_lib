//////////////////////////////////////////////////////////
// 	_____           _             _     _      _ _      //
// |  __ \         | |           | |   | |    (_) |    	//
// | |__) | __ ___ | | _____  ___| |_  | |     _| |__  	//
// |  ___/ '__/ _ \| |/ / _ \/ __| __| | |    | | '_ \ 	//
// | |   | | | (_) |   <  __/ (__| |_  | |____| | |_) |	//
// |_|   |_|  \___/|_|\_\___|\___|\__| |______|_|_.__/ 	//
//////////////////////////////////////////////////////////

ProkectLib = {}

ProkectLib.Version = "1.1.0"
ProkectLib.Author = "NyoN banane"
ProkectLib.Discord = "https://discord.gg/BH5GCjgWKx"
ProkectLib.GitHub = "https://github.com/prokect-addon"

MsgC(Color(0, 68, 255), "[ProkectLib]", color_white, " Loading...\n")
MsgC(Color(0, 68, 255), "[ProkectLib]", color_white, " Version: "..ProkectLib.Version .. "\n")
MsgC(Color(0, 68, 255), "[ProkectLib]", color_white, " Author: "..ProkectLib.Author.."\n")
MsgC(Color(0, 68, 255), "[ProkectLib]", color_white, " Discord: "..ProkectLib.Discord.."\n")
MsgC(Color(0, 68, 255), "[ProkectLib]", color_white, " GitHub: "..ProkectLib.GitHub.."\n")

if SERVER then
	resource.AddFile("resource/fonts/Montserrat-Light.ttf")
	resource.AddFile("resource/fonts/Montserrat-Medium.ttf")
	resource.AddFile("resource/fonts/Montserrat-Bold.ttf")
	resource.AddFile("resource/fonts/Font Awesome 6 Pro Solid.ttf")
	resource.AddFile("resource/fonts/Font Awesome 6 Pro Regular.ttf")
end

function ProkectLib.Loader(directory, client, server, config, vgui, lang, name)
	local function Inclu(f) return include(directory.."/"..f) end
	local function AddCS(f) return AddCSLuaFile(directory.."/"..f) end
	local function IncAdd(f) return Inclu(f), AddCS(f) end

	if config then
		for _, f in pairs(file.Find(directory.."/*.lua", "LUA")) do
			IncAdd(f)
		end
	end

	for _, f in pairs(file.Find(directory.."/shared/*.lua", "LUA")) do
		IncAdd("shared/"..f)
	end

	if lang then
		for _, f in pairs(file.Find(directory.."/lang/*.lua", "LUA")) do
			IncAdd("lang/"..f)
		end
	end

	if SERVER then

		if client then
			for _, f in pairs(file.Find(directory.."/client/*.lua", "LUA")) do
				AddCS("client/"..f)
			end
		end
		
		if server then
			for _, f in pairs(file.Find(directory.."/server/*.lua", "LUA")) do
				Inclu("server/"..f)
			end
		end

		if vgui then
			for _, f in pairs(file.Find(directory.."/vgui/*.lua", "LUA")) do
				AddCS("vgui/"..f)
			end
		end
	else
		if client then
			for _, f in pairs(file.Find(directory.."/client/*.lua", "LUA")) do
				Inclu("client/"..f)
			end
		end

		if vgui then
			for _, f in pairs(file.Find(directory.."/vgui/*.lua", "LUA")) do
				Inclu("vgui/"..f)
			end
		end
	end
end

ProkectLib.Loader("prokect_lib", true, true, true, true, false, "ProkectLib")

MsgC(Color(0, 68, 255), "[ProkectLib]", color_white, " Loaded!\n")