local enabled = false
local On = false
local _on = false
local yes = false
local admin = false

Citizen.CreateThread(function()
    while true do 
        TriggerServerEvent("ross:check")
        Citizen.Wait(100)
    end
end)

RegisterNetEvent("permitido")
AddEventHandler("permitido", function()
    admin = true
end)

function getPlayers()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        table.insert(players, {id = GetPlayerServerId(player), name = GetPlayerName(player)})
    end
    return players
end

function DrawText4D(coords, text, size)
	local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
	local camCoords      = GetGameplayCamCoords()
	local dist           = GetDistanceBetweenCoords(camCoords, coords.x, coords.y, coords.z, true)
	local size           = size

	if size == nil then
		size = 1
	end

	local scale = (size / dist) * 2
	local fov   = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov

	if onScreen then
		SetTextScale(0.0 * scale, 0.55 * scale)
		SetTextFont(0)
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry('STRING')
		SetTextCentre(1)

		AddTextComponentString(text)
		DrawText(x, y)
	end
end

function DrawText3D(x, y, z, M, al, ag, ab)
    SetDrawOrigin(x, y, z, 0)
    SetTextFont(2)
    SetTextProportional(0)
    SetTextScale(0.0, 0.35)
    SetTextColour(al, ag, ab, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(M)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

local activatecrosshair = true

function ManipulationLogic(cam, x, y, z)
	local type = "null"
	local r,g,b = 0,255,0
	local rightVec, forwardVec, upVec = GetCamMatrix(cam)
	local curVec = vector3(x, y, z)
	local targetVec = curVec + forwardVec * 150
	local handle = StartShapeTestRay(curVec.x, curVec.y, curVec.z, targetVec.x, targetVec.y, targetVec.z, -1)
	local _, hit, endCoords, _, entity = GetShapeTestResult(handle)
	if DoesEntityExist(entity) then
		print("okok")
	end
	print(entity)
	if IsEntityAnObject(entity) then
		entity = entity
		type = "Obect"
	elseif IsEntityAVehicle(entity) then
		entity = entity
		r,g,b = 255,0,0
		type = "vehicle"
	elseif IsEntityAPed(entity) then
		entity = entity
		r,g,b = 0,255,255
		type = "ped"
	else 
		entity = nill
	end
	local entcords = GetEntityCoords(entity)
	local model = GetEntityModel(entity)
	HoveredEntity = entity
	DrawBoundingBox(HoveredEntity,r,g,b,40)
	DrawText4D(entcords,"Tipo: "..type.."\nCoords: "..entcords.."\nModel: "..model,2.0)

	if IsControlPressed(0,25) then
		SetEntityAsMissionEntity(entity, true, true)
        DeleteEntity(entity)
	end

end

function DrawBoundingBox(entity, r, g, b, a)
	if entity then
		r = r or 255
		g = g or 0
		b = b or 0
		a = a or 40
		local model = GetEntityModel(entity)
		local min, max = GetModelDimensions(model)
		local top_front_right = GetOffsetFromEntityInWorldCoords(entity, max)
		local top_back_right = GetOffsetFromEntityInWorldCoords(entity, vector3(max.x, min.y, max.z))
		local bottom_front_right = GetOffsetFromEntityInWorldCoords(entity, vector3(max.x, max.y, min.z))
		local bottom_back_right = GetOffsetFromEntityInWorldCoords(entity, vector3(max.x, min.y, min.z))
		local top_front_left = GetOffsetFromEntityInWorldCoords(entity, vector3(min.x, max.y, max.z))
		local top_back_left = GetOffsetFromEntityInWorldCoords(entity, vector3(min.x, min.y, max.z))
		local bottom_front_left = GetOffsetFromEntityInWorldCoords(entity, vector3(min.x, max.y, min.z))
		local bottom_back_left = GetOffsetFromEntityInWorldCoords(entity, min)
		-- LINES
		-- RIGHT SIDE
		DrawLine(top_front_right, top_back_right, r, g, b, a)
		DrawLine(top_front_right, bottom_front_right, r, g, b, a)
		DrawLine(bottom_front_right, bottom_back_right, r, g, b, a)
		DrawLine(top_back_right, bottom_back_right, r, g, b, a)
		-- LEFT SIDE
		DrawLine(top_front_left, top_back_left, r, g, b, a)
		DrawLine(top_back_left, bottom_back_left, r, g, b, a)
		DrawLine(top_front_left, bottom_front_left, r, g, b, a)
		DrawLine(bottom_front_left, bottom_back_left, r, g, b, a)
		-- Connection
		DrawLine(top_front_right, top_front_left, r, g, b, a)
		DrawLine(top_back_right, top_back_left, r, g, b, a)
		DrawLine(bottom_front_left, bottom_front_right, r, g, b, a)
		DrawLine(bottom_back_left, bottom_back_right, r, g, b, a)
		-- POLYGONS
		-- FRONT
		DrawPoly(top_front_left, top_front_right, bottom_front_right, r, g, b, a)
		DrawPoly(bottom_front_right, bottom_front_left, top_front_left, r, g, b, a)
		-- TOP
		DrawPoly(top_front_right, top_front_left, top_back_right, r, g, b, a)
		DrawPoly(top_front_left, top_back_left, top_back_right, r, g, b, a)
		-- BACK
		DrawPoly(top_back_right, top_back_left, bottom_back_right, r, g, b, a)
		DrawPoly(top_back_left, bottom_back_left, bottom_back_right, r, g, b, a)
		-- LEFT
		DrawPoly(top_back_left, top_front_left, bottom_front_left, r, g, b, a)
		DrawPoly(bottom_front_left, bottom_back_left, top_back_left, r, g, b, a)
		-- RIGHT
		DrawPoly(top_front_right, top_back_right, bottom_front_right, r, g, b, a)
		DrawPoly(top_back_right, bottom_back_right, bottom_front_right, r, g, b, a)
		-- BOTTOM
		DrawPoly(bottom_front_left, bottom_front_right, bottom_back_right, r, g, b, a)
		DrawPoly(bottom_back_right, bottom_back_left, bottom_front_left, r, g, b, a)
		return true
	end

	return false
end

function Crosshair(on)
	if on then
		DrawRect(0.5, 0.5, 0.008333333, 0.001851852, 100, 100, 100, 255)
		DrawRect(0.5, 0.5, 0.001041666, 0.014814814, 100, 100, 100, 255)
	else
		DrawRect(0.5, 0.5, 0.008333333, 0.001851852, 100, 100, 100, 255)
		DrawRect(0.5, 0.5, 0.001041666, 0.014814814, 100, 100, 100, 255)
	end
end

function MoveCamera(cam, x, y, z)
	local curVec = vector3(x, y, z)
	local rightVec, forwardVec, upVec = GetCamMatrix(cam)
	local speed = 1.0

	if IsControlPressed(0, 32) then
		curVec = curVec + forwardVec * speed
	end

	if IsControlPressed(0, 33) then
		curVec = curVec - forwardVec * speed
	end

	if IsControlPressed(0, 34) then
		curVec = curVec - rightVec * speed
	end

	if IsControlPressed(0, 35) then
		curVec = curVec + rightVec * speed
	end

	if IsControlPressed(0, 55) then
		curVec = curVec + upVec * speed
	end

	if IsControlPressed(0, 73) then
		curVec = curVec - upVec * speed
	end

	return curVec.x, curVec.y, curVec.z
end



function Tick()
	if not DoesCamExist(Cam) then
		Cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	end

	while enabled do
		local rot_vec = GetGameplayCamRot(0)
		Wait(0)

		if On and not _on then
			SetCamActive(Cam, true)
			RenderScriptCams(true, false, false, true, true)
			_on = true
			local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.0) + (GetEntityForwardVector(PlayerPedId()) * 2)
			camX, camY, camZ = coords.x, coords.y, coords.z + 1.0
			ClearPedTasks(PlayerPedId())
		elseif not On and _on then
			FreezeEntityPosition(PlayerPedId(), false)
			SetCamActive(Cam, false)
			RenderScriptCams(false, false, false, false, false)
			SetFocusEntity(PlayerPedId())
			_on = false
		end

		if On and _on then
			if not IsPedInAnyVehicle(PlayerPedId()) then
				FreezeEntityPosition(PlayerPedId(), true)
			end
			Crosshair(activatecrosshair)
			SetFocusPosAndVel(camX, camY, camZ, 0, 0, 0)
			SetCamCoord(Cam, camX, camY, camZ)
			SetCamRot(Cam, rot_vec.x + 0.0, rot_vec.y + 0.0, rot_vec.z + 0.0)
			camX, camY, camZ = MoveCamera(Cam, camX, camY, camZ)
			ManipulationLogic(Cam, camX, camY, camZ)
		end
	end
end

RegisterCommand('encender', function() 
    if admin then
	    enabled = true
	    On = true
	    yes = true
        ESX.ShowNotification("Entity debugger encendido")
	    Tick()
    else
        ESX.ShowNotification("No tienes los permisos necesarios")
    end
end, false)

RegisterCommand('apagar', function() 
	enabled = false
	On = false
	yes = false
end, false)