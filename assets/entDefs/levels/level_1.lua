local entData = {'level_1'}

-- Declare Catagory
entData.entClass = VectorEntity

-- Registration List (declares the types of entities that are present in this level)
entData.regList = {
	{'layer', entClass = VectorEntity},
	{'physLayer', entClass = PhysLayer},
}

entData.gRegList = {
	'asteroid',
	'ship',
	'turret',
	'ground',
}

-- Declare subEntities (Layers)
entData.compList = {
	{
		'physLayer',
		name = 'main',
		compList = {
			{'ground', x = 0, y = 500},
			{'asteroid', x = 300, y = 300},
			{'asteroid', x = 80, y = 10},
			{'asteroid', x = 150, y = 100},
			{'asteroid', x = 400, y = 100},
			{'asteroid', x = 500, y = 100},
			{'ship', x = 300, y = 300},
			{'turret', x = 400, y = 300},
			{'asteroid', x = 600, y = 100},
			{'asteroid', x = 700, y = 100},
			{'asteroid', x = 800, y = 100},
			{'asteroid', x = 900, y = 100},
		},
		
		gy = 200,
	}
}

return entData;