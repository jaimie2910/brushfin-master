local entComps = "EntityComponents."
local layers = "Layers."

local modNames = {
	-- actor components
	entComps..'PhysComponent',
	entComps..'DrawComponent',
	entComps..'DrawPhysComponent',
	entComps..'DrawStaticComponent',
	
	-- layers
	layers..'PhysLayer',
}

EL = {}

localRequire(modNames,...)