local defaultBodyType = 'dynamic' -- 'static' or 'kinematic' are the other options
local shapeCreators = {}

PhysComponent = class('PhysComponent',EntityComponent)
PhysCompName = PhysComponent.name

--[[
TODO: subclass for more expensive scenarios e.g.
	-> chains of objects having the same objects (reusing shapes)
]]

function PhysComponent.static.setIntrinsicData(entDef)
	
	-- The entData should have a table of fixtureDefs
	local fixDefs = entDef.fixDefs
	for i=1,#fixDefs do
		local shapeDef = fixDefs[i].shapeDef
		fixDefs[i].shape = shapeCreators[shapeDef[1]](shapeDef.data)
		fixDefs[i].shapeDef = nil
	end
end

do
	local world
	
	function setPhysWorld(physWorld)
		world = physWorld
	end
	
	function PhysComponent:initialize(entDef,owner)

		-- Create the body
		if not world then print("the physWorld has not been set!") return end
		local body = lp.newBody(world,entDef.x,entDef.y,entDef.physType or defaultBodyType)
		local bodyFuncs = entDef.bodyFuncs
		if bodyFuncs then
			print('bodyFuncs:')
			for bodyFunc,funcData in pairs(bodyFuncs) do
				print(bodyFunc,funcData)
				local expFuncData
				if(type(funcData) == 'table') then
					expFuncData = unpack(funcData)
				else
					expFuncData = funcData
				end
				body[bodyFunc](body,expFuncData)
			end
		else
			print('No bodyFuncs')
		end
		
		-- Add all the defined fixtures to the body
		for _,fixtureDef in pairs(entDef.fixDefs) do
		
			-- Create the shape
			local shape = fixtureDef.shape or shapeCreators[fixtureDef.shapeDef[1]](fixtureDef.shapeDef.data)
			
			-- Create the fixture
			local fixture = lp.newFixture(body,shape,fixtureDef.density)
			local fixtureFuncs = fixtureDef.fixFuncs
			if fixtureFuncs then
				for fixtureFunc,funcData in pairs(fixtureFuncs) do
					fixture[fixtureFunc](fixture,funcData)
				end
			end
			fixture:setUserData(owner)
		end
		
		self.body = body
		--print(body:getPosition())
		print('PhysComponent initialized')
		EntityComponent.initialize(self,PhysComponent.name,owner)
	end
end

function PhysComponent:getTrans()
	return vector(self.body:getPosition()),self.body:getAngle()
end

function PhysComponent:getBody()
	return self.body
end

function PhysComponent:update() end

----------------------------
-- ShapeCreator Functions --
----------------------------

function shapeCreators.chain(shapeData)
	return lp.newChainShape(shapeData.loop or false, unpack(shapeData))
end

function shapeCreators.basicCircle(shapeData)
	return lp.newCircleShape(shapeData)
end

function shapeCreators.posCircle(shapeData)
	return lp.newCircleShape(shapeData.x,shapeData.y,shapeData.r)
end

function shapeCreators.edge(shapeData)
	return lp.newEdgeShape(unpack(shapeData))
end

function shapeCreators.polygon(shapeData)
	return lp.newPolygonShape(unpack(shapeData))
end

function shapeCreators.basicRectangle(shapeData)
	return lp.newRectangleShape(shapeData.w,shapeData.h)
end

function shapeCreators.posRectangle(shapeData)
	return lp.newRectangleShape(shapeData.x,shapeData.y,shapeData.w,shapeData.h,shapeData.a)
end