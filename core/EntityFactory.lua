localRequire ({'VectorEntity','EntDef'},...)

EntityFactory = class('EntityFactory')

local mt = {}
local defaultDef = {
	'DEFAULT',
	entMap = {},
}

function EntityFactory:initialize(entPath, folderNames)
	self.entMap = {entDef = self}
	setmetatable(self.entMap,mt)
	self.entPath = entPath
	self.folderNames = folderNames
	
	self[1] = EntityFactory.name
end

--[[
function EntityFactory.static.initDefaultDef()
	setmetatable(defaultDef,{__index = function () print("Tried to access non-existent parameter in an entDef") return end})
end]]

mt.__index = function(entMap,entType)
	print('Factory entMap __index called: returning defaultDef')
	return defaultDef
end

do
	
	local factMap
	local folderNames
	local entPath
	
	local function getDefFile(entType)
		local fileEnd = entType .. luaExt
		for _,folderName in pairs(folderNames) do
			local fullFilePath = entPath .. folderName .. fileEnd
			--print(fullFilePath)
			if lfs.exists(fullFilePath) then
				--print('file found!')
				return lfs.load(fullFilePath)()
			end
		end
		return nil
	end
	
	local entMap_mt = {
		__index = function(entMap,entType)
			print("entMap __index called!")
			--local entDef = entMap.entDef
			--print(entDef[1])
			--print(type(entDef.dDef))
			--for k,v in pairs(entDef.dDef) do print(k,v) end
			--print(type(entDef.dDef.entMap))
			return entMap.pMap[entType]
			--return getmetatable(entDef).__index(entDef,'entMap')[entType]
		end
	}
	
	-- This is a local function because it is used by factory's entity map and local entity maps
	local function registerEnt(entMap,entData)
		
		print('registerEnt called')
		-- checks the given entity map AND the factory map before registering the entity. Note that this will trigger the __index metamethod and check all higher-level entMaps before deciding to quit.
		--local entMap = parentDef.entMap; print(entMap.entDef[1])
		local entType = entData[1]; print(entType)
		--print(entMap[entType])
		if not entMap[entType].create then
			print(entType .. " is about to be registered")
			
			-- This ternary operation will check if entData has the field ent class. If so it will accept the entData given as sufficient data for registration. If not it will look for a file with the name [entType]
			entData = entData.entClass and entData or getDefFile(entType)
			
			-- if it's not in the file then it's really an error
			if not entData then
				print("ERROR in EntityFactory:registerEntities: " .. entType .. " does not exist!")
				return
			end
			
			local entDef = EntDef(entData,entMap[entType])
			if type(entDef.create) ~= 'table' then print("NO CREATE METHOD") end
			--print("TYPE OF COMPDEF: "..type(entDef.create.initialize))
			if entData[1] == 'asteroid' then
				print('ASTEROID')
				for k,v in pairs(entDef.compList) do print(k,v.entClass.name) end
			end
			
			-- Some entities we would like to register directly at the factory, so that they are accessible from all scopes
			local gRegList = entData.gRegList
			if gRegList then
				print("Processing global reg List for "..entType)
				for _,subEntData in pairs(gRegList) do
					if type(subEntData) ~= 'table' then subEntData = {subEntData} end
					print(subEntData[1])
					registerEnt(factMap,subEntData)
				end
				print('Finished registering global list')
			end
			
			-- Now attempt to register all of the sub-entities
			-- e.g. if a launcher fires grenades we want the launcher to be able to create the grenade (because we won't be creating any grenades when the launcher is created)
			local regList = entData.regList
			if regList then
				print("Creating local entMap for "..entType)
				local compMap = {pMap = entMap}
				setmetatable(compMap,entMap_mt)
				entDef.entMap = compMap
				for _,subEntData in pairs(regList) do
					--print('compType = '..subEntData)
					if type(subEntData) ~= 'table' then subEntData = {subEntData} end
					--print(subEntData[1])
					--print(type(entDef.entMap[subEntData[1]]).."!!!")
					registerEnt(entDef.entMap,subEntData)
				end
			end
			
			-- Finally, store the entDef in the entMap, keyed with the entType
			entMap[entType] = entDef
			
			local compList = entData.compList --> Entities can also hold onto a compList that contains all of the components present
			
			-- If there is a compList then register those components on a local entMap
			if compList then
				print('**IN COMPLIST FOR '..entType)
				for compID = 1,#compList do
				
					-- Ths will replace each element in the list with an entDef, built from the entData that it originally held.
					print(compID)
					
					local compData = compList[compID]
					local compType = compData[1]
					print(compType)
					--print(type(entDef.entMap.pMap))
					local dDef = entDef.entMap[compType] or defaultDef
					local compDef = EntDef(compData,dDef)
					
					compList[compID] = compDef
					
					--[[
					if compList[compID][1] == 'asteroid' then
						print('-- Asteroid --')
						for k,v in pairs(compList[compID]) do print(k,v) end
						if compList[compID].create then print("YEAAAAAH") end
						if compList[compID].compList then print("YEAAAAH") end
						for k,v in pairs(entDef.entMap[compList[compID][1]]--.compList) do print(k,v[1]) end
					--end
					
				end
			else
				entDef.compList = {}
			end
			
			print('Finished Registering '..entType)
		end
	end
	
	-- This is a PUBLIC member function
	function EntityFactory:registerEntity(entData)
		print('registerEntity called.')
		entPath = self.entPath
		folderNames = self.folderNames
		factMap = self.entMap
		
		registerEnt(self.entMap,entData) -- tail call
		if not self.entMap['asteroid'] then print('ASTEROID NOT REGISTERED') end
		if self.entMap['asteroid'] then print('ASTEROID REGISTERED!!!') end
		if self.entMap['asteroid'].create then print('CREATE METHOD FOR ASTEROID') end
	end
	
end


do	
	
	-- Note this userEntDef is visible to both EntityFactory:createEntity and the local function createEnt
	local userEntDef
	local factMap
	
	-- A local function is used here so that entity specific definitions (usually for components) can use this function for recursion.
	local function createEnt(superEnt)
		
		-- Instantiate the entity
		print('Creating Entity '..userEntDef[1])
		--if not userEntDef.create then print("Problem!") end
		local ent = userEntDef:create(superEnt)
		--print('finished construction')
		
		--print(userEntDef.x,userEntDef.y,'444444444444444444444444444444')
		--if not ent.addComponent then print('CAN"T ADD COMPONENTS ' .. userEntDef[1]) end
		
		-- Instantiate and add any components and add them to the current entity
		-- *NOTE that sub-Entities are referenced by a number index, while components can be indexed by numeric or non-numeric entities. This means that numeric for loops will only update sub-Entities
		local compList = userEntDef.compList
		if compList then
			--for k,v in pairs(compList) do print(k,v.create.name) end
			for compID,compDef in pairs(compList) do
				
				-- Now change the userEntDef's default entDef to the compDef
				-- It is the use of a closure (do ... end) instead of a simple function call that allows us to access the user input data (the table that was passed in the call to EntityFactory:createEntity) stored in userEntDef
				print('Creating component number '..tostring(compID))
				print('compType = ',compDef[1])
				
				
				--print(userEntDef.x,userEntDef.y,'5555555555555555555555555555')
				local locEntDef
				if not compDef.create then
					print('caching userEntDef')
					--if factMap['asteroid'] then print('ASTEROID REGISTERED!!!') end
					locEntDef = userEntDef
					compDef = EntDef(compDef,factMap[compDef[1]])
					userEntDef = userEntDef + compDef
					--rawset(compDef,'dDef',factMap[compDef[1]])
					--if not compDef.create then print('SERIOUS PROBLEM') end
				else
					print('create found')
					rawset(userEntDef,'dDef',compDef)
				end
				
				--print(userEntDef.x,userEntDef.y,'6666666666666666666666666666')
				--if not compDef.create then for k,v in pairs(compDef) do print(k,v) end end
				--print('compList length = ',#(compDef.compList))
				
				-- This if statement basically tests if the parameter entData in the call to EntityFactory:createEntity was nil. If it was not nil then important information was passed in the entData, and that info may be required by this component, so we can 'decorate' the compDef with our user ent def to include this information. If it was nil then we can just use the compDef directly (because no extra info about the new entity was provided during the call).
				--if not compDef.create then for k,v in pairs(compDef) do print(k,v) end end
				
				print('userEntDef.dDef set')
				--print(userEntDef.x,userEntDef.y,'77777777777777777777777777777')
				--print('compList length = ',#(userEntDef.compList))
				
				-- Note the userEntDef will often defer to the compDef which will automatically check the default entMap (either the parent Def's map or the factory's map) if value cannot be found in the compDef table
				ent:addComponent(createEnt(ent),rawget(compDef,'name'))
				print('COMPONENT ADDED!!!')
				if locEntDef then
					print('Restoring userEntDef ***********')
					userEntDef = locEntDef
				end
			end
		end
		
		-- This function typically starts processes, and registers signals
		if ent.pInit then ent:pInit() end --post process the entity if necessary
		
		--print('ABOUT TO RETURN '..userEntDef[1])
		return ent
	end
	
	-- This is a PUBLIC member function
	function EntityFactory:createEntity(entType,entData,superEnt)
		print("+=+=+=+=+=+=+=+=+=+=+=+=+=+")
		if self.entMap['asteroid'] then print('ASTEROID REGISTERED!!!') end
		print('EntityFactory:createEntity')
		print('EntType = '..entType)
		--if not entData then entData = {} end
		--if entData then entData[1] = entType end
		userEntDef = EntDef(entData,self.entMap[entType])
		
		factMap = self.entMap
		
		-- If its not there then alert the user
		if not userEntDef then
			print("ERROR in EntityFactory:registerEntities:" .. entType .. " does not exist, or is not registered in the current level.")
			return
		end
		return createEnt(superEnt) --tail call
	end

end

-- Convenience function to register and create entities
function EntityFactory:regAndCreate(entType,superEnt)
	self:registerEntity(entType)
	return self:createEntity(entType,superEnt,{})
end