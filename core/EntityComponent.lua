EntityComponent = class('EntityComponent')

function EntityComponent.static.getIntrinsicData(entDef)
	entDef.compList = {}
end

function EntityComponent:initialize(compType,owner)
	print('Base EntityComponent initialized')
	self.type = compType
	self.owner = owner
end

function EntityComponent:update() end

function EntityComponent:draw() end