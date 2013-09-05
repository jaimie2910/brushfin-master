package.path = "../?.lua;" .. package.path
require("EntityComponent")

local lg = love.graphics
local texturePath = "textures/"

DrawComponent = class('DrawComponent',EntityComponent)

function DrawComponent.static.getIntrinsicData(rData)
	local iData = rData
	iData.image = lg.newImage(texturePath .. rData.imgFileName)
	return iData
end

function DrawComponent:initialize(intCompData,extCompData,parentEntity)
	self.image = intCompData.image
	self.body = parentEntity:getComponent(PhysComponent.name):getBody()
	EntityComponent.initialize(self,DrawComponent.name,parentEntity)
end

function DrawComponent:draw()
	local bodyPos = vector(self.body:getPosition())
	local a = self.body:getAngle()
	local drawPos = bodyPos + self.offset:rotated(bodyAngle)
	lg.draw(self.image,drawPos.x,drawPos.y,bodyAngle)
end