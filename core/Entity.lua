package.path = "../?.lua;" .. package.path
require ("external_modules.middleclass")

Entity = class('Entity')

function Entity:initialize(entType,owner)
	self.entType = entType
	self.comps = {}
	self.owner = owner
end

function Entity:addComponent(component)
	--table.insert(self.components,component)
	print('Component added!')
	--self.comps[component.type] = component
end

function Entity:getComponent(componentID)
	print('Returning component' .. componentID)
	--return self.comps[componentID]
end

function Entity:getOwner()
	return self.owner
end

function Entity:destroy()
	--for compID,comp in pairs(self.comps) do comp:destroy() end
end