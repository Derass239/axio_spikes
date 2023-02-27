-------------------------------------------------
-------------- Axio Spikes by Derass ------------
------------- Discord : Derass#4974 -------------
--------- https://discord.gg/HPD35pasA5 ---------
-------------------------------------------------
lib.locale()

-- Variable
local spikeModel = joaat("p_ld_stinger_s")
local spikes = {}

if Config.framework == "ESX" then
    ESX = exports["es_extended"]:getSharedObject()

    ESX.RegisterUsableItem(Config.spikeItem, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(Config.spikeItem, 1)

        TriggerClientEvent('axio_spikes:client:addSpike', source)
    end)
elseif Config.framework == "QBCore" then
    QBCore = nil

    TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

    QBCore.Functions.CreateUseableItem(Config.spikeItem, function(source)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        xPlayer.Functions.RemoveItem(Config.spikeItem, 1)

        TriggerClientEvent('axio_spikes:client:addSpike', source)
    end)
end

RegisterNetEvent('axio_spikes:server:addSpike', function(position)
    local spike = CreateObjectNoOffset(spikeModel, position.x, position.y, position.z, true, true, false)
    SetEntityHeading(spike, position.w)
    FreezeEntityPosition(spike, true)

    spikes[NetworkGetNetworkIdFromEntity(spike)] = position

    TriggerClientEvent('axio_spikes:client:syncSpikes', -1, spikes)
end)

RegisterNetEvent('axio_spikes:server:removeSpike', function(netId, toRemove)
    if spikes[netId] then
        DeleteEntity(NetworkGetEntityFromNetworkId(netId))
        spikes[netId] = nil

        TriggerClientEvent('axio_spikes:client:syncSpikes', -1, spikes)

        if toRemove then
            local rand = math.random(1, 100)
            if rand > Config.percentToBroke then

                if Config.framework == "ESX" then
                    local xPlayer = ESX.GetPlayerFromId(source)
                    xPlayer.addInventoryItem(Config.spikeItem, 1)
                elseif Config.framework == "QBCore" then
                    local xPlayer = QBCore.Functions.GetPlayer(source)
                    xPlayer.Functions.AddItem(Config.spikeItem, 1)
                end

                -- Give back spike
                TriggerClientEvent('ox_lib:notif', source, { type = 'inform', description = locale('spikeGiveBack')})
            else
                TriggerClientEvent('ox_lib:notif', source, { type = 'error', description = locale('spikeBroke')})
            end
        end
    end
end)

--[[ Version Checker ]]
CreateThread(function()
    PerformHttpRequest("https://raw.githubusercontent.com/Derass239/axiome_script_info/master/script_version/axio_spikes.json", function(err, text, headers)
        if text then
            local data = json.decode(text)
            local version = GetResourceMetadata(GetCurrentResourceName(), "version", 0) or "2.0.0"

            if (not string.find(version, data.lastest)) then
                print(("^3[WARNING] ^7You are currently an outdated version ^2%s^7, please update to last version ^2%s"):format(version, data.lastest))
                print("^7News :")
                for _, v in pairs(data.patchnotes) do
                    print(("^7    - %s"):format(v))
                end
            end
        end
    end)
end)
