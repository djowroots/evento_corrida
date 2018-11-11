--começo

function LocalPed()
	return GetPlayerPed(-1)
end
 
--blips
local blips = {
    {title="~b~Evento~w~: CORRIDA", colour=5, id=315, x= 3103.01, y= -4826.48, z= 111.81}
}


local IsRacing = false 
local cP = 1
local cP2 = 2
local checkpoint
local blip
local startTime


local CheckPoints = {}
CheckPoints[1] =  	{ x = 3193.48, y = -4833.70, z = 111.10, type = 5}
CheckPoints[2] =	{ x = 3220.04, y = -4723.66, z = 111.59, type = 5}
CheckPoints[3] =	{ x = 3259.36, y = -4683.49, z = 112.09, type = 5}
CheckPoints[4] =	{ x = 3213.41, y = -4788.37, z = 111.09, type = 5}
CheckPoints[5] =	{ x = 3273.93, y = -4842.86, z = 111.08, type = 5}
CheckPoints[6] =	{ x = 3448.06, y = -4860.14, z = 111.06, type = 5}
CheckPoints[7] =	{ x = 3512.24, y = -4863.06, z = 110.98, type = 5}
CheckPoints[8] =	{ x = 3536.23, y = -4734.19, z = 111.84, type = 5}
CheckPoints[9] =	{ x = 3535.28, y = -4676.86, z = 113.47, type = 5}
CheckPoints[10] =  	{ x = 3493.69, y = -4660.35, z = 114.08, type = 5}
CheckPoints[11] =  	{ x = 3296.20, y = -4614.22, z = 115.23, type = 5}
CheckPoints[12] =  	{ x = 3241.98, y = -4617.21, z = 115.14, type = 5}
CheckPoints[13] =	{ x = 3236.97, y = -4655.57, z = 113.90, type = 5}
CheckPoints[14] =  	{ x = 3243.55, y = -4682.48, z = 112.04, type = 5}
CheckPoints[15] =  	{ x = 3210.94, y = -4817.35, z = 111.09, type = 9}
--CheckPoints[16] =  	{ x = 3224.37, y = -4699.35, z = 112.09, type = 0} -- Teste de lastcheckpoint

Citizen.CreateThread(function()
    preRace()
end)

function preRace()
    while not IsRacing do
        Citizen.Wait(0)
            DrawMarker(1, 3103.01, -4826.48, 111.81 - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0)
        if GetDistanceBetweenCoords( 3103.01, -4826.48, 111.81, GetEntityCoords(LocalPed())) < 50.0 then
            	Draw3DText( 3103.01, -4826.48, 111.81  +.500, "Yankton",7,0.3,0.2)
            	Draw3DText( 3103.01, -4826.48, 111.81  +.100, "Corrida",7,0.3,0.2)
        end
        if GetDistanceBetweenCoords( 3222.01, -4697.48, 112.81, GetEntityCoords(LocalPed())) < 50.0 then
            Draw3DText( 3224.43, -4699.7, 114.62, "~r~CHEGADA",7,0.3,0.3)
            DrawMarker(5, 3224.43, -4699.7, 114.62 - 1, 0, 0, 0, 0, 0, 0, 5.0000, 5.0000, 5.0000, 255, 0, 0,165, 0, 0, 0,0)
    end
        if GetDistanceBetweenCoords( 3103.01, -4826.48, 111.81, GetEntityCoords(LocalPed())) < 2.0 then
            TriggerEvent("fs_freemode:displayHelp", "~INPUT_CONTEXT~ para Correr!")
            if (IsControlJustReleased(1, 38)) then
                if IsRacing == false then
                    IsRacing = true
                    TriggerEvent("cRace:TPAll")
                else
                    return
                end
            end
        end
    end
end

RegisterNetEvent("cRace:TPAll")
AddEventHandler("cRace:TPAll", function()
    SetPedCoordsKeepVehicle(PlayerPedId(), 3103.01, -4826.48, 111.81)
    SetEntityHeading(PlayerPedId(), 265.0)
    Citizen.CreateThread(function()
        local time = 0
        function setcountdown(x)
          time = GetGameTimer() + x*1000
        end
        function getcountdown()
          return math.floor((time-GetGameTimer())/1000)
        end
        setcountdown(6)
        while getcountdown() > 0 do
            Citizen.Wait(1)
            
            --drawhud

            DrawHudText(getcountdown(), {255,191,0,255},0.5,0.4,4.0,4.0)
        end
            TriggerEvent("fs_race:BeginRace")
    end)
end)

RegisterNetEvent("fs_race:BeginRace") 
AddEventHandler("fs_race:BeginRace", function()
    startTime = GetGameTimer()
    Citizen.CreateThread(function()
        checkpoint = CreateCheckpoint(CheckPoints[cP].type, CheckPoints[cP].x,  CheckPoints[cP].y,  CheckPoints[cP].z + 2, CheckPoints[cP2].x, CheckPoints[cP2].y, CheckPoints[cP2].z, 8.0, 204, 204, 1, 100, 0)
        blip = AddBlipForCoord(CheckPoints[cP].x, CheckPoints[cP].y, CheckPoints[cP].z)          
        while IsRacing do 
            Citizen.Wait(5)
            SetVehicleDensityMultiplierThisFrame(0.0)
            SetPedDensityMultiplierThisFrame(0.0)
            SetRandomVehicleDensityMultiplierThisFrame(0.0)
            SetParkedVehicleDensityMultiplierThisFrame(0.0)
            SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)

            DrawHudText(math.floor(GetDistanceBetweenCoords(CheckPoints[cP].x,  CheckPoints[cP].y,  CheckPoints[cP].z, GetEntityCoords(GetPlayerPed(-1)))) .. " meters", {249, 249, 249,255},0.0,0.75,1.0,1.0)
            DrawHudText(string.format("%i / %i", cP, tablelength(CheckPoints)), {249, 249, 249, 255},0.7,0.0,1.5,1.5)
            DrawHudText(formatTimer(startTime, GetGameTimer()), {249, 249, 249,255},0.0,0.0,1.5,1.5)
                if GetDistanceBetweenCoords(CheckPoints[cP].x,  CheckPoints[cP].y,  CheckPoints[cP].z, GetEntityCoords(GetPlayerPed(-1))) < 10.0 then
                    if CheckPoints[cP].type == 5 then
                        DeleteCheckpoint(checkpoint)
                        RemoveBlip(blip)
                        PlaySoundFrontend(-1, "RACE_PLACED", "HUD_AWARDS")
                        cP = math.ceil(cP+1)
                        cP2 = math.ceil(cP2+1)
                        checkpoint = CreateCheckpoint(CheckPoints[cP].type, CheckPoints[cP].x,  CheckPoints[cP].y,  CheckPoints[cP].z + 2, CheckPoints[cP2].x, CheckPoints[cP2].y, CheckPoints[cP2].z, 8.0, 204, 204, 1, 100, 0)
                        blip = AddBlipForCoord(CheckPoints[cP].x, CheckPoints[cP].y, CheckPoints[cP].z)
                    else
                        PlaySoundFrontend(-1, "ScreenFlash", "WastedSounds")
                        DeleteCheckpoint(checkpoint)
                        RemoveBlip(blip)
                        IsRacing = false
                        cP = 1
                        cP2 = 2
                        TriggerEvent("chatMessage", "Server", {0,0,0}, string.format("Terminou com um tempo de " .. formatTimer(startTime, GetGameTimer())))
                        preRace()
                    end
                    else
                end
            end
        end)
end)


function tablelength(T)
    local count = 0
    for _ in pairs(T) do 
    count = count + 1 end
    return count
end

function formatTimer(startTime, currTime)
    local newString = currTime - startTime
        local ms = string.sub(newString, -3, -2)
        local sec = string.sub(newString, -5, -4)
        local min = string.sub(newString, -7, -6)
        newString = string.format("%s%s.%s", min, sec, ms)
    return newString
end

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
         local px,py,pz=table.unpack(GetGameplayCamCoords())
         local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    
         local scale = (1/dist)*20
         local fov = (1/GetGameplayCamFov())*100
         local scale = scale*fov
    
         SetTextScale(scaleX*scale, scaleY*scale)
         SetTextFont(fontId)
         SetTextProportional(1)
         SetTextColour(255, 255, 255, 250)
         SetTextDropshadow(1, 1, 1, 1, 255)
         SetTextEdge(2, 0, 0, 0, 150)
         SetTextDropShadow()
         SetTextOutline()
         SetTextEntry("STRING")
         SetTextCentre(1)
         AddTextComponentString(textInput)
         SetDrawOrigin(x,y,z+2, 0)
         DrawText(0.0, 0.0)
         ClearDrawOrigin()
        end

function DrawHudText(text,colour,coordsx,coordsy,scalex,scaley) --courtesy of driftcounter
    SetTextFont(7)
    SetTextProportional(7)
    SetTextScale(scalex, scaley)
    local colourr,colourg,colourb,coloura = table.unpack(colour)
    SetTextColour(colourr,colourg,colourb, coloura)
    SetTextDropshadow(0, 0, 0, 0, coloura)
    SetTextEdge(1, 0, 0, 0, coloura)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(coordsx,coordsy)
end

Citizen.CreateThread(function()
    for _, info in pairs(blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 1.0)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
    end
end)
