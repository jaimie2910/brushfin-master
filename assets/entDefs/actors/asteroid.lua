local entData = {'asteroid'}

-- Declare class
entData.entClass = Actor

-- Declare behaviours
entData.bhvs = {'tractorBeam','repelBeam'}

-- Declare components
entData.compList = {
	{
		PhysCompName,
		name = PhysCompName,
		entClass = PhysComponent,
		
		bodyFuncs = {
			setLinearDamping = 2,
			setAngularDamping = 0.4,
		},
		fixDefs = {
			{shapeDef = {'basicCircle',data = 20}}
		}
		--shape = {shapeType = 'basicCircle', shapeData = 20}
	},
	{
		DrawCompName,
		name = DrawCompName,
		entClass = DrawPhysComponent,
		
		imgFileName = 'asteroid.png',
		offset = vector(-25,-25)
	},
}

return entData;