image = class:new()

function image:init(name)
	self.imgName = name
	self.img = getImg(name)
	self.r = 255; self.g = 255; self.b = 255
end

function image:update(dt)
end

function image:setQuad(x, y, w, h)
	self.quad = love.graphics.newQuad((x-1)*w, (y-1)*h, w, h, self.img:getDimensions())
end

function image:setRGB(r, g, b)
	self.r = r
	self.g = g
	self.b = b
end

function image:draw(x, y, sx, sy)
	sx = sx or 1; sy = sy or 1
	love.graphics.setColor(self.r, self.g, self.b)
	love.graphics.draw(self.img, x, y, 0, sx, sy)
end

function image:drawQuad(x, y, sx, sy)
	love.graphics.setColor(self.r, self.g, self.b)
	love.graphics.draw(self.img, self.quad, math.floor(x), math.floor(y), 0, sx, sy)
end