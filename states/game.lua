game = {}

function game:enter()
	local width, height = 8, 8
    self.board = Board:new(width, height)
	
	self.pieces = {}
	for x = 1, width do
		table.insert(self.pieces, Pawn:new(x, 2, 1))
		table.insert(self.pieces, Pawn:new(x, height-1, 2))
	end
	table.insert(self.pieces, Rook:new(1, 1, 1))
	table.insert(self.pieces, Rook:new(width, 1, 1))
	table.insert(self.pieces, Rook:new(1, height, 2))
	table.insert(self.pieces, Rook:new(width, height, 2))
	
	table.insert(self.pieces, Knight:new(2, 1, 1))
	table.insert(self.pieces, Knight:new(width-1, 1, 1))
	table.insert(self.pieces, Knight:new(2, height, 2))
	table.insert(self.pieces, Knight:new(width-1, height, 2))
	
	table.insert(self.pieces, King:new(5, 1, 1))
	table.insert(self.pieces, King:new(5, height, 2))
	
	self.color = 1
	
	self.selected = nil
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
	
	self.selected = nil
	
	for i, piece in ipairs(self.pieces) do
		-- if no piece is selected or this piece is selected
		
		if piece.color == self.color and piece:isHover(x, y) then
			-- if a piece is selected, then self.selected is set to the piece's index. else set to nil
			if not self.selected or self.selected == i then
				if piece:clicked(mbutton) then
					self.selected = i
				end
			end
		elseif piece.selected then
			local tileX, tileY = self.board:getTile(x, y)
			if tileX and tileY then
				piece:setLocation(tileX, tileY)
			end
		end
		
		--piece.color == self.color

		if piece.color ~= self.color then
			-- only show information about it, no movement or selecting
		end
		
	end
	
	-- guarentees all pieces are deselected
	for i, piece in ipairs(self.pieces) do
		piece:deselect()
	end
	
	-- selects a piece if needed
	if self.selected then
		self.pieces[self.selected]:select()
	end
end

function game:draw()
    love.graphics.setFont(font[48])
	
	self.board:draw()
	
	for k, piece in pairs(self.pieces) do
		piece:draw()
	end
end