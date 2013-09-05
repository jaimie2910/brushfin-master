--core/include.lua
--This file simply requires all of the necessary local modules

local modNames = {
	-- Process and process manager
	'Process',
	'ProcessManager',

	-- All types of entities
	'VectorEntity',
	--'Level',
	--'Layer',
	'Actor',
	'EntityComponent',
	
	-- Class for entity definitions
	'EntDef',

	-- Entity Factory can create entities from a dynamic map
	'EntityFactory',

}

localRequire(modNames,...)