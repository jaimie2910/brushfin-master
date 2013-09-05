-- utils/include.lua
-- This file simply requires all of the necessary local modules

local modNames = {

	-- load the necessary hump modules
	gamestate = 'hump.gamestate',
	vector = 'hump.vector',
	signal = 'hump.signal',		

	-- Middle class allows for object oriented programming
	'middleclass',

	-- This is a useful parser for .json files (may use with RUBE...)
	-- "dkjson",
	
	-- A debug library
	--'debug',
}

-- load the modules
localRequire(modNames,...)