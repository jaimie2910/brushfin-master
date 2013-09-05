local levelDef = {}

levelDef.entTypes = {
	"zepp",
	"explosion",
	"tank",
	"bullet",
	"asteroid",
	"ship",
	"wall",
	"turret",
	"deposit_station",
	"bomb",
	"score",
}

levelDef.layerDefs = {
	{layerName = "background"},
	{layerName = "main", layerType = "physLayer", physDef = {grav = {x = 0, y = 0}, met = 50,
	worldCollisionCallbacks={
	beginContact = function (fixtureA,fixtureB,contact)
		print('beginContact called!')
		local entA = fixtureA:getUserData()
		local entB = fixtureB:getUserData()
		if entA.onContact then entA:onContact(entB,contact) end
		if entB.onContact then entB:onContact(entA,contact) end
	end,
	postSolve = function (fixtureA, fixtureB, contact, normal_impulse, tangent_impulse)
		local entA = fixtureA:getUserData()
		local entB = fixtureB:getUserData()
		if entA.postSolveContact then entA:postSolveContact(entB,contact,normal_impulse,tangent_impulse) end
		if entB.postSolveContact then entB:postSolveContact(entB,contact,normal_impulse,tangent_impulse) end
	end,
	},
	worldFilterCallbacks={
	filter = function (fixtureA,fixtureB)
		local typeA = fixtureA:getUserData():getType()
		local typeB = fixtureB:getUserData():getType()
		if (typeA == 'wall' or typeB == 'wall') then
			print('one type is wall')
			if (typeA == 'ship' and typeB == 'wall' or typeA == 'wall' and typeB == 'ship') then
				return true
			else
				print('wall and asteroid')
				return false
			end
		end
		return true
	end,
	}}},
	{layerName = "foreground"},
	{layerName = "HUD"},
}

levelDef.startingEnts = {
	{entType='asteroid',layerName='main',entData={pos={x=500,y=300,a=math.random(0,2*math.pi)},
				vel={x=0,y=0,a=8.377}}},
	{entType='asteroid',layerName='main',entData={pos={x=600,y=300,a=math.random(0,2*math.pi)},
				vel={x=0,y=0,a=8.377}}},
	{entType='asteroid',layerName='main',entData={pos={x=400,y=300,a=math.random(0,2*math.pi)},
				vel={x=0,y=0,a=8.377}}},
	{entType='bomb',layerName='main',entData={pos={x=400,y=100,a=math.random(0,2*math.pi)},
				vel={x=0,y=0,a=8.377}}},
	{entType='bomb',layerName='main',entData={pos={x=300,y=100,a=math.random(0,2*math.pi)},
				vel={x=0,y=0,a=8.377}}},
	{entType='bomb',layerName='main',entData={pos={x=200,y=100,a=math.random(0,2*math.pi)},
				vel={x=0,y=0,a=8.377}}},
	{entType='bomb',layerName='main',entData={pos={x=600,y=100,a=math.random(0,2*math.pi)},
				vel={x=0,y=0,a=8.377}}},
	{entType='bomb',layerName='main',entData={pos={x=450,y=100,a=math.random(0,2*math.pi)},
				vel={x=0,y=0,a=8.377}}},
	{entType='ship',layerName='main',entData={pos={x=50,y=200},polyPoints={0,0,30,0,15,50}},player=true},
	{entType='turret',layerName='main',player=true,
		entData={pos={x=50,y=50},size={width=5,height=30},density=0.01,forceMag=150,
		beamEffects={
		pull = { func  = function (body,contactPoint,originPoint,forceMag)
			local forceVec = (originPoint - contactPoint):normalized()*forceMag
			local fx,fy = forceVec:unpack()
			local cx,cy = contactPoint:unpack()
			body:applyForce(fx,fy,cx,cy)
		end,
		color = {r = 0, g = 255, b = 0}},
		push = { func = function (body,contactPoint,originPoint,forceMag)
			local forceVec = -(originPoint - contactPoint):normalized()*forceMag
			local fx,fy = forceVec:unpack()
			local cx,cy = contactPoint:unpack()
			body:applyForce(fx,fy,cx,cy)
		end,
		color = {r = 0, g = 255, b =255}},
		},
		}},
	{entType='wall',layerName='main',entData={pos={x=0,y=0},polyPoints={0,0,0,600,800,600,800,0}}},
	{entType='deposit_station',layerName='main',entData={pos={x=400,y=0}}},
	{entType='score',layerName='HUD',entData={pos={x=5,y=5},font='ubuntu',size=16}},
}

levelDef.amendmentFunctions = {
	mousepressed = function (self, x, y, button) if button == "l" then Shoot(x,y) end end
}

levelDef.signals = {
	up = function(player) player:move(0,-1) end,
	down = function(player) player:move(0,1) end,
	left = function(player) player:move(-1,0) end,
	right = function(player) player:move(1,0) end,
	quit = function(game) game:quit() end,
	mouseLeftDown = function(player) player:beamFire('pull') end,
	mouseLeftUp = function(player) player:beamStop('pull') end,
	mouseRightDown = function(player) player:beamFire('push') end,
	mouseRightUp = function(player) player:beamStop('push') end,
}

levelDef.inputMap={
	keydown = {
		d = 'up',
		s = 'down',
		a = 'left',
		f = 'right',
		escape = 'quit',
	},
	keyup = {
		d = 'down',
		s = 'up',
		a = 'right',
		f = 'left',
	},
	mousedown = {
		l = 'mouseLeftDown',
		r = 'mouseRightDown',
	},
	mouseup = {
		l = 'mouseLeftUp',
		r = 'mouseRightUp',
	},
}

return levelDef;