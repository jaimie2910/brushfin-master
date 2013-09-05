local entData = {'turret'}

-- Declare class
entData.entClass = Actor

-- Declare behaviours
-- Could load behaviour packs with lfs.load here, or possibly from a global table
entData.bhvs = {'tractorBeam','repelBeam'}

local w,h = 5,30

-- Declare components
entData.compList = {
	{
		PhysCompName,
		entClass = PhysComponent,
		name = PhysCompName,
		
		bodyFuncs = {
			setLinearDamping = 5,
			setAngularDamping = 4,
		},
		fixDefs = {
			{
			shapeDef = {'basicRectangle',data = {w = w,h = h}},
			fixFuncs = {setRestitution = 0.9},
			},
		},
	},
	{
		DrawCompName,
		entClass = DrawPhysComponent,
		name = DrawCompName,
		
		imgData = {w = w,h = h,imgType = 'rectangle',shapeData = {0,0,w,h},rgba = {255,0,255}},
		offset = vector(-w/2,-h/2),
	},
}

----------------
-- Other Data --
----------------

entData.pivotPt = vector(w/2,h/4)


return entData;

--[[
local ent = {}

function ent:init(entData)
	self.world = game.level.layers[self.layerName]:getWorld()
	self.body = love.physics.newBody(self.world,entData.pos.x,entData.pos.y,entData.physType or 'dynamic')
	self.width = entData.size.width
	self.height = entData.size.height
	self.forceMag = entData.forceMag
	self.beamEffects = entData.beamEffects
	local shape = love.physics.newRectangleShape(self.width,self.height)
	local fixture = love.physics.newFixture(self.body,shape,entData.density or 1.0)
	self.pivotPoint = vector(self.width/2,self.height/4) --point about which the turret pivots on the ship (in turret local co-oridinates)
	self.barrelEnd = vector(self.width/2,self.height)
	fixture:setUserData(self)
	self.firingBeam = false
end

function ent:getBody()
	return self.body
end

function ent:printType()
	print(self.type)
end

function ent:getType()
	return self.type
end

function ent:getPivotPoint()
	return self.pivotPoint
end

function ent:targetPoint(x,y)
	self.objPoint = vector(x,y)
end

function ent:setFiringBeam(beamType)
	if beamType then
		self.firingBeam = true
		self.firingFunc = self.beamEffects[beamType].func
		self.beamColor = self.beamEffects[beamType].color
	else
		self.firingBeam = false
		self.firingFunc = nil
		self.beamColor = nil
	end
end

function ent:fireBeam()

	self.closestFixture = nil
	self.worldBarrelEnd = vector(self.body:getWorldPoint(self.barrelEnd:unpack()))
	local minCollDist = maxRayLength
	self.minCollPoint = self.turretDir*maxRayLength
	
	--'shoot' the beam
	self.world:rayCast(self.worldBarrelEnd.x,self.worldBarrelEnd.y,self.minCollPoint.x,self.minCollPoint.y,beamRayCastCallback)
	
	-- test each fixture to see what is closest
	function beamRayCastCallback(fixture, x, y, xn, yn, fraction)
		if(fixture:getUserData():getType() == 'wall') then return -1 end
		local collPoint = vector(x,y)
		local collDist = (collPoint-self.worldBarrelEnd):len()
		if (collDist < minCollDist) then
			self.minCollPoint = collPoint
			minCollDist = collDist
			ent.closestFixture = fixture
		end
		
		return -1
	end
	
	--If a valid fixture is found
	if self.closestFixture then
		local closestBody = self.closestFixture:getBody()
		self.firingFunc(closestBody,self.minCollPoint,self.worldBarrelEnd,self.forceMag)
	end
	
end

function ent:update(dt)
	local worldPivotPoint = vector(self.body:getWorldPoint(self.pivotPoint:unpack()))
	self.turretDir = self.objPoint - worldPivotPoint
	local turretAngle = -math.atan2(self.turretDir:unpack())
	self.body:setAngle(turretAngle)
	
	if self.firingBeam then
		self:fireBeam()
	end
end

function ent:draw()
	if self.firingBeam then
		love.graphics.setColor(self.beamColor.r,self.beamColor.g,self.beamColor.b)
		love.graphics.line(self.worldBarrelEnd.x,self.worldBarrelEnd.y,self.minCollPoint.x,self.minCollPoint.y)
		love.graphics.reset()
	end
	
	--love.graphics.setColor(0,255,0)
	--love.graphics.line(self.worldBarrelEnd.x,self.worldBarrelEnd.y,self.minCollPoint.x,self.minCollPoint.y)
	--love.graphics.reset()
	
	love.graphics.setColor(255,0,255)
	love.graphics.polygon('fill',self.body:getWorldPoints(0,0,0,self.height,self.width,self.height,self.width,0))
	love.graphics.reset()
end



return ent;
]]