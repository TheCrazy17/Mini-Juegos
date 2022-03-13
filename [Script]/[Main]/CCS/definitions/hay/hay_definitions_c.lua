Hay = {}

Hay.VisibleAnnounce = false
Hay.maxReached = 0
Hay.Leaders = {}

rich_visible = false;

Hay['sX'], Hay['sY'] = guiGetScreenSize()

function Hay.resetClient()
	setCameraTarget ( localPlayer )
	Hay.VisibleAnnounce = true;

	setTimer ( toggleControl, 2000, 1, "fire", false )

	setTimer(function()
		Hay.VisibleAnnounce = false;
	end, 5000, 1)

	anim_startTime = getTickCount();
	anim_endTime = anim_startTime + 1000;
		
	Hay.maxReached = 0
end
addEvent("onClientResetHay", true)

function Hay.load()
	setPlayerHudComponentVisible("weapon", true)
	setPlayerHudComponentVisible("ammo", true)
	setPlayerHudComponentVisible("radio", true)
	setPlayerHudComponentVisible("health", true)
	setPlayerHudComponentVisible("crosshair", true)
	setPlayerHudComponentVisible("armour", true)
	setPlayerHudComponentVisible("clock", true)

	addEventHandler("onClientResetHay", root, Hay.resetClient)
	addEventHandler("onClientRender", root, Hay.Render)

	Hay.resetClient()
end
addEvent("onClientSetUpHayDefinitions", true)
addEventHandler("onClientSetUpHayDefinitions", root, Hay.load)


function Hay.unload()
	removeEventHandler("onClientResetHay", root, Hay.resetClient)
	removeEventHandler("onClientSetDownHayDefinitions", root, Hay.unload)
	removeEventHandler("onClientRender", root, Hay.Render)	

	setPlayerHudComponentVisible("weapon", false)
	setPlayerHudComponentVisible("ammo", false)
	setPlayerHudComponentVisible("health", false)
	setPlayerHudComponentVisible("armour", false)
	setPlayerHudComponentVisible("clock", false)
	setPlayerHudComponentVisible("radio", false)
end
addEvent("onClientSetDownHayDefinitions", true)

function Hay.Render()
	local arenaElement = getElementParent(localPlayer)	

	local _, _, Z = getElementPosition(localPlayer)
	local cLevel = math.floor(Z  / 3 - 0.5)
	
	if cLevel > Hay.maxReached then
		Hay.maxReached = cLevel
	end

	Hay.Leaders = {}
	local maxLevel = 0

	for _, Player in ipairs(getAlivePlayersInArena(arenaElement)) do
		local _, _, Z = getElementPosition(Player)
		local pLevel = math.floor(Z  / 3 - 0.5)
		
		if pLevel ~= 0 then
			if pLevel > maxLevel then
				maxLevel = pLevel
				
				Hay.Leaders = {}
				table.insert(Hay.Leaders, Player)
			elseif pLevel == maxLevel then
				table.insert(Hay.Leaders, Player)
			end
		end
	end

	local leaderText = ""

	if #Hay.Leaders == 1 then
		leaderText = "#2ed781Líder: #FFFFFF".. Hay.Leaders[1].name .." #FFFFFF("..maxLevel..")"
	elseif #Hay.Leaders > 1 then
		leaderText = "#2ed781Líderes: #FFFFFF"

		for i = 1, #Hay.Leaders do
			if i == 1 then
				leaderText = leaderText .. Hay.Leaders[i].name
			else
				
				leaderText = leaderText .. ", #FFFFFF"..Hay.Leaders[i].name
			end
		end

		leaderText = leaderText.. " #FFFFFF("..maxLevel..")"
	else
		leaderText = "#2ed781Líder: #FFFFFF-"
	end

	dxDrawText("#2ed781Tú nivel: #FFFFFF"..cLevel.."\n#2ed781Máximo alcanzado: #FFFFFF"..Hay.maxReached.."\n\n"..leaderText, Hay.sX * 0.3992, Hay.sY * 0.0486, Hay.sX * 0.6008, Hay.sY * 0.1208, tocolor(0, 223, 0, 255), 1.00, "default-bold", "center", "center", false, false, false, true, false)

	if ( Hay.VisibleAnnounce == true ) then
		local now = getTickCount();
		local elapsed = now - anim_startTime;
		local duration = anim_endTime - anim_startTime;
		local progress = elapsed / duration;

		local scale = interpolateBetween ( 1.6, 0, 0, 2, 0, 0, progress, "CosineCurve")
		dxDrawText("¡Llega hasta la cima del pajar!", 1, Hay.sY / 2 - 20, Hay.sX, Hay.sY / 2 + 20, tocolor(0, 0, 0, 255), scale, "sans", "center", "center", false, false, false, false, false)
        dxDrawText("¡Llega hasta la cima del pajar!", 0, Hay.sY / 2 - 21, Hay.sX, Hay.sY / 2 + 20, tocolor(135, 255, 0, 255), scale, "sans", "center", "center", false, false, false, false, false)
	end
end