Gungame = {}
Gungame.x, Gungame.y = guiGetScreenSize()
Gungame.relX, Gungame.relY = (Gungame.x/800), (Gungame.y/600)
Gungame.wallTexture = dxCreateTexture("img/white.png")
Gungame.moveStartTime = nil
Gungame.circleSizes = {0.65, 0.35, 0.15, 0.05, 0}
Gungame.radius = nil
Gungame.startRadius = nil
Gungame.origin = {}
Gungame.roundStartOrigion = {}
Gungame.roundTargetOrigin = {}
Gungame.targetOrigin = {}
Gungame.wallColor = tocolor(255, 0, 0, 200)
Gungame.wallAreaColor = tocolor(255, 0, 0, 100)
Gungame.round = 0
Gungame.moving = false
Gungame.wallClosingTimer = nil
Gungame.wallClosingWarnTime = 10000 
Gungame.lastTick = 0
Gungame.roundStartRadius = nil
Gungame.roundTargetRadius = nil
Gungame.startOrigin = nil
Gungame.showingMap = false
Gungame.mapWidth = 600 * Gungame.relY
Gungame.mapHeight = 600 * Gungame.relY
Gungame.mapX = Gungame.x / 2 - Gungame.mapWidth / 2
Gungame.mapY = Gungame.y / 2 - Gungame.mapHeight / 2
Gungame.wall = false
Gungame.mapInfoShown = false
Gungame.fuelCheck = 0
Gungame.fuelReduction = 1
Gungame.cameraAngle = {0, 0}
Gungame.choosingCharacter = false
Gungame.skins = getValidPedModels()
Gungame.skinIndex = 1
Gungame.character = 0
Gungame.chooseCharacterInstructionText = "Use arrow keys to switch.\nUse Enter to accept."
local lobbyActive
Gungame.compassWidth = 400 * Gungame.relY
Gungame.compassHeight = 32 * Gungame.relY
Gungame.compassPosX = Gungame.x / 2 - Gungame.compassWidth / 2
Gungame.compassPosY = 60 * Gungame.relY

function Gungame.load()
	lobbyActive = false

	outputChatBox("Loading client", 0, 255, 0)
--[[
	addEventHandler("onClientUnloadGungameDefinitions", root, Gungame.unload)
	addEventHandler("onClientLobbyDisable", root, Gungame.disableLobby)
	addEventHandler("onClientLobbyEnable", root, Gungame.enableLobby)
	addEventHandler("onClientPlayerReady", root, Gungame.loadingFinished)
	addEventHandler("onClientCountdownStart", root, Gungame.countdown)
	addEventHandler("onClientMapStart", root, Gungame.mapStart)
	addEventHandler("onClientMatchStart", root, Gungame.matchStart)
	addEventHandler("onClientPlaneReachFinalPosition", root, Gungame.planeFinish)
	addEventHandler("onClientRoundEnd", root, Gungame.roundEnd)
	addEventHandler("onClientRoundStart", root, Gungame.roundStart)
	addEventHandler("onClientRender", root, Gungame.render)
	addEventHandler("onClientMapEnding", root, Gungame.mapEnd)
	addEventHandler("onClientMatchInProgress", root, Gungame.matchInProgress)
	addEventHandler("onClientPlayerWin", root, Gungame.playerWin)
	addEventHandler("onClientPlayerLeavePlane", root, Gungame.parachute)
	addEventHandler("onClientVehicleEnter", root, Gungame.vehicleEnter)
	addEventHandler("onClientMapChange", root, Gungame.mapChange)
	addEventHandler("onClientPreMapEnd", root, Gungame.preMapEnd)
]]
	setPlayerHudComponentVisible("weapon", true)
	setPlayerHudComponentVisible("ammo", true)
	setPlayerHudComponentVisible("radio", true)
	setPlayerHudComponentVisible("health", true)
	setPlayerHudComponentVisible("crosshair", true)
	setPlayerHudComponentVisible("armour", true)
	setPlayerHudComponentVisible("clock", true)
end
addEvent("onClientLoadGungameDefinitions", true)
addEventHandler("onClientLoadGungameDefinitions", root, Gungame.load)


function Gungame.unload()
	removeEventHandler("onClientUnloadGungameDefinitions", root, Gungame.unload)
	removeEventHandler("onClientLobbyDisable", root, Gungame.disableLobby)
	removeEventHandler("onClientLobbyEnable", root, Gungame.enableLobby)
	removeEventHandler("onClientPlayerReady", root, Gungame.loadingFinished)
	removeEventHandler("onClientCountdownStart", root, Gungame.countdown)	
	removeEventHandler("onClientMapStart", root, Gungame.mapStart)	
	removeEventHandler("onClientMatchStart", root, Gungame.matchStart)
	removeEventHandler("onClientPlaneReachFinalPosition", root, Gungame.planeFinish)
	removeEventHandler("onClientRoundEnd", root, Gungame.roundEnd)
	removeEventHandler("onClientRoundStart", root, Gungame.roundStart)
	removeEventHandler("onClientMapEnding", root, Gungame.mapEnd)
	removeEventHandler("onClientRender", root, Gungame.render)
	removeEventHandler("onClientMatchInProgress", root, Gungame.matchInProgress)
	removeEventHandler("onClientPlayerWin", root, Gungame.playerWin)
	removeEventHandler("onClientPlayerLeavePlane", root, Gungame.parachute)
	removeEventHandler("onClientVehicleEnter", root, Gungame.vehicleEnter)
	removeEventHandler("onClientMapChange", root, Gungame.mapChange)
	removeEventHandler("onClientPreMapEnd", root, Gungame.preMapEnd)	

	setPlayerHudComponentVisible("weapon", false)
	setPlayerHudComponentVisible("ammo", false)
	setPlayerHudComponentVisible("health", false)
	setPlayerHudComponentVisible("armour", false)
	setPlayerHudComponentVisible("clock", false)
	setPlayerHudComponentVisible("radio", false)

	if Gungame.loadingScreen then 

		Gungame.loadingScreen:destroy()
		Gungame.loadingScreen = nil
		
	end	

end
addEvent("onClientUnloadGungameDefinitions", true)


function Gungame.reset()

	removeEventHandler("onClientPreRender", root, Gungame.followPlane)
	removeEventHandler("onClientPedStep", localPlayer, Gungame.mapInfo)
	removeEventHandler("onClientCursorMove", root, Gungame.cursorMove)
	
	Gungame.stopChooseCharacter()
	
	if isTimer(Gungame.wallClosingTimer) then killTimer(Gungame.wallClosingTimer) end

	Gungame.targetOrigin = {}
	Gungame.moving = false
	Gungame.showingMap = false
	Gungame.wall = false
	Gungame.mapInfoShown = false
	Gungame.round = 0

	if Gungame.waitingMessage then 
		
		Gungame.waitingMessage:destroy() 
		Gungame.waitingMessage = nil
		
	end
	
	if Gungame.matchStartCountdown then
	
		Gungame.matchStartCountdown:destroy()
		Gungame.matchStartCountdown = nil
		
	end
	
	if Gungame.roundStartMessage then
	
		Gungame.roundStartMessage:destroy()
		Gungame.roundStartMessage = nil
		
	end
	
	if Gungame.ringClosingCountDown then
	
		Gungame.ringClosingCountDown:destroy()
		Gungame.ringClosingCountDown = nil
		
	end
	
	if Gungame.leavePlaneButton then
	
		Gungame.leavePlaneButton:destroy()
		Gungame.leavePlaneButton = nil
		
	end
	
	if Gungame.timeUpMessage then
	
		Gungame.timeUpMessage:destroy()
		Gungame.timeUpMessage = nil
		
	end
	
	if Gungame.nextMatchCountDown then
	
		Gungame.nextMatchCountDown:destroy()
		Gungame.nextMatchCountDown = nil
		
	end	

	if Gungame.mapInfoMessage then
	
		Gungame.mapInfoMessage:destroy()
		Gungame.mapInfoMessage = nil
		
	end

	if Gungame.chooseCharacterInstructionMessage then
	
		Gungame.chooseCharacterInstructionMessage:destroy()
		Gungame.chooseCharacterInstructionMessage = nil
		
	end

	if Gungame.chooseCharacterMessage then
	
		Gungame.chooseCharacterMessage:destroy()
		Gungame.chooseCharacterMessage = nil
		
	end
	
	if Gungame.mapEndCountDown then
	
		Gungame.mapEndCountDown:destroy()
		Gungame.mapEndCountDown = nil
		
	end	

end
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", root, Gungame.reset)


function Gungame.enableLobby()
	lobbyActive = true
end
addEvent("onClientLobbyEnable")


function Gungame.disableLobby()

	lobbyActive = false

end
addEvent("onClientLobbyDisable")


function Gungame.mapEnd(text, countTime)
	
	if Gungame.timeUpMessage then
	
		Gungame.timeUpMessage:destroy()
		Gungame.timeUpMessage = nil
		
	end
	
	Gungame.nextMatchCountDown = OnScreenMessage.new(text.."\n", 0.75, "#ffffff", 2, countTime, false, true)

	Gungame.wall = false

	if isTimer(Gungame.wallClosingTimer) then killTimer(Gungame.wallClosingTimer) end

end
addEvent("onClientMapEnding", true)


function Gungame.preMapEnd(text, countTime, timeUp)

	if timeUp then
	
		Gungame.timeUpMessage = OnScreenMessage.new("Time's up!", 0.5, "#ff0000", 3)
		toggleAllControls(false, true, false)	
	
	end

	Gungame.mapEndCountDown = OnScreenMessage.new(text.."\n", 0.75, "#ffffff", 2, countTime, false, true)

end
addEvent("onClientPreMapEnd", true)


function Gungame.followPlane()

	local arenaElement = getElementParent(localPlayer)
	
	if not getElementData(localPlayer, "inplane") then return end
	
	local plane = getElementData(arenaElement, "plane")
	
	if isElement(plane) then
	
		local x, y, z = getElementPosition(plane)

		local ox = x - math.sin(math.rad(Gungame.cameraAngle[1])) * 50
		local oy = y - math.cos(math.rad(Gungame.cameraAngle[1])) * 50
		local oz = z + math.tan(math.rad(Gungame.cameraAngle[2])) * 50
		setCameraMatrix(ox, oy, oz, x, y, z)
		
		return
		
	end

end


function Gungame.cursorMove(rx, ry, x, y)

	if not getElementData(localPlayer, "inplane") then return end

	if isCursorShowing() then return end
	
	if isChatBoxInputActive() then return end

	if isConsoleActive() then return end
	
	if isMainMenuActive() then return end

	local sx, sy = guiGetScreenSize()
	
	Gungame.cameraAngle[1] = (Gungame.cameraAngle[1] + (x - sx / 2) / 10) % 360
	Gungame.cameraAngle[2] = (Gungame.cameraAngle[2] + (y - sy / 2) / 10) % 360
	
	if Gungame.cameraAngle[2] > 180 then
	
		if Gungame.cameraAngle[2] < 300 then Gungame.cameraAngle[2] = 300 end
		
	else
	
		if Gungame.cameraAngle[2] > 60 then Gungame.cameraAngle[2] = 60 end
		
	end
	
end


function Gungame.render()
	
	local arenaElement = getElementParent(localPlayer)	
	
	local cameraTarget = getCameraTarget(localPlayer)
	
	if not cameraTarget then 
	
		cameraTarget = localPlayer
		
	end	
	
	if getElementType(cameraTarget) == "player" then
	
		local vehicle = getPedOccupiedVehicle(cameraTarget)
		
		if vehicle then
		
			cameraTarget = vehicle
			
		end
		
	end
	
	if not cameraTarget then 
	
		cameraTarget = localPlayer
		
	end	
	
	if Gungame.wall then
	
		if Gungame.moving then
		
			local progress = (getTickCount() - Gungame.moveStartTime) / Gungame.roundDuration
			
			progress = math.min(progress, 1)

			Gungame.radius = interpolateBetween ( Gungame.roundStartRadius, 0, 0, Gungame.roundTargetRadius, 0, 0, progress, "Linear" )

			Gungame.origin.x, Gungame.origin.y = interpolateBetween ( Gungame.roundStartOrigion.x, Gungame.roundStartOrigion.y, 0, Gungame.roundTargetOrigin.x, Gungame.roundTargetOrigin.y, 0, progress, "Linear" ) 
		
			if progress == 1 then
				
				Gungame.moving = false

			end

		end

		local mover = 0
		local points = math.floor( math.pow( Gungame.radius, 0.4 ) * 5 )
		local step = math.pi * 2 / points
		local sx, sy

		for i = 0, points do
		
			local ex = math.cos ( i * step ) * Gungame.radius
			local ey = math.sin ( i * step ) * Gungame.radius
			
			if sx then
				
				mover = mover + 0.002;
				local stretch = Gungame.radius * 0.5;
				if (stretch < 300) then stretch = Gungame.radius * 3 end
				
				dxDrawMaterialSectionLine3D(Gungame.origin.x + sx, Gungame.origin.y + sy, 0, Gungame.origin.x + ex, Gungame.origin.y + ey, 0, 0 , mover, 150000, stretch, Gungame.wallTexture, 10000, Gungame.wallColor, Gungame.origin.x, Gungame.origin.y, 0)
			
			end
			
			sx, sy = ex, ey
			
		end
		
		if not lobbyActive and not Gungame.isPlayerInCircle(Gungame.origin, Gungame.radius) then
			
			if getTickCount() - Gungame.lastTick > 1000 then
		
				if cameraTarget == localPlayer or cameraTarget == getPedOccupiedVehicle(localPlayer) then
		
					local health = getElementHealth(localPlayer)
				
					setElementHealth(localPlayer, health - 2.5)
					
					local vehicle = getPedOccupiedVehicle(localPlayer)
					
					if vehicle then
					
						local health = getElementHealth(vehicle)
				
						setElementHealth(vehicle, health - 25)
						
					end
					
					Gungame.lastTick = getTickCount()
					
				end
				
			end

			dxDrawRectangle(0, 0, Gungame.x, Gungame.y, Gungame.wallAreaColor, false);
		
		end
	
	end
	
	if Gungame.showingMap then
	
		dxDrawImage(Gungame.mapX, Gungame.mapY, Gungame.mapWidth, Gungame.mapHeight, "img/map.png", 0, 0, 0, tocolor(255, 255, 255, 255))
	
		local x, y, z = getElementPosition(cameraTarget)
		local x = x * (Gungame.mapWidth/6000) + Gungame.mapWidth/2
		local y = y * (-Gungame.mapWidth/6000) + Gungame.mapWidth/2
	
		if Gungame.wall then
		
			local roundTargetX = Gungame.roundTargetOrigin.x * (Gungame.mapWidth/6000) + Gungame.mapWidth/2
			local roundTargetY = Gungame.roundTargetOrigin.y * (-Gungame.mapWidth/6000) + Gungame.mapWidth/2
			local roundTargetRadius = Gungame.roundTargetRadius * (Gungame.mapWidth/6000)
		
			dxDrawCircleLine(Gungame.mapX + roundTargetX, Gungame.mapY + roundTargetY, roundTargetRadius, tocolor(255, 255, 255, 255), 2, false)
		
			local originX = Gungame.origin.x * (Gungame.mapWidth/6000) + Gungame.mapWidth/2
			local originY = Gungame.origin.y * (-Gungame.mapWidth/6000) + Gungame.mapWidth/2
			local originRadius = Gungame.radius * (Gungame.mapWidth/6000)
			
			dxDrawCircleLine(Gungame.mapX + originX, Gungame.mapY + originY, originRadius, tocolor(255, 0, 0, 255), 2, false)
			
			if not Gungame.isPlayerInCircle(Gungame.roundTargetOrigin, Gungame.roundTargetRadius) and Gungame.isPlayerInCircle(Gungame.origin, Gungame.radius) then

				local pX, pY = Gungame.getPointOnCircle(x, y, roundTargetX, roundTargetY, roundTargetRadius)
			
				dxDrawLine(Gungame.mapX + x, Gungame.mapY + y, Gungame.mapX + pX, Gungame.mapY + pY, tocolor(255, 255, 255, 255), 2)
			
			elseif not Gungame.isPlayerInCircle(Gungame.origin, Gungame.radius) then

				local pX, pY = Gungame.getPointOnCircle(x, y, originX, originY, originRadius)
			
				dxDrawLine(Gungame.mapX + x, Gungame.mapY + y, Gungame.mapX + pX, Gungame.mapY + pY, tocolor(255, 0, 0, 255), 2)
			
			end
			
		end
		
		local _, _, zr = getElementRotation(cameraTarget)
		
		dxDrawImage(Gungame.mapX + x - 16/2, Gungame.mapY + y - 16/2, 16, 16, "img/blip.png", -zr, 0, 0, tocolor ( 255, 255, 255, 255 ), false)  	
	
		for i, player in pairs(getAlivePlayersInArena(arenaElement)) do
		
			while true do
			
				if player == localPlayer then break end
			
				if not getPlayerTeam(localPlayer) then break end
			
				if getPlayerTeam(player) ~= getPlayerTeam(localPlayer) then break end
			
				local x, y, z = getElementPosition(player)
				local x = x * (Gungame.mapWidth/6000) + Gungame.mapWidth/2
				local y = y * (-Gungame.mapWidth/6000) + Gungame.mapWidth/2
						
				local playerName = getPlayerName(player)
				local c1, c2 = string.find(playerName, '#%x%x%x%x%x%x')
				local blipr, blipg, blipb
				
				if c1 then
				
					blipr, blipg, blipb = getColorFromString(string.sub(playerName, c1, c2))
			
				else
				
					blipr = 255
					blipg = 255
					blipb = 255
			
				end

				dxDrawImage(Gungame.mapX + x - 6, Gungame.mapY + y - 6, 12, 12, "img/blipNormal.png", 0, 0, 0, tocolor ( blipr, blipg, blipb, 255 ))
				
				break
			
			end
				
		end
		
		local plane = getElementData(arenaElement, "plane")
		
		if isElement(plane) then
		
			local x, y, z = getElementPosition(plane)
			local x = x * (Gungame.mapWidth/6000) + Gungame.mapWidth/2
			local y = y * (-Gungame.mapWidth/6000) + Gungame.mapWidth/2
			local _, _, zr = getElementRotation(plane)
			
			dxDrawImage(Gungame.mapX + x - 16 * Gungame.relY, Gungame.mapY + y - 16 * Gungame.relY, 32 * Gungame.relY, 32 * Gungame.relY, "img/plane.png", -zr, 0, 0, tocolor ( 255, 255, 255, 255 ), false)
		
		end
	end
	
	if getPedOccupiedVehicle(localPlayer) then
	
		if getTickCount() - Gungame.fuelCheck > 1000 then
		
			local vehicle = getPedOccupiedVehicle(localPlayer)
		
			local fuel = getElementData(vehicle, "fuel")
		
			if getElementSpeed(vehicle) ~= 0 then
		
				fuel = math.max(0, fuel - Gungame.fuelReduction)
			
				setElementData(vehicle, "fuel", fuel)
			
			end
			
			if fuel == 0 then
	
				if getVehicleEngineState(vehicle) then
				
					outputChatBox("This vehicle is out of fuel!", 255, 0, 128, true)
				
					setVehicleEngineState(vehicle, false)
					
				end
		
			end
		
			Gungame.fuelCheck = getTickCount()
		
		end
		
	end
	
	--local _,_,rot = getElementRotation(getCamera())
	--local pos = rot/360
	--dxDrawImageSection(Gungame.compassPosX, Gungame.compassPosY, Gungame.compassWidth, Gungame.compassHeight, 660 + -pos * 2400, 0, 1100, 72, "img/compass.png")
	--dxDrawImage(Gungame.x / 2 - 7 * Gungame.relY, Gungame.compassPosY, 14 * Gungame.relY, 11 * Gungame.relY, "img/arrow.png", 0, 0, 0, tocolor(255, 255, 255))
	
end

function Gungame.getPointOnCircle(x, y, cX, cY, radius)

	local vX = x - cX
	local vY = y - cY

	local magV = math.sqrt(vX * vX + vY * vY)
	
	local aX = cX + vX / magV * radius
	local aY = cY + vY / magV * radius

	return aX, aY

end


function Gungame.isPlayerInCircle(circle, radius)
	
	local x, y = getCameraMatrix()
	
	if (circle.x - x)^2 + (circle.y - y)^2 <= radius^2 then 
	
		return true
		
	end
	
	return false

end


function Gungame.loadingFinished(duration, timePassed, waitTime)

	if Gungame.loadingScreen then 

		Gungame.loadingScreen:destroy()
		Gungame.loadingScreen = nil
		
	end	

	if getElementData(source, "state") == "Waiting" then
		
		Gungame.waitingMessage = OnScreenMessage.new("Waiting for more players..\n", 0.5, "#ffffff", 3)
		
		if not getElementData(localPlayer, "Spectator") then
		
			Gungame.chooseCharacter()
			
		end
		
	elseif getElementData(source, "state") == "Countdown" then
		
		Gungame.matchStartCountdown = OnScreenMessage.new("Match starting in ", 0.75, "#ffffff", 2, waitTime, false, true, true)
		
		if not getElementData(localPlayer, "Spectator") and waitTime > 5000 then
		
			Gungame.chooseCharacter()
			
		end
		
	end
	
end
addEvent("onClientPlayerReady", true)


function Gungame.countdown(waitTime)

	if Gungame.waitingMessage then 
		
		Gungame.waitingMessage:destroy() 
		Gungame.waitingMessage = nil
		
	end

	Gungame.matchStartCountdown = OnScreenMessage.new("Match starting in ", 0.75, "#ffffff", 2, waitTime, false, true, true)

	if Gungame.choosingCharacter then
	
		Gungame.matchStartCountdown:setVisible(false)
	
	end

end
addEvent("onClientCountdownStart", true)


function Gungame.mapStart(map, time)

	Gungame.leavePlaneButton = OnScreenMessage.new("Press 'F' to leave the plane", 0.75, "#ffffff", 2)

	bindKey("F", "down", Gungame.leavePlane)

	addEventHandler("onClientPreRender", root, Gungame.followPlane)
	addEventHandler("onClientCursorMove", root, Gungame.cursorMove)
	
	setTime(time, 0)
	
	Gungame.stopChooseCharacter()
	
end
addEvent("onClientMapStart", true)


function Gungame.mapChange()
	
	if Gungame.loadingScreen then 

		Gungame.loadingScreen:destroy()
		Gungame.loadingScreen = nil
		
	end
	
	Gungame.loadingScreen = LoadingScreen.new()

end
addEvent("onClientMapChange", true)


function Gungame.leavePlane()

	if not getElementData(localPlayer, "inplane") then return end

	triggerServerEvent("onPlayerRequestExitPlane", localPlayer)

	if getKeyBoundToFunction(Gungame.leavePlane) then unbindKey("F", "down", Gungame.leavePlane) end

	if Gungame.leavePlaneButton then
	
		Gungame.leavePlaneButton:destroy()
		Gungame.leavePlaneButton = nil
		
	end

end


function Gungame.parachute()

	addEventHandler("onClientPedStep", localPlayer, Gungame.mapInfo)	

end
addEvent("onClientPlayerLeavePlane", true)


function Gungame.planeFinish()

	if getKeyBoundToFunction(Gungame.leavePlane) then unbindKey("F", "down", Gungame.leavePlane) end

	if Gungame.leavePlaneButton then
	
		Gungame.leavePlaneButton:destroy()
		Gungame.leavePlaneButton = nil
		
	end

end
addEvent("onClientPlaneReachFinalPosition", true)


function Gungame.matchStart(currentOrigin, targetOrigin, radius)

	Gungame.round = 1

	Gungame.startOrigin = currentOrigin

	Gungame.origin.x, Gungame.origin.y = Gungame.startOrigin.x, Gungame.startOrigin.y

	Gungame.targetOrigin = targetOrigin
	
	Gungame.startRadius = radius
	
	Gungame.radius = Gungame.startRadius

	Gungame.wall = true


end
addEvent("onClientMatchStart", true)


function Gungame.roundStart(round, roundDuration)

	if not Gungame.wall then return end

	Gungame.moving = false

	Gungame.round = round

	Gungame.roundDuration = roundDuration

	Gungame.wallClosingTimer = setTimer(Gungame.ringClosingWarning, Gungame.roundDuration - Gungame.wallClosingWarnTime, 1)

	Gungame.roundStartOrigion.x, Gungame.roundStartOrigion.y = Gungame.origin.x, Gungame.origin.y

	Gungame.roundTargetOrigin.x, Gungame.roundTargetOrigin.y = interpolateBetween ( Gungame.startOrigin.x, Gungame.startOrigin.y, 0, Gungame.targetOrigin.x, Gungame.targetOrigin.y, 0, 1 - Gungame.circleSizes[Gungame.round], "Linear" ) 

	Gungame.roundStartRadius = Gungame.radius
	
	Gungame.roundTargetRadius = Gungame.startRadius * Gungame.circleSizes[Gungame.round]

	Gungame.roundStartMessage = OnScreenMessage.new("Round "..Gungame.round.." begins..", 0.5, "#00ff00", 2, 5000, true)

end
addEvent("onClientRoundStart", true)


function Gungame.roundEnd()

	if not Gungame.wall then return end

	Gungame.moving = true

	Gungame.moveStartTime = getTickCount()

end
addEvent("onClientRoundEnd", true)


function Gungame.matchInProgress(currentOrigin, targetOrigin, radius, round, roundDuration, wallMoving, timeLeft, time)

	Gungame.moving = wallMoving

	Gungame.round = round

	Gungame.roundDuration = roundDuration

	Gungame.startOrigin = currentOrigin

	Gungame.startRadius = radius

	Gungame.wall = true

	Gungame.targetOrigin = targetOrigin
	
	if Gungame.moving then
	
		Gungame.moveStartTime = getTickCount() - (roundDuration - timeLeft)
	
	else
	
		if timeLeft > Gungame.wallClosingWarnTime then
		
			Gungame.wallClosingTimer = setTimer(Gungame.ringClosingWarning, timeLeft - Gungame.wallClosingWarnTime, 1)

		end	
	
	end
	
	if Gungame.round > 1 then

		Gungame.roundStartOrigion.x, Gungame.roundStartOrigion.y =  interpolateBetween ( Gungame.startOrigin.x, Gungame.startOrigin.y, 0, Gungame.targetOrigin.x, Gungame.targetOrigin.y, 0, 1 - Gungame.circleSizes[Gungame.round - 1], "Linear" ) 

		Gungame.origin.x, Gungame.origin.y = Gungame.roundStartOrigion.x, Gungame.roundStartOrigion.y

		Gungame.roundStartRadius = Gungame.startRadius * Gungame.circleSizes[Gungame.round - 1]
		
		Gungame.radius = Gungame.startRadius * Gungame.circleSizes[Gungame.round - 1]
	
	else
	
		Gungame.roundStartOrigion.x, Gungame.roundStartOrigion.y = Gungame.startOrigin.x, Gungame.startOrigin.y
		
		Gungame.origin.x, Gungame.origin.y = Gungame.roundStartOrigion.x, Gungame.roundStartOrigion.y
		
		Gungame.roundStartRadius = Gungame.startRadius
		
		Gungame.radius = Gungame.startRadius

	end

	Gungame.roundTargetOrigin.x, Gungame.roundTargetOrigin.y = interpolateBetween ( Gungame.startOrigin.x, Gungame.startOrigin.y, 0, Gungame.targetOrigin.x, Gungame.targetOrigin.y, 0, 1 - Gungame.circleSizes[Gungame.round], "Linear" ) 

	Gungame.roundTargetRadius = Gungame.startRadius * Gungame.circleSizes[Gungame.round]

	setTime(time, 0)

end
addEvent("onClientMatchInProgress", true)


function Gungame.playerWin(message)

	Gungame.winMessage = OnScreenMessage.new(message, 0.5, "#04B404", 3, 5000)

end
addEvent("onClientPlayerWin", true)


function Gungame.ringClosingWarning()

	Gungame.ringClosingCountDown = OnScreenMessage.new("Wall moving in ", 0.5, "#ff0000", 2, Gungame.wallClosingWarnTime, false, true, true)

end


function Gungame.showMap()

	if lobbyActive then return end
	
	Gungame.showingMap = not Gungame.showingMap

end


function Gungame.mapInfo()

	if Gungame.mapInfoShown then return end
	
	Gungame.mapInfoShown = true
	
	Gungame.mapInfoMessage = OnScreenMessage.new("Press 'M' to show the Map", 0.75, "#ffffff", 2, 3000, true)	

end


function Gungame.vehicleEnter(player)

	if player ~= localPlayer then return end
	
	if not getElementData(source, "fuel") then return end

	if getElementData(source, "fuel") == 0 then
	
		setVehicleEngineState(source, false)
		return
		
	end

end


function Gungame.getWallProgress()

	if not Gungame.wall then return end
	
	if not Gungame.moving then return 0 end
	
	local progress = (getTickCount() - Gungame.moveStartTime) / Gungame.roundDuration
			
	return math.min(progress, 1)

end
export_getWallProgress = Gungame.getWallProgress


function Gungame.chooseCharacter()

	local arenaElement = getElementParent(localPlayer)

	Gungame.choosingCharacter = true

	Gungame.chooseCharacterMessage = OnScreenMessage.new("Choose your character", 0.25, "#ffffff", 3)

	Gungame.chooseCharacterInstructionMessage = OnScreenMessage.new("<"..Gungame.skinIndex.."/"..#Gungame.skins..">\n"..Gungame.chooseCharacterInstructionText, 0.75, "#ffffff", 1)

	setElementModel(localPlayer, Gungame.character)

	toggleAllControls(false, true, false)
	
	setElementFrozen(localPlayer, true)

	local x, y, z = getElementPosition(localPlayer)
	
	local cameraPosition = localPlayer.matrix.position + localPlayer.matrix.forward * 5

	setCameraMatrix(cameraPosition.x, cameraPosition.y, cameraPosition.z, x, y, z)

	addEventHandler("onClientKey", root, Gungame.keyClick)
	addEventHandler("onClientPlayerDamage", localPlayer, Gungame.preventDamage)

	if Gungame.waitingMessage then
	
		Gungame.waitingMessage:setVisible(false)
		
	end
	
	if Gungame.matchStartCountdown then
	
		Gungame.matchStartCountdown:setVisible(false)
		
	end	

	setElementDimension(localPlayer, math.random(30000))

end


function Gungame.stopChooseCharacter()

	local arenaElement = getElementParent(localPlayer)

	if Gungame.chooseCharacterInstructionMessage then
	
		Gungame.chooseCharacterInstructionMessage:destroy()
		Gungame.chooseCharacterInstructionMessage = nil
		
	end

	if Gungame.chooseCharacterMessage then
	
		Gungame.chooseCharacterMessage:destroy()
		Gungame.chooseCharacterMessage = nil
		
	end

	Gungame.choosingCharacter = false
	
	setCameraTarget(localPlayer, localPlayer)
	
	toggleAllControls(true, true, true)
	
	setElementFrozen(localPlayer, false)

	if Gungame.waitingMessage then
	
		Gungame.waitingMessage:setVisible(true)
		
	end
	
	if Gungame.matchStartCountdown then
	
		Gungame.matchStartCountdown:setVisible(true)
		
	end
	
	setElementDimension(localPlayer, getElementDimension(arenaElement))
	
	removeEventHandler("onClientKey", root, Gungame.keyClick)
	removeEventHandler("onClientPlayerDamage", localPlayer, Gungame.preventDamage)

	triggerServerEvent("onPlayerChooseCharacter", localPlayer, Gungame.character)

end


function Gungame.keyClick(button, pressOrRelease)

	if not pressOrRelease then return end

	if isCursorShowing() then return end
	
	if isChatBoxInputActive() then return end

	if isConsoleActive() then return end
	
	if isMainMenuActive() then return end

	if button == "arrow_l" then
	
		Gungame.skinIndex = Gungame.skinIndex - 1
	
		if Gungame.skinIndex < 1 then 
		
			Gungame.skinIndex = #Gungame.skins
			
		end

		Gungame.character = Gungame.skins[Gungame.skinIndex]
	
		setElementModel(localPlayer, Gungame.character)
	
		Gungame.chooseCharacterInstructionMessage:setText("<"..Gungame.skinIndex.."/"..#Gungame.skins..">\n"..Gungame.chooseCharacterInstructionText, 0.75, "#ffffff", 1)
	
	elseif button == "arrow_r" then
	
		Gungame.skinIndex = Gungame.skinIndex + 1
	
		if Gungame.skinIndex > #Gungame.skins then 
		
			Gungame.skinIndex = 1
			
		end
	
		Gungame.character = Gungame.skins[Gungame.skinIndex]
	
		setElementModel(localPlayer, Gungame.character)
	
		Gungame.chooseCharacterInstructionMessage:setText("<"..Gungame.skinIndex.."/"..#Gungame.skins..">\n"..Gungame.chooseCharacterInstructionText, 0.75, "#ffffff", 1)
	
	elseif button == "enter" then
	
		Gungame.stopChooseCharacter()
	
	end

end


function Gungame.preventDamage()

	cancelEvent()

end


-- HUD
	local Fuente = dxCreateFont('Fuente.ttf',15)

function Renderizar()
	local screenW, screenH = guiGetScreenSize()
	-- Evitamos el renderizado erroneo del HUD
	if not localPlayer:getData('GG:Nivel') then return end
	-- Se crea la fuente y prosige a dibujar el texto con el nivel del jugador
	dxDrawText(
		'#fb6d0cNivel actual: #FFFFFF'..localPlayer:getData('GG:Nivel')..
		'\n#fb6d0cAsesinatos: #FFFFFF'..localPlayer:getData('GG:Asesinatos'),
		screenW * 0.8049, screenH * 0.8878, screenW * 0.9583, screenH * 0.9333, tocolor(254, 254, 254, 255), 1.00,Fuente, "center", "center", false, false, false, true, false)
end
addEventHandler('onClientRender',root,Renderizar)