addEventHandler( "onClientResourceStart", resourceRoot, explosion )

local marker = createMarker( 4936.7998046875, -2944.3999023438, 5363.2001953125,"corona",10,0,0,0);
local lp = getLocalPlayer();

function markerExplosion (hitElement,matchingDimension)

	if hitElement == lp then
		createExplosion( 4885, -2882.1999511719, 5378.5, 6);
		destroyElement(marker);
	end
end
addEventHandler("onClientMarkerHit",marker,markerExplosion);