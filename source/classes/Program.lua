-- -- -- -- CONSTANTS -- -- -- -- 
local gfx <const> = playdate.graphics
local windowPositioningDistance = 2
local windowPositioningDelay = 40

class("Program").extends(gfx.sprite)
function Program:init()
	Program.super.init(self)
	
	if #factory.programList > 0 then
		self.x = factory.programList[#factory.programList].x +(menuBarHeight)
		self.y = factory.programList[#factory.programList].y + (menuBarHeight)
	else
		self.x = 51
		self.y = 20
	end
	
	self:baseInputHandlers()
	self.programActive = false
	self.allowWindowPositioning = false
	self.allowRemove = false
	self.windowActivelyClosing = false
	self.windowActivelyPositioning = false
end

function Program:update()
	self:moveTo(self.x, self.y)
end

function Program:setProgramActive()
	self.programActive = true

	self:setZIndex(100)
	self:updateDraws()
	self:pushInputHandlers(self.baseInputHandlers)
end

function Program:setProgramInactive()
	self.programActive = false
	self:setZIndex(self:getZIndex() - 1)
	self:updateDraws()
end

function Program:pushInputHandlers(handlers)
	playdate.inputHandlers.push(handlers)
end

function Program:popInputHandlers()
	playdate.inputHandlers.pop()
end

function Program:baseInputHandlers()
	self.baseInputHandlers = {
		AButtonDown = function()
			
		end,
		AButtonHeld = function()
			if not self.allowWindowPositioning then
				self:windowPositioningInputHandlers()
				
				-- TODO: Call a different "outline" version of the window here instead
				self.allowWindowPositioning = true
			end
		end,
		AButtonUp = function()
			if self.allowWindowPositioning then
				self:popInputHandlers()
				
				self.allowWindowPositioning = false
			end
		end,
		BButtonDown = function()
			cursor:setPosition(self.x + 13, self.y + 8)
			cursor:setVisibility(true)
		end,
		BButtonHeld = function()
			-- TODO: Add a slow cursor movement from +26 to +13
			
			self.allowRemove = true
			factory:beforeRemoveActiveProgram()
		end,
		BButtonUp = function()
			if self.allowRemove then
				self.allowRemove = false
				factory:removeActiveProgram()
			elseif not self.allowRemove then
				factory:cycleActivePrograms()
			end
			
			cursor:setVisibility(false)
		end,
	}
end

function Program:windowPositioningInputHandlers()
	self.windowPositioningInputHandlers = {
		upButtonDown = function()
			if self.allowWindowPositioning and not self.windowActivelyPositioning then
				self.windowActivelyPositioning = true
				
				local function timerCallback()
					self.programWindow.y = self.programWindow.y - windowPositioningDistance
					self.y = self.programWindow.y
					self:markDirty()
				end
				self.keyTimer = playdate.timer.keyRepeatTimerWithDelay(windowPositioningDelay, windowPositioningDelay, timerCallback)
			end
		end,
		upButtonUp = function()
			self.windowActivelyPositioning = false
			
			if self.keyTimer ~= nil then
				self.keyTimer:remove()
			end
		end,
		downButtonDown = function()
			if self.allowWindowPositioning and not self.windowActivelyPositioning then
				self.windowActivelyPositioning = true
				
				local function timerCallback()
					self.programWindow.y = self.programWindow.y + windowPositioningDistance
					self.y = self.programWindow.y
					self:markDirty()
				end
				self.keyTimer = playdate.timer.keyRepeatTimerWithDelay(windowPositioningDelay, windowPositioningDelay, timerCallback)
			end
		end,
		downButtonUp = function()
			self.windowActivelyPositioning = false
			
			if self.keyTimer ~= nil then
				self.keyTimer:remove()
			end
		end,
		leftButtonDown = function()
			if self.allowWindowPositioning and not self.windowActivelyPositioning then
				self.windowActivelyPositioning = true
				
				local function timerCallback()
					self.programWindow.x = self.programWindow.x - windowPositioningDistance
					self.x = self.programWindow.x
					self:markDirty()
				end
				self.keyTimer = playdate.timer.keyRepeatTimerWithDelay(windowPositioningDelay, windowPositioningDelay, timerCallback)
			end
		end,
		leftButtonUp = function()
			self.windowActivelyPositioning = false
			
			if self.keyTimer ~= nil then
				self.keyTimer:remove()
			end
		end,
		rightButtonDown = function()
			if self.allowWindowPositioning and not self.windowActivelyPositioning then
				self.windowActivelyPositioning = true
				
				local function timerCallback()
					self.programWindow.x = self.programWindow.x + windowPositioningDistance
					self.x = self.programWindow.x
					self:markDirty()
				end
				self.keyTimer = playdate.timer.keyRepeatTimerWithDelay(windowPositioningDelay, windowPositioningDelay, timerCallback)
			end
		end,
		rightButtonUp = function()
			self.windowActivelyPositioning = false
			
			if self.keyTimer ~= nil then
				self.keyTimer:remove()
			end
		end
	}
	
	self:pushInputHandlers(self.windowPositioningInputHandlers)
end