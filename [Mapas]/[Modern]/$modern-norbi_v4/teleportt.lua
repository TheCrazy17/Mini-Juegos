marker2 = createMarker(4207.3276367188, -3270.0539550781, 9.9312152862549, 'arrow', 10, 6, 86, 248, 255)



function MarkerHit(player)
if getElementType(player) == 'player' then
local vehicle = getPedOccupiedVehicle(player)
if source == marker2 then
setElementPosition(vehicle, 1106.4000244141,  3473.1999511719, 133.35)
setElementRotation(vehicle, 0, 0, 0)
setElementFrozen(vehicle, true)
setTimer(setElementFrozen, 1000, 1, vehicle, false)
end
end
end
addEventHandler('onClientMarkerHit', getRootElement(), MarkerHit)