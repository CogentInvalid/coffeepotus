debugger = class:new()

function debugger:init()
	self.msg = "none"
	self.active = false
	self.timer = 0

	self.w = 160; self.h = 40
end

function debugger:update(dt)
	if self.active then
		self.timer = self.timer - dt
		if self.timer < 0 then
			self.active = false
		end
	end
end

function debugger:print(str, dur)
	self.timer = dur or 5
	self.active = true
	self.msg = str
end

function debugger:draw()
	if self.active then
		love.graphics.setColor(180, 180, 180, 200)
		love.graphics.rectangle("fill", 20, 20, self.w, self.h)
		love.graphics.setColor(255,255,255)
		love.graphics.print(self.msg, 30, 30)
	end
end