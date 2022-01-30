local QBCore = exports['qbr-core']:GetCoreObject()

-- pump prompt
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local pos, awayFromObject = GetEntityCoords(PlayerPedId()), true
		local pumpObject = GetClosestObjectOfType(pos, 5.0, GetHashKey("p_waterpump01x"), false, false, false)
		if pumpObject ~= 0 then
			local objectPos = GetEntityCoords(pumpObject)
			if #(pos - objectPos) < 3.0 then
				awayFromObject = false
				DrawText3Ds(objectPos.x, objectPos.y, objectPos.z + 1.0, "~g~J~w~ - USE")
				if IsControlJustReleased(0, 0xF3830D8E) then -- [J]
					TriggerEvent('rsg_waterpump:client:drinking')
				end
			end
		end
		if awayFromObject then
			Citizen.Wait(1000)
		end
	end
end)

-- well pump prompt
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local pos, awayFromObject = GetEntityCoords(PlayerPedId()), true
		local wellpumpObject = GetClosestObjectOfType(pos, 5.0, GetHashKey("p_wellpumpnbx01x"), false, false, false)
		if wellpumpObject ~= 0 then
			local objectPos = GetEntityCoords(wellpumpObject)
			if #(pos - objectPos) < 3.0 then
				awayFromObject = false
				DrawText3Ds(objectPos.x, objectPos.y, objectPos.z + 1.0, "~g~J~w~ - USE")
				if IsControlJustReleased(0, 0xF3830D8E) then -- [J]
					TriggerEvent('rsg_waterpump:client:drinking')
				end
			end
		end
		if awayFromObject then
			Citizen.Wait(1000)
		end
	end
end)

-- thirst adjust
RegisterNetEvent('rsg_waterpump:client:drinking')
AddEventHandler('rsg_waterpump:client:drinking', function()
	QBCore.Functions.Progressbar("drink-pump", "Drinking..", 5000, false, true, {
		disableMovement = false,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		ClearPedTasksImmediately(PlayerPedId())
		QBCore.Functions.Notify("ahhh fresh", "success")
		TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + 100) -- adjust as required
	end, function()
		QBCore.Functions.Notify("Cancelled", "error")
	end)
end)

function DrawText3Ds(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)

    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end