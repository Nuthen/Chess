Knight = class('Knight', Piece)

function Knight:initialize(x, y, color)
	self.canMove = function(x, y)
		if not game.board.tiles[y][x].piece then
			if math.abs(x-self.x) == 2 and math.abs(y-self.y) == 1 or math.abs(x-self.x) == 1 and math.abs(y-self.y) == 2 then
				return true
			end
		end
	end

	self.canCapture = function(x, y)
		if game.board.tiles[y][x].piece and game.board.tiles[y][x].piece.color ~= self.color then
			if math.abs(x-self.x) == 2 and math.abs(y-self.y) == 1 or math.abs(x-self.x) == 1 and math.abs(y-self.y) == 2 then
				return true
			end
		end
	end
	
	Piece.initialize(self, x, y, color)
end