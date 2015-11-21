--this is nothing

player = class:new()
player:addparent(gameObject)

function player:init(args)
	self:initialize()

	self.id = "player"

	--phys component
	self.phys = self:addComponent(physics:new(self, args.x, args.y, 20, 20))
	self.img = self:addComponent(image:new("player"))
end

function player:update(dt)

	--update all components
	for i,comp in ipairs(self.component) do
		comp:update(dt)
	end

	--movement
	local move = "ex"
	local speed = 300; local accel = 5
	local xMove = 0; local yMove = 0

	xMove = -(self.phys.vx - speed*input.movDir.x) * accel*dt
	yMove = -(self.phys.vy - speed*input.movDir.y) * accel*dt

	self.phys:addVel(xMove, yMove)

	--friction
	self.phys:addVel(-self.phys.vx*3*dt, -self.phys.vy*3*dt, 0)

end

function player:draw()
	self.img:draw(self.phys.x, self.phys.y, 20/50, 20/50)
end

function player:resolveCollision(entity, dir)
	--if entity.id == "tile" and (not keyDown("e")) then self.phys:hitSide(entity, dir) end
end