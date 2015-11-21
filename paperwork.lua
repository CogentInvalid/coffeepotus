paperwork = class:new()

function paperwork:init()

	self.cursor = cursor:new({x=200,y=200})

end

function paperwork:update(dt)

	self.cursor:update(dt)

end

function paperwork:draw()
	love.graphics.setColor(0,0,255)
	love.graphics.rectangle("fill",10,10,200,200)
	self.cursor:draw()
end