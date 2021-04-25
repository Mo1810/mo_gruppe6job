--[[--------------------------]]--
--[[  Created by Mo1810#4230  ]]--
--[[--------------------------]]--

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) 
	ESX = obj 
	while ESX == nil do
		Citizen.Wait(1)
	end
end)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --  VARIABLES  -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local onShift, stockadeVehicle, moneyCase, targetNumber, onCooldown, doorCoords, moneyCourier, vehicleGuardOne, vehicleGuardTwo, DepositoryBlip, TargetBlip, moneyCourierBlip, wasRobbed, currentMoneyInCase, hideText = false, nil, nil, 0, false, vector3(0,0,0), nil, nil, nil, nil, false, 0, false


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --   COMMAND   -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

RegisterCommand('cancelShift', function()
	TriggerEvent('transportOfValuables:cancelShift')
end)


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- HEIST -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

Citizen.CreateThread(function()
	while true do
		while stockadeVehicle ~= nil and GetEntitySpeed(stockadeVehicle) < 0.05 and not onCooldown do
			while GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetWorldPositionOfEntityBone(stockadeVehicle, GetEntityBoneIndexByName(stockadeVehicle, Config.vehicleBone)), true) < 1.5 and not onCooldown do
				doorCoords = GetWorldPositionOfEntityBone(stockadeVehicle, GetEntityBoneIndexByName(stockadeVehicle, Config.vehicleBone))
				Draw3DText(doorCoords.x, doorCoords.y, doorCoords.z, 1.5, '~r~[E] ~s~| '.._U('heistTruck_text'))
				if IsControlJustReleased(0, Config.trigger_key) then
					startHeist()
				end
				Citizen.Wait(4)
			end
			Citizen.Wait(2000)
		end
		Citizen.Wait(5000)
	end
end)

function startHeist()
	local continue = nil
	
	ESX.TriggerServerCallback('transportOfValuables:getOnlinePoliceCount', function(enoughCops)
		if enoughCops then
			ESX.TriggerServerCallback('transportOfValuables:removeThermiteCharge', function(hasRemoved)
				if hasRemoved then
					FreezeEntityPosition(stockadeVehicle, true)
					onCooldown = true
					Citizen.Wait(3000)
					TriggerServerEvent('transportOfValuables:callPolice', stockadeVehicle)
					ESX.Streaming.RequestNamedPtfxAsset('des_train_crash')
					
					while not HasNamedPtfxAssetLoaded('des_train_crash') do
						Citizen.Wait(10)
					end
					
					for timeExpired = 1, 9 * Config.WaitTime, 1 do
						UseParticleFxAssetNextCall('des_train_crash')
						local particle = StartParticleFxLoopedOnEntityBone('ent_ray_train_sparks', stockadeVehicle, -0.12, 0.2, 0.0, 0.0, 45.0, -90.0, GetEntityBoneIndexByName(stockadeVehicle, Config.vehicleBone), 1.0, false, false, false)
						Citizen.Wait(100)
						StopParticleFxLooped(particle, true)
					end
					
					SetVehicleDoorOpen(stockadeVehicle, 2, false, false)
					SetVehicleDoorOpen(stockadeVehicle, 3, false, false)
					Citizen.Wait(1000)
					notify(_U('truckOpen'))
					local timeExpired = 0
					local tookMoney = false
					
					Citizen.SetTimeout(1, function()
						while not tookMoney and timeExpired < 46 do 
							timeExpired = timeExpired + 1
							Citizen.Wait(1000)
						end
						if timeExpired > 44 then
							FreezeEntityPosition(stockadeVehicle, false)
							SetVehicleDoorShut(stockadeVehicle, 2, false, false)
							SetVehicleDoorShut(stockadeVehicle, 3, false, false)
							print('Player took too long to take the money.')
							notify(_U('tookToLongToTakeMoney'))
						end
					end)
					
					while timeExpired < 46 and not tookMoney do
						while GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), doorCoords, true) < 1.5 and not tookMoney do
							Draw3DText(doorCoords.x, doorCoords.y, doorCoords.z, 1.5, '~r~[E] ~s~| '.._U('heist_takeMoney'))
							if IsControlJustReleased(0, Config.trigger_key) then
								ESX.TriggerServerCallback('transportOfValuables:giveMoneyToPlayer', function(unused)end, GetVehicleNumberPlateText(stockadeVehicle))
								ESX.TriggerServerCallback('transportOfValuables:updateMoneyInVehicle', function(unused)end, GetVehicleNumberPlateText(stockadeVehicle), 0, true, false)
								tookMoney = true
								Citizen.Wait(500)
								FreezeEntityPosition(stockadeVehicle, false)
								SetVehicleDoorShut(stockadeVehicle, 2, false, false)
								SetVehicleDoorShut(stockadeVehicle, 3, false, false)
							end
							Citizen.Wait(4)
						end
						Citizen.Wait(1500)
					end
					
					Citizen.SetTimeout(60000 * Config.cooldown, function()
						onCooldown = false
					end)
				else
					onCooldown = false
					return
				end
			end)
		else
			notify(_U('not_enough_cops'))
			onCooldown = false
			return
		end
	end)
end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- --   COURIER HEIST   -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

Citizen.CreateThread(function()
	while true do
		if moneyCourier ~= nil and not onCooldown and moneyCase ~= nil then
			if not IsPedInAnyVehicle(moneyCourier, false) then
				closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer(GetEntityCoords(moneyCourier))
				if IsPlayerFreeAimingAtEntity(closestPlayer, moneyCourier) then
					ESX.TriggerServerCallback('transportOfValuables:getOnlinePoliceCount', function(enoughCops)
						if enoughCops then
							TriggerServerEvent('transportOfValuables:callPolice', stockadeVehicle)
							notify(_U('caseStolen'))
							onCooldown = true
							DetachEntity(moneyCase, true, true)
							SetBlipColour(moneyCourierBlip, 1)
							SetBlipFlashes(moneyCourierBlip, true)
							SetBlipFlashInterval(moneyCourierBlip, 500)
							ESX.Streaming.RequestAnimDict('missminuteman_1ig_2', function()
								ClearPedTasksImmediately(moneyCourier)
								TaskPlayAnim(moneyCourier, 'missminuteman_1ig_2', 'handsup_enter', 8.0, 8.0, -1, 50, 0, false, false, false)
								Citizen.Wait(1000)
								
								local timeExpired = 0
								local tookMoney = false
								Citizen.SetTimeout(1, function()
									while not tookMoney and timeExpired < 46 do 
										timeExpired = timeExpired + 1
										Citizen.Wait(1000)
									end
									if timeExpired > 44 then
										ESX.Game.DeleteObject(moneyCase)
										print('Player took too long to take the money.')
										notify(_U('tookToLongToTakeMoney'))
										ClearPedTasksImmediately(moneyCourier)
										TaskEnterVehicle(moneyCourier, stockadeVehicle, -1, 2, 1.0, 1, 0)
									end
								end)
								while timeExpired < 46 and not tookMoney do
									while GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(moneyCase), true) < 2.5 and not tookMoney do
										local objectCoords = GetEntityCoords(moneyCase)
										Draw3DText(objectCoords.x, objectCoords.y, objectCoords.z, 1.5, '~r~[E] ~s~| '.._U('heist_takeMoney'))
										if IsControlJustReleased(0, Config.trigger_key) then
											ESX.Game.DeleteObject(moneyCase)
											ESX.TriggerServerCallback('transportOfValuables:giveCaseMoneyToPlayer', function(unused)end, currentMoneyInCase)
											wasRobbed = true
											tookMoney = true
											Citizen.Wait(2000)
											local _moneyCourier = moneyCourier
											Citizen.SetTimeout(5000, function()
												ClearPedTasksImmediately(_moneyCourier)
												TaskEnterVehicle(moneyCourier, stockadeVehicle, -1, 2, 2.0, 1, 0)
											end)
										end
										Citizen.Wait(4)
									end
									Citizen.Wait(1500)
								end
							end)
						else
							notify(_U('not_enough_cops'))
							onCooldown = false
						end
					end)
				end
			end
		end
		Citizen.Wait(2000)
	end
end)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- JOIN THREAD -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

Citizen.CreateThread(function()	
	TriggerEvent('chat:addSuggestion', '/cancelShift', _U('cancelCommandHelp'), { })
	local BuildingBlip = AddBlipForCoord(Config.startShift.coords)
	SetBlipDisplay(BuildingBlip, Config.blips.building.Display)
	SetBlipSprite(BuildingBlip, Config.blips.building.Sprite)
	SetBlipColour(BuildingBlip, Config.blips.building.Colour)
	SetBlipScale(BuildingBlip, Config.blips.building.Scale)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('GruppeSechs')
	EndTextCommandSetBlipName(BuildingBlip)
	SetBlipAsShortRange(BuildingBlip, true)
end)


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- SHIFT -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

Citizen.CreateThread(function()
	while not ESX.IsPlayerLoaded() do
		Citizen.Wait(100)
	end
	
	while true do
		print("sdsa")
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.startShift.coords, true) < 2.0 and not onShift and not hideText then
			while GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.startShift.coords, true) < 2.0 and not hideText do
				Draw3DText(Config.startShift.coords.x, Config.startShift.coords.y, Config.startShift.coords.z, 1.5, '~r~[E] ~s~| '.._U('startShift_text'))
				if IsControlJustReleased(0, Config.trigger_key) then
					hideText = true
					TriggerEvent('transportOfValuables:startShift')
				end
				Citizen.Wait(4)
			end
		end
		Citizen.Wait(5500)
	end
end)

RegisterNetEvent('transportOfValuables:startShift')
AddEventHandler('transportOfValuables:startShift', function()
	stockadeVehiclePlate = nil
	local getVehiclePlateFinished = false
	
	ESX.TriggerServerCallback('transportOfValuables:getVehiclePlate', function(finished)
		while not finished do
			Citizen.Wait(50)
		end
		getVehiclePlateFinished = true
	end)
	
	while getVehiclePlateFinished == false do
		Citizen.Wait(50)
		print('Waiting for vehicle to load.')
	end
	
	if stockadeVehiclePlate == nil then
		notify(_U('noVehiclesAvailable'))
		return
	end
	
	local retval, spawnCarCoords, spawnCarHeading, unknown1 = GetNthClosestVehicleNodeWithHeading(-196.95, -831.04, 30.76, 99, 9, 3.0, 2.5)
	
	stockadeVehicle = nil
	
	ESX.Streaming.RequestModel(GetHashKey('stockade'), function()
		while IsPositionOccupied(spawnCarCoords, 4.0, false, true, true, false, false, 0, false) do
			print('Spawn area is occupied. Waiting...')
			Citizen.Wait(1000)
		end
		ESX.Game.SpawnVehicle(GetHashKey('stockade'), spawnCarCoords, spawnCarHeading, function(_stockadeVehicle)
			stockadeVehicle = _stockadeVehicle
			SetVehicleTyresCanBurst(stockadeVehicle, false)
			SetVehicleFuelLevel(stockadeVehicle, 100.0)
		end)
		
	end)
	
	while stockadeVehicle == nil do
		Citizen.Wait(10)
	end
	
	SetVehicleNumberPlateText(stockadeVehicle, stockadeVehiclePlate)
	local stockadeVehicleBlip = AddBlipForEntity(stockadeVehicle)
	SetBlipDisplay(stockadeVehicleBlip, Config.blips.truck.Display)
	SetBlipSprite(stockadeVehicleBlip, Config.blips.truck.Sprite)
	SetBlipColour(stockadeVehicleBlip, Config.blips.truck.Colour)
	SetBlipScale(stockadeVehicleBlip, Config.blips.truck.Scale)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('truckLabel'))
	EndTextCommandSetBlipName(stockadeVehicleBlip)
	SetBlipAsShortRange(stockadeVehicleBlip, true)
	
	moneyCourier = nil
	vehicleGuardTwo = nil
	vehicleGuardOne = nil
	
	ESX.Streaming.RequestModel(GetHashKey(Config.PedModel), function()
		moneyCourier = CreatePedInsideVehicle(stockadeVehicle, 4, GetHashKey(Config.PedModel), -1, true, true)
		SetBlockingOfNonTemporaryEvents(moneyCourier, true)
		vehicleGuardTwo = CreatePedInsideVehicle(stockadeVehicle, 4, GetHashKey(Config.PedModel), 0, true, true)
		SetBlockingOfNonTemporaryEvents(vehicleGuardTwo, true)
		vehicleGuardOne = CreatePedInsideVehicle(stockadeVehicle, 4, GetHashKey(Config.PedModel), 1, true, true)
		SetBlockingOfNonTemporaryEvents(vehicleGuardOne, true)
	end)
	
	SetPedCanBeDraggedOut(moneyCourier, false)
	SetPedCanBeDraggedOut(vehicleGuardTwo, false)
	SetPedCanBeDraggedOut(vehicleGuardOne, false)
	SetPedDropsWeaponsWhenDead(moneyCourier, false)
	SetPedDropsWeaponsWhenDead(vehicleGuardTwo, false)
	SetPedDropsWeaponsWhenDead(vehicleGuardOne, false)
	SetEntityInvincible(moneyCourier, true)
	SetEntityInvincible(vehicleGuardTwo, true)
	SetEntityInvincible(vehicleGuardOne, true)

	TaskVehicleDriveToCoordLongrange(moneyCourier, stockadeVehicle, Config.startDrive.coords, 10.0, 783, 2.0)
	notify(_U('vehicleOnTheWay'))
	
	while GetDistanceBetweenCoords(GetEntityCoords(moneyCourier), Config.startDrive.coords) > 4 do
		Citizen.Wait(100)
	end
	
	Citizen.Wait(1500)
	TaskLeaveVehicle(moneyCourier, stockadeVehicle, 0)
	Citizen.Wait(2500)
	TaskEnterVehicle(moneyCourier, stockadeVehicle, 8000, 2, 1.0, 1, 0)
	notify(_U('truckArrived'))
	Citizen.Wait(8000)
	
	local timeExpired = 0
	
	while not IsPedInAnyVehicle(PlayerPedId(), false) and GetVehiclePedIsIn(PlayerPedId(), false) ~= stockadeVehicle and timeExpired < 61 do 
		timeExpired = timeExpired + 1
		Citizen.Wait(1000)
	end
	
	if timeExpired > 59 then
		notify(_U('tookToLongToEnter'))
		print('Player took too long to enter the vehicle.')
		ESX.TriggerServerCallback('transportOfValuables:updateMoneyInVehicle', function(unused)end, GetVehicleNumberPlateText(stockadeVehicle), 0, true, true)
		TaskLeaveVehicle(moneyCourier, stockadeVehicle, 0)
		Citizen.Wait(2500)
		TaskEnterVehicle(moneyCourier, stockadeVehicle, 8000, -1, 1.0, 1, 0)
		Citizen.Wait(9000)
		SetPedAsNoLongerNeeded(moneyCourier)
		Citizen.Wait(3000)
		SetPedAsNoLongerNeeded(vehicleGuardTwo)
		SetPedAsNoLongerNeeded(vehicleGuardOne)
		local _stockadeVehicle = stockadeVehicle
		local _moneyCourier = moneyCourier
		local _vehicleGuardTwo = vehicleGuardTwo
		local _vehicleGuardOne = vehicleGuardOne
		hideText = false
		onShift = false
		Citizen.SetTimeout(10000, function()
			ESX.Game.DeleteVehicle(_stockadeVehicle)
			DeletePed(_moneyCourier)
			DeletePed(_vehicleGuardTwo)
			DeletePed(_vehicleGuardOne)
			ESX.TriggerServerCallback('transportOfValuables:updateMoneyInVehicle', function(unused)end, GetVehicleNumberPlateText(_stockadeVehicle), 0, true, true)
		end)
		return
	end
	onShift = true
	
	Citizen.SetTimeout(1, function()
		SetPlayerCanDoDriveBy(PlayerId(), false)
		while onShift do
			Citizen.Wait(1000)
			while not IsPedInAnyVehicle(PlayerPedId(), false) do
				BeginTextCommandDisplayHelp("THREESTRINGS")
				AddTextComponentSubstringPlayerName(_U('getInVehicleAgainHelp'))
				AddTextComponentSubstringPlayerName('')
				AddTextComponentSubstringPlayerName('')
				EndTextCommandDisplayHelp(0, false, true, 0)
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(stockadeVehicle), true) > 10.0 then
					notify(_U('leftVehicle'))
					TriggerEvent('transportOfValuables:cancelShift')
					break
				end
				Citizen.Wait(10)
			end
		end
		SetPlayerCanDoDriveBy(PlayerId(), true)
	end)
	TriggerEvent('transportOfValuables:startDrive')
end)


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- DRIVE -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

RegisterNetEvent('transportOfValuables:startDrive')
AddEventHandler('transportOfValuables:startDrive', function()
	targetNumber = 0
	for routeNumber = 1, Config.maxAmountOfRoutes, 1 do
		if targetNumber ~= nil then
			lastTargetNumber = targetNumber
			print('Last target Number: '..lastTargetNumber)
		else
			print('Last target Number: nil')
		end
		
		currentMoneyInCase = 0
		targetNumber = math.random(1, #Config.places)
		print('Target Number: '..targetNumber)
		local Target = Config.places[targetNumber]
		
		while lastTargetNumber == targetNumber do
			targetNumber = math.random(1, #Config.places)
			Target = Config.places[targetNumber]
			Citizen.Wait(1)
		end
		
		TargetBlip = AddBlipForCoord(Target.Parking)
		SetBlipDisplay(TargetBlip, Config.blips.currentTarget.Display)
		SetBlipSprite(TargetBlip, Config.blips.currentTarget.Sprite)
		SetBlipColour(TargetBlip, Config.blips.currentTarget.Colour)
		SetBlipScale(TargetBlip, Config.blips.currentTarget.Scale)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('pickupPosition'))
		EndTextCommandSetBlipName(TargetBlip)
		SetBlipAsShortRange(TargetBlip, true)
		SetBlipRoute(TargetBlip, true)
		SetBlipRouteColour(TargetBlip, Config.blips.currentTarget.Colour)
		SetBlipFlashes(TargetBlip, true)
		SetBlipFlashInterval(TargetBlip, 500)
		Citizen.Wait(1000)
		
		while true do
			if GetDistanceBetweenCoords(Target.Parking, GetEntityCoords(PlayerPedId()), true) < 2.5 then
				BeginTextCommandDisplayHelp("THREESTRINGS")
				AddTextComponentSubstringPlayerName(_U('stopHelpMessage'))
				AddTextComponentSubstringPlayerName('')
				AddTextComponentSubstringPlayerName('')
				EndTextCommandDisplayHelp(0, false, true, 0)
			end
			if GetDistanceBetweenCoords(Target.Parking, GetEntityCoords(PlayerPedId()), true) < 2.5 and IsControlJustReleased(0, 38) and GetVehiclePedIsIn(PlayerPedId(), false) == stockadeVehicle then
				break
			end
			DrawMarker(
			Config.MarkerType,
			Target.Parking.x,
			Target.Parking.y,
			Target.Parking.z,
			0.0,
			0.0,
			0.0,
			0.0,
			0.0,
			0.0,
			1.0,
			1.0,
			1.0,
			225,
			0,
			0,
			100,
			false,
			true,
			2,
			nil,
			nil,
			false)
			Citizen.Wait(10)
		end
		
		SetVehicleHandbrake(stockadeVehicle, true)
		
		while GetEntitySpeed(stockadeVehicle) > 0.01 do
			print('Waiting for vehicle to stop.')
			Citizen.Wait(100)
		end
		
		SetVehicleHandbrake(stockadeVehicle, false)
		FreezeEntityPosition(stockadeVehicle, true)
		RemoveBlip(TargetBlip)
		ClearAllBlipRoutes()
		notify(_U('standbyWhileLoading'))
		moneyCourier = GetPedInVehicleSeat(stockadeVehicle, 2)
		SetBlockingOfNonTemporaryEvents(moneyCourier, true)
		moneyCourierBlip = AddBlipForEntity(moneyCourier)
		SetBlipDisplay(moneyCourierBlip, Config.blips.moneyCourier.Display)
		SetBlipSprite(moneyCourierBlip, Config.blips.moneyCourier.Sprite)
		SetBlipColour(moneyCourierBlip, Config.blips.moneyCourier.Colour)
		SetBlipScale(moneyCourierBlip, Config.blips.moneyCourier.Scale)
		vehicleGuardOne = GetPedInVehicleSeat(stockadeVehicle, 1)
		SetBlockingOfNonTemporaryEvents(vehicleGuardOne, true)
		vehicleGuardTwo = GetPedInVehicleSeat(stockadeVehicle, 0)
		SetBlockingOfNonTemporaryEvents(vehicleGuardTwo, true)
		SetPedDropsWeaponsWhenDead(moneyCourier, false)
		SetPedDropsWeaponsWhenDead(vehicleGuardOne, false)
		SetPedDropsWeaponsWhenDead(vehicleGuardTwo, false)
		ESX.Streaming.RequestAnimDict("move_m@intimidation@cop@unarmed", function()
			TaskPlayAnim(vehicleGuardOne, "move_m@intimidation@cop@unarmed", "idle", 2.0, 2.5, -1, 49, 0.0, false, false, false)
			TaskPlayAnim(vehicleGuardTwo, "move_m@intimidation@cop@unarmed", "idle", 2.0, 2.5, -1, 49, 0.0, false, false, false)
		end)
		
		Citizen.Wait(500)
		TaskLeaveVehicle(moneyCourier, stockadeVehicle, 0)
		TaskLeaveVehicle(vehicleGuardOne, stockadeVehicle, 0)
		TaskLeaveVehicle(vehicleGuardTwo, stockadeVehicle, 0)
		Citizen.Wait(1500)
		
		TaskStandGuard(vehicleGuardOne, GetEntityCoords(vehicleGuardOne), GetEntityHeading(stockadeVehicle) - 180, "WORLD_HUMAN_GUARD_STAND")
		TaskStandGuard(vehicleGuardTwo, GetEntityCoords(vehicleGuardTwo), GetEntityHeading(stockadeVehicle) - 90, "WORLD_HUMAN_GUARD_STAND")
		TaskGoToCoordAnyMeans(moneyCourier, Target.Coords, 1.0, nil, false, 0xbf800000, 0)
		
		while true do
			Citizen.Wait(1500)
			if GetDistanceBetweenCoords(GetEntityCoords(moneyCourier), Target.Coords, true) < 1 then
				ESX.Streaming.RequestAnimDict("amb@prop_human_atm@female@enter", function()
					TaskPlayAnim(moneyCourier, "amb@prop_human_atm@female@enter", "enter", 2.0, 2.0, 4300, 1, 1.0, false, false, false)
				end)
				
				Citizen.Wait(1400)
				ESX.Streaming.RequestModel('prop_security_case_01', function()
					ESX.Game.SpawnObject(GetHashKey('prop_security_case_01'), GetEntityCoords(moneyCourier), function(_moneyCase)
						currentMoneyInCase = math.random(Config.places[targetNumber].Money.Min, Config.places[targetNumber].Money.Max)
						moneyCase = _moneyCase
						AttachEntityToEntity(moneyCase, moneyCourier, GetPedBoneIndex(moneyCourier, 0xDEAD), 0.16, 0.04, 0.0, 0.0, -90.0, 45.0, false, false, false, false, 1, true)
					end)
				end)
				Citizen.Wait(3000)
				TaskEnterVehicle(moneyCourier, stockadeVehicle, -1, 2, 1.0, 1, 0)
				while not IsPedInAnyVehicle(moneyCourier, false) do
					Citizen.Wait(2000)
				end
				Citizen.Wait(1000)
				ClearPedTasksImmediately(vehicleGuardOne)
				ClearPedTasksImmediately(vehicleGuardTwo)
				break
			end
		end
		
		TaskEnterVehicle(vehicleGuardOne, stockadeVehicle, 6000, 1, 1.0, 1, 0)
		TaskEnterVehicle(vehicleGuardTwo, stockadeVehicle, 6000, 0, 1.0, 1, 0)
		
		while not IsPedInAnyVehicle(moneyCourier, false) or not IsPedInAnyVehicle(vehicleGuardOne, false) or not IsPedInAnyVehicle(vehicleGuardTwo, false) do
			Citizen.Wait(500)
		end
		
		SetVehicleDoorShut(stockadeVehicle, 0, false, false)
		SetVehicleDoorShut(stockadeVehicle, 1, false, false)
		SetVehicleDoorShut(stockadeVehicle, 2, false, false)
		SetVehicleDoorShut(stockadeVehicle, 3, false, false)
		Citizen.Wait(500)
		RemoveBlip(moneyCourierBlip)
		ESX.Game.DeleteObject(moneyCase)
		if not wasRobbed then
			ESX.TriggerServerCallback('transportOfValuables:updateMoneyInVehicle', function(unused)end, GetVehicleNumberPlateText(stockadeVehicle), currentMoneyInCase, false, false)
		end
		FreezeEntityPosition(stockadeVehicle, false)
		if Target.Type == 'centralbank' then
			break
		end
	end
	TriggerEvent('transportOfValuables:startReturnDrive')
end)


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- RETURNDRIVE -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

RegisterNetEvent('transportOfValuables:startReturnDrive')
AddEventHandler('transportOfValuables:startReturnDrive', function()
	notify(_U('driveToDepository'))
	DepositoryBlip = AddBlipForCoord(Config.blips.returnToDepository.Coords)
	SetBlipDisplay(DepositoryBlip, Config.blips.returnToDepository.Display)
	SetBlipSprite(DepositoryBlip, Config.blips.returnToDepository.Sprite)
	SetBlipColour(DepositoryBlip, Config.blips.returnToDepository.Colour)
	SetBlipScale(DepositoryBlip, Config.blips.returnToDepository.Scale)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('depositoryBlip'))
	EndTextCommandSetBlipName(DepositoryBlip)
	SetBlipAsShortRange(DepositoryBlip, true)
	SetBlipRoute(DepositoryBlip, true)
	SetBlipRouteColour(DepositoryBlip, Config.blips.returnToDepository.Colour)
	SetBlipFlashes(DepositoryBlip, true)
	SetBlipFlashInterval(DepositoryBlip, 500)
	while true do 
		if GetDistanceBetweenCoords(Config.blips.returnToDepository.Coords, GetEntityCoords(PlayerPedId()), true) < 2.5 then
			BeginTextCommandDisplayHelp("THREESTRINGS")
			AddTextComponentSubstringPlayerName(_U('stopHelpMessage'))
			AddTextComponentSubstringPlayerName('')
			AddTextComponentSubstringPlayerName('')
			EndTextCommandDisplayHelp(0, false, true, 0)
		end
		
		if GetDistanceBetweenCoords(Config.blips.returnToDepository.Coords, GetEntityCoords(PlayerPedId()), true) < 1.0 and IsControlJustReleased(0, 38) and GetVehiclePedIsIn(PlayerPedId(), false) == stockadeVehicle 
		and GetEntityHeading(PlayerPedId()) < Config.blips.returnToDepository.Heading + 15 and GetEntityHeading(PlayerPedId()) > Config.blips.returnToDepository.Heading - 15 then
			break
		end
		
		if GetDistanceBetweenCoords(Config.blips.returnToDepository.Coords, GetEntityCoords(PlayerPedId()), true) < 1.0 and IsControlJustReleased(0, 38) and GetVehiclePedIsIn(PlayerPedId(), false) == stockadeVehicle then
			notify(_U('parkInDepository'))
		end
		
		DrawMarker(
		Config.MarkerType,
		Config.blips.returnToDepository.Coords.x,
		Config.blips.returnToDepository.Coords.y,
		Config.blips.returnToDepository.Coords.z,
		0.0,
		0.0,
		0.0,
		0.0,
		0.0,
		0.0,
		1.0,
		1.0,
		1.0,
		225,
		0,
		0,
		100,
		false,
		true,
		2,
		nil,
		nil,
		false)
		Citizen.Wait(5)
	end
	
	TriggerEvent('transportOfValuables:cancelShift')
	ESX.TriggerServerCallback('transportOfValuables:giveSalary', function(hasGiven)
		if hasGiven then
			notify(_U('finished', Config.salary))
		else
			print('Failed to add Money to Player. Please contact Mo1810#4230.')
		end
	end)
end)

RegisterNetEvent('transportOfValuables:getVehiclePlate')
AddEventHandler('transportOfValuables:getVehiclePlate', function(_stockadeVehiclePlate)
	stockadeVehiclePlate = _stockadeVehiclePlate
end)


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- CALL POLICE -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

RegisterNetEvent('transportOfValuables:callPolice')
AddEventHandler('transportOfValuables:callPolice', function(_stockadeVehicle)
	local ped = GetPlayerPed(PlayerId())
	if ESX.GetPlayerData(ped).job.name == 'police' then
		Citizen.Wait(1000)
		notify(_U('alarmPolice'))
		local stockadeEmergencyVehicleBlip = AddBlipForEntity(_stockadeVehicle)
		SetBlipDisplay(stockadeEmergencyVehicleBlip, Config.blips.truck.Display)
		SetBlipSprite(stockadeEmergencyVehicleBlip, Config.blips.truck.Sprite)
		SetBlipColour(stockadeEmergencyVehicleBlip, 1)
		SetBlipScale(stockadeEmergencyVehicleBlip, Config.blips.truck.Scale + 0.1)
		SetBlipFlashes(stockadeEmergencyVehicleBlip, true)
		SetBlipFlashInterval(stockadeEmergencyVehicleBlip, 500)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('robbedTruckLabel'))
		EndTextCommandSetBlipName(stockadeEmergencyVehicleBlip)
		Citizen.SetTimeout(30000, function()
			RemoveBlip(stockadeEmergencyVehicleBlip)
		end)
		for i=2, 1, -1 do
		PlaySound(-1, '5_SEC_WARNING', 'HUD_MINI_GAME_SOUNDSET', 0, 0, 1)
			Citizen.Wait(125)
		end
		Citizen.Wait(500)
		for i=2, 1, -1 do
			PlaySound(-1, '5_SEC_WARNING', 'HUD_MINI_GAME_SOUNDSET', 0, 0, 1)
			Citizen.Wait(125)
		end
		Citizen.Wait(3000)
		for i=2, 1, -1 do
			PlaySound(-1, '5_SEC_WARNING', 'HUD_MINI_GAME_SOUNDSET', 0, 0, 1)
			Citizen.Wait(125)
		end
		Citizen.Wait(500)
		for i=2, 1, -1 do
			PlaySound(-1, '5_SEC_WARNING', 'HUD_MINI_GAME_SOUNDSET', 0, 0, 1)
			Citizen.Wait(125)
		end
	end
end)


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- CANCELSHIFT -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

RegisterNetEvent('transportOfValuables:cancelShift')
AddEventHandler('transportOfValuables:cancelShift', function(message)
	onShift, hideText = false, false
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	TaskLeaveVehicle(PlayerPedId(), stockadeVehicle, 0)
	
	--[[PEDS]]--
	if moneyCourier ~= nil then
		ClearPedTasksImmediately(moneyCourier)
		SetPedAsNoLongerNeeded(moneyCourier)
		DeletePed(moneyCourier)
	end
	if vehicleGuardOne ~= nil then
		ClearPedTasksImmediately(vehicleGuardOne)
		SetPedAsNoLongerNeeded(vehicleGuardOne)
		DeletePed(vehicleGuardOne)
	end
	if vehicleGuardTwo ~= nil then
		ClearPedTasksImmediately(vehicleGuardTwo)
		SetPedAsNoLongerNeeded(vehicleGuardTwo)
		DeletePed(vehicleGuardTwo)
	end
	
	--[[OBJECTS]]--
	if stockadeVehicle ~= nil then
		ESX.TriggerServerCallback('transportOfValuables:updateMoneyInVehicle', function(unused)end, GetVehicleNumberPlateText(stockadeVehicle), 0, true, true)
		Citizen.Wait(200)
		ESX.Game.DeleteVehicle(stockadeVehicle)
	end
	if moneyCase ~= nil then
		ESX.Game.DeleteObject(moneyCase)
	end
	
	--[[BLIPS]]--
	if DepositoryBlip ~= nil then
		RemoveBlip(DepositoryBlip)
	end
	if TargetBlip ~= nil then
		RemoveBlip(TargetBlip)
	end
	if moneyCourierBlip ~= nil then
		RemoveBlip(moneyCourierBlip)
	end
	
	Citizen.Wait(1000)
	
	if message ~= nil then
		notify(message)
	end
	
	DoScreenFadeIn(1000)
end)


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --  FUNCTIONS  -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function Draw3DText(x, y, z, scl_factor, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.0, 0.4)
        SetTextLeading(true)
        SetTextFont(4)
        SetTextProportional(0.5)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        if Config.greySquare == true then
			local factor = (string.len(text)) / 370
			DrawRect(_x,_y+0.0125, 0.015+ factor, 0.038, 003, 003, 003, 75)
        end
        DrawText(_x, _y)
    end
end

function notify(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	EndTextCommandThefeedPostTicker(false, true)
end

--[[--------------------------]]--
--[[  Created by Mo1810#4230  ]]--
--[[--------------------------]]--