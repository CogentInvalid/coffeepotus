require "comp/physics"
require "comp/image"
gameObject = class:new()

function gameObject:initialize()
	self.id = "unspecified"
	self.drawLayer = "front"
	self.component = {}
	self.die = false
	self.img = nil --"imgNotFound" perhaps
	self.game = gameMode
end

function gameObject:update(dt)

	--update all components
	for i,comp in ipairs(self.component) do
		comp:update(dt)
	end

end

function gameObject:draw()
end

function gameObject:addComponent(c)
	self.component[#self.component+1] = c
	return self.component[#self.component]
end

function gameObject:getPosition()
	if self.phys ~= nil then
		return self.phys.x, self.phys.y
	else
		crash("ERROR: This <" .. self.id .. "> does not have a phys component")
	end
end