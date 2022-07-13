-- -- -- -- CONSTANTS -- -- -- -- 
local gfx <const> = playdate.graphics
local textOffsets = {
	{0,0}, {0,0}, {0,0}, {0,0}, 
	{0,0}, {0,0}, {0,0}, {0,0}, 
	{0,0}, {0,0}, {0,0}, {0,0}, 
	{0,0}, {0,0}, {0,0}, {0,0}, 
}

class("Puzzle").extends("Program")
function Puzzle:init()
	Puzzle.super.init(self)
	
	self:setZIndex(100)
	self:setOpaque(true)
	self:setCenter(0, 0) 
	
	self.width = 91
	self.height = 110
	
	self.boardX = 5
	self.boardY = menuBarHeight + 4
	self.boardSize = 81
	self.gridSize = 4
	self.tileSize = 20
	self.tileTotal = self.gridSize * self.gridSize
	
	self.tileList = table.create(self.tileTotal, 0)
	self.tilePositions = table.create(self.tileTotal, 0)
	self.adjacentTiles = table.create(4, 0)
	self.tileEmptyPositionIndex = nil
	self:createPositions()
	self:createTiles()
	self.tileSelected = 1
	self.tileSelectedIndex = 1
	

	self:setBounds(self.x, self.y, self.width, self.height)
	self:add()
	
	self:createInputHandlers()
	self:pushInputHandlers(self.inputHandlers)
end

function Puzzle:update()
	self:moveTo(self.x, self.y)
end

function Puzzle:draw()
	self:drawWindow()
	self:drawGrid()
end

function Puzzle:drawWindow()
	-- base
	gfx.setColor(kWhite)
	gfx.fillRoundRect(0, 0, self.width, self.height, 8)
	
	-- header
	gfx.setColor(kBlack)
	gfx.fillRoundRect(0, 0, self.width, 50, 8)
	
	-- background bottom
	gfx.setPattern({0x55, 0x88, 0x55, 0x22, 0x55, 0x88, 0x55, 0x22})
	gfx.fillRoundRect(0, self.height - 29, self.width, 28, 8)
	
	-- background middle
	gfx.setPattern({0x55, 0x88, 0x55, 0x22, 0x55, 0x88, 0x55, 0x22})
	gfx.fillRect(0, menuBarHeight, self.width, self.height - 40)
	
	-- border
	gfx.setColor(kBlack)
	gfx.drawRoundRect(0, 0, self.width, self.height, 8)
	
	-- header divider
	gfx.drawLine(1, menuBarHeight - 1, self.width - 2, menuBarHeight - 1)
	
	-- board background
	gfx.setColor(kWhite)
	gfx.setPattern({0xDD, 0xFF, 0x77, 0xFF, 0xDD, 0xFF, 0x77, 0xFF})
	gfx.fillRect(self.boardX, self.boardY, self.boardSize, self.boardSize)
	gfx.setColor(kWhite)
end

function Puzzle:drawGrid()
	-- border
	gfx.setColor(kBlack)
	gfx.drawRect(self.boardX, self.boardY, self.boardSize, self.boardSize)
	
	-- vertical grid lines
	for i=1, 3 do
		gfx.drawLine(self.boardX + ((self.tileSize) * i), self.boardY, self.boardX + ((self.tileSize) * i), self.boardY + (self.boardSize - 3))
	end
	
	-- vertical grid lines
	for i=1, 3 do
		gfx.drawLine(self.boardX, self.boardY + ((self.tileSize ) * i), self.boardX + (self.boardSize - 3), self.boardY + ((self.tileSize) * i))
	end
end

function Puzzle:createPositions()
	for i=1, (self.gridSize * self.tileSize), self.tileSize do
		for j=1, (self.gridSize * self.tileSize), self.tileSize do
			local xPos = self.x + self.boardX + j
			local yPos = self.y + self.boardY + i
			
			local position = {xPos, yPos}
			table.insert(self.tilePositions, position)
		end
	end
end

function Puzzle:createTiles()
	for i=1, (self.tileTotal) do
		local tile = PuzzleTile(
			{
				offsetX = textOffsets[i][1],
				offsetY = textOffsets[i][2]
			}
		)

		table.insert(self.tileList, tile)
	end
	
	self:randomizeTiles()
	
	for i,v in ipairs(self.tileList) do
		v:moveTile(self.tilePositions[i][1], self.tilePositions[i][2])
	end
	
	self:markDirty()
end

function Puzzle:randomizeTiles()
	local shuffledPositions = {}
	local possiblePositions = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}
	
	-- TODO: add this shuffled to Utilities !
	function shuffleTiles()
		for i, v in ipairs(possiblePositions) do
			local pos = math.random(1, #shuffledPositions+1)
			table.insert(shuffledPositions, pos, v)
		end
	end
	
	shuffleTiles()
	
	-- TODO: add solvability calulation here, with re-roll contained inside
	
	-- Don't allow the first position to be the empty tile
	if shuffledPositions[1] == 16 then
		repeat
			shuffleTiles()
			print('Reroll!')
		until shuffledPositions[1] ~= 16
	end
	
	
	-- TODO: verify these
	for i,v in ipairs(self.tileList) do
		v.tileIndex = shuffledPositions[i]
		v.text = shuffledPositions[i]
		v.positionIndex = i
		
		if shuffledPositions[i] == 16 then
			self.tileEmptyPositionIndex = i
			v:setVisibility(false)
		end
	end
	
	self:setAdjacentTiles()
end

function Puzzle:swapTiles()
	local selected = nil
	local empty = nil
	
	print("BEFORE -- tileSelected: " .. self.tileSelected .. " _ " .. "tileEmptyPositionIndex: " .. self.tileEmptyPositionIndex)
	
	for i,v in ipairs(self.tileList) do
		
		-- Move the selected tile to the empty position
		if v.positionIndex == self.tileSelected then
			v:moveTile(self.tilePositions[self.tileEmptyPositionIndex][1], self.tilePositions[self.tileEmptyPositionIndex][2])
			
			selected = self.tileSelected
			v:setSelected(false)
			v:markDirty()
			
		-- Move the empty tile to the previously selected position
		elseif v.positionIndex == self.tileEmptyPositionIndex then
			v:moveTile(self.tilePositions[self.tileSelected][1], self.tilePositions[self.tileSelected][2])
			
			empty = self.tileEmptyPositionIndex
			v:setSelected(true)
			v:markDirty()
		end
	end

	self.tileSelected = empty
	self.tileEmptyPositionIndex = selected
	
	self:markDirty()
	
	print("AFTER -- tileSelected: " .. self.tileSelected .. " _ " .. "tileEmptyPositionIndex: " .. self.tileEmptyPositionIndex)
end

-- TODO: fix right and left index checks
function Puzzle:getAdjacentTiles(index)
	local row = math.ceil(index/self.gridSize)
	
	-- Top
	local topIndex = math.max((index - self.gridSize), 0)
	table.insert(self.adjacentTiles, topIndex)

	-- Right 
	local rightIndex = index + 1 
	if (rightIndex - 1) == (row * self.gridSize) then rightIndex = 0 end
	-- table.insert(self.adjacentTiles, rightIndex)
	
	-- Bottom
	local bottomIndex = math.min((index + self.gridSize), 17)
	table.insert(self.adjacentTiles, bottomIndex)
	
	-- Left 
	local leftIndex = index - 1 
	if (leftIndex + 1) == (row) then leftIndex = 0 end
	-- table.insert(self.adjacentTiles, leftIndex)
	
	-- Remove out-of-bounds entries below 1 or above 16
	for i,v in ipairs(self.adjacentTiles) do
		if v < 1 or v > 16 then
			table.remove(self.adjacentTiles, i)
		end
	end

	printTable(self.adjacentTiles)
end

function Puzzle:setAdjacentTiles()
	self.adjacentTiles = {}
	self:getAdjacentTiles(self.tileEmptyPositionIndex)
	self.tileSelected = self.adjacentTiles[self.tileSelectedIndex]
end

function Puzzle:createInputHandlers()
	self.inputHandlers = {
		BButtonDown = function()

			self.tileList[self.tileSelected]:setSelected(false)
			self.tileList[self.tileSelected]:markDirty()

			-- Increment through the available adjacent selectable tiles list
			self.tileSelectedIndex = (self.tileSelectedIndex%#self.adjacentTiles) + 1
			
			-- Set tile selected to the next in the list
			for i,v in ipairs(self.tileList) do
				if v.positionIndex == self.adjacentTiles[self.tileSelectedIndex] then
					self.tileSelected = v.positionIndex
					v:setSelected(true)
					v:markDirty()
				end
			end
			
			-- This is kind of working?
		end,
		AButtonDown = function()
			self:swapTiles()
			
			self:setAdjacentTiles()
		end
	}
end

-- -- -- -- -- --

class("PuzzleTile").extends(gfx.sprite)
function PuzzleTile:init(offsets)
	PuzzleTile.super.init(self)

	self.tileSize = 19
	self.tileIndex = nil
	self.positionIndex = nil
	self.tileRect = playdate.geometry.rect.new(0, 0, self.tileSize, self.tileSize)
	self.isSelected = false
	
	self.text = nil
	self.textX = offsets.offsetX
	self.textY = offsets.offsetY
	
	self:setCenter(0, 0)
	self:setZIndex(500)
	self:setBounds(0, 0, self.tileSize, self.tileSize)
	
	self:add()
	self:setVisible(true)
end

function PuzzleTile:update()
end

function PuzzleTile:draw()
	gfx.setColor(kWhite)
	gfx.fillRect(self.tileRect)
	
	if self.isSelected then
		gfx.setColor(kBlack)
		gfx.drawRect(self.tileRect:insetBy(0.25, 0.25))
	end
	
	gfx.drawTextAligned(self.text, self.textX + 9, self.textY + 2, kCenter)
end

function PuzzleTile:moveTile(x, y)
	self:moveTo(x, y)
	self:markDirty()
end

function PuzzleTile:setVisibility(flag)
	self:setVisible(flag)
end

function PuzzleTile:setSelected(flag)
	self.isSelected = flag
end