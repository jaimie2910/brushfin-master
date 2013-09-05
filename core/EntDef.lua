
--EntDef = class('EntDef')

local defaultDef = {
	entType = 'DEFAULT',
	entMap = {}
}

local mt = {}

function EntDef(entData,dDef)
	
	-- In the case when no entData was passed, the new entDef would always defer to the defaultDef when accessed if created normally. To save memory and cpu time we can just return the defaultDef and it should behave as expected
	if not dDef then dDef = defaultDef end
	--if not entData or entData == {} then return dDef end
	
	local entDef = {}
	-- This initialized the new entDef a deep copy of the entData, this may become a shallow copy in the future, depending on how entData is declared. Maybe we could pass an extra boolean parameter to help make the decision
	if entData then for k,v in pairs(entData) do entDef[k] = v end end
	
	-- This chunk is used for 'primary' entDefs. This is an unnofficial designation for entDefs that holds the 'create' key. Primary entDefs will usually have the global defaultDef as their dDef. Plain (other) entDefs are not declared with the entClass field in the entData. They will refer to another entDef (possibly a primary entDef) for the 'create' method.
	local entClass = entData and entData.entClass
	if entClass then
		entDef.create = entClass
		entDef.entClass = nil
		
		print('About to set the intrinsic data for '..entClass.name)
		-- this static function loads assets and does all possible pre-processing
		entClass.setIntrinsicData(entDef)
	end
	
	-- This next line looks simple, but it could call 2 metamethods. First, if there is no entMap on the parent the parentDef will ask its parent for an entMap, and so on until it reaches the factory map, which will return its entMap or the defaultMap. Second, if the parent has an entMap, but does not have the desired entDef, the parents' entMap will ask the grandparents' entMap for the entDef, and so on until it is handled. If the call reaches the defaultMap, it will print an error and return nil.
	-- This is just an elegant method for getting a meaningful default entDef, so that when a local entDef doesn't have the necessary construction data, knows just where to look to find it.
	entDef.dDef = dDef
	--print('dDef = '..entDef.dDef.entType)
	
	-- Finally, set the metatable of the entDef, so it can execute all of the fanciness described in the above comments
	setmetatable(entDef,mt)
	if not entDef.create then print('NO CREATE METHOD FOR '..entDef[1]..'!+!+!+!==============================') end
	return entDef
end

mt.__index = function (def,key)
	print('EntDef __index called')
	return def.dDef[key]
end

mt.__add = function (def1,def2)
	print('__add called')
	local res = {}
	for k,v in pairs(def1) do res[k] = v; print(k,v) end
	print('++++')
	for k,v in pairs(def2) do res[k] = v; print(k,v) end
	setmetatable(res,mt)
	return res
end

--Will need destroy methods later