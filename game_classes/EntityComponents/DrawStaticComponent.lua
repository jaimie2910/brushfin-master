
DrawStaticComponent = class('DrawStaticComponent',DrawComponent)
DrawStaticCompName = DrawStaticComponent.name

--[[function DrawComponent.static.getIntrinsicData(rData)
	local iData = rData
	iData.image = lg.newImage(texturePath .. rData.imgFileName)
	return iData
end]]

function DrawStaticComponent:initialize(iData,extCompData,owner)
	self.x,self.y,self.a = eData.x,eData.y,eData.a
	DrawComponent.initialize(self,iData,extCompData,owner)
end

function DrawStaticComponent:postPInit()
end

function DrawStaticComponent:draw()
	lg.draw(self.image,self.x,self.y,self.a)
end