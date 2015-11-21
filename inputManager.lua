inputManager = class:new()

function inputManager:init()

	self.bind = {}
	self.bind["up"] = {"w", "up"}
	self.bind["down"] = {"s", "down"}
	self.bind["left"] = {"a", "left"}
	self.bind["right"] = {"d", "right"}
	self.bind["interact"] = {"z", " "}

	self.movDir = {x=0, y=0}
	self.x = 0; self.y = 0

end

function inputManager:update(dt)

	self.movDir = {x=0, y=0}

	for dir in pairs(self.bind) do
		for j,key in ipairs(self.bind[dir]) do

			if keyDown(key) then
				
				if dir == "up" then self.movDir.y = self.movDir.y - 1 end
				if dir == "down" then self.movDir.y = self.movDir.y + 1 end
				if dir == "left" then self.movDir.x = self.movDir.x - 1 end
				if dir == "right" then self.movDir.x = self.movDir.x + 1 end

			end

		end
	end

	self.x = self.movDir.x; self.y = self.movDir.y

end

function inputManager:keyIs(bind, key)
	for i,k in ipairs(self.bind[bind]) do
		if k == key then return true end
	end
end