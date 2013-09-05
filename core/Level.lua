require ("VectorEntity")
Level = class('Level',VectorEntity)

--[[
Levels control triggers, scripted events, etc...
Drawing order of layers matters here, so they are stored in that order
]]

function Level:initialize(levelData,levelID,game)
	--Do stuff with level data
	
	--VectorEntity.initialize(
end

function Level:update(dt)
	for i,layer in ipairs(self.layers) do
		layer:update(dt)
	end
end

function Level:draw()
	for i,layer in ipairs(self.layers) do
		layer:draw()
	end
end

--[[
local function makeLayer(layerType)
	if layerType then
		return love.filesystem.load(layerType .. luaExt)
	else
		return love.filesystem.load("layer.lua")
	end
end

function level:init(levelDef)
	self:loadLayers(levelDef.layerDefs)
	entMgr:regEntDefs(levelDef.entTypes)
	--level.signals = require('hump.signal')
	local playerData = {}
	for i,entDef in ipairs(levelDef.startingEnts) do
		local ent = entMgr:createEntFromTable(entDef)
		if entDef.player then playerData[ent.type] = ent end
		self.layers[entDef.layerName]:addEnt(ent)
	end
	return playerData
end

function level:update(dt)
	for i,layer in ipairs(self.layers) do
		layer:update(dt)
	end
end

function level:draw()
	for i,layer in ipairs(self.layers) do
		layer:draw()
	end
end

--Pause Function
--Level End function
--Other level wide triggers (event) functions

function level:loadLayers(layerDefs)
	if layerDefs then
		for i,layerDef in ipairs(layerDefs) do
			local layer = makeLayer(layerDef.layerType)()
			local name = layerDef.layerName
			layer:init(layerDef)
			self.layers[name] = layer
			self.layers[i] = layer
		end
	else
		print("Error in level:loadLayers","layerDefs is not defined.")
	end
	print("layers loaded")
end

return level;
]]