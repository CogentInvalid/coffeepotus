imgManager = class:new()

function imgManager:getImage(name, path)
	path = path or self.path

	if self.img[name] == nil then
		self.img[name] = love.graphics.newImage(path[1] .. name .. path[2])
	end
	return self.img[name]

end

function imgManager:init(parent)
	
	self.id = "imgManager"
	self.game = parent
	self.path = {"/img/", ".png"}

	self.img = {}

	effect = love.graphics.newShader [[
		extern float x;
		extern float y;
		extern float amt;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {	
			vec4 color1 = texture2D(texture, gl_TexCoord[0].st);
			number r = color1[0]*color[0];
			number g = color1[1]*color[1];
			number b = color1[2]*color[2];
			number a = color1[3]*color[3];
			number x2 = pixel_coords[0];
			number y2 = pixel_coords[1];
			number dist = sqrt(((x-x2)*(x-x2))+(((y-y2)*(y-y2)))/amt);
			if(dist > 400)
			{
				r = r*pow(amt,1);
				g = g*pow(amt,1);
				b = b*pow(amt,1);
			}
			if(dist > 200)
			{
				r = r*pow(amt,0.6);
				g = g*pow(amt,0.6);
				b = b*pow(amt,0.6);
			}
			if(dist < 200)
			{
				r = r*pow(amt,0.3);
				g = g*pow(amt,0.3);
				b = b*pow(amt,0.3);
			}
            return vec4(r, g, b, a);
        }
    ]]

end