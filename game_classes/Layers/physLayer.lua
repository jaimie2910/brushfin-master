PhysLayer = class('PhysLayer',VectorEntity)
PhysLayerName = PhysLayer.name

function PhysLayer:setIntrinsicData(entDef)
	VectorEntity.setIntrinsicData(entDef)
end

function PhysLayer:initialize(entDef,owner)
	local world = lp.newWorld(entDef.gx,entDef.gy,entDef.sleep)
	setPhysWorld(world)
	
	self.world = world
	VectorEntity.initialize(self,entDef,owner)
end

function PhysLayer:update(dt)
	self.world:update(dt)
	VectorEntity.update(self,dt)
end