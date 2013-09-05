local entData = {'ship'}

-- Declare class
entData.entClass = Actor

-- Declare behaviours
-- Could load behaviour packs with lfs.load here, or possibly from a global table
entData.bhvs = {'tractorBeam','repelBeam'}

local w,h = 20,35
local points = {0,0,w,0,w/2,h}

-- Declare components
entData.compList = {
	{
		PhysCompName,
		entClass = PhysComponent,
		name = PhysCompName,
		
		bodyFuncs = {
			setLinearDamping = 0.3,
			setAngularDamping = 0.4,
		},
		fixDefs = {
			{
			shapeDef = {'polygon',data = points},
			fixFuncs = {setRestitution = 0.9},
			},
		},
	},
	{
		DrawCompName,
		entClass = DrawPhysComponent,
		name = DrawCompName,
		
		imgData = {w = w,h = h,imgType = 'polygon',shapeData = points,rgba = {0,255,255}},
		--imgFileName = 'test.png',
		offset = vector(0,0),
	},
}

return entData;

--[[
local ent = Derive("base")

ent.forceMag = 200
ent.forceDir = vector(0,0)
ent.forceVec = vector(0,0)

function ent:init(entData)
	self.body = love.physics.newBody(game.level.layers[self.layerName]:getWorld(),entData.pos.x,entData.pos.y,entData.physType or 'dynamic')
	self.polyPoints = entData.polyPoints
	local shape = love.physics.newPolygonShape(self.polyPoints[1],self.polyPoints[2],self.polyPoints[3],self.polyPoints[4],self.polyPoints[5],self.polyPoints[6])
	local fixture = love.physics.newFixture(self.body,shape,entData.density or 1.0)
	
	fixture:setRestitution(0.9)
	self.body:setLinearDamping(3)
	self.body:setAngularDamping(10)
	
	self.fpx = self.polyPoints[5]
	self.fpy = (3/4)*self.polyPoints[6]
	
	self.pivotPoint = vector(self.polyPoints[5],(2/5)*self.polyPoints[6])
	
	self.player = entData.player
	fixture:setUserData(self)
end

function ent:printType()
	print(self.type)
end

function ent:getType()
	return self.type
end

function ent:getBody()
	return self.body
end

function ent:getPivotPoint()
	return self.pivotPoint
end

function ent:draw()
	love.graphics.setColor(0,255,255)
	love.graphics.polygon('fill',self.body:getWorldPoints(self.polyPoints[1],self.polyPoints[2],self.polyPoints[3],self.polyPoints[4],self.polyPoints[5],self.polyPoints[6]))
	love.graphics.reset()
end

function ent:force(x,y)
	self.forceDir.x = self.forceDir.x + x
	self.forceDir.y = self.forceDir.y + y
	self.forceVec = self.forceDir:normalized()*self.forceMag
end

function ent:update(dt)
	local wx,wy = self.body:getWorldPoint(self.fpx,self.fpy) 
	self.body:applyForce(self.forceVec.x, self.forceVec.y, wx, wy)
end

return ent;
]]