function load()
	love.graphics.setBackgroundColor( 190, 190, 190 )
	imgPlay = love.graphics.newImage("textures/play.png")
	imgPlayOn = love.graphics.newImage("textures/play_on.png")
	imgExit = love.graphics.newImage("textures/exit.png")
	imgExitOn = love.graphics.newImage("textures/exit_on.png")
	
	buttons = 	{
				{imgOff = imgPlay, imgOn = imgPlayOn, x = 400, y = 300 - 64, w = 256, h = 64, action = "play"},
				{imgOff = imgExit, imgOn = imgExitOn, x = 400, y = 300 + 64, w = 256, h = 64, action = "exit"}
				}
end

local function drawButton(off, on, x, y, w, h, mx, my)
	local ins = insideBox( mx, my, x - (w/2), y - (h/2), w, h )
	
	love.graphics.setColor( 255, 255, 255, 255 )
	
	if ins then
		love.graphics.draw( on, x, y, 0, 1, 1, (w/2), (h/2) )
	else
		love.graphics.draw( off, x, y, 0, 1, 1, (w/2), (h/2) )
	end
end

function love.draw()
	local x = love.mouse.getX( )
	local y = love.mouse.getY( )

	for k, v in pairs(buttons) do
		drawButton( v.imgOff, v.imgOn, v.x, v.y, v.w, v.h, x, y )
	end
end

function love.update(dt)
end

function love.focus(bool)
end

function love.keypressed( key, unicode )
end

function love.keyreleased( key, unicode )
	
end

function love.mousepressed( x, y, button )
	if button == "l" then
		for k, v in pairs(buttons) do
			local ins = insideBox( x, y, v.x - (v.w/2), v.y - (v.h/2), v.w, v.h )
			
			if ins then
				if v.action == "play" then
					loadState("Level_1")
				elseif v.action == "exit" then
					love.event.quit()
				end
			end
		end
	end
end

function love.mousereleased( x, y, button )
end

function love.quit()
end

function insideBox( px, py, x, y, wx, wy )
	if px > x and px < x + wx then
		if py > y and py < y + wy then
			return true
		end
	end
	return false
end