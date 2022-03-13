function replaceModel() 
  txd = engineLoadTXD("infernus2.txd", 411 )
  engineImportTXD(txd, 411)
  dff = engineLoadDFF("infernus.dff", 411 )
  engineReplaceModel(dff, 411)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

addCommandHandler ( "reloadcar", replaceModel )