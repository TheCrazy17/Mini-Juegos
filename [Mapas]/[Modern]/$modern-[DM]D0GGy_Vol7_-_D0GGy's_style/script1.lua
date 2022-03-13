function replaceModel() 
  txd = engineLoadTXD("Electricgate.txd", 969 )
  engineImportTXD(txd, 969)
  dff = engineLoadDFF("electricgate.dff", 969 )
  engineReplaceModel(dff, 969)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

addCommandHandler ( "reloadcar", replaceModel )