
VectorEntity = class('VectorEntity')
VectorEntityName = VectorEntity.name

-- Static processing called by EntityFactory during method RegisterEntities
function VectorEntity.static.setIntrinsicData(entDef)
	--[[local bhvs = 
	for i,behaviour in ipairs(entDef.behaviour) do bhvs[i] = _G[behaviour] end
	return {bhvs = bhvs}]]
end

-- Initialize the entity
function VectorEntity:initialize(entDef,owner)
	self.type = entDef[1]
	self.bhvs = entDef.bhvs
	--self.postData = entDef.postData
	--for action, behaviour in intData.bhvs do self.bhvs[action] = behaviour end
	self.pMgr = ProcessManager()
	--self.type = entDef.entType
	self.comps = {l = 0}
	self.owner = owner
	self.requests = {}
end

function VectorEntity:postInit()
	local postData = self.postData
	
	for action,aData in pairs(postData.procs) do
		self.pMgr:attachProcess(self:actOn(action,aData))
	end
	
	--  ... Do other post processing ...
	
	self.postData = nil
end

-- Act on the current entity. This will use the action to look up the corresponding response action (process)
function VectorEntity:actOn(action,aData)
	local ReactionProcessClass = self.bhvs[action]
	if ReactionProcessClass then 
		--[[local process = ReactionProcessClass(self,aData)
		local procID
		self.extProcs,procID = addElement(self.extProcs,process)
		return process,procID]]
		return ReactionProcessClass(self,aData)
	else
		return Process() -- Should I return an empty process? I don't know...
	end
end

-- Update the current entity
function VectorEntity:update(dt)
	--print("VectorEnt update "..self.type)
	self.pMgr:update(dt)
	for i = 1, self.comps.l do
		local comp = self.comps[i]
		if comp then
			comp:update(dt)
		end
	end
end

-- Draw the current entity (this is overridden by at least the actor subclass)
function VectorEntity:draw()
	for i = 1, self.comps.l do
		local comp = self.comps[i]
		if comp then
			comp:draw()
		end
	end
end

-- This global function will add an element to a table and give it the smallest available integer key. It assumes that the table stores its longest ever length in the field <table_name>.l 
function addElement(t,e)
	local lastID,lenID = t.l,#t
	if lenID == lastID then
		lastID = lastID + 1
		lenID = lastID
		t.l = lastID
	else
		lenID = lenID + 1
	end
	t[lenID] = e
	return lenID
end

-- Gets the type of the current entity
function VectorEntity:getType()
	return self.type
end

-- Set the ID of the current entity
function VectorEntity:setID(entID)
	self.ID = entID
end

-- Get the ID of the current entity
function VectorEntity:getID()
	return self.ID
end

-- Add a component to the current entity. Notice this adds will always give a numeric key to the component. But it may also assign a string key for the component. Usually the numeric key is used in updating, while the string key is used for getting
function VectorEntity:addComponent(component,compName)
	print(type(addElement))
	print(type(self.comps))
	local compID = addElement(self.comps,component)
	component.ID = compID
	if compName then
		self.comps[compName] = component
	end
	print('Component '.. (compName or tostring(compID))..' added!')
end

-- Get the component with ID compID (compID could be a integer or string type)
function VectorEntity:getComponent(compID)
	return self.comps[compID]
end

-- Request the owner to destroy the current entity
function VectorEntity:kill()
	self.owner:destroyComponent(self.ID)
end

-- Destroy the component given by compID
function VectorEntity:destroyComponent(compID)
	self.comps[compID]:destroy()
	self.comps[compID] = nil
end

--[[function VectorEntity:removeComponent(compID)
	local component = self.comps[compID]
	self.comps[compID] = nil
	return component
end]]

-- Destroy the current entity
function VectorEntity:destroy()
	self.pMgr:destroy()
	for compID,comp in pairs(self.comps) do if comp then comp:destroy() end end
end

---------------------------------
-- USEFUL NON-MEMBER FUNCTIONS --
---------------------------------

function processComponents(compList,entType,entClass)
	entData = {}
	for name,compList in pairs(compList) do
		table.insert(entData,{entType, name = name, compList = compList, entClass = entClass or VectorEntity})
	end
	return entData
end

