ent = {}

function ent:init(entData)
	self.value = 0
	self.text = 'Score: ' .. tostring(self.value)
	self.font = entData.font or 'courier new'
	self.pos = entData.pos
	
	self.font = love.graphics.newFont('fonts/Ubuntu-Regular.ttf',entData.size or 12)
end

function ent:update(dt)
	if self.value ~= score then
		self.value = score
		self.text = 'Score: ' .. tostring(self.value)
	end
end

function ent:draw()
	love.graphics.setFont(self.font)
	love.graphics.print(self.text,self.pos.x,self.pos.y)
end

return ent;