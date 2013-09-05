localRequire ({'Process'},...)

ProcessManager = class('ProcessManager')

function ProcessManager:initialize()
	self.prcs = {}
end

function ProcessManager:attachProcess(process)
	table.insert(self.prcs,process)
	print(process.class.name .. ' has been attached to the prcs')
end

function ProcessManager:update(dt)
	for i,process in pairs(self.prcs) do
		--print(type(process.getState))
		if process:getState() ~= 'p' then
			--[[if process:getState() == 'u' then
				print('found an uninitialized process')
				process:begin()
			end]]
			if process:getState() == 'r' then
				process:update(dt)
			end
			local pState = process:getState()
			if pState == 's' then
				if process.isChild then
					self:attachProcess(process:getChild())
				end
				table.remove(self.prcs,i)
				process:onSuccess()
			elseif pState == 'f' then
				print('process: ' .. process.class.name .. ' failed.')
				table.remove(self.prcs,i)
				process:onFail()
			end
		else
			print('process: ' .. process.class.name .. ' is paused.')
		end
	end
end