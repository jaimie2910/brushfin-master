local ent = {}

function ent:init(entData)
	self.body = love.physics.newBody(game.level.layers[self.layerName]:getWorld(),entData.pos.x,entData.pos.y,entData.physType or 'static')
	self.radius = 20
	local shape = love.physics.newCircleShape(self.radius)
	local fixture = love.physics.newFixture(self.body,shape,entData.density or 1.0)
	fixture:setRestitution(0.9)
	
	fixture:setUserData(self)
end

function ent:onContact(cEnt)
	if(cEnt:getType() == 'asteroid') then
		score = score + 1
		cEnt:destroy()
	elseif(cEnt:getType() == 'bomb') then
		score = score - 1
	end
end

function ent:printType()
	print(self.type)
end

function ent:getType()
	return self.type
end

function ent:draw()
	love.graphics.circle('fill',self.body:getX(),self.body:getY(),self.radius,32)
end

function ent:die()
end

return ent;
