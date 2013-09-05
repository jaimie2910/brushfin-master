--game.lua
game = {}

function game:init()
--empty for now
end

--local newLevel = love.filesystem.load("level.lua")

function game:enter(previous, ...)
	local levelName = ...
	--local levelDef = love.filesystem.load( "states/game/" .. levelName .. luaExt )()
	--[[if previous == self then
		print("game state reset!")
	else
		print("entering game state!")
	end]]
	
	entFact:registerEntity(levelName)
	self.level = entFact:createEntity(levelName,self)
	
	--local playerData = self.level:init(levelDef)
	--self.player = lfs.load("player.lua")()
	--self.player:init(playerData)
	
	--game.inputMap = levelDef.inputMap
	--game:registerSignals(levelDef.signals)
	--love.graphics.setBackgroundColor(0,0,0)
	--score = 0
end

function game:registerSignals(signals)
	for signalName, Func in pairs(signals) do
		signal.register(signalName,Func)
	end
end

function game:leave()
end

function game:update(dt)
	self.player:update(dt)
	self.level:update(dt)
end

function game:draw()
	self.level:draw()
end

function game:focus(screenFocus)
--if screen focus is lost then pause
--if screen focus comes back and the player did not pause, then resume
--trigger an event
end

function game:keypressed(key, unicode)
	print('key = ', key)
	local mappedInput = self.inputMap.keydown[key]
	print (mappedInput)
	if mappedInput then signal.emit(mappedInput, self.player) end
end

function game:keyreleased(key)
	if key == 'escape' then self:quit(); return end
	local mappedInput = self.inputMap.keyup[key]
	print (mappedInput)
	if mappedInput then signal.emit(mappedInput, self.player) end
end

function game:mousepressed(x, y, button)
	-- print(type(x))
	-- print(type(y))
	-- print(type(button))
	local mappedInput = self.inputMap.mousedown[button]
	print (mappedInput)
	if mappedInput then signal.emit(mappedInput, self.player) end
end

function game:mousereleased(x, y, button)
--if important, register that button is up
--possibly trigger an event (signal)
	local mappedInput = self.inputMap.mouseup[button]
	print (mappedInput)
	if mappedInput then signal.emit(mappedInput, self.player) end
end

function game:quit()
--fade screen and exit
end