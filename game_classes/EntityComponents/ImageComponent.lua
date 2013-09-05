package.path = "../?.lua;" .. package.path
require("EntityComponent")

RenderComponent = class('ImageComponent',EntityComponent)

function ImageComponent:initialize(intCompData,extCompData,parentEntity)
	
end