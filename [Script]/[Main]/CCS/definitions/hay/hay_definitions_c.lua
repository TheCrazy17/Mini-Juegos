Hay = {}
local lastVisible
local lobbyActive

function Hay.load()

	lobbyActive = false
	lastVisible = false
	setTime(9,00)
	setWeather(3)
	setSkyGradient(60, 100, 196, 60, 100, 196 )
	setCameraMatrix(-1360, 1618, 100, -1450, 1200, 100)
	
	Hay.pvpZone = createColPolygon(-1436.8759765625, -354.572265625,
										-1227.5185546875, -695.99609375,
										-1227.171875, -552.2138671875,
										-1155.4853515625, -476.3330078125,
										-1119.13671875, -382.115234375,
										-1134.7119140625, -241.4609375,
										-1077.9892578125, -219.259765625,
										-1212.1474609375, -28.1845703125,
										-1154.376953125, 30.2353515625,
										-1243.763671875, 120.435546875,
										-1184.8935546875, 179.5234375,				
										-1229.25, 223.25,				
										-999.515625, 453.296875,				
										-1039.8232421875, 493.546875,				
										-1717.3935546875, -192.4453125,	
										-1733.7646484375, -618.2734375,
										-1624.259765625, -695.63671875)

	--Hay.window = HayWindow.new()

	--bindKey("F3", "down", Hay.showPositionMap)
	setPlayerHudComponentVisible("weapon", true)
	setPlayerHudComponentVisible("ammo", true)
	setPlayerHudComponentVisible("radio", true)
	setPlayerHudComponentVisible("health", true)
	setPlayerHudComponentVisible("crosshair", true)
	setPlayerHudComponentVisible("armour", true)
	setPlayerHudComponentVisible("clock", true)
	addEventHandler("onClientSetDownHayDefinitions", root, Hay.unload)
	addEventHandler("onClientLobbyDisable", root, Hay.enablePositionMap)	
	addEventHandler("onClientLobbyEnable", root, Hay.disablePositionMap)
	addEventHandler("onClientColShapeHit", Hay.pvpZone, Hay.enterZone)
	addEventHandler("onClientColShapeLeave", Hay.pvpZone, Hay.leaveZone)
	addEventHandler("onClientKey", root, Hay.shoot)	
	addEventHandler("onClientVehicleEnter", root, Hay.heliBlades)
	
	triggerEvent("onClientCreateNotification", localPlayer, "Press F3 to show the menu!", "information")
	
end
addEvent("onClientSetUpHayDefinitions", true)
addEventHandler("onClientSetUpHayDefinitions", root, Hay.load)


function Hay.unload()

	--Hay.window.destroy()
	removeEventHandler("onClientLobbyDisable", root, Hay.enablePositionMap)
	removeEventHandler("onClientLobbyEnable", root, Hay.disablePositionMap)
	removeEventHandler("onClientSetDownHayDefinitions", root, Hay.unload)
	removeEventHandler("onClientColShapeHit", Hay.pvpZone, Hay.enterZone)
	removeEventHandler("onClientColShapeLeave", Hay.pvpZone, Hay.leaveZone)
	removeEventHandler("onClientKey", root, Hay.shoot)
	removeEventHandler("onClientVehicleEnter", root, Hay.heliBlades)
	if getKeyBoundToFunction(Hay.showPositionMap) then unbindKey("F3", "down", Hay.showPositionMap) end
	setPlayerHudComponentVisible("weapon", false)
	setPlayerHudComponentVisible("ammo", false)
	setPlayerHudComponentVisible("health", false)
	setPlayerHudComponentVisible("armour", false)
	setPlayerHudComponentVisible("clock", false)
	setPlayerHudComponentVisible("radio", false)
	destroyElement(Hay.pvpZone)
	setRadioChannel(0)
	
end
addEvent("onClientSetDownHayDefinitions", true)


function Hay.showPositionMap()

	if lobbyActive then return end

	if Hay.window.isVisible() then	
		Hay.window.setVisible(false)
		isVisible = false
	else
		Hay.window.setVisible(true)
		isVisible = true		
	end

end

function Hay.disablePositionMap()

	lastVisible = isVisible
	--if Hay.window.isVisible() then Hay.showPositionMap() end
	lobbyActive = true	

end
addEvent("onClientLobbyEnable")


function Hay.enablePositionMap()

	lobbyActive = false	
	if lastVisible then Hay.showPositionMap() end
	lastVisible = false

end
addEvent("onClientLobbyDisable")


function Hay.enterZone(hitElement)
	
	if hitElement ~= localPlayer then return end

	outputChatBox("You have entered a PVP zone!", 255, 0, 0)
	
	toggleControl("fire", true)
	toggleControl("action", true)
	toggleControl("aim_weapon", true)
	
end


function Hay.leaveZone(leaveElement)

	if leaveElement ~= localPlayer then return end

	outputChatBox("You have left a PVP zone!", 0, 240, 0)

	toggleControl("fire", false)
	toggleControl("action", false)
	toggleControl("aim_weapon", false)
	
	setPedControlState(localPlayer, "fire", false)
	setPedControlState(localPlayer, "vehicle_fire", false)
	setPedControlState(localPlayer, "vehicle_secondary_fire", false)
		
end


function Hay.shoot(button, pressOrRelease)
	
	if not pressOrRelease then return end

	if isElementWithinColShape(localPlayer, Hay.pvpZone) then return end
	
	local vehicle = getPedOccupiedVehicle(localPlayer)
	
	if not vehicle then return end
	
	if getElementModel(vehicle) ~= 425 and getElementModel(vehicle) ~= 447 and getElementModel(vehicle) ~= 520 and getElementModel(vehicle) ~= 476 then return end
	
	local found = false
	
	for key, state in pairs(getBoundKeys("vehicle_fire")) do
			
		if key == button then
		
			found = true
			break
			
		end
		
	end	
	
	for key, state in pairs(getBoundKeys("vehicle_secondary_fire")) do
			
		if key == button then
		
			found = true
			break
			
		end
		
	end	
	
	if found then 
	
		cancelEvent()
		outputChatBox("You can only fight in a PVP zone!", 255, 0, 0)
	
	end
	
end


function Hay.getWeapon()

	if isElementWithinColShape(localPlayer, Hay.pvpZone) then return end
	
	setPedWeaponSlot(localPlayer, 0)
	
	outputChatBox("You can only fight in a PVP zone!", 255, 0, 0)

end
addEvent("onPlayerReceiveWeapon", true)
addEventHandler("onPlayerReceiveWeapon", root, Hay.getWeapon)


function Hay.heliBlades()

	setHeliBladeCollisionsEnabled(source, false)

end