addEventHandler( "onClientResourceStart", resourceRoot, explosion )

local marker = createMarker( 4927.2001953125, -2928.599609375, 5363.2001953125,"corona",10,0,0,0);
local lp = getLocalPlayer();

function markerExplosion (hitElement,matchingDimension)

	if hitElement == lp then
		createExplosion( 4894.3999023438, -2877.6000976563, 5374.5, 6);
		destroyElement(marker);
	end
end
addEventHandler("onClientMarkerHit",marker,markerExplosion);