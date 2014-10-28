Piece = class('Piece')

function Piece:initialize(x, y)
	self.board = {tileWidth = game.board.tileWidth, tileHeight = game.board.tileHeight}
	self:setLocation(x, y, true)
	
	self.offsetX = game.board.offsetX
	self.offsetY = game.board.offsetY
	
	self.width = 40
	self.height = 40
end

function Piece:draw()
	love.graphics.setColor(0, 0, 255)
	if self.selected then
		love.graphics.setColor(255, 0, 255)
	end
	
	love.graphics.rectangle('fill', self.realX-self.width/2 + self.offsetX, self.realY-self.height/2 + self.offsetY, self.width, self.height)
end


function Piece:setLocation(x, y, first)
	if first or self.x ~= x or self.y ~= y then
		if not first and not game.board.tiles[y][x].piece or first then
			if self.x and self.y then
				game.board.tiles[self.y][self.x].piece = nil
			end

			self.x = x
			self.y = y
			self.tile = game.board.tiles[y][x]
			self.realX = self.tile.x + self.board.tileWidth/2
			self.realY = self.tile.y + self.board.tileHeight/2
			
			game.board.tiles[self.y][self.x].piece = self
			
			self.selected = false
		end
	end
end

-- Checks if a screen coordinate is over anywhere on the pieces tile, not just the drawn image of a piece
function Piece:isHover(x, y)
	if x >= self.tile.x + self.offsetX and x < self.tile.x + self.offsetX + self.board.tileWidth and y >= self.tile.y + self.offsetY and  y < self.tile.y + self.offsetY + self.board.tileHeight then
		return true
	else
		return false
	end
end

function Piece:clicked(button)
	if not self.selected then
		self.selected = true
	else
		self.selected = false
	end
end