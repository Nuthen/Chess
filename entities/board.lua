Board = class('Board')

function Board:initialize(width, height)
	self.width = width
	self.height = height
	
	self.tileWidth = 64
	self.tileHeight = 64
	
	self.realWidth = self.width * self.tileWidth
	self.realHeight = self.height * self.tileHeight
	
	local scrnWidth, scrnHeight = love.graphics.getDimensions()
	self.offsetX, self.offsetY = scrnWidth/2 - self.realWidth/2, scrnHeight/2 - self.realHeight/2
	
	self.tiles = {}
	for iy = 1, self.height do
		self.tiles[iy] = {}
		for ix = 1, self.width do
			-- y is inverted so that (1, 1)/(A, 1) will be in the bottom-left corner of the board
			self.tiles[iy][ix] = {x = (ix-1)*self.tileWidth, y = (self.height-iy)*self.tileHeight}
		
			local tile = 1
			if ix % 2 == 1 and iy % 2 == 0 or ix % 2 == 0 and iy % 2 == 1 then
				tile = 0
			end
			
			self.tiles[iy][ix].tile = tile
		end
	end
end

function Board:draw()
	local x, y = self.offsetX, self.offsetY
	
	for iy = 1, self.height do
		for ix = 1, self.width do
			local tile = self.tiles[iy][ix]
			local color = {157, 100, 232}
			if tile.tile == 0 then
				color = {240, 224, 161}
			elseif tile.tile == 1 then
				color = {176, 123, 9}
			end
			
			love.graphics.setColor(color)
			love.graphics.rectangle('fill', x + tile.x, y + tile.y, self.tileWidth, self.tileHeight)
			love.graphics.setColor(255, 255, 255)
			love.graphics.rectangle('line', x + tile.x, y + tile.y, self.tileWidth, self.tileHeight)
		end
	end
end


function Board:getTile(x, y)
	local tileX, tileY = math.ceil((x - self.offsetX)/self.tileWidth), self.height - math.ceil((y - self.offsetY)/self.tileHeight) + 1
	if tileX >= 1 and tileX <= self.width and tileY >= 1 and tileY <= self.height then
		return tileX, tileY
	else
		return nil
	end
end