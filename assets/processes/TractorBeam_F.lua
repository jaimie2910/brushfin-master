package.path = "../?.lua;" .. package.path
require("core.Process")

local fireBeam

TractorBeam_F = class('TractorBeam_F',Process)

function TractorBeam_F:initialize(actor,aData)
	
	--get the necessary components
	self.body = actor:getComponent('physComp'):getBody()
	self.rComp = actor:getComponent('drawComp')
	
	Process.initialize(aData)
end

function TractorBeam_F:update(dt)
	
end