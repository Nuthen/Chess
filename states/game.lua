game = {}

function game:enter()
    self.board = Board:new(8, 8)
	
	self.pieces = {}
	self.pieces[1] = Piece:new(1, 1)
	self.pieces[2] = Piece:new(5, 2)
end

function game:update(dt)

end

function game:keypressed(key, isrepeat)
    if console.keypressed(key) then
        return
    end
end

function game:mousepressed(x, y, mbutton)
    if console.mousepressed(x, y, mbutton) then
        return
    end
	
	-- fix selected
	
	for k, piece in pairs(self.pieces) do
		if piece:isHover(x, y) then
			piece:clicked(mbutton)
		elseif piece.selected then
			local tileX, tileY = self.board:getTile(x, y)
			if tileX and tileY then
				piece:setLocation(tileX, tileY)
			end
		end
	end
end

function game:draw()
    love.graphics.setFont(font[48])
	
	self.board:draw()
	
	for k, piece in pairs(self.pieces) do
		piece:draw()
	end
end