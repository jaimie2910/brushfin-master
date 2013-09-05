--package.path = "../?.lua;" .. package.path
--require ("external_modules.middleclass")

Process = class('Process')

--[[
	States:
	'r': Running
	'p': Paused
	's': Succeeded
	'f': Failed
]]

function Process:initialize(aData)
	print ('Base process initialized')
	self.state = 'r'
	self.aData = aData
end

function Process:attachChild(process)
	self.child = process
end

--[[function Process:begin()
	print ('Base process has begun')
	self.state = 'r'
end]]

function Process:setState(newState)
	self.state = newState
end

function Process:getState()
	return self.state
end

function Process:update()
	--print ('This is the base process update!')
end

function Process:onSuccess()
	--print ('Base process successful')
end

function Process:onFail()
	print ('Base process failed')
end