coffee = class:new()

function coffee:init()
	self.canvas = love.graphics.newCanvas(500,600)
	self.meter = 1
	self.drainRate = 0.05
end

function coffee:update(dt)
	self.meter = self.meter - self.drainRate*dt
end

function coffee:draw()
	love.graphics.setCanvas(self.canvas)
	self.canvas:clear()
	love.graphics.setColor(0,255,0)
	love.graphics.rectangle("fill",10,10,self.meter*400,100)
	love.graphics.setCanvas()
	love.graphics.draw(self.canvas, 500, 0)
end

function coffee:keypressed(key)

end

function coffee:mousepressed(x, y, b)

end