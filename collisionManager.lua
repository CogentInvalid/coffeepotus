-- WARNING!!!
-- You can clip through corners if you have an incidental single collision on the same frame.

local bump = require "libs/bump"

collisionManager = class:new()

function collisionManager:init(parent)

	self.id = "collisionManager"
	self.game = parent

	self.world = bump.newWorld() --a "world" to keep track of all objects and detect collisions.

end

function collisionManager:resetWorld()
	self.world = {}
	self.world = bump.newWorld()
end

function collisionManager:addEnt(entity, x, y, w, h)
	--add an entity to the world
	self.world:add(entity, x, y, w, h)
end

function collisionManager:removeEnt(entity)
	self.world:remove(entity)
end

function collisionManager:moveEnt(entity, x, y, w, h)
	self.world:move(entity, x, y, w, h)
end

function collisionManager:isReal(ent)
	return true
end

--collision functions
function collisionManager:collide(ent1, collideOrder)
	for n,cond in ipairs(collideOrder) do
		col = self:detectCollisions(ent1, cond)
		for i=1, #col do
			local dir = col[i][1]
			local ent2 = col[i][2]
			--do collisions
			if ent1.resolveCollision ~= nil then ent1:resolveCollision(ent2, dir) end
		end
	end
end

function collisionManager:detectCollisions(ent1, cond) --collisions for all the things* (*that are rectangles)
	local all = {}
	local counter = {}
	local cols, len = self.world:queryRect(ent1.phys.x-8, ent1.phys.y-8, ent1.phys.w+16, ent1.phys.h+16)
	for i,ent2 in ipairs(cols) do
		counter[i] = 0
		if cond(ent2) and ent1 ~= ent2 then

			local e1 = ent1.phys; local e2 = ent2.phys

			--find collision direction
			if e1.y+e1.h>e2.y and e1.y<e2.y+e2.h then --left/right
				if e1.px+e1.w <= e2.px and e1.x+e1.w > e2.x then --left
					all[i] = {"left", ent2}
					counter[i] = counter[i] + 1
				end
				if e1.px >= e2.px+e2.w and e1.x < e2.x+e2.w then --right
					all[i] = {"right", ent2}
					counter[i] = counter[i] + 1
				end
			end
			if e1.x+e1.w>e2.x and e1.x<e2.x+e2.w then --up/down
				if e1.py+e1.h <= e2.py and e1.y+e1.h > e2.y then --from above
					all[i] = {"up", ent2}
					counter[i] = counter[i] + 1
				end
				if e1.py >= e2.py+e2.h and e1.y < e2.y+e2.h then --below
					all[i] = {"down", ent2}
					counter[i] = counter[i] + 1
				end
			end
			if counter[i] == 0 then --already inside
				if e1.y+e1.h>e2.y and e1.y<e2.y+e2.h and e1.x+e1.w>e2.x and e1.x<e2.x+e2.w then
					all[i] = {"in", ent2}
					--counter[i] = counter[i] + 1
				end
			end
		end
	end

	local priority = false
	for i=1, len do
		if counter[i] == 1 then priority = true end
		--ignore all double collisions as long as there is at least one single collision
	end
	local finalCols = {}
	for i=1, len do
		if counter[i] == 1 then finalCols[#finalCols+1] = all[i] end
		if counter[i] > 1 and priority == false then finalCols[#finalCols+1] = all[i] end
	end
	
	return finalCols
end