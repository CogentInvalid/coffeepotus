imgManager = class:new()

function imgManager:init(parent)
	
	self.id = "imgManager"
	self.game = parent
	self.path = {"/img/", ".png"}

	self.img = {}

end

function imgManager:getImage(name, path)
	path = path or self.path

	if self.img[name] == nil then
		self.img[name] = love.graphics.newImage(path[1] .. name .. path[2])
	end
	return self.img[name]

end