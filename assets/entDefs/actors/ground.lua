local entData = {'ground'}

-- Declare class
entData.entClass = Actor

-- Declare behaviours
-- entData.bhvs = {'tractorBeam','repelBeam'}

local points = {0,0,800,0}

-- Declare components
entData.compList = {
	{
		PhysCompName,
		name = PhysCompName,
		entClass = PhysComponent,
		
		physType = 'static',
		fixDefs = {
			{shapeDef = {'chain',data = points}},
		},
	},
	{
		DrawCompName,
		name = DrawCompName,
		entClass = DrawPhysComponent,
		
		imgData = {w = points[3],h = 2,imgType = 'line',shapeData = points,rgba = {255,255,255}},
		offset = vector(0,0)
	},
}

return entData;