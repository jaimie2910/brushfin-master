--main.lua

--local screenVec = vector(800,600)
--maxRayLength = screenVec:len()

require("include") -- the file include.lua does all the necessary file loading so that all the expected modules and varaibles are available

function love.load()
	
	entFact = EntityFactory("assets/entDefs/",{"actors/","layers/","levels/"})
	
	entFact:registerEntity{'level_1'}
	level = entFact:createEntity('level_1')
	
	font = lg.newFont('assets/fonts/Ubuntu-Regular.ttf',16)
	lg.setFont(font)
	
	--lt.sleep(0.5)
	collectgarbage()
	
	--entFact:registerEntity{'layer_1'}
	--layer = entFact:createEntity('layer_1')
	
	--entFact:registerEntity{'asteroid'}
	--ast = entFact:createEntity('asteroid',{x = 10, y = 10})
	
	--level:getComponent('main'):addComponent(entFact:createEntity('asteroid',{x = 200, y = 200}))
	--[[
	Gamestate.registerEvents() --This function 'initializes' the Gamestate object, so that love will call <currentGameState>.<callback> instead of love.<callback> (e.g. game.update instead of love.update)
	Gamestate.switch(menu) --Switch the current gamestate to the menu
	]]
end

function love.update(dt)
	level:update(dt)
	--layer:update(dt)
end

function love.draw()
	level:draw()
	lg.print(lt.getFPS(),5,5)
end