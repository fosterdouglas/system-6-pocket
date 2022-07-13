-- -- -- -- CONSTANTS -- -- -- -- 
local gfx <const> = playdate.graphics

class("Finder").extends("Program")
function Finder:init(config)
	Finder.super.init(self)
	self.keyTimer = nil
	
	self.programWindow = Window(config.title, config.content, nil, nil, config.footer)
		
	-- Simulate an opening delay (and make room for openingAnimation)
	self.startDelay = playdate.frameTimer.new(7)
	self.startDelay.timerEndedCallback = function(timer)
		self.programWindow:displayWindow(self.x, self.y)		
	end
	
	self:add()
	self.programActive = true
	
	self:createInputHandlers()
	self:pushInputHandlers(self.inputHandlers)
end

function Finder:update()
end

function Finder:draw()
	self.programWindow:markDirty()
	
	if self.programActive then
		self.programWindow:setActive()
	else
		self.programWindow:setInactive()
	end
end

function Finder:createInputHandlers()
	self.inputHandlers = {
		AButtonDown = function()
			
		end,
	}
end

-- Recurring functions needed for each class (Program depends on these)

function Finder:getWidth()
	return self.programWindow.width
end

function Finder:getHeight()
	return self.programWindow.height
end

function Finder:updateDraws()
	self.programWindow:markDirty()
	
	if self.programActive then
		self.programWindow:setActive()
	else
		self.programWindow:setInactive()
	end
end

function Finder:beforeDestroy()
	self.programWindow:setClosing(true)
end

function Finder:destroy()
	self.programWindow:remove()
	self:popInputHandlers()
end