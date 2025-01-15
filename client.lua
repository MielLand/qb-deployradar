local radars = {}

local cameraModel = GetHashKey(Config.Object)
local clockradius = Config.ClockRadius
RegisterNetEvent("MielRadar:DeployRadar")
AddEventHandler("MielRadar:DeployRadar", function (radar)
    RequestModel(cameraModel)
    while not HasModelLoaded(cameraModel) do
        Wait(0)
    end
    radar.object = CreateObject(cameraModel, radar.x, radar.y, radar.z, false, true, false)
    SetEntityHeading(radar.object, GetEntityHeading(radar.heading))
    table.insert(radars, radar)
    SetModelAsNoLongerNeeded(cameraModel)
end)

-- Citizen.CreateThread(function ()
--     while true do
--         Citizen.Wait(5000)
--         print("client radars: "..json.encode(radars))
--     end
-- end)

function isWithinBoundary(coords, center, radius)
    local distance = #(coords - center)
    return distance <= radius
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1500)
        if #radars ~= 0 then
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                local vehicle = GetVehiclePedIsIn(ped, false)
    
                local coords = GetEntityCoords(ped)
    
                for index, radar in ipairs(radars) do
                    if isWithinBoundary(coords, vector3(radar.x, radar.y, radar.z), clockradius) then
                        local speed = GetEntitySpeed(vehicle)
                        local speedMPH = speed * 2.23694
                        if speedMPH >= radar.speedlimit then
                            TriggerServerEvent("MielRadar:NotifyOfficer", radar, speedMPH)
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("MielRadar:RemoveRadar")
AddEventHandler("MielRadar:RemoveRadar", function (radarindex)
    local radarobject = radars[radarindex].object
    if DoesEntityExist(radarobject) then
        DeleteObject(radarobject)
    end
    table.remove(radars, radarindex)
end)

RegisterNetEvent("GetGroundZ:Request")
AddEventHandler("GetGroundZ:Request", function(x, y, z, requestId)
    local foundGround, groundZ = GetGroundZFor_3dCoord(x, y, z, false)
    TriggerServerEvent("GetGroundZ:Response", requestId, foundGround, groundZ)
end)
