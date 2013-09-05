local player = {}
player.beams = {}

function player:init(playerData)
	self.ship = playerData.ship
	self.turret = playerData.turret
	
	local localTurretPivotPoint = self.turret:getPivotPoint()
	local localShipPivotPoint = self.ship:getPivotPoint()
	
	local turretBody = self.turret:getBody()
	local shipBody = self.ship:getBody()
	
	local turretPosition = vector(turretBody:getPosition())
	local shipPosition = vector(shipBody:getPosition())
	
	local turretPivot = turretPosition + localTurretPivotPoint
	local shipPivot = shipPosition + localShipPivotPoint
	
	local transVector = turretPivot - shipPivot
	turretBody:setPosition((turretPosition - transVector):unpack())
	
	local px, py = turretBody:getWorldPoint(localTurretPivotPoint:unpack())
	
	self.pivot = love.physics.newRevoluteJoint(self.ship:getBody(),self.turret:getBody(),px,py,playerData.isColliding or false)
end

function player:move(x,y)
	self.ship:force(x,y)
end

function player:beamFire(beamType)
	player.beams[#player.beams + 1] = beamType
	self.turret:setFiringBeam(beamType)
end

function player:beamStop(beamType)
	self.turret:setFiringBeam(nil)
	for i,extBeamType in ipairs(self.beams) do
		if(beamType == extBeamType) then
			table.remove(self.beams, i)
			break
		end
	end
	if #self.beams > 0 then
		self.turret:setFiringBeam(self.beams[#self.beams])
	end
end

function player:update(dt)
	self.turret:targetPoint(love.mouse.getPosition())
end

return player;