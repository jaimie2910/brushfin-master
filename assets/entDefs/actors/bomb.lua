local ent = {}

function ent:init(entData)
	self.image = love.graphics.newImage("textures/meteor1-tractor0.png")
	self.offset = vector(-25,-25)
	
	self.world = game.level.layers[self.layerName]:getWorld()
	self.body = love.physics.newBody(self.world,entData.pos.x,entData.pos.y,entData.physType or 'dynamic')
	self.radius = 20
	local shape = love.physics.newCircleShape(self.radius)
	local fixture = love.physics.newFixture(self.body,shape,entData.density or 1.0)
	fixture:setRestitution(0.9)
	
	self.body:setLinearDamping(2)
	self.body:setAngularDamping(3)
	
	self.maxNormImp = 2
	self.maxTangImp = 2
	
	self.exploding = false
	self.explosionProg = 0
	self.maxExplodingTime = 1.2
	self.explosionRad = 150
	self.expForce = 400
	self.active = true
	self.finalPos = nil
	
	self.body:setLinearVelocity(entData.vel.x or 0,entData.vel.y or 0)
	self.body:setAngularVelocity(entData.vel.a or 0)
	
	fixture:setUserData(self)
end

function ent:printType()
	print(self.type)
end

function ent:getType()
	return self.type
end

function ent:destroy()
	game.level.layers[self.layerName]:destroyEnt(self.id)
end

function ent:postSolveContact(ent,contact,normal_impulse,tangent_impulse)
	print(type(normal_impulse))
	print(type(tangent_impulse))
	if (ent:getType() == 'wall') then print('bomb and wall'); return end
	if (normal_impulse > self.maxNormImp) or (tangent_impulse > self.maxTangImp) then
		self:explode()
	else
		print('Too weak for explosion')
	end
end

function ent:explode()
	print('EXPLOSION')
	self.exploding = true
	self.finalPos = vector(self.body:getX(),self.body:getY())
end

function ent:update(dt)
	if self.exploding then
		if self.active then self.body:setActive(false); self.active = false end
		if self.explosionProg >= 1 then
			self:destroy()
		end
		self.explosionProg = self.explosionProg + dt/self.maxExplodingTime
		
		local expRad = self.explosionRad*self.explosionProg
		self.world:queryBoundingBox(self.finalPos.x-expRad,self.finalPos.y-expRad,self.finalPos.x+expRad,self.finalPos.y+expRad,affectEnts)
		
		function affectEnts(fixture)
			ent = fixture:getUserData()
			if ent == self then print('exploding myself!!!') return end
			local body = fixture:getBody()
			local dispPos = vector(body:getPosition())-self.finalPos
			local distance = dispPos:len()
			if (distance > expRad) then return end
			local bodyExpForce = self.expForce/distance
			body:applyForce(dispPos.x*bodyExpForce,dispPos.y*bodyExpForce)
		end
		
	end
end

function ent:draw()
	love.graphics.setColor(255,0,0,255*(1-self.explosionProg))
	local drawPos = vector(self.body:getPosition()) + self.offset:rotated(self.body:getAngle())
	love.graphics.draw(self.image,drawPos.x,drawPos.y,self.body:getAngle())
	if self.exploding then
		love.graphics.circle('fill',self.body:getX(),self.body:getY(),self.explosionProg*self.explosionRad,64)
	end
	love.graphics.reset()
	return
end

function ent:die()
	self.body:destroy()
end

return ent;