-------------------------------------------------
-------------- Axio Spikes by Derass ------------
------------- Discord : Derass#4974 -------------
--------- https://discord.gg/HPD35pasA5 ---------
-------------------------------------------------
lib.locale()

-- Export
local ox_target = exports.ox_target

-- Script optimisation
local Wait = Wait
local GetEntityCoords = GetEntityCoords

-- Variable
local spikeModel = joaat('p_ld_stinger_s')
local spawnedSpikes, closestSpike = {}, nil

CreateThread(function()
    ox_target:addModel(spikeModel, {
        {
            label = locale('disassemble'),
            icon = "fas fa-hand-lizard",
            event = "axio_spikes:client:removeSpike",
            distance = 2.5,
            groups = Config.allowRemoveSpike,
        }
    })
end)

--[[ Command admin ]]
RegisterCommand('addSpike', function()
    TriggerEvent('axio_spikes:client:addSpike')
end, true)

local function GetProperGroundCoord(obj, position, heading, offset)
    local object = CreateObject(obj, position.x, position.y, position.z, false)
    SetEntityVisible(object, false)
    SetEntityHeading(object, heading)
    PlaceObjectOnGroundProperly(object)

    position = GetEntityCoords(object)
    DeleteObject(object)

    return vector4(position.x, position.y, position.z + (offset or 0.0), heading)
end

--[[ Event ]]
RegisterNetEvent('axio_spikes:client:addSpike', function()
    local ped = cache.ped
    local spikeCoords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 3.0, 0.0)
    local spikeHeading = GetEntityHeading(ped)

    if lib.progressBar({
        duration = Config.timeToLaunch,
        label = locale('spikeLaunch'),
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false
        },
        anim = {
            dict = "anim@narcotics@trash",
            clip = "drop_front",
            flag = 16
        }
    }) then
        TriggerServerEvent('axio_spikes:server:addSpike', GetProperGroundCoord(spikeModel, spikeCoords, spikeHeading))
    end
end)

RegisterNetEvent('axio_spikes:client:removeSpike', function(data)
    if lib.progressBar({
        duration = Config.timeToDisassemble,
        label = locale('spikeGrab'),
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false
        },
        anim = {
            dict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
            clip = "plant_floor",
            flag = 16
        }
    }) then
        TriggerServerEvent('axio_spikes:server:removeSpike', ObjToNet(data.entity), true)
    end
end)

RegisterNetEvent('axio_spikes:client:syncSpikes', function(spikes)
    spawnedSpikes = spikes
end)

--[[ Thread ]]
lib.onCache('seat', function(seat)
    while seat ~= false do
        local pos = GetEntityCoords(cache.ped, true)
        local current, dist

        for spikeID, spike in pairs(spawnedSpikes) do
            if current == nil then
                dist = #(pos - vector3(spike.x, spike.y, spike.z))
                current = spikeID
            elseif current then
                if #(pos - vector3(spike.x, spike.y, spike.z)) < dist then
                    current = spikeID
                end
            end
            closestSpike = current
        end

        Wait(500)
    end
end)

lib.onCache('seat', function(seat)
    while seat ~= false do
        local ped = cache.ped
        local coords = GetEntityCoords(ped)
        local vehicle = cache.vehicle

        if closestSpike and spawnedSpikes[closestSpike] then
           local spikePos = vector3(spawnedSpikes[closestSpike].x, spawnedSpikes[closestSpike].y, spawnedSpikes[closestSpike].z)

            if #(spikePos - coords) <= 10 then
                local tires = {
                    {bone = "wheel_lf", index = 0},
                    {bone = "wheel_rf", index = 1},
                    {bone = "wheel_lm", index = 2},
                    {bone = "wheel_rm", index = 3},
                    {bone = "wheel_lr", index = 4},
                    {bone = "wheel_rr", index = 5},
                }

                for a = 1, #tires do
                    local tirePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tires[a].bone))

                    if #(tirePos - spikePos) < 1.8 then
                        if not IsVehicleTyreBurst(vehicle, tires[a].index, true) or IsVehicleTyreBurst(vehicle, tires[a].index, false) then
                            SetVehicleTyreBurst(vehicle, tires[a].index, false, 1000.0)

                            if Config.removeSpikeAfterBurst then
                                TriggerServerEvent("axio_spikes:server:removeSpike", closestSpike, false)
                            end
                        end
                    end
                end
            end
        end

        Wait(5)
    end
end)