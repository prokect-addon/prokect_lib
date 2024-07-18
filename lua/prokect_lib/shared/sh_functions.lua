local cLog = {
    ["error"] = Color(255, 0, 0),
    ["info"] = Color(0, 255, 0),
    ["debug"] = Color(0, 0, 255),
    ["log"] = Color(0, 0, 0)
}

function ProkectLib.Log(sType, ...)
    if sType == "error" then
        MsgC(cLog["error"], "[Error] - ", ..., "\n")
    elseif sType == "info" then
        MsgC(cLog["info"], "[Info] - ", ..., "\n")
    elseif sType == "debug" then
        MsgC(cLog["debug"], "[Debug] - ", ..., "\n")
    else
        MsgC(cLog["log"], "[Log] - ", ..., "\n")
    end
end

function ProkectLib.GetPlayerByName(sName)
    for _, v in pairs(player.GetAll()) do
        if v:Nick() == sName then
            return v
        end
    end
end

/*
    Data
*/

function ProkectLib.VerifyData(sName, sDirectory)
    return file.Exists(string.format("prokect_lib/%s/%s.txt", sDirectory, sName), "DATA")
end

function ProkectLib.ReadData(sName, sDirectory)
    if not ProkectLib.VerifyData(sName, sDirectory) then return end

    util.JSONToTable(file.Read(string.format("prokect_lib/%s/%s.txt", sDirectory, sName), "DATA"))
end

function ProkectLib.WriteData(sName, sDirectory, sData)
    if not ProkectLib.VerifyData(sName, sDirectory) then return end
    file.Write(string.format("prokect_lib/%s/%s.txt", sDirectory, sName), util.TableToJSON(sData))
end

function ProkectLib.DeleteData(sName, sDirectory)
    if not ProkectLib.VerifyData(sName, sDirectory) then return end
    file.Delete(string.format("prokect_lib/%s/%s.txt", sDirectory, sName), "DATA")
end

function ProkectLib.CreateData(sName, sDirectory)
    if ProkectLib.VerifyData(sName, sDirectory) then return end
    file.CreateDir(string.format("prokect_lib/%s", sDirectory))
    file.Write(string.format("prokect_lib/%s/%s.txt", sDirectory, sName)) 
end

/*
    SQL
*/

function ProkectLib:Query(query, ...)
    local args = {...}
    for i, v in ipairs(args) do
        args[i] = sql.SQLStr(v)
    end

    local formattedQuery = query:format(unpack(args))

    local lastQuery = sql.Query(formattedQuery)
    if lastQuery == false and ProkectLib.Config.Debugging then
        ErrorNoHaltWithStack(sql.LastError())
        return false
    elseif formattedQuery == nil then 
        return true 
    end

    return lastQuery
end

function ProkectLib:QueryValue(query, ...)
    local lastQuery = ProkectLib:Query(query, ...)
    if not lastQuery then 
        ErrorNoHaltWithStack(sql.LastError())
        
        return false 
    end
    return lastQuery[1]
end

function ProkectLib:QueryRow(query, ...)
    local lastQuery = ProkectLib:Query(query, ...)
    if not lastQuery then return false end
    return lastQuery
end

/*
    Network
*/

local SizeTable = {
    {iByte = 1, iValue = 1},
    {iByte = 2, iValue = 3},
    {iByte = 3, iValue = 7},
    {iByte = 4, iValue = 15},
    {iByte = 5, iValue = 31},
    {iByte = 6, iValue = 63},
    {iByte = 7, iValue = 127},
    {iByte = 8, iValue = 255},
    {iByte = 9, iValue = 511},
    {iByte = 10, iValue = 1023},
    {iByte = 11, iValue = 2047},
    {iByte = 12, iValue = 4095},
    {iByte = 13, iValue = 8191},
    {iByte = 14, iValue = 16383},
    {iByte = 15, iValue = 32767},
    {iByte = 16, iValue = 65535},
    {iByte = 17, iValue = 131071},
    {iByte = 18, iValue = 262143},
    {iByte = 19, iValue = 524287},
    {iByte = 20, iValue = 1048575},
    {iByte = 21, iValue = 2097151},
    {iByte = 22, iValue = 4194303},
    {iByte = 23, iValue = 8388607},
    {iByte = 24, iValue = 16777215},
    {iByte = 25, iValue = 33554431},
    {iByte = 26, iValue = 67108863},
    {iByte = 27, iValue = 134217727},
    {iByte = 28, iValue = 268435455},
    {iByte = 29, iValue = 536870911},
    {iByte = 30, iValue = 1073741823},
    {iByte = 31, iValue = 2147483647},
    {iByte = 32, iValue = 4294967295}
}

function ProkectLib.SizeUInt(iValue)
    local Byte
    for k, v in ipairs(SizeTable) do
        if iValue <= v.iValue then
            Byte = v.iByte
            break
        end
    end

    return Byte or 32
end

/*
    UInt
*/

function ProkectLib.WriteUInt(iValue)
    local iSize = ProkectLib.SizeUInt(iValue)
    net.WriteUInt(iSize, 6)
    net.WriteUInt(iValue, iSize)
end

function ProkectLib.ReadUInt()
    local iSize = net.ReadUInt(6)
    local iValue = net.ReadUInt(iSize)

    return iValue
end

/*
    Entity
*/

function ProkectLib.WriteEntity(eEntity)
    if not IsValid(eEntity) then
        ProkectLib.WriteUInt(0)
    else
        ProkectLib.WriteUInt(eEntity:EntIndex())
    end 
end

function ProkectLib.ReadEntity()
    local iIndex = ProkectLib.ReadUInt()

    if iIndex == 0 then
        return ProkectLib.Log("error", "Invalid Entity")
    else
        return Entity(iIndex)
    end
end

/*
    Table
*/

function ProkectLib.WriteTable(tTable)
    local iCompress = util.Compress(util.TableToJSON(tTable))
    local iLength = #iCompress

    ProkectLib.WriteUInt(iLength)
    net.WriteData(iCompress, iLength)
end

function ProkectLib.ReadTable()
    local iLength = ProkectLib.ReadUInt()
    local iCompress = net.ReadData(iLength)
    local decompressedData = util.Decompress(iCompress)
    if decompressedData then
        return util.JSONToTable(decompressedData)
    else
        return nil
    end
end

/*
    Color
*/

function ProkectLib.WriteColor(cColor, bAlpha)
    if bAlpha == nil then bAlpha = true end

    assert(IsColor(cColor), "ProkectLib.WriteColor: Invalid Color expected Color got " .. type(cColor))

    local iR, iG, iB, iA = cColor.r, cColor.g, cColor.b, cColor.a

    ProkectLib.WriteUInt(iR)
    ProkectLib.WriteUInt(iG)
    ProkectLib.WriteUInt(iB)

    if bAlpha then
        ProkectLib.WriteUInt(iA)
    end
end

function ProkectLib.ReadColor(bAlpha)
    if bAlpha == nil then bAlpha = true end

    local iR, iG, iB = ProkectLib.ReadUInt(), ProkectLib.ReadUInt(), ProkectLib.ReadUInt()

    local iA = 255

    if bAlpha then
        iA = ProkectLib.ReadUInt()
    end

    return Color(iR, iG, iB, iA)
end

/*
    Network Start and Receiver
*/

ProkectLib.Receiver = {}
function ProkectLib.Start(sName, iId, fcCallback)
    net.Start(sName)
        ProkectLib.WriteUInt(iId)
    fcCallback()
end

function ProkectLib.Receive(sName, iId, fcCallback)
    ProkectLib.Receiver[sName:lower()] = ProkectLib.Receiver[sName:lower()] or {}
    ProkectLib.Receiver[sName:lower()][iId] = fcCallback

    net.Receive(sName, function(iLen, pPlayer)
        local iId = ProkectLib.ReadUInt()
        
        if not iId then return end

        if ProkectLib.Receiver[sName:lower()] then
            local fcFunction = ProkectLib.Receiver[sName:lower()][iId]
            if isfunction(fcFunction) then
                fcFunction(iLen, pPlayer)
            end
        end
    end)  
end

/*
    Hook
*/

function ProkectLib.Hook(sName, sIdentifier, fcCallback)
    if not isstring(sName) then ProkectLib.Log("error", "ProkectLib.Hook: Invalid sName expected string got " .. type(sName)) return end
    if not isfunction(fcCallback) then ProkectLib.Log("error", "ProkectLib.Hook: Invalid fcCallback expected function got " .. type(fcCallback)) return end

    hook.Add(sName, "ProkectLib:" .. sIdentifier, fcCallback)
end

function ProkectLib.UnHook(sName, sIdentifier)
    if not isstring(sName) then ProkectLib.Log("error", "ProkectLib.UnHook: Invalid sName expected string got " .. type(sName)) return end

    hook.Remove(sName, "ProkectLib:" .. sIdentifier)
end

/*
    Command 
*/

function ProkectLib.Command(sName, sArgs, fcCallback)
    if not isstring(sName) then ProkectLib.Log("error", "ProkectLib.Command: Invalid sName expected string got " .. type(sName)) return end
    if not isfunction(fcCallback) then ProkectLib.Log("error", "ProkectLib.Command: Invalid fcCallback expected function got " .. type(fcCallback)) return end

    local tArgs = string.Split(sArgs, " ")

    if string.sub(sName .. " ", 1, #sName) == sName then
        fcCallback(tArgs, sName)
    end
end

/*
    Table
*/

function ProkectLib.ConcatTable(tTable, sSeparator, sPrint)
    if not istable(tTable) then ProkectLib.Log("error", "ProkectLib.ConcatTable: Invalid tTable expected table got " .. type(tTable)) return end

    local sString = ""

    for k, v in pairs(tTable) do
        local categoryName = type(sPrint) == "string" and v[sPrint] or v["Name"]
        sString = sString .. sSeparator .. tostring(categoryName)
    end

    return string.sub(sString, #sSeparator + 1)
end

/*
    Near NPC
*/

function ProkectLib.NearNPC(pPlayer, sName)
    if not IsValid(pPlayer) or not pPlayer:IsPlayer() then return end
    if not isstring(sName) then ProkectLib.Log("error", "ProkectLib.NearNPC: Invalid sName expected string got " .. type(sName)) return end

    for k, v in pairs(ents.FindByClass(sName)) do
        if (v:GetPos():Distance(LocalPlayer():GetPos()) < 100) then
            return true
        end
    end
    return false
end