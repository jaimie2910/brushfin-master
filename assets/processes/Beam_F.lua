package.path = "../?.lua;" .. package.path
require("core.Process")

Beam_F = class('Beam_F',Process)

Beam_F.static.maxLen = 5000 -- Every ray cast needs a length. This value should be sufficiently large so the beam never ends

function Beam_F:initialize(actor,aData)

	self.tBody = actor:getComponent('physComp'):getBody() -- the b2body of the physics component
	self.bLen = actor:getProperty('barrelLen') -- a vector containing the length of the end of the barrel relative to the turret origin
	self.dComp = actor:getComponent('drawComp')
	
	--self.cf = nil -- need a 'closest fixture' variable but it doesn't need to appear in the constructor
	Process.initialize(aData)
end

--[[
Beam_RF = class('Beam_RF',Process)

function Beam_RF:initialize(actor,aData)
end
]]

do	-- Local scope opened for fireBeam function, this permits both the firing and reflection beam classes to share the same function

	function Beam_F:update(dt)
		local barrelAngle = self.tBody:getAngle()
		local barrelEnd = vector(self.bLen*cos(barrelAngle),self.bLen*sin(barrelAngle))
		local worldBarrelEnd = vector(self.tBody:getWorldPoint(barrelEnd:unpack()))
		
		self:fireBeam(worldBarrelEnd,barrelEnd:normalize_inplace())
	end

	local fireBeam = function(self,launchPt,launchDir) --'shoot' the beam
		
		local minCollDist = Beam_F.maxLen
		local minCollPt = launchPt + launchDir*minCollDist
		local closestFixture -- declare a temporary closest fixture so we can see if it has changed
		self.world:rayCast(launchPt.x,launchPt.y,launcDir.x,launchDir.y,beamRayCastCallback)
		
		-- test each fixture to see what is closest
		function beamRayCastCallback(fixture, x, y, xn, yn, fraction)
			local collPoint = vector(x,y)
			local collDist = (collPoint-self.worldBarrelEnd):len()
			if (collDist < minCollDist) then
				minCollPt = collPoint
				minCollDist = collDist
				closestFixture = fixture
			end
			
			return -1
		end
		
		--If a valid fixture is found
		if closestFixture then
			if closestFixture ~= self.cf then
				if self.cf then self.subP:setState('s') end
				self.cf = closestFixture
				self.subAData = {fMag = self.fMag}
				closestFixture.getUserData():ActOn(self.class,self.subAData)
			end
			local subAData = {beamDir = launchDir, collPt = collPoint}
			self.subP:update(dt,subAData)
		elseif self.cf then
			self.subP:setState('s')
			self.cf = nil
			self.subAData = nil
		end
		
		--In any case, draw the beam
		
	end

end