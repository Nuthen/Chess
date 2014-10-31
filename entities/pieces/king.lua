King = class('King', Piece)

function King:initialize(x, y, color)
	self.canMove = function(x, y)
		if not game.board.tiles[y][x].piece then
			if math.abs(x-self.x) <= 1 and math.abs(y-self.y) <= 1 then
				return true
			end
		end
	end

	self.canCapture = function(x, y)
		if game.board.tiles[y][x].piece and game.board.tiles[y][x].piece.color ~= self.color then
			if math.abs(x-self.x) <= 1 and math.abs(y-self.y) <= 1 then
				return true
			end
		end
	end
	
	self.image = love.graphics.newImage('img/pikachu.png')
	
	Piece.initialize(self, x, y, color)
end