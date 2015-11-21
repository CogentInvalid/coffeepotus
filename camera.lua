local gamera = require "libs/gamera" --game camera lib
camera = class:new()

function camera:init(parent)

	self.id = "camera"
	self.game = parent

	local sx, sy = love.window.getDimensions()
	self.cam = gamera.new(0,0,sx,sy)
	self:setDimensions(love.window.getDimensions())

	self.speed = 15
	self.screenShake = 0
	self.target = nil

	self.x = self.cam.x
	self.y = self.cam.y

	self.active = true

end

function camera:update(dt)

	--follow player
	if self.target ~= nil then
		local px = self.target.phys.x; local py = self.target.phys.y
		local mx = self:mouseX(); local my = self:mouseY()
		self.tx = (px*3 + mx) / 4
		self.ty = (py*3 + my) / 4

		if self.active then
			self.x = self.x - (self.x-self.tx)*self.speed*dt
			self.y = self.y - (self.y-self.ty)*self.speed*dt
		end
	end

	--screen shake
	if self.screenShake > 0 then
		self.x = self.x + math.random()*30*20*dt-(30*10*dt)
		 self.y = self.y + math.random()*30*20*dt-(30*10*dt)
	end
	self.screenShake = self.screenShake - dt
	if self.screenShake < 0 then self.screenShake = 0 end
	self.cam:setPosition(math.floor(self.x), math.floor(self.y))
	
end

function camera:setPosition(x, y)
	self.x = x; self.y = y
end

function camera:setDimensions(w, h)
	local x = (w+h)/2
	self.cam:setScale(x/700)
	self.cam:setWindow(0,0,w,h)
end

function camera:mouseX()
	local x, y = self.cam:toWorld(mouseX(),mouseY())
	return x
end

function camera:mouseY()
	local x, y = self.cam:toWorld(mouseX(),mouseY())
	return y
end

function camera:zoomOut(amt)
	self.cam:setScale(self.cam:getScale()-(0.06*amt))
end

function camera:focus(dt)
	self.x = self.game.p.phys.x
	self.y = self.game.p.phys.y
	self.cam:setPosition(math.floor(self.x), math.floor(self.y))
end

function camera:levelLoaded(x,y,w,h)
	self.cam:setWorld(x,y,w,h)
end

function camera:levelChanged()

end