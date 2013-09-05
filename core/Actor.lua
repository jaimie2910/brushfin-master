localRequire ({'VectorEntity'},...)

Actor = class('Actor',VectorEntity)

function Actor.static.setIntrinsicData(entDef)
	print('getting actor intrinsic data')
	return VectorEntity.setIntrinsicData(entDef)
end

function Actor:initialize(entDef,owner)
	self.entDef = entDef
	VectorEntity.initialize(self,entDef,owner)
end

-- Calls the postPInit function on each component (Actor Components often need to have knowledge of eachother (e.g. Draw Components neet to reference physComponents) and we need to be sure that all components have been initialized already)
function Actor:pInit()
	for compID = 1,#(self.comps) do
		local comp = self.comps[compID]
		print(compID,comp)
		if comp.postPInit then comp:postPInit() end
	end
	
	local postFuncs = self.entDef.postFuncs
	if postFuncs then
		for i=1,#(postFuncs) do
			postFuncs[i](self)
		end
	end
	
	self:postPInit()
end

function Actor:postPInit()
	self.entDef = nil
end

--[[
function Actor:draw()
	self.comps[DrawCompName]:draw()
end
]]

function Actor:draw()
	for i = 1, self.comps.l do
		local comp = self.comps[i]
		if comp then
			comp:draw()
		end
	end
end