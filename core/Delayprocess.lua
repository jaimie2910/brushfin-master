require("Process")

DelayProcess = class('DelayProcess',Process)

function DelayProcess:initialize(delayTime)
	print('DelayProcess initialized')
	self.delayTime = delayTime
	self.accumTime = 0
	Process.initialize(self)
end

function DelayProcess:update(dt)
	self.accumTime = self.accumTime + dt
	print('The DelayProcess has been updated, current time is ' .. tostring(self.accumTime))
	if (self.accumTime >= self.delayTime) then
		self:setState('s')
	end
end

function DelayProcess:onSuccess()
	print('yay, DelayProcess was successful!')
end

function DelayProcess:onStop()
	print('DelayProcess was stopped')
end