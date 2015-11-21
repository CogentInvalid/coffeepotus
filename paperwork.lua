paperwork = class:new()

function paperwork:init()

	self.cursor = cursor:new({x=200,y=300})

	local options = {"peas", "budget"}
	self.papx = math.random(50,150); self.papy = math.random(100,200) --target paper position
	self:getThing(randomSelect(options))

	self.state = "wait"

	self.finished = false

end

function paperwork:getThing(thing)

	local xpos = math.random(0,200)
	local ypos = 600

	self.paper = {img=imgMan:getImage(thing), x=xpos, y=ypos}
	if thing == "peas" then
		self.successZone = {85,227,129,274}
		self.failZone = {141,227,178,269}
	end
	if thing == "budget" then
		self.successZone = {118,147,158,196}
		self.failZone = {55,131,224,194}
	end

end

function paperwork:update(dt)

	self.cursor:update(dt)

	self.paper.x = self.paper.x - (self.paper.x - self.papx)*5*dt
	self.paper.y = self.paper.y - (self.paper.y - self.papy)*5*dt
	debug(love.mouse.getX()-self.paper.x .. ", " .. love.mouse.getY()-self.paper.y)

end

function paperwork:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.paper.img, self.paper.x, self.paper.y, 0, 30/50, 30/50)

	local r = 255; local g = 255; local b = 255
	local x = 200; local y = 500
	local str = ""

	if self.state == "win" then
		r=0; g=255; b=0
		str = "YA DID IT SON"
	end
	if self.state == "lose" then
		r=255; g=0; b=0
		str = "YA DONE GOOFED SON"
	end
	if self.state == "miss" then
		r=255; g=255; b=0
		str = "YA GOTTA TRY AGAIN SON"
	end

	love.graphics.setColor(r,g,b)
	love.graphics.print(str, x, y)

	self.cursor:draw()
	love.graphics.setColor(255,0,0)
	love.graphics.setColor(255,255,255)
end

function paperwork:keypressed(key)
	if key == "z" then
		local phys = self.cursor.phys
		local x = phys.x+phys.w/2; local y = phys.y+phys.h/2

		--test success zone
		if x>self.successZone[1]+self.paper.x and y>self.paper.y+self.successZone[2]
		and x<self.paper.x+self.successZone[3] and y<self.paper.y+self.successZone[4] then
			self.state = "win"
		else
			--test fail zone
			if x>self.failZone[1]+self.paper.x and y>self.paper.y+self.failZone[2]
			and x<self.paper.x+self.failZone[3] and y<self.paper.y+self.failZone[4] then
				self.state = "lose"
			else
				self.state = "miss"
			end
		end

	end
end