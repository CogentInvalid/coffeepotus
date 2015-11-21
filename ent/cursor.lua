cursor = class:new()
cursor:addparent(gameObject)

function cursor:init(args)
	self:initialize()

	self.id = "cursor"

	--phys component
	self.phys = self:addComponent(physics:new(self, args.x, args.y, 20, 20))
	self.img = self:addComponent(image:new("player"))
end

function cursor:update(dt)

	--update all components
	for i,comp in ipairs(self.component) do
		comp:update(dt)
	end

	--movement
	local speed = 300; local accel = 5
	local xMove = 0; local yMove = 0

	xMove = -(self.phys.vx - speed*input.movDir.x) * accel*dt
	yMove = -(self.phys.vy - speed*input.movDir.y) * accel*dt

	self.phys:addVel(xMove, yMove)

	self.phys:addVel(math.random()*5000*randSign()*dt,math.random()*5000*randSign()*dt)

	--friction
	self.phys:addVel(-self.phys.vx*3*dt, -self.phys.vy*3*dt, 0)

end

function cursor:draw()
	self.img:draw(self.phys.x, self.phys.y, 20/50, 20/50)
end

function cursor:resolveCollision(entity, dir)
	--if entity.id == "tile" and (not keyDown("e")) then self.phys:hitSide(entity, dir) end
end