util.AddNetworkString("ProkectLib:Entity.Variables")
util.AddNetworkString("ProkectLib:Msg")
util.AddNetworkString("ProkectLib:InitPlayer")

net.Receive("ProkectLib:InitPlayer", function(_, pPlayer)
    hook.Run("ProkectLib:InitPlayer", pPlayer)
end)