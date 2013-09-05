package.path = "../?.lua;" .. package.path
require("core.Process")

TractorBeam_R = class('TractorBeam_R',Process)

function TractorBeam_R:initialize(actor,aData)
	
	--get the necessary components
	self.body = actor:getComponent('physComp'):getBody()
	self.rComp = actor:getComponent('drawComp')
	
	Process.initialize(aData)
end

function TractorBeam_R:update(dt)
	local force = -self.aData.beamDir * aData.fMag * dt
	self.body:applyForce(force.x, force.y, aData.p.x, aData.p.y)
	
	--Update the draw Component
end

function TractorBeam_R:onSuccess()
	--Return child process that will fade the drawing effect appropriately
end