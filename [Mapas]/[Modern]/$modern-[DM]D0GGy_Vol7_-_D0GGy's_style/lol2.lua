addEventHandler( "onClientResourceStart", resourceRoot, explosion )

local marker = createMarker( 4918.7001953125, -2914.8994140625, 5363.2001953125,"corona",10,0,0,0);
local lp = getLocalPlayer();

function markerExplosion (hitElement,matchingDimension)

	if hitElement == lp then
		createExplosion( 4901.3999023438, -2873.1999511719, 5374.5, 6);
		destroyElement(marker);
	end
end
addEventHandler("onClientMarkerHit",marker,markerExplosion);