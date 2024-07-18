function ProkectLib:Imgur(sId, fDirectory)
    fDirectory = fDirectory or "base"

    if file.Exists("prokect_lib/" .. fDirectory .. "/" .. sId, "DATA") then 
        return Material("../data/prokect_lib/" .. fDirectory .. "/" .. sId)
    end
    http.Fetch("https://i.imgur.com/" .. sId, function(body, length, headers, code)
            if not file.IsDir("prokect_lib/" .. fDirectory .. "/","DATA") then 
                file.CreateDir("prokect_lib/" .. fDirectory .. "/") 
            end

            file.Write("prokect_lib/" .. fDirectory.. "/" .. sId, body)
        end,

        function(error)
            print(error)
        end
    )

	timer.Simple(0,function()
		if file.Exists("prokect_lib/" .. fDirectory .. "/" .. sId, "DATA") then 
			return Material("../data/prokect_lib/" .. fDirectory .. "/" .. sId)
		else 
			return Material(".png")
		end
	end)

	return Material(".png")
end