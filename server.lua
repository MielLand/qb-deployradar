QBCore = exports['qb-core']:GetCoreObject()

local radars = {}
local requests = {}

QBCore.Commands.Add("deployradar", "Deploy a speed radar", false, false, function (source, args)
    for _, checkradar in ipairs(radars) do
        if checkradar.assignedPlayer == source then
            TriggerClientEvent("QBCore:Notify", source, "You already have a radar active!", "error")
            return
        end
    end
    if not isPlayerPolice(source) then
        TriggerClientEvent("QBCore:Notify", source, "You are not a police officer", "error")
        return
    end
    if #args < 1 then
        TriggerClientEvent("QBCore:Notify", source, "Please provide a speed limit.", "error")
        return
    end

    local player = GetPlayerPed(source)
    local playercoords = GetEntityCoords(player)

    getGroundZFromClient(playercoords.x, playercoords.y, playercoords.z, function (foundGround, groundZ)
        if not foundGround then
            TriggerClientEvent("QBCore:Notify", source, "Ground not found.", "error")
            return
        end

        local radar = {
            x = playercoords.x,
            y = playercoords.y,
            z = groundZ,
            heading = GetEntityHeading(player),
            assignedPlayer = source,
            speedlimit = tonumber(args[1]),
        }

        table.insert(radars, radar)
        TriggerClientEvent("QBCore:Notify", source, "Radar deployed successfully.", "success")
        TriggerClientEvent("MielRadar:DeployRadar", -1, radar)
    end)
end)

-- Citizen.CreateThread(function ()
--     while true do
--         Citizen.Wait(5000)
--         print("server radars: "..json.encode(radars))
--     end
-- end)

QBCore.Commands.Add("removeradar", "Remove a speed radar", false, false, function (source, args)
    if not isPlayerPolice(source) then
        TriggerClientEvent("QBCore:Notify", source, "You are not a police officer", "error")
        return
    end
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local closeRadarIndex = nil
    local closestDistance = 5.0

    for i, radar in ipairs(radars) do
        local radarCoords = vector3(radar.x, radar.y, radar.z)
        local distance = #(playerCoords - radarCoords)

        if distance < closestDistance then
            closeRadarIndex = i
            closestDistance = distance
        end
    end

    if closeRadarIndex then
        table.remove(radars, closeRadarIndex)
        TriggerClientEvent("MielRadar:RemoveRadar", -1, closeRadarIndex)
        TriggerClientEvent("QBCore:Notify", source, "Radar removed successfully.", "success")
    else
        TriggerClientEvent("QBCore:Notify", source, "No radar found nearby.", "error")
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    for index, radar in ipairs(radars) do
        if src == radar.assignedPlayer then
            table.remove(radars, index)
            TriggerClientEvent("MielRadar:RemoveRadar", -1, index)
            break
        end
    end
end)

RegisterNetEvent("MielRadar:NotifyOfficer")
AddEventHandler("MielRadar:NotifyOfficer", function (radar, speed)
    TriggerClientEvent("QBCore:Notify", radar.assignedPlayer, "Caught player going: "..math.floor(speed).." MPH past your speed radar", "success")
end)

function getGroundZFromClient(x, y, z, callback)
    local requestId = math.random(1, 100000)
    requests[requestId] = callback

    TriggerClientEvent("GetGroundZ:Request", -1, x, y, z, requestId)
end

RegisterNetEvent("GetGroundZ:Response")
AddEventHandler("GetGroundZ:Response", function(requestId, foundGround, groundZ)
    if requests[requestId] then
        requests[requestId](foundGround, groundZ)

        requests[requestId] = nil
    end
end)

function isPlayerPolice(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local jobName = Player.PlayerData.job.name
        if jobName == "police" then
            return true
        else
            return false
        end
    else
        print("player not found")
    end
end