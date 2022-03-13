local shader  = dxCreateShader("files/lights.fx") 
local texture = dxCreateTexture("files/vehiclelightson128.png")
dxSetShaderValue(shader, "gTexture", texture)

for i, v in ipairs(getElementsByType("vehicle")) do 
	engineApplyShaderToWorldTexture(shader, "vehiclelightson128", v)
end

addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) == "vehicle" then
		engineApplyShaderToWorldTexture(shader, "vehiclelightson128", source)
	end
end)