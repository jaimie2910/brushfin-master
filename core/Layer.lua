require("Entity")
Layer = class('Layer',Entity)

--[[
Layers draw different types of components, different drawing scales, scrolling rates, overall colour tints, etc...
]]

function Layer:initialize(layerData,layerID,level)
	--initialize with layer Data
	Entity.initialize(self,layerID,level)
end

function Layer:update(dt)
	for i=1,entID do
		comp = self.comps[i]
		if comp and comp.update then
			comp:update(dt)
		end
	end
end

function Layer:draw() -- move the camera so it draws differnetly
	for i=1,entID do
		comp = self.comps[i]
		if comp and comp.draw then
			comp:draw()
		end
	end
end

--[[
local layer = {}

local entID = 0

function layer:init(layerDef)
	self.name = layerDef.layerName
	self.ents = {}
end

function layer:addEnt(ent)
	entID = entID + 1
	ent.id = entID
	ent.layerName = self.name
	self.ents[entID]=ent
	print("ent.id = ",ent.id)
	print("layer = ",ent.layerName)
	print("new ", ent.type)
end

function layer:destroyEnt(entID)
	if self.ents[entID] then
		if self.ents[entID].die then
			self.ents[entID]:die()
		end
		self.ents[entID] = nil
	end
end



return layer;
]]