paperwork = class:new()

function paperwork:init()

	self.cursor = cursor:new({x=200,y=200})
	peas = imgMan:getImage("peas")
	self.paper = {img=imgMan:getImage("peas"), x=100, y=200}
	self.successZone = {85,227,}
	self.failZone = {}

end

function paperwork:update(dt)

	self.cursor:update(dt)

	-- debug(love.mouse.getX()-self.paper.x .. ", " .. love.mouse.getY()-self.paper.y)

end

function paperwork:draw()
	love.graphics.setColor(255,255,255)
	--love.graphics.rectangle("fill",10,10,200,200)
	--love.graphics.draw(peas, 0, 0)
	love.graphics.draw(self.paper.img, self.paper.x, self.paper.y, 0, 30/50, 30/50)
	self.cursor:draw()
end

function paperwork:keypressed(key)
	if key == "z" then
		local phys = self.cursor.phys
		local x = phys.x+phys.w/2; local y = phys.y+phys.h/2
	end
end