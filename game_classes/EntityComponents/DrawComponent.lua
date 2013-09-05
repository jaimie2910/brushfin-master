local texturePath = "assets/textures/"

DrawComponent = class('DrawComponent',EntityComponent)
DrawCompName = DrawComponent.name

function DrawComponent.static.setIntrinsicData(entDef)
	if entDef.imgFileName then
		entDef.image = lg.newImage(texturePath .. entDef.imgFileName)
	elseif entDef.imgData then
		local imgData = entDef.imgData
		local imgCanvas = lg.newCanvas(imgData.w,imgData.h)
		lg.setCanvas(imgCanvas)
		lg.setColor(imgData.rgba)
		local imgType = imgData.imgType
		if imgType == 'circle' or imgType == 'polygon' or imgType == 'rectangle' then
			lg[imgData.imgType]('fill',unpack(imgData.shapeData))
		else
			lg[imgData.imgType](unpack(imgData.shapeData))
		end
		lg.reset()
		lg.setCanvas()
		entDef.image = lg.newImage(imgCanvas:getImageData())
	end
end

function DrawComponent:initialize(entDef,owner)
	self.image = entDef.image
	self.offset = entDef.offset
	--owner:requestComponent(PhysCompName)
	EntityComponent.initialize(self,DrawCompName,owner)
end

-- Note the actual draw functions are in derived classes such as DrawPhysComponent and DrawStaticComponent
function DrawComponent:draw()
	print('Error: base DrawComponent:draw() called!!')
end