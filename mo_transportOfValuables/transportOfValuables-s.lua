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

Citizen.CreateThread(function()
	MySQL.Async.fetchAll("UPDATE `gruppe6vehicles` SET `inGarage` = 1 WHERE `inGarage` = 0", {},function(result)end)
	MySQL.Async.fetchAll("UPDATE `gruppe6vehicles` SET `currentMoneyInside` = 0 WHERE `currentMoneyInside` > 0", {},function(result)end)
end)

ESX.RegisterServerCallback("transportOfValuables:getOnlinePoliceCount",function(source,cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local Players = ESX.GetPlayers()
	local policeOnline = 0
	for i = 1, #Players do
		local xPlayer = ESX.GetPlayerFromId(Players[i])
		if xPlayer["job"]["name"] == "police" then
			policeOnline = policeOnline + 1
		end
	end
	if policeOnline >= Config.RequiredPolice then
		cb(true)
	else
		cb(false)
		xPlayer.showNotification(_U('not_enough_cops'), false, true, nil)
	end
end)

ESX.RegisterServerCallback('transportOfValuables:removeThermiteCharge', function(source, cb)
	_source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	while xPlayer == nil do
		xPlayer = ESX.GetPlayerFromId(_source)
		Citizen.Wait(1)
	end
	if xPlayer.getInventoryItem(Config.item).count > 0 then
		xPlayer.removeInventoryItem(Config.item, 1)
		cb(true)
	else
		xPlayer.showNotification(_U('noThermite'))
		cb(false)
	end
end)

ESX.RegisterServerCallback('transportOfValuables:giveCaseMoneyToPlayer', function(source, cb, amount)
	_source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	while xPlayer == nil do
		xPlayer = ESX.GetPlayerFromId(_source)
		Citizen.Wait(1)
	end
	xPlayer.addAccountMoney(Config.HeistMoneyAccountType, amount)
	xPlayer.showNotification(_U('moneyInCase', amount))
	cb(true)
end)

ESX.RegisterServerCallback('transportOfValuables:giveMoneyToPlayer', function(source, cb, plate)
	_source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	while xPlayer == nil do
		xPlayer = ESX.GetPlayerFromId(_source)
		Citizen.Wait(1)
	end
	MySQL.Async.fetchAll("SELECT `currentMoneyInside` FROM `gruppe6vehicles` WHERE `plate` = @plate", {['@plate'] = plate},
	function(result)
		if result ~= nil then
			xPlayer.addAccountMoney(Config.HeistMoneyAccountType, result[1].currentMoneyInside)
			xPlayer.showNotification(_U('moneyInTruck', result[1].currentMoneyInside))
			cb(true)
		else
			print('Error getting money inside of the truck.')
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('transportOfValuables:getVehiclePlate', function(source, cb)
	_source = source
	local stockadeVehiclePlate = nil
	MySQL.Async.fetchAll("SELECT `plate` FROM `gruppe6vehicles` WHERE `inGarage` = 1", {},
	function(result)
		if result[1] == nil then
			TriggerClientEvent('transportOfValuables:getVehiclePlate', _source, nil)
		else
			TriggerClientEvent('transportOfValuables:getVehiclePlate', _source, result[1].plate)
			MySQL.Async.fetchAll("UPDATE `gruppe6vehicles` SET `inGarage` = 0 WHERE `plate` = @plate", {['@plate'] = result[1].plate},function(result)end)
		end
		cb(true)
	end)
end)

ESX.RegisterServerCallback('transportOfValuables:checkPlayersJob', function(source, cb)
	_source = source
	Citizen.Wait(10)
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getJob().name == Config.jobName then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('transportOfValuables:updateMoneyInVehicle', function(source, cb, plate, amount, clearBool, parkBool)
	if parkBool then
		MySQL.Async.fetchAll("UPDATE `gruppe6vehicles` SET `inGarage` = 1 WHERE `plate` = @plate", {['@plate'] = plate},function(result)end)
	end
	if clearBool then
		MySQL.Async.fetchAll("UPDATE `gruppe6vehicles` SET `currentMoneyInside` = 0 WHERE `plate` = @plate", {['@plate'] = plate},function(result)end)
	else
		MySQL.Async.fetchAll("SELECT `currentMoneyInside` FROM `gruppe6vehicles` WHERE `plate` = @plate", {['@plate'] = plate},
		function(result)
			MySQL.Async.fetchAll("UPDATE `gruppe6vehicles` SET `currentMoneyInside` = @currentMoney WHERE `plate` = @plate", 
			{['@currentMoney'] = result[1].currentMoneyInside + amount, ['@plate'] = plate},function(result)end)
		end)
	end
end)

RegisterServerEvent('transportOfValuables:callPolice')
AddEventHandler('transportOfValuables:callPolice', function(stockadeVehicle)
	TriggerClientEvent('transportOfValuables:callPolice', -1, stockadeVehicle)
end)

ESX.RegisterServerCallback('transportOfValuables:giveSalary', function(source, cb)
	_source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	Citizen.Wait(10)
	xPlayer.addAccountMoney(Config.SalaryAccountType, Config.salary)
	cb(true)
end)

--[[--------------------------]]--
--[[  Created by Mo1810#4230  ]]--
--[[--------------------------]]--