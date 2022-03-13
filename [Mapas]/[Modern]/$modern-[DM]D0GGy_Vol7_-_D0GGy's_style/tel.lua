marker = createMarker(3261.5, -483.29998779297, 4192.6000976563, "corona", 3.5, 255, 0, 0, 255)

function teleport(player)
if getElementType(player)=="player" then
local vehicle=getPedOccupiedVehicle(player)
if source == marker then
setElementPosition(vehicle, 202.80000305176, 2502.8000488281, 58.2000)
setVehicleFrozen(vehicle, true)
setTimer(setVehicleFrozen, 1000, 1, vehicle, false)
end
end
end
addEventHandler("onClientMarkerHit", getRootElement(), teleport) 