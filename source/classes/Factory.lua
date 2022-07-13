-- -- -- -- CONSTANTS -- -- -- -- 
local gfx <const> = playdate.graphics

class("Factory").extends()
function Factory:init()
	Factory.super.init(self)
	
	self.programList = {}
end

function Factory:addNewProgram(program)
	table.insert(self.programList, program)
	self:cycleActivePrograms()
	
	self:openingAnimation()
end

function Factory:beforeRemoveActiveProgram()
	self.programList[self:getActiveProgramIndex()]:beforeDestroy()
end

function Factory:removeActiveProgram()
	local prevIndex = self:getActiveProgramIndex()
	local program = self.programList[prevIndex]
	
	program:popInputHandlers()
	program:destroy()
	program = nil
	
	self:cycleActivePrograms()
	
	table.remove(self.programList, prevIndex)
end

function Factory:getActiveProgramIndex()
	for i,v in ipairs(self.programList) do
		if v.programActive then 
			return i 
		end
	end
end

function Factory:cycleActivePrograms()
	if #self.programList > 0 then
		local nextIndex = (self:getActiveProgramIndex()) % (#self.programList) + 1
		
		for i,v in ipairs(self.programList) do
			if i == nextIndex then
				self.programList[i]:setProgramActive()
			else
				self.programList[i]:setProgramInactive()
			end
		end
	end
end

-- move this out to its own class probably
function Factory:openingAnimation(originX, originY)	
	local program = self.programList[self:getActiveProgramIndex()]
	local finalWidth = program:getWidth()
	local finalHeight = program:getHeight()
	
	local containerSprite = gfx.sprite.new()
	local animationTimer = playdate.frameTimer.new(6)
	local totalRects = 8
	local counter = 1
	animationTimer.updateCallback = function(timer)
		if timer.frame <= timer.duration * 1/3 then 
			counter = 1 
			containerSprite:markDirty()
		elseif timer.frame > timer.duration * 1/3 and timer.frame <= timer.duration * 2/3 then 
			counter = 2 
			containerSprite:markDirty()
		elseif timer.frame >= timer.duration * 2/3 then 
			counter = 3 
			containerSprite:markDirty()
		end
	end
	
	animationTimer.timerEndedCallback = function(timer)
		containerSprite:remove()
		containerSprite = nil
	end
	
	containerSprite:setCenter(0,0)
	containerSprite:setBounds(25, 25, 400, 240)
	containerSprite:setZIndex(2000)
	containerSprite:add()
	
	local storedRects = table.create(totalRects, 0)
	for i=1, 8 do
		local rect = playdate.geometry.rect.new(
			(i * math.max((i-3), 1) + (i*3)), 
			(i * math.max((i-3), 1) + (i*3)), 
			_roundNumber((finalWidth * 0.65)*(i/totalRects) - (totalRects/i), 0), 
			_roundNumber((finalHeight * 0.65)*(i/totalRects) - (totalRects/i), 0)
		)
		table.insert(storedRects, rect)
	end

	local displayingRects = {{1, 2, 3, 4}, {3, 4, 5, 6}, {5, 6, 7, 8}}
	
	containerSprite.draw = function()
		gfx.setColor(kBlack)
		
		for i,v in ipairs(storedRects) do
			for j,w in ipairs(displayingRects[counter]) do
				if i == w then
					gfx.drawRect(v)
				end
			end
		end
	end

end

-- -- -- -- -- 

function Factory:createFinder(config)
	self:addNewProgram( Finder(config) )
end

function Factory:createNotePad()
	self:addNewProgram( NotePad() )
end

function Factory:createPuzzle()
	self:addNewProgram( Puzzle() )
end