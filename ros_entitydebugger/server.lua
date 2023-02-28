ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function doesPlayerHavePerms(player,perms)
    local allowed = false
    for k,v in ipairs(perms) do
            if IsPlayerAceAllowed(player, v) then
                    return true
            end
    end
    return false
end

RegisterNetEvent('ross:check')
AddEventHandler('ross:check', function()
        if doesPlayerHavePerms(source,Config.Allow) then
            TriggerClientEvent("permitido",source)
        end
end)