
DrawPhysComponent = class('DrawPhysComponent',DrawComponent)
DrawPhysCompName = DrawPhysComponent.name

function DrawPhysComponent:initialize(entDef,owner)
	print('INITIALIZING DRAWPHYSCOMPONENT')
	self.offset = entDef.offset
	DrawComponent.initialize(self,entDef,owner)
end

function DrawPhysComponent:postPInit()
	print('DRAWPHYSCOMPONENT POSTPINIT')
	local physComp = self.owner:getComponent(PhysCompName)
	if physComp then
		self.physComp = physComp
		self.body = physComp:getBody()
	else
		print('No physComp found for DrawPhysComp')
	end
	print('finished init')
end

function DrawPhysComponent:draw()
	--local bodyPos,a = self.physComp:getTrans()
	local angle = self.body:getAngle()
	--local bodyPos = vector(self.body:getPosition())
	local drawPos = vector(self.body:getPosition()) + self.offset:rotated(angle)
	--print(bodyPos,a)
	lg.draw(self.image,drawPos.x,drawPos.y,angle)
end