local ent = {}

function ent:init(entData)
	self.body = love.physics.newBody(game.level.layers[self.layerName]:getWorld(),entData.pos.x,entData.pos.y,entData.physType or 'static')
	self.polyPoints = entData.polyPoints
	local shape = love.physics.newChainShape(entData.loop or true, self.polyPoints[1],self.polyPoints[2],self.polyPoints[3],self.polyPoints[4],self.polyPoints[5],self.polyPoints[6],self.polyPoints[7],self.polyPoints[8])
	local fixture = love.physics.newFixture(self.body,shape,entData.density or 1.0)
	fixture:setUserData(self)
end

function ent:printType()
	print(self.type)
end

function ent:getType()
	return self.type
end

return ent;