function ProkectLib:ConfigDataInit()
    if not file.Exists("prokect_lib/config.json", "DATA") then
        file.CreateDir("prokect_lib")
        file.Write("prokect_lib/config.json", util.TableToJSON(ProkectLib.Config))
        MsgC(Color(0, 68, 255), "[ProkectLib] ", Color(255, 255, 255), "Create config file\n")
    end
end

function ProkectLib:ReadDataConfig()
    if file.Exists("prokect_lib/config.json", "DATA") then
        ProkectLib.Config = util.JSONToTable(file.Read("prokect_lib/config.json", "DATA"))
    end
end

function ProkectLib.Msg(pPlayer, ...)
    local sMsg = {...}

    ProkectLib.Start("ProkectLib:Msg", 1, function()
            ProkectLib.WriteTable(sMsg)
        net.Send(pPlayer)
    end)
end
