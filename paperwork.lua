paperwork = class:new()

function paperwork:init()

	self.cursor = cursor:new({x=200,y=300})

	local options = {"peas", "budget"}
	self:getThing(randomSelect(options))
	--self.paper = {img=imgMan:getImage("peas"), x=100, y=200}
	--self.successZone = {85,227,129,274}
	--self.failZone = {141,227,178,269}

	self.state = "wait"

end

function paperwork:getThing(thing)

	if thing == "peas" then
		self.paper = {img=imgMan:getImage("peas"), x=100, y=200}
		self.successZone = {85,227,129,274}
		self.failZone = {141,227,178,269}
	end

	if thing == "budget" then
		self.paper = {img=imgMan:getImage("budget"), x=100, y=200}
		self.successZone = {118,147,158,196}
		self.failZone = {55,131,224,194}
	end

end

function paperwork:update(dt)

	self.cursor:update(dt)

	debug(love.mouse.getX()-self.paper.x .. ", " .. love.mouse.getY()-self.paper.y)

end

function paperwork:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.paper.img, self.paper.x, self.paper.y, 0, 30/50, 30/50)

	if self.state == "win" then
		love.graphics.setColor(0,255,0)
		love.graphics.print("YA DID IT SON", self.paper.x+100, self.paper.y+150)
	end
	if self.state == "lose" then
		love.graphics.setColor(255,0,0)
		love.graphics.print("YA DONE GOOFED SON", self.paper.x+100, self.paper.y+150)
	end
	if self.state == "miss" then
		love.graphics.setColor(255,255,0)
		love.graphics.print("YA GOTTA TRY AGAIN SON", self.paper.x+100, self.paper.y+150)
	end

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