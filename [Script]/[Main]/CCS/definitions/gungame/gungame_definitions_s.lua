Gungame = {}

--Gungame.Weapons = {22,23,24,25,26,27,28,29,32,30,31,33,34,37,18,16,35,39,38,4}
Gungame.Weapons = {31}

Gungame.round = {}
Gungame.spawns = {}

Gungame.time = {}

function Gungame.load()

	outputDebugString(getElementID(source)..": Loading Gungame Definitions")

	addEventHandler("onUnloadGungameDefinitions", source, Gungame.unload)
	addEventHandler("onPlayerRequestSpawn", source, Gungame.spawn)
	addEventHandler("onMapChange", source, Gungame.mapChange)
	addEventHandler("onCountdownStart", source, Gungame.doCountdown)
	addEventHandler("onMapStart", source, Gungame.mapStart)
	addEventHandler("onPlayerJoinArena", source, Gungame.join)
	addEventHandler("onPlayerLeaveArena", source, Gungame.quit)
	addEventHandler("onMatchStart", source, Gungame.matchStart)
	addEventHandler("onRoundEnd", source, Gungame.roundEnd)
	addEventHandler("onRoundStart", source, Gungame.roundStart)
	addEventHandler("onPlayerWasted", source, Gungame.playerDeath)
	addEventHandler("onMapEnd", source, Gungame.mapEnd)
	addEventHandler("onMapLoading", source, Gungame.mapLoading)
	addEventHandler("onArenaReset", source, Gungame.reset)
	addEventHandler("onPreMapEnd", source, Gungame.preMapEnd)	
	
	Gungame.time[source] = {}
	
	local mode = getElementData(source, "mode")
	local type = getElementData(source, "type")
	local map = MapManager.findMap("GunGame - "..mode, type)
	
	local map2 = MapManager.getRandomArenaMap('Gungame')

	triggerEvent("onStartNewMap", source, map2, false)

	outputDebugString("[GUNGAME] Cargando definitions...")
	outputDebugString("[GUNGAME] MAPA: "..tostring(map2))
	outputDebugString("[GUNGAME] MAPA: "..tostring(map2[1]))
	
	spawns = MapManager.getSpawnpoints(source)
	outputDebugString(tostring(spawns))
end
addEvent("onLoadGungameDefinitions", true)
addEventHandler("onLoadGungameDefinitions", root, Gungame.load)


function Gungame.unload()
	outputDebugString(getElementID(source)..": Unloading GunGame Definitions")

	removeEventHandler("onUnloadGungameDefinitions", source, Gungame.unload)
	removeEventHandler("onPlayerRequestSpawn", source, Gungame.spawn)
	removeEventHandler("onMapChange", source, Gungame.mapChange)
	removeEventHandler("onCountdownStart", source, Gungame.doCountdown)
	removeEventHandler("onMapStart", source, Gungame.mapStart)
	removeEventHandler("onPlayerJoinArena", source, Gungame.join)
	removeEventHandler("onPlayerLeaveArena", source, Gungame.quit)
	removeEventHandler("onMatchStart", source, Gungame.matchStart)
	removeEventHandler("onRoundEnd", source, Gungame.roundEnd)
	removeEventHandler("onRoundStart", source, Gungame.roundStart)	
	removeEventHandler("onPlayerWasted", source, Gungame.playerDeath)	
	removeEventHandler("onMapEnd", source, Gungame.mapEnd)
	removeEventHandler("onMapLoading", source, Gungame.mapLoading)
	removeEventHandler("onArenaReset", source, Gungame.reset)
	removeEventHandler("onPreMapEnd", source, Gungame.preMapEnd)	
end
addEvent("onUnloadGungameDefinitions", true)


function Gungame.reset()

	if isTimer(Arena.timers[source].secondaryTimer) then killTimer(Arena.timers[source].secondaryTimer) end
	if isTimer(Arena.timers[source].primaryTimer) then killTimer(Arena.timers[source].primaryTimer) end
	
	Gungame.time[source] = {}
	
end
addEvent("onArenaReset")


function Gungame.mapChange(map)

	setElementData(source, "state", "Waiting")

end
addEvent("onMapChange")


function Gungame.playerDeath(totalAmmo, killer)
	if not isElement(source) then return end

	local arenaElement = getElementParent(source)

	if getElementData(source, "state") ~= "Alive" then return end

	if killer and getElementType(killer) == "vehicle" then
		killer = getVehicleOccupant(killer)
	end

	if isElement(killer) and killer ~= source then
		local myPlayerName = getPlayerName(source)
		local hisPlayername = getPlayerName(killer)

		triggerClientEvent(arenaElement, "onClientCreateMessage", source, "#ffffff"..myPlayerName.." #00fffffue asesinado por #ffffff"..hisPlayername)
	else
		triggerClientEvent(arenaElement, "onClientCreateMessage", arenaElement, getPlayerName(source).."#ff0000 murió!", "right")	
	end

	setTimer(Gungame.spawnPlayer, 3000, 1, source)
	--Gungame.spawnPlayer(source)
	
	if not isElement(killer) then return end

	local tKills = killer:getData('GG:Asesinatos') + 1
	local nNivel = math.floor ( tKills/2 ) + 1 -- Se obtiene el nivel del jugador en base a los asesinatos de este

	-- Actualiza los datos ( para el scoreboard )
	killer:setData ( "GG:Asesinatos", tKills )
	killer:setData ( "GG:Nivel", nNivel )

	if not Gungame.Weapons[nNivel] then
		-- Si es que se a llegado al nivel maximo, entonces finalizar la ronda y declararlo como ganador.
		--terminarRonda( jugador )
		triggerEvent("onRoundEnd", arenaElement, killer)
		return
	end

	Gungame.giveWeapon(killer)
		--[[return 
	end

	if getElementData(arenaElement, "state") ~= "In Progress" then return end
	
	triggerEvent("onPlayerGungameWasted", source, #getAlivePlayersInArena(arenaElement))

	triggerClientEvent(source, "onClientRequestSpectatorMode", source)

	setElementData(source, "state", "Dead")

	setElementAlpha(source, 0)

	if #getAlivePlayersInArena(arenaElement) == 1  then

		local alivePlayers = getAlivePlayersInArena(arenaElement)
		
		triggerClientEvent(arenaElement, "onClientPlayerWin", alivePlayers[1], "#ffffff"..getPlayerName(alivePlayers[1]).."#04B404 has won as last player alive!")

		triggerEvent("onPlayerWin", alivePlayers[1], getCleanPlayerName(alivePlayers[1]))

		triggerEvent("onPreMapEnd", arenaElement)

	end
]]
end


function Gungame.spawn()
	
	local arenaElement = getElementParent(source)

	outputServerLog(getElementID(arenaElement)..": Spawn Request by: "..getPlayerName(source))

	if getElementData(source, "Spectator") then

		triggerClientEvent(source, "onClientRequestSpectatorMode", source, true)
		triggerClientEvent(source, "onClientPlayerReady", arenaElement, getElementData(arenaElement, "Duration"), Core.getTimePassed(arenaElement), Gungame.getWaitingTime(arenaElement))

		Gungame.sendMatchData(source)

		return

	end

	--[[
	if getElementData(arenaElement, "state") ~= "Waiting" and getElementData(arenaElement, "state") ~= "Countdown" then 
	
		triggerClientEvent(source, "onClientRequestSpectatorMode", source, true)
		triggerClientEvent(source, "onClientPlayerReady", arenaElement, getElementData(arenaElement, "Duration"), Core.getTimePassed(arenaElement), Gungame.getWaitingTime(arenaElement))	
		
		Gungame.sendMatchData(source)
		
		return 
		
	end]]

	Gungame.spawnPlayer(source)
	
	triggerClientEvent(source, "onClientPlayerReady", arenaElement, getElementData(arenaElement, "Duration"), Core.getTimePassed(arenaElement), Gungame.getWaitingTime(arenaElement))	

	local readyPlayers = #getAlivePlayersInArena(arenaElement)	
	
	if readyPlayers < 2 then return end

	if not isTimer(Arena.timers[arenaElement].secondaryTimer) and getElementData(arenaElement, "state") ~= 'In Progress' then
		outputChatBox("Ahora debería empezar el gungame :) Duración: "..getElementData(arenaElement, "Duration"))

		--Gungame.mapStart()
		triggerEvent("onMapStart", arenaElement, getElementData(arenaElement, "map"))
		
		--end

		--[[setElementData(arenaElement, "state", "In Progress")
		
		triggerEvent("onRoundStart", arenaElement)

		local currentPlayers = getAlivePlayersInArena(arenaElement)

		for _, Player in ipairs(currentPlayers) do
			outputChatBox("Asignando datos a "..getPlayerName(Player))
	
			Player:setData ( "GG:Nivel", 1 )
			Player:setData ( "GG:Asesinatos", 0 )
			Player:setData ( "GG:Muertes", 0 )
			
			triggerClientEvent(v, "onClientMapStart",
		end]]
		--for k, v in ipairs(getAlivePlayersInArena(arenaElement)) do
			--giveWeapon(v, 31, 500)
		--end
		--triggerEvent("onCountdownStart", arenaElement)

	end
	
end
addEvent("onPlayerRequestSpawn", true)

function Gungame.giveWeapon(player)
	if not isElement(player) then return end
	
	local pLevel = player:getData('GG:Nivel')

	if not Gungame.Weapons[pLevel] then return end

	takeAllWeapons(player)

	player:giveWeapon(Gungame.Weapons[pLevel], 500, true)
end

function Gungame.spawnPlayer(player)

	local arenaElement = getElementParent(player)

	local mode = getElementData(arenaElement, "mode")

	local spawns = MapManager.getSpawnpoints(arenaElement)

	local spawn = spawns[math.random(1, #spawns)]
	
	spawnPlayer(player, spawn.posX, spawn.posY, spawn.posZ, 0, 0, 0, getElementDimension(arenaElement))
	setPedHeadless(player, false)
	setElementAlpha(player, 255)
	setElementFrozen(player, false)
	setElementRotation(player, 0, 0, 0)
	setElementData(player, "state", "Alive")
	setCameraTarget(player, player)
	toggleAllControls(player, true, true, true)
	toggleControl(player, "fire", true)
	toggleControl(player, "action", true)
	toggleControl(player, "aim_weapon", true)
	setPedOnFire(player, false)
	setPedStat(player, 160, 1000)
	setPedStat(player, 229, 1000)
	setPedStat(player, 230, 1000)
	setPedStat(player, 69, 1000)
	setPedStat(player, 70, 1000)
	setPedStat(player, 71, 1000)
	setPedStat(player, 72, 1000)
	setPedStat(player, 73, 1000)
	setPedStat(player, 74, 1000)
	setPedStat(player, 75, 1000)
	setPedStat(player, 76, 1000)
	setPedStat(player, 77, 1000)
	setPedStat(player, 78, 1000)
	setPedStat(player, 79, 1000)

	Gungame.giveWeapon(player)
end


function Gungame.sendMatchData(player)

	local arenaElement = getElementParent(player)

	if Gungame.origin[arenaElement].x then
	
		if isTimer(Arena.timers[arenaElement].secondaryTimer) then 
		
			local timeLeft = getTimerDetails(Arena.timers[arenaElement].secondaryTimer)
			
			local mode = getElementData(arenaElement, "mode")
			
			triggerClientEvent(player, "onClientMatchInProgress", arenaElement, Gungame.cirlceOrigins[mode], Gungame.origin[arenaElement], Gungame.startRadius, Gungame.round[arenaElement], Gungame.roundDuration, 	Gungame.wallMoving[arenaElement], timeLeft, Gungame.time[arenaElement])
			
		end
			
	end	

end


function Gungame.doCountdown()
	
	setElementData(source, "state", "Countdown")
	
	Arena.timers[source].secondaryTimer = setTimer(triggerEvent, getElementData(source, "timer:waitingForPlayers"), 1, "onMapStart", source, getElementData(source, "map"))

	triggerClientEvent(source, "onClientCountdownStart", source, getElementData(source, "timer:waitingForPlayers"))

	outputServerLog(getElementID(source)..": Countdown Start")

end
addEvent("onCountdownStart", true)
--addCommandHandler("abc", function(p) 	local arenaElement = getElementParent(p) triggerEvent("onCountdownStart", arenaElement) end)
--addCommandHandler("ghi", function(p) givePedJetPack (p)   end) 

function Gungame.mapStart()

	outputServerLog(getElementID(source)..": Map Start")

	setElementData(source, "state", "In Progress")

	for i, p in pairs(getAlivePlayersInArena(source)) do
	
		takeAllWeapons(p)
		
		setElementHealth(p, 100)
		
		outputChatBox("Asignando datos a "..getPlayerName(p))
	
		p:setData ( "GG:Nivel", 1 )
		p:setData ( "GG:Asesinatos", 0 )
		p:setData ( "GG:Muertes", 0 )
		
		Gungame.giveWeapon(p)
		
	end

	--Arena.timers[source].primaryTimer = setTimer(outputChatBox, getElementData(source, "Duration"), 1, "fin del tiempo de la ronda", root, 255, 0, 0)
	Arena.timers[source].primaryTimer = setTimer(triggerEvent, getElementData(source, "Duration"), 1, "onRoundEnd", source)
	--triggerEvent, Gungame.roundDuration, 1, "onRoundEnd", source
	--Arena.timers[source].secondaryTimer = setTimer(triggerEvent, Gungame.planeFlyTime, 1, "onPlaneReachFinalPosition", source)

	Gungame.time[source] = math.random(0, 23)

	outputChatBox(tostring(Gungame.time[source]))
	triggerClientEvent(source, "onClientMapStart", source, getElementData(source, "map"), Gungame.time[source])

end
addEvent("onMapStart", false)


function Gungame.mapEnd()
	
	setElementData(source, "state", "End")

	triggerClientEvent(source, "onClientMapEnding", source, "Next match starts in: ", 7000)
		
	Arena.timers[source].secondaryTimer = setTimer(triggerEvent, 7000, 1, "onMapLoading", source)

end
addEvent("onMapEnd", false)


function Gungame.preMapEnd(timeUp)

	if getElementData(source, "state") ~= "In Progress" then return end

	setElementData(source, "state", "End")

	if isTimer(Arena.timers[source].secondaryTimer) then killTimer(Arena.timers[source].secondaryTimer) end

	if getElementData(source, "podium") then

		Arena.timers[source].secondaryTimer = setTimer(triggerEvent, 3000, 1, "onMapEnd", source)

		triggerClientEvent(source, "onClientPreMapEnd", source, "Map will end in: ", 3000, timeUp)

	else
	
		triggerEvent("onMapEnd", source)
	
	end

end
addEvent("onPreMapEnd", true)


function Gungame.mapLoading()

	local mode = getElementData(source, "mode")
	local type = getElementData(source, "type")
	--local map = MapManager.findMap("Battle Royale - "..mode, type)

	--triggerEvent("onStartNewMap", source, map[1], true)


	local map2 = MapManager.getRandomArenaMap('Gungame')

	triggerEvent("onStartNewMap", source, map2, true)
	
	outputChatBox("CARGANDO NUEVO MAPA", root, 255, 0, 0)
end
addEvent("onMapLoading", true)

function Gungame.join()
	local arenaElement = getElementParent(source)
	local state = getElementData(arenaElement, "state")

	if state == 'In Progress' then
		outputChatBox("Asignando datos")
	
		source:setData ( "GG:Nivel", 1 )
		source:setData ( "GG:Asesinatos", 0 )
		source:setData ( "GG:Muertes", 0 )
	end

	outputChatBox(getPlayerName(source).." ingresó a "..getElementData(arenaElement, "name"))
	outputChatBox("Estado de la arena: "..tostring(getElementData(arenaElement, "state")))
end
addEvent("onPlayerJoinArena", true)

function Gungame.quit()
	local arenaElement = getElementParent(source)	

	source:removeData ( "GG:Nivel")
	source:removeData ( "GG:Asesinatos")
	source:removeData ( "GG:Muertes")
	--[[if getElementData(arenaElement, "state") == "Waiting" or getElementData(arenaElement, "state") == "Countdown" then

		local readyPlayers = #getAlivePlayersInArena(arenaElement) - 1
		
		if readyPlayers < 2 then
		
			if isTimer(Arena.timers[arenaElement].secondaryTimer) then killTimer(Arena.timers[arenaElement].secondaryTimer) end
		
			triggerEvent("onMapLoading", arenaElement)
		
		end
		
	end
	]]
end
addEvent("onPlayerLeaveArena", true)

function Gungame.matchStart()

	outputServerLog(getElementID(source)..": Match Start")

	Gungame.origin[source].x, Gungame.origin[source].y = Gungame.getRandomOrigin()

	local mode = getElementData(source, "mode")

	triggerClientEvent(source, "onClientMatchStart", source, Gungame.cirlceOrigins[mode], Gungame.origin[source], Gungame.startRadius)	

	triggerEvent("onRoundStart", source)

end
addEvent("onMatchStart", false)


function Gungame.roundStart()

		for i, p in pairs(getAlivePlayersInArena(source)) do
	
	triggerClientEvent(p, "onClientRoundStart", source, Gungame.round[source], Gungame.roundDuration)	
	end
	--[[Gungame.round[source] = Gungame.round[source] + 1

	outputServerLog(getElementID(source)..": Round "..Gungame.round[source].." Start")

	Gungame.wallMoving[source] = false

	triggerClientEvent(source, "onClientRoundStart", source, Gungame.round[source], Gungame.roundDuration)	

	Arena.timers[source].secondaryTimer = setTimer(triggerEvent, Gungame.roundDuration, 1, "onRoundEnd", source)
]]
end
addEvent("onRoundStart", false)


function Gungame.roundEnd(Winner)
	if isElement(Winner) then
		-- Si hay un ganador se informa de este.
		outputChatBox ( Winner.name .. " A GANADO LA RONDA!", root, 0, 255, 0)
	else
		-- Si es que no lo hay, se busca al jugador con mas asesinatos.
		local nmaxasesinatos = 0
		for k,v in ipairs(getAlivePlayersInArena(source)) do
			local nasesinatos = v:getData('GG:Asesinatos') or 0
			if nasesinatos > nmaxasesinatos then
				Winner = v
				nmaxasesinatos = nasesinatos
			elseif nasesinatos == nmaxasesinatos then
				Winner = nil
			end
		end

		if Winner then
				outputChatBox ( Winner.name .. " A GANADO LA RONDA!", root, 0, 255, 0)
		else
				outputChatBox ( "LA RONDA A TERMINADO EN EMPATE!", root, 255, 0, 0)
		end
	end
	
	triggerClientEvent(source, "onClientRoundEnd", source)
	
	
	--local map2 = MapManager.getRandomArenaMap('Gungame')

	triggerEvent("onMapEnd", source, map2, false)
	--[[
	if Gungame.round[source] < Gungame.maxRounds then
	
		Arena.timers[source].secondaryTimer = setTimer(triggerEvent, Gungame.roundDuration, 1, "onRoundStart", source)	

	end]]

end
addEvent("onRoundEnd", false)

function Gungame.getWaitingTime(arenaElement)

	if getElementData(arenaElement, "state") ~= "Countdown" then return false end

	if not isTimer(Arena.timers[arenaElement].secondaryTimer) then return false end

	return getTimerDetails(Arena.timers[arenaElement].secondaryTimer)

end