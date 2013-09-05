-- include.lua
-- This file sets up some global variables and includes all the 'core' files for the game

-- Loading all the love modules into global vars
la = love.audio
lfs = love.filesystem
lf = love.font
lg = love.graphics
li = love.image
--lj = love.joystick
lk = love.keyboard
lm = love.mouse
lp = love.physics
ls = love.sound
--lth = love.thread
lt = love.timer

-- A handy global var
luaExt = ".lua"

-- A convenince function to require local modules (files) that do not return values
function localRequire(modNames,...)
	local localFolder = (...):match("(.-)[^%.]+$")
	local mods = {}
	for key,modName in pairs(modNames) do
		local module = require(localFolder..modName)
		if type(key) == 'string' then 
			if _G[key] then
				print("module name "..key.." is already the name of a global var!")
			else
				_G[key] = module
			end
		end
	end
end
--	This function is based on a trick explained in the this question: http://stackoverflow.com/questions/9145432/load-lua-files-by-relative-path

--package.path = package.path..";?\include"

require("utils.include")		-- 3rd party modules
require("core.include")			-- Core game classes
require("game_classes.include")	-- Game specific code