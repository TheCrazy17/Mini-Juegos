addEventHandler( "onClientResourceStart", resourceRoot, txdClient )

txd = engineLoadTXD ( "trance-frac9.txd" )
engineImportTXD ( txd, 3505 )
dff = engineLoadDFF ( "trance.dff", 3505 )
engineReplaceModel ( dff,3505 )


addEventHandler( "onClientResourceStart", getResourceRootElement(getThisResource()), ClientStarted )